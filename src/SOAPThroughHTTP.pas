unit SOAPThroughHTTP;

interface

uses IdHTTP, IdIntercept, SysUtils, StrUtils, Classes;

const
	INVOKE_RESPONSE	= 'Invoke Response';

type

TSOAP = class( TObject)
	constructor Create( AURL, AUserName, APassword: string; AHTTP: TIdHTTP = nil);
	destructor Destroy; override;

	function Invoke( AMethodName: string; AParams, AValues: array of string): string;
private
	FHTTP: TIdHTTP;
	FIntercept: TIdConnectionIntercept;
	FExternalHTTP: boolean;
	FResponse: string;
	FURL: string;
	FConcat: boolean;

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

constructor TSOAP.Create( AURL, AUserName, APassword: string; AHTTP: TIdHTTP);
begin
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
	FHTTP.HTTPOptions := [];
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
		FHTTP.Post( FullURL, list);
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
