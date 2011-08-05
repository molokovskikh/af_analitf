unit U_SchedulesController;

interface

uses
  SysUtils, Classes, Contnrs, DB, StrUtils, Variants,
  DateUtils,
  //App modules
  Constant,
  AProc,
  DModule,
  ExchangeParameters,
  U_ExchangeLog,
  MyAccess,
  U_DBMapping;

type
  TScheduleCheckItem = record
    Hour,
    Minute : Word;
  end;

  TScheduleItem = class
   public
    Id : Int64;
    Hour,
    Minute : Integer;
    function LessOrEqualThan(checkItem : TScheduleCheckItem) : Boolean;
    function GreaterThan(checkItem : TScheduleCheckItem) : Boolean;
  end;

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
    function IsPreviosDayUpdate : Boolean;
    function GetUpdateCheckItem : TScheduleCheckItem;
    function GetCurrentCheckItem : TScheduleCheckItem;
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

function TSchedulesController.GetCurrentCheckItem: TScheduleCheckItem;
var
  tmp : Word;
begin
  DecodeTime(Now(), Result.Hour, Result.Minute, tmp, tmp);
end;

function TSchedulesController.GetUpdateCheckItem: TScheduleCheckItem;
var
  d : TDateTime;
  tmp : Word;
begin
  d := UTCToLocalTime(DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime);
  DecodeTime(d, Result.Hour, Result.Minute, tmp, tmp);
end;

function TSchedulesController.IsPreviosDayUpdate: Boolean;
begin
  Result := UTCToLocalTime(DM.adtParams.FieldByName( 'UpdateDateTime').AsDateTime) < Date();
end;

procedure TSchedulesController.LoadSchedules;
var
  dataSet : TMyQuery;
  scheduleItem : TScheduleItem;
  newList : TObjectList;
begin
  dataSet := TDBMapping.GetSqlDataSet(
    DM.MainConnection,
 'select '
+'  Id, '
+'  Hour, '
+'  Minute '
+'from        '
+'    schedules '
+'order by Hour, Minute ',
    [],
    []);

  newList := TObjectList.Create();
  try
    try
      while not dataSet.Eof do begin
        scheduleItem := TScheduleItem.Create();
        scheduleItem.Id := dataSet['Id'];
        scheduleItem.Hour := dataSet['Hour'];
        scheduleItem.Minute := dataSet['Minute'];

        newList.Add(scheduleItem);
        dataSet.Next;
      end;
    finally
      dataSet.Free;
    end;
  except
    newList.Free;
    raise;
  end;

  FreeAndNil(FSchedules);
  FSchedules := newList;
end;

function TSchedulesController.NeedUpdate: Boolean;
var
  I : Integer;
  currentItem,
  updateItem : TScheduleCheckItem;
  currentSchedule : TScheduleItem;
begin
  Result := False;

  updateItem := GetUpdateCheckItem();
  currentItem := GetCurrentCheckItem();
  
  for I := 0 to FSchedules.Count-1 do begin
    currentSchedule := TScheduleItem(FSchedules[i]);
    if currentSchedule.GreaterThan(updateItem) then begin
      if currentSchedule.LessOrEqualThan(currentItem) then
        Result := True;
      Break;
    end;
  end;
end;

function TSchedulesController.NeedUpdateOnBegin: Boolean;
var
  I : Integer;
  updateItem : TScheduleCheckItem;
  currentSchedule : TScheduleItem;
begin
  Result := SchedulesEnabled and DM.adtParams.FieldByName( 'UpdateDateTime').IsNull;
  if not Result then begin
    if IsPreviosDayUpdate() then begin
      updateItem := GetUpdateCheckItem();
      for I := 0 to FSchedules.Count-1 do begin
        currentSchedule := TScheduleItem(FSchedules[i]);
        if currentSchedule.GreaterThan(updateItem) then begin
          Result := True;
          Break;
        end;
      end;
    end
    else
      Result := NeedUpdate();
  end;
end;

function TSchedulesController.SchedulesEnabled: Boolean;
begin
  Result := FSchedules.Count > 0;
end;

{ TScheduleItem }

function TScheduleItem.GreaterThan(checkItem: TScheduleCheckItem): Boolean;
begin
  Result :=
  (Hour > checkItem.Hour)
  or
  ((Hour >= checkItem.Hour) and (Minute > checkItem.Minute));
end;

function TScheduleItem.LessOrEqualThan(
  checkItem: TScheduleCheckItem): Boolean;
begin
  result :=
  (Hour < checkItem.Hour)
  or
  ((Hour = checkItem.Hour) and (Minute <= checkItem.Minute));
end;

initialization
  FSchedulesController := TSchedulesController.Create;
end.
