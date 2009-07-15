unit SOAPThroughHTTP;

interface

uses IdHTTP, IdIntercept, SysUtils, StrUtils, Classes, IdException, WinSock, IdURI,
  IdGlobal, IdStack, IdStackConsts, IdComponent, IdHeaderList;

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
  FOnError : TOnConnectError;

  FQueryResults : TStringList;

	{ √руппа полей, использующихс€ дл€ временного хранени€ }
	{ настроек AHTTP, дл€ их восстановлени€ в деструкторе  }
	FHTTPRequest: TIdHTTPRequest;
	FHTTPOptions: TIdHTTPOptions;
	FTmpIntercept: TIdConnectionIntercept;

	function ExtractHost( AURL: string): string;
  procedure OnReconnectError(E : EIdException);
  //ѕроизводим POST несколько раз, если возникают ошибки сети
  procedure DoPost(AFullURL : String; ASource: TStringList);

  //Ётот метод необходим, чтобы формировать ответ от сервера,
  //т.к. в свойстве FHTTP.Response.ContentStream он бывает не полным из-за ошибок при передачи данных
	procedure OnReceive( ASender: TIdConnectionIntercept; var ABuffer : TIdBytes);
  //—обыти€ дл€ отладки взаимодействи€ с сервером
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

procedure TSOAP.DoPost(AFullURL: String; ASource: TStringList);
const
  FReconnectCount = 10;
var
  ErrorCount  : Integer;
  PostSuccess : Boolean;
begin
  ErrorCount := 0;
  PostSuccess := False;
  repeat
    try

      FHTTP.Post( AFullURL, ASource);

      PostSuccess := True;

    except
      on E : EIdConnClosedGracefully do begin
        if (ErrorCount < FReconnectCount) then begin
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
  { QueryResults.DelimitedText не работает из-за пробела, который почему-то считаетс€ разделителем }
  while TmpResult <> '' do FQueryResults.Add( GetNextWord( TmpResult, ';'));
  Result := FQueryResults;
end;

procedure TSOAP.OnReceive( ASender: TIdConnectionIntercept; var ABuffer : TIdBytes);
var
  RecieveString : String;
begin
  RecieveString := BytesToString(ABuffer);
  FResponse := FResponse + RecieveString;
{$ifdef DEBUG}
  //Ёто необходимо включить, когда надо получать более детальную хронологию ответов сервера
  //WriteExchangeLog('TSOAP.OnReceive:' + FHTTP.Name, RecieveString);
{$endif}
end;

procedure TSOAP.OnReconnectError(E: EIdException);
begin
  //ѕроисходит переподключение, поэтому сбрасываем переменную FResponse, чтобы она заполнилась корректно
  FResponse := '';
  if Assigned(FOnError) then
    FOnError('Reconnect on error : ' + E.Message);
end;

{$ifdef DEBUG}
procedure TSOAP.OnSend(ASender: TIdConnectionIntercept;
  var ABuffer: TIdBytes);
var
  SendString : String;
begin
  SendString := BytesToString(ABuffer);
  //Ёто необходимо включить, когда надо получать более детальную хронологию запросов к серверу
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
  ForceEncodeParamsSet : Boolean;
begin
	if High( AParams) <> High( AValues) then
		raise Exception.Create( 'Ќесовпадает количество параметров и значений');

	FullURL := FURL;
	if FullURL[ Length( FullURL)] <> '/' then FullURL := FullURL + '/';
	FullURL := FullURL + AMethodName;

	FResponse := '';
	try

    list := TStringList.Create;
    try
      list.Clear;
      for i := Low( AParams) to High( AParams) do
      begin
        list.Add(
          AParams[i] +
          '=' +
          StringReplace(TIdURI.ParamsEncode(AValues[i]), '&', '%26', [rfReplaceAll]));
      end;

      //ѕровере€м, усталовен ли параметр hoForceEncodeParams
      //Ётот параметр надо сбросить, чтобы передаваемые значени€ не кодировались IdHTTP
      ForceEncodeParamsSet := hoForceEncodeParams in FHTTP.HTTPOptions;
      FHTTP.HTTPOptions := FHTTP.HTTPOptions - [hoForceEncodeParams];
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
        if ForceEncodeParamsSet then
          FHTTP.HTTPOptions := FHTTP.HTTPOptions + [hoForceEncodeParams];
        FIntercept.OnReceive := nil;
  {$ifdef DEBUG}
        FHTTP.OnHeadersAvailable := nil;
        FIntercept.OnSend := nil;
  {$endif}
      end;
    finally
      list.Free;
    end;

	except
    //ѕроизводим протоколирование ответа, который успели получить до ошибки
    //todo: !!! не логировать просто так содержание ответа, только заголовки
    WriteExchangeLog('SOAP.Response.Raw:' + FHTTP.Name, Utf8ToAnsi(FResponse));
    raise;
	end;

  //ѕроизводим протоколирование ответа, если от сервера получили код, отличный от 200
  if (FHTTP.ResponseCode <> 200) then
    WriteExchangeLog('SOAP.Response.Raw:' + FHTTP.Name, Utf8ToAnsi(FResponse));

  if (FHTTP.ResponseCode = 401) or (FHTTP.ResponseCode = 403) then
    raise Exception.Create('ƒоступ запрещен.'#13#10'¬ведены некорректные учетные данные.')
  else
    if (FHTTP.ResponseCode = 407) then
      raise Exception.Create('ƒоступ запрещен.'#13#10'¬ведены некорректные учетные данные дл€ прокси-сервера.')
    else
      if (FHTTP.ResponseCode <> 200) then
        raise Exception.Create('ѕри выполнении вашего запроса произошла ошибка.'#13#10'ѕовторите запрос через несколько минут.');

	start := PosEx( '>', FResponse, Pos( 'xmlns', FResponse)) + 1;
	stop := PosEx( '</', FResponse, start);
	TmpResult := Copy( FResponse, start, stop - start);
  Result := TmpResult;
end;

end.
