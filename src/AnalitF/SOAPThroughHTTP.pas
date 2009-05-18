unit SOAPThroughHTTP;

interface

uses IdHTTP, IdIntercept, SysUtils, StrUtils, Classes, IdException, WinSock, IdURI,
  IdGlobal, IdStack, IdStackConsts, IdComponent, IdHeaderList;

const
	INVOKE_RESPONSE	= 'Invoke Response';

type

TOnConnectError = procedure (AMessage : String) of object;

TSOAP = class( TObject)

	constructor Create( AURL, AUserName, APassword: string; AOnError : TOnConnectError; AHTTP: TIdHTTP = nil);
	destructor Destroy; override;

	function Invoke( AMethodName: string; AParams, AValues: array of string): TStrings;
	function SimpleInvoke( AMethodName: string; AParams, AValues: array of string): String;
private
	FHTTP: TIdHTTP;
	FIntercept: TIdConnectionIntercept;
	FExternalHTTP: boolean;
	FResponse: string;
	FURL: string;
	FConcat: boolean;
  FOnError : TOnConnectError;

  FQueryResults : TStringList;

	{ ������ �����, �������������� ��� ���������� �������� }
	{ �������� AHTTP, ��� �� �������������� � �����������  }
	FHTTPRequest: TIdHTTPRequest;
	FHTTPOptions: TIdHTTPOptions;
	FTmpIntercept: TIdConnectionIntercept;

	function ExtractHost( AURL: string): string;
  procedure OnReconnectError(E : EIdException);
  //���������� POST ��������� ���, ���� ��������� ������ ����
  procedure DoPost(AFullURL : String; AList : TStringList);

  //���� ����� ���������, ����� ����������� ����� �� �������,
  //�.�. � �������� FHTTP.Response.ContentStream �� ������ �� ������ ��-�� ������ ��� �������� ������
	procedure OnReceive( ASender: TIdConnectionIntercept; var ABuffer : TIdBytes);
  //������� ��� ������� �������������� � ��������
{$ifdef DEBUG}
  procedure HttpReceiveHeadersAvailable(Sender: TObject; AHeaders: TIdHeaderList; var VContinue: Boolean);
	procedure OnSend( ASender: TIdConnectionIntercept; var ABuffer : TIdBytes);
{$endif}
end;

implementation

uses
  AProc, U_ExchangeLog;

{ TSOAP }

constructor TSOAP.Create( AURL, AUserName, APassword: string; AOnError : TOnConnectError; AHTTP: TIdHTTP);
begin
  FQueryResults := TStringList.Create;
  FOnError := AOnError;
	if Assigned( AHTTP) then
	begin
		FExternalHTTP := True;
		FHTTP := AHTTP;
		FHTTPRequest := FHTTP.Request;
		FHTTPOptions := FHTTP.HTTPOptions;
		FTmpIntercept := AHTTP.Intercept;
		FHTTP.Request.Clear;
        end
	else
	begin
		FExternalHTTP := False;
		FHTTP := TIdHTTP.Create( nil);
	end;
	FURL := AURL;
	FConcat := False;
	FIntercept := TIdConnectionIntercept.Create( nil);
	FHTTP.Intercept := FIntercept;
	FHTTP.Request.BasicAuthentication := True;
	FHTTP.Request.Host := ExtractHost( AURL);
	FHTTP.Request.Password := APassword;
	FHTTP.Request.Username := AUserName;
end;

destructor TSOAP.Destroy;
begin
  FQueryResults.Free;
	if not FExternalHTTP then FHTTP.Free
	else
	begin
		FHTTP.Intercept := FTmpIntercept;
		FHTTP.Request := FHTTPRequest;
		FHTTP.HTTPOptions := FHTTPOptions;
	end;
  FIntercept.Free;
end;

procedure TSOAP.DoPost(AFullURL: String; AList: TStringList);
const
  FReconnectCount = 10;
var
  ErrorCount  : Integer;
  PostSuccess : Boolean;
  Params      : TStringList;
begin
  Params := TStringList.Create;
  try

    ErrorCount := 0;
    PostSuccess := False;
    repeat
      try

        Params.Clear;
        Params.AddStrings(AList);
        FHTTP.Post( AFullURL, Params);

        PostSuccess := True;

      except
        on E : EIdConnClosedGracefully do begin
          if (ErrorCount < FReconnectCount) then begin
            if FHTTP.Connected then
              try
                FHTTP.Disconnect;
              except
              end;
            Inc(ErrorCount);
            OnReconnectError(E);
            Sleep(100);
          end
          else
            raise;
        end;
        on E : EIdSocketError do begin
          if (ErrorCount < FReconnectCount) and
            ((e.LastError = Id_WSAECONNRESET) or (e.LastError = Id_WSAETIMEDOUT)
              or (e.LastError = Id_WSAENETUNREACH) or (e.LastError = Id_WSAECONNREFUSED))
          then begin
            if FHTTP.Connected then
              try
                FHTTP.Disconnect;
              except
              end;
            Inc(ErrorCount);
            OnReconnectError(E);
            Sleep(100);
          end
          else
            raise;
        end;
      end;
    until (PostSuccess);

  finally
    Params.Free;
  end;
end;

function TSOAP.ExtractHost( AURL: string): string;
var
  u : TIdURI;
begin
  u := TIdURI.Create(AURL);
  try
    Result := u.Host;
  finally
    u.Free;
  end;
end;

{$ifdef DEBUG}
procedure TSOAP.HttpReceiveHeadersAvailable(Sender: TObject;
  AHeaders: TIdHeaderList; var VContinue: Boolean);
begin
   WriteExchangeLog('TSOAP.OnHeadersAvailable:' + FHTTP.Name, 'Headers :'#13#10 + AHeaders.Text);
end;
{$endif}

{
http://ios.analit.net/PrgDataEx/Code.asmx
}
function TSOAP.Invoke( AMethodName: string; AParams, AValues: array of string): TStrings;
var
  TmpResult : String;
begin
  TmpResult := SimpleInvoke(AMethodName, AParams, AValues);
  FQueryResults.Clear;
  { QueryResults.DelimitedText �� �������� ��-�� �������, ������� ������-�� ��������� ������������ }
  while TmpResult <> '' do FQueryResults.Add( GetNextWord( TmpResult, ';'));
  Result := FQueryResults;
end;

procedure TSOAP.OnReceive( ASender: TIdConnectionIntercept; var ABuffer : TIdBytes);
var
  RecieveString : String;
begin
  RecieveString := BytesToString(ABuffer);
{$ifdef DEBUG}
  //��� ���������� ��������, ����� ���� �������� ����� ��������� ���������� ������� �������
  //WriteExchangeLog('TSOAP.OnReceive:' + FHTTP.Name, RecieveString);
{$endif}
	if FConcat then FResponse := FResponse + RecieveString;
end;

procedure TSOAP.OnReconnectError(E: EIdException);
begin
  if Assigned(FOnError) then
    FOnError('Reconnect on error : ' + E.Message);
  //���������� ���������������, ������� ���������� ���������� FResponse, ����� ��� ����������� ���������
  FResponse := '';
end;

{$ifdef DEBUG}
procedure TSOAP.OnSend(ASender: TIdConnectionIntercept;
  var ABuffer: TIdBytes);
var
  SendString : String;
begin
  SendString := BytesToString(ABuffer);
  //��� ���������� ��������, ����� ���� �������� ����� ��������� ���������� �������� � �������
  //WriteExchangeLog('TSOAP.OnSend:' + FHTTP.Name, SendString);
end;
{$endif}

function TSOAP.SimpleInvoke(AMethodName: string; AParams,
  AValues: array of string): String;
var
	list: TStringList;
	i: integer;
	FullURL: string;
	start, stop: integer;
  TmpResult : String;
begin
	if High( AParams) <> High( AValues) then
		raise Exception.Create( '����������� ���������� ���������� � ��������');
	list := TStringList.Create;
	list.Clear;
	list.Add( '');
	list.Add( '');
	for i := Low( AParams) to High( AParams) do
	begin
		list[ 1] := list[ 1] + AParams[ i] + '=' + AValues[ i];
		if i < High( AParams) then list[ 1] := list[ 1] + '&';
	end;
	FullURL := FURL;
	if FullURL[ Length( FullURL)] <> '/' then FullURL := FullURL + '/';
	FullURL := FullURL + AMethodName;
	FResponse := '';
	FConcat := True;
	try

    FIntercept.OnReceive := OnReceive;
{$ifdef DEBUG}
    FIntercept.OnSend := OnSend;
    FHTTP.OnHeadersAvailable := HttpReceiveHeadersAvailable;
{$endif}
    try
{$ifdef DEBUG}
      WriteExchangeLog('TSOAP.SimpleInvoke:' + FHTTP.Name, 'MethodName : ' + AMethodName);
{$endif}

      DoPost(FullURL, list);
    finally
      FIntercept.OnReceive := nil;
{$ifdef DEBUG}
      FHTTP.OnHeadersAvailable := nil;
      FIntercept.OnSend := nil;
{$endif}
    end;

	except
    //���������� ���������������� ������, ������� ������ �������� �� ������
    WriteExchangeLog('SOAP.Response.Raw:' + FHTTP.Name, Utf8ToAnsi(FResponse));
    raise;
	end;
	FConcat := False;
	list.Free;

  //���������� ���������������� ������, ���� �� ������� �������� ���, �������� �� 200
  if (FHTTP.ResponseCode <> 200) then
    WriteExchangeLog('SOAP.Response.Raw:' + FHTTP.Name, Utf8ToAnsi(FResponse));

  if (FHTTP.ResponseCode = 401) or (FHTTP.ResponseCode = 403) then
    raise Exception.Create('������ ��������.'#13#10'������� ������������ ������� ������.')
  else
    if (FHTTP.ResponseCode = 407) then
      raise Exception.Create('������ ��������.'#13#10'������� ������������ ������� ������ ��� ������-�������.')
    else
      if (FHTTP.ResponseCode <> 200) then
        raise Exception.Create('��� ���������� ������ ������� ��������� ������.'#13#10'��������� ������ ����� ��������� �����.');

	start := PosEx( '>', FResponse, Pos( 'xmlns', FResponse)) + 1;
	stop := PosEx( '</', FResponse, start);
	TmpResult := Copy( FResponse, start, stop - start);
  Result := TmpResult;
end;

end.
