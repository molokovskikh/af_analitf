unit ExclusiveParams;

interface

uses
  SysUtils,
  Classes,
  DB,
  MyAccess,
  MyServerControl,
  GlobalParams,
  UniqueId,
  DBProc,
  SysNames;

type
  TExclusiveParams = class(TGlobalParams)
   private
    procedure FilterDB(DataSet: TDataSet; var Accept: Boolean);
   public
    ExclusiveId : String;
    ExclusiveComputerName : String;
    ExclusiveDate : TDateTime;
    procedure ReadParams; override;
    procedure SaveParams; override;
    procedure SetExclusive;
    procedure ResetExclusive;
    function CountOfProcess : Integer;
    function ClearOrSelfExclusive : Boolean;
    function SelfExclusive : Boolean;
  end;

implementation

uses
  Variants;

{ TExclusiveParams }

function TExclusiveParams.ClearOrSelfExclusive: Boolean;
begin
  Result := (ExclusiveId = '') or SelfExclusive;
end;

function TExclusiveParams.CountOfProcess: Integer;
var
  ServerControl : TMyServerControl;
begin
  ServerControl := TMyServerControl.Create(nil);
  try
    ServerControl.Connection := FConnection;
    ServerControl.ShowProcessList(True);
    try
      SetFilterProc(ServerControl, FilterDB);
      Result := ServerControl.RecordCount;
    finally
      SetFilterProc(ServerControl, nil);
    end;
  finally
    ServerControl.Free;
  end;
end;

procedure TExclusiveParams.FilterDB(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := AnsiCompareText('analitf', DataSet.FieldByName('DB').AsString) = 0;
end;

procedure TExclusiveParams.ReadParams;
var
  value : Variant;
begin
  value := GetParam('ExclusiveId', 'analitf');
  if VarIsNull(value) then
    ExclusiveId := ''
  else
    ExclusiveId := value;
  value := GetParam('ExclusiveComputerName', 'analitf');
  if VarIsNull(value) then
    ExclusiveComputerName := ''
  else
    ExclusiveComputerName := value;
  value := GetParam('ExclusiveDate', 'analitf');
  if VarIsNull(value) then
    ExclusiveDate := 0
  else
    ExclusiveDate := VarToDateTime(value);
end;

procedure TExclusiveParams.ResetExclusive;
begin
  ExclusiveId := '';
  ExclusiveComputerName := '';
  ExclusiveDate := 0;
  SaveParams;
end;

procedure TExclusiveParams.SaveParams;
begin
  SaveParam('ExclusiveId', ExclusiveId);
  SaveParam('ExclusiveComputerName', ExclusiveComputerName);
  SaveParam('ExclusiveDate', ExclusiveDate);
  inherited;
end;

function TExclusiveParams.SelfExclusive: Boolean;
begin
  Result := ExclusiveId = GetNetworkCopyID();
end;

procedure TExclusiveParams.SetExclusive;
begin
  ExclusiveId := GetNetworkCopyID();
  ExclusiveComputerName := GetComputerName_();
  ExclusiveDate := Now;
  SaveParams;
end;

end.
