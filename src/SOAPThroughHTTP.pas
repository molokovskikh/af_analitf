unit SOAPThroughHTTP;

interface

uses IdHTTP, IdIntercept, SysUtils, StrUtils, Classes, IdException, WinSock, IdURI;

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

	{ √руппа полей, использующихс€ дл€ временного хранени€ }
	{ настроек AHTTP, дл€ их восстановлени€ в деструкторе  }
	FHTTPRequest: TIdHTTPRequest;
	FHTTPOptions: TIdHTTPOptions;
	FTmpIntercept: TIdConnectionIntercept;

	function ExtractHost( AURL: string): string;
	procedure OnReceive( ASender: TIdConnectionIntercept; AStream: TStream);
  procedure OnReconnectError(E : EIdException);
end;

implementation

uses
  AProc;

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
		FHTTP.Host := ExtractHost( AURL);
	end;
	FURL := AURL;
	FConcat := False;
	FIntercept := TIdConnectionIntercept.Create( nil);
	FIntercept.OnReceive := OnReceive;
	FHTTP.Intercept := FIntercept;
//	FHTTP.HTTPOptions := [];
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

{
http://ios.analit.net/PrgDataEx/Code.asmx
}

function TSOAP.Invoke( AMethodName: string; AParams, AValues: array of string): TStrings;
var
  TmpResult : String;
begin
  TmpResult := SimpleInvoke(AMethodName, AParams, AValues);
  FQueryResults.Clear;
  { QueryResults.DelimitedText не работает из-за пробела, который почему-то считаетс€ разделителем }
  while TmpResult <> '' do FQueryResults.Add( GetNextWord( TmpResult, ';'));
  Result := FQueryResults;
end;

procedure TSOAP.OnReceive( ASender: TIdConnectionIntercept; AStream: TStream);
var
	ss: TStringStream;
begin
	ss := TStringStream.Create( '');
	ss.CopyFrom( AStream, AStream.Size);
	if FConcat then FResponse := FResponse + ss.DataString;
	ss.Free;
end;

procedure TSOAP.OnReconnectError(E: EIdException);
begin
  if Assigned(FOnError) then
    FOnError('Reconnect on error : ' + E.Message);
  //ѕроисходит переподключение, поэтому сбрасываем переменную FResponse, чтобы она заполнилась корректно
  FResponse := '';
end;

function TSOAP.SimpleInvoke(AMethodName: string; AParams,
  AValues: array of string): String;
var
	list: TStringList;
	i: integer;
	FullURL: string;
	start, stop: integer;
	ExceptMessage: string;
  TmpResult : String;
begin
	if High( AParams) <> High( AValues) then
		raise Exception.Create( 'Ќесовпадает количество параметров и значений');
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

    FHTTP.OnReconnectError := OnReconnectError;
    try
      FHTTP.Post( FullURL, list);
    finally
      FHTTP.OnReconnectError := nil;
    end;

	except
		on E: Exception do
		begin
			if ( Pos( #$D#$A#$D#$A, FResponse) > 0) then begin
				ExceptMessage := Copy( FResponse, Pos( #$D#$A#$D#$A, FResponse) + 4, Length( FResponse));
        if Length(ExceptMessage) = 0 then
          ExceptMessage := e.ClassName + ': ' + e.Message;
  			raise Exception.Create( ExceptMessage);
      end
			else
        raise;
		end;
	end;
	FConcat := False;
	list.Free;

	start := PosEx( '>', FResponse, Pos( 'xmlns', FResponse)) + 1;
	stop := PosEx( '</', FResponse, start);
	TmpResult := Copy( FResponse, start, stop - start);
  Result := TmpResult;
end;

end.
