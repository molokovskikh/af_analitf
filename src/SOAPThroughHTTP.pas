unit SOAPThroughHTTP;

interface

uses IdHTTP, IdIntercept, SysUtils, StrUtils, Classes, IdException, WinSock;

const
	INVOKE_RESPONSE	= 'Invoke Response';

type

TOnConnectError = procedure (AMessage : String) of object;

TSOAP = class( TObject)

	constructor Create( AURL, AUserName, APassword: string; AOnError : TOnConnectError; AHTTP: TIdHTTP = nil);
	destructor Destroy; override;

	function Invoke( AMethodName: string; AParams, AValues: array of string): string;
private
	FHTTP: TIdHTTP;
	FIntercept: TIdConnectionIntercept;
	FExternalHTTP: boolean;
	FResponse: string;
	FURL: string;
	FConcat: boolean;
  FOnError : TOnConnectError;

	{ √руппа полей, использующихс€ дл€ временного хранени€ }
	{ настроек AHTTP, дл€ их восстановлени€ в деструкторе  }
	FHTTPRequest: TIdHTTPRequest;
	FHTTPOptions: TIdHTTPOptions;
	FTmpIntercept: TIdConnectionIntercept;

	function ExtractHost( AURL: string): string;
	procedure OnReceive( ASender: TIdConnectionIntercept; AStream: TStream);
end;

implementation

{ TSOAP }

constructor TSOAP.Create( AURL, AUserName, APassword: string; AOnError : TOnConnectError; AHTTP: TIdHTTP);
begin
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
	start, stop: integer;
begin
	if Pos( 'http://', AnsiLowerCase( AURL)) > 0 then
		start := Pos( 'http://', AnsiLowerCase( AURL)) + 7
	else start := 1;
	stop := PosEx( '/', AnsiLowerCase( AURL), start);
	result := Copy( AURL, start, stop - start);
end;

{
http://ios.analit.net/PrgDataEx/Code.asmx
}

function TSOAP.Invoke( AMethodName: string; AParams, AValues: array of string): string;
var
	list: TStringList;
	i: integer;
	FullURL: string;
	start, stop: integer;
	ExceptMessage: string;
  ErrorCount : Integer;
  PostSuccess : Boolean;
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
    ErrorCount := 0;
    PostSuccess := False;
    repeat
      try
        FHTTP.Post( FullURL, list);
        PostSuccess := True;
      except
        on E : EIdSocketError do begin
          if (ErrorCount < 10) and
            ((e.LastError = WSAECONNRESET) or (e.LastError = WSAETIMEDOUT)
              or (e.LastError = WSAENETUNREACH) or (e.LastError = WSAECONNREFUSED))
          then begin
            if FHTTP.Connected then
            try
              FHTTP.Disconnect;
            except
              on E : Exception do
                if Assigned(FOnError) then
                  FOnError('Error on Disconnect : ' + e.Message);
            end;
            if Assigned(FOnError) then
              FOnError('Reconnect on error : ' + e.Message);
            Inc(ErrorCount);
            Sleep(100);
          end
          else
            raise;
        end;
      end;
    until (PostSuccess);
	except
		on E: Exception do
		begin
			if ( Pos( #$D#$A#$D#$A, FResponse) > 0) then
				ExceptMessage := Copy( FResponse,
				Pos( #$D#$A#$D#$A, FResponse) + 4, Length( FResponse))
			else ExceptMessage := E.Message;
			raise Exception.Create( ExceptMessage);
		end;
	end;
	FConcat := False;
	list.Free;

	start := PosEx( '>', FResponse, Pos( 'xmlns', FResponse)) + 1;
	stop := PosEx( '</', FResponse, start);
	result := Copy( FResponse, start, stop - start);
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

end.
