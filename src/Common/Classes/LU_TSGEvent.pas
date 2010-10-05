unit LU_TSGEvent;

interface

uses
 classes;

type
 //Базовый класс для сообытий системы.
 TSGEvent = class ( TComponent )
  private
   //Метка времени создания объекта
   eventCreationDate : TDateTime;
  public
   //получить метку времни создания объекта
   function    getEventCreationDate : TDateTime;
   constructor Create ( AOwner : TComponent );override;
   function    Dump : string;virtual;
   destructor  Destroy;override;
 end;

implementation

uses
  sysutils,
  LU_LeakWatcher;

{ TSGEvent }

constructor TSGEvent.Create(AOwner: TComponent);
begin
  inherited Create ( AOwner );
  eventCreationDate := Now;
  LW.RegisterReference ( Self );
end;

destructor TSGEvent.Destroy;
begin
  LW.UnRegisterReference ( Self );
  inherited;
end;

function TSGEvent.Dump: string;
begin
 Result := 'неопределено';
end;

function TSGEvent.getEventCreationDate: TDateTime;
begin
 Result := eventCreationDate;
end;

end.
