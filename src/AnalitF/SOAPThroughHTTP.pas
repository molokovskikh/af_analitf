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
  function SimpleInvoke(
    MethodName: string;
    Params,
    Values: array of string): String; overload;
  function SimpleInvoke(
    MethodName: string;
    PostParams : TStringList): String; overload;
  function PreparePostValue(PostValue : String) : String;
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
      on E : EIdCouldNotBindSocket do begin
        if (ErrorCount < FReconnectCount) then begin
          try
            FHTTP.Disconnect;
          except
          end;
          Inc(ErrorCount);
          OnReconnectError(E);
          Sleep(1000);
        end
        else
          raise;
      end;
      on E : EIdConnClosedGracefully do begin
        if (ErrorCount < FReconnectCount) then begin
          try
            FHTTP.Disconnect;
          except
          end;
          Inc(ErrorCount);
          OnReconnectError(E);
          Sleep(500);
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
          Sleep(500);
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

function TSOAP.SimpleInvoke(
  MethodName: string;
  Params,
  Values: array of string): String;
var
  list: TStringList;
  i: integer;
begin
  if High(Params) <> High(Values) then
    raise Exception.Create( 'Ќесовпадает количество параметров и значений');

  list := TStringList.Create;
  try
    for i := Low(Params) to High(Params) do
      if Length(Params[i]) > 0 then
        list.Add(Params[i] + '=' + PreparePostValue(Values[i]));

    Result := SimpleInvoke(MethodName, list);

  finally
    list.Free;
  end;
end;

function TSOAP.PreparePostValue(PostValue: String): String;
begin
  Result :=
    StringReplace(TIdURI.ParamsEncode(PostValue), '&', '%26', [rfReplaceAll]);
  Result :=
    StringReplace(Result, '+', '%2B', [rfReplaceAll]);
end;

function TSOAP.SimpleInvoke(
  MethodName: string;
  PostParams: TStringList): String;
var
  FullURL: string;
  start, stop: integer;
  TmpResult : String;
  ForceEncodeParamsSet : Boolean;
  ResponseLog : String;
  Utf8Response : String;
begin
  FullURL := FURL;
  if FullURL[ Length( FullURL)] <> '/' then FullURL := FullURL + '/';
  FullURL := FullURL + MethodName;

  FResponse := '';
  try

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
      WriteExchangeLog(
        'TSOAP.SimpleInvoke:' + FHTTP.Name,
        'MethodName : ' + MethodName);
{$endif}

      DoPost(FullURL, PostParams);
    finally
      if ForceEncodeParamsSet then
        FHTTP.HTTPOptions := FHTTP.HTTPOptions + [hoForceEncodeParams];
      FIntercept.OnReceive := nil;
{$ifdef DEBUG}
      FHTTP.OnHeadersAvailable := nil;
      FIntercept.OnSend := nil;
{$endif}
    end;

  except
    //ѕроизводим протоколирование ответа, который успели получить до ошибки
{$ifndef DEBUG}
    if ( Pos( #$D#$A#$D#$A, FResponse) > 0) then
      ResponseLog := Copy(FResponse,
        Pos( #$D#$A#$D#$A, FResponse) + 4, Length( FResponse))
    else
{$endif}
      ResponseLog := FResponse;
    Utf8Response := Utf8ToAnsi(ResponseLog);
    if Length(Utf8Response) > 0 then
      WriteExchangeLog('SOAP.Response.Raw:' + FHTTP.Name, Utf8Response)
    else
      WriteExchangeLog('SOAP.Response.Raw:' + FHTTP.Name, ResponseLog);
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
