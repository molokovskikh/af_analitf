unit LU_TSGEvent;

interface

uses
 classes;

type
 //������� ����� ��� �������� �������.
 TSGEvent = class ( TComponent )
  private
   //����� ������� �������� �������
   eventCreationDate : TDateTime;
  public
   //�������� ����� ������ �������� �������
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
 Result := '������������';
end;

function TSGEvent.getEventCreationDate: TDateTime;
begin
 Result := eventCreationDate;
end;

end.
