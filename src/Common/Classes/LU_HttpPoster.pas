unit LU_HttpPoster;

interface

uses
 syncobjs,
 IdHttp,
 contnrs,
 classes;

type
 TPostResult = ( tprOK, tprException );

 THttpPosterCallback = procedure (
                        AResult : TPostResult;
                        AMessage : string ) of object;

 THttpPoster = class
  private
   CS      : TCriticalSection;
   queue   : TObjectList;
   worker  : TThread;
   event   : TSimpleEvent;
   Timeout : integer;
   PID     : Integer;
   function get : TObject;
  public
   //ATimeout - максимальное врем€ пребывани€ запроса в очереди в секундах
   //(делать более мелкое разрешение e.g. миллисекунды не вижу смысла )
   //если запрос стоит в очереди больше оговоренного времени, “о он не
   //исполн€етс€
   //ATimeout <= 0 испон€ть всегда.
   constructor Create ( ATimeout : integer );
   destructor  Destroy;override;
   //AURL      - полностью сформированный запрос, включа€ параметры.
   //AData     - метод получает во владение
   //ACallback - может быть NIL
   procedure   Post (
                AURL : string;
                AData : TMemoryStream;
                ACallback : THttpPosterCallback;
                AUser     : string;
                APassword : string );
 end;

implementation

uses
 LU_Tracer,
 LU_TTimeIndicator,
 sysutils,
 LU_TimeUtils;

type
 TRequestContainer = class
  public
   CreationStamp : TDateTime;
   FAURL         : string;
   FData         : TMemoryStream;
   FCallback     : THttpPosterCallback;
   FUser         : string;
   FPassword     : string;
   FLifeTimeGMT  : TDateTime;
   constructor Create;
   destructor  Destroy;override;
 end;

 TWorker = class ( TThread )
  private
   http : TIdHttp;
  protected
   procedure Execute;override;
  public
   event  : TSimpleEvent;
   poster : THttpPoster;
 end;

var
  HttpPosterID : Integer;

{ THttpPoster }

constructor THttpPoster.Create(ATimeout: integer);
begin
 PID := HttpPosterID;
 Inc(HttpPosterID);
 Timeout := ATimeout;
 CS     := TCriticalSection.Create;
 queue  := TObjectList.Create;
 queue.OwnsObjects := False;
 worker := TWorker.Create ( True );
 event := TSimpleEvent.Create;
 TWorker (worker).poster := Self;
 TWorker (worker).event := event;
 worker.Resume;
end;

destructor THttpPoster.Destroy;
begin
  event.SetEvent;
  worker.Terminate;
  event.SetEvent;
  CS.Free;
  queue.Free;
  event.Free;
  worker.Free;
  inherited;
end;

function THttpPoster.get: TObject;
begin
 CS.Enter;
 try
   if queue.Count > 0 then
     begin
      Result := queue[0];
      queue.Delete ( 0 );
     end
    else
     Result := NIL;
  finally
   CS.Leave;
 end;
 
end;

procedure THttpPoster.Post(AURL: string; AData: TMemoryStream;
  ACallback: THttpPosterCallback;
  AUser     : string;
  APassword : string);
var
 req : TRequestContainer;
begin
 req           := TRequestContainer.Create;
 req.FAURL     := AURL;
 req.FData     := AData;
 req.FCallback := ACallback;
 req.FUser     := AUser;
 req.FPassword := APassword;
 if Timeout <= 0 then
   req.FLifeTimeGMT := NowGMT + 10000 // 10000 дней дл€ программы это вечно.
  else
   req.FLifeTimeGMT := NowGMT + Timeout /SecsPerDay;
 CS.Enter;
 try
   queue.Add ( req );
  finally
   CS.Leave;
 end;
 event.SetEvent;
end;

{ TRequestContainer }

constructor TRequestContainer.Create;
begin
 CreationStamp := NowGMT;
end;

destructor TRequestContainer.Destroy;
begin
  FData.Free;
  inherited;
end;

{ TWorker }

procedure TWorker.Execute;
var
 o : TRequestContainer;
 m : TMemoryStream;
 s : string;
 l : integer;
begin
  http := TIdHTTP.Create(NIL);
  with http do
  begin
    Name := 'hc';
    ConnectTimeout := poster.Timeout*1000;
    ReadTimeout := poster.Timeout*1000;
    AllowCookies := True;
    Request.ContentType := 'text/plain';
    Request.BasicAuthentication := True;
    Request.UserAgent := 'HttpPoster';
  end;

 try
   while not Terminated do
    begin
     event.WaitFor ( 1 );
     event.ResetEvent;
     if not Terminated then begin
       o := TRequestContainer ( poster.get );
       if Assigned ( o ) then
        try
          //≈сть запрос слишком долго сто€л в очереди - удал€ем.
          if o.FLifeTimeGMT >= NowGMT then
           begin
              if o.FUser <> '' then
               begin
                http.Request.Password := o.FPassword;
                http.Request.Username := o.FUser;
               end;
              m := TMemoryStream.Create;
              try TimeIndicator.StartTime (
               'HttpPost(' + IntToStr(poster.PID) + '):'+o.FAURL ); except end;
              try
                try
                  try TimeIndicator.StartTime (
                   'HttpPostIndy(' + IntToStr(poster.PID) + '):'+o.FAURL ); except end;
                  try
                    http.Post ( o.FAURL , o.FData , m );
                  finally
                    try TimeIndicator.StopTime (
                     'HttpPostIndy(' + IntToStr(poster.PID) + '):'+o.FAURL );except end;
                  end;
                  l := m.Size;
                  m.Seek ( 0 , soFromBeginning );
                  SetLength ( s , l );
                  if ( Length ( s ) > 0 )then
                   m.Read ( s[1] , l );
                  if Assigned ( o.FCallback ) then
                   o.FCallback ( tprOK , s );
                 except
                  on E : Exception do
                   begin
                    if Assigned ( o.FCallback ) then
                     o.FCallback ( tprException , E.message );
                   end;
                end;
               finally
                m.Free;
                try TimeIndicator.StopTime (
                 'HttpPost(' + IntToStr(poster.PID) + '):'+o.FAURL );except end;
              end;
           end
            else
             begin
              //«апрос не отправили и он будет удален в finally секции
              o.FCallback ( tprException ,
               'THttpPoster: «апрос просто€л в очереди слишком'+
               ' долго и удал€етс€ без отправки' );
             end;
         finally
          o.Free;
        end;
     end;
    end;
  except
   on E : Exception do
    if not Terminated then
      Tracer.TR ( 'httpPoster' , '»сключение в нити: ' + E.message );
 end;
end;

initialization
  HttpPosterID := 0;
end.
