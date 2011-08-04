unit U_SchedulesController;

interface

uses
  SysUtils, Classes, Contnrs, DB, StrUtils, Variants,
  DateUtils,
  //App modules
  Constant, DModule, ExchangeParameters, U_ExchangeLog;

type
  TSchedulesController = class
   private
    FSchedules : TObjectList;
   public
    constructor Create();
    destructor Destroy; override;
    procedure LoadSchedules();
    function SchedulesEnabled : Boolean;
    function NeedUpdateOnBegin : Boolean;
    function NeedUpdate : Boolean;
  end;

  function SchedulesController() : TSchedulesController;

implementation

var
  FSchedulesController : TSchedulesController;

function SchedulesController() : TSchedulesController;
begin
  Result := FSchedulesController;
end;

{ TSchedulesController }

constructor TSchedulesController.Create;
begin
  FSchedules := TObjectList.Create(True);
end;

destructor TSchedulesController.Destroy;
begin
  FSchedules.Free;
  inherited;
end;

procedure TSchedulesController.LoadSchedules;
begin
  //DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime
end;

function TSchedulesController.NeedUpdate: Boolean;
begin
  Result := True;
end;

function TSchedulesController.NeedUpdateOnBegin: Boolean;
begin
  Result := False;
end;

function TSchedulesController.SchedulesEnabled: Boolean;
begin
  Result := FSchedules.Count > 0;
end;

initialization
  FSchedulesController := TSchedulesController.Create;
end.
