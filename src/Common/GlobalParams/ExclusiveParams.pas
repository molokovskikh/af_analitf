unit ExclusiveParams;

interface

uses
  SysUtils,
  Classes,
  MyAccess,
  MyServerControl,
  GlobalParams,
  UniqueId,
  SysNames;

type
  TExclusiveParams = class(TGlobalParams)
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

uses Variants, DB;

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
    Result := ServerControl.RecordCount;
  finally
    ServerControl.Free;
  end;
end;

procedure TExclusiveParams.ReadParams;
var
  value : Variant;
begin
  value := GetParam('ExclusiveId');
  if VarIsNull(value) then
    ExclusiveId := ''
  else
    ExclusiveId := value;
  value := GetParam('ExclusiveComputerName');
  if VarIsNull(value) then
    ExclusiveComputerName := ''
  else
    ExclusiveComputerName := value;
  value := GetParam('ExclusiveDate');
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
end;

function TExclusiveParams.SelfExclusive: Boolean;
begin
  Result := ExclusiveId = GetPathCopyID();
end;

procedure TExclusiveParams.SetExclusive;
begin
  ExclusiveId := GetPathCopyID();
  ExclusiveComputerName := GetComputerName_();
  ExclusiveDate := Now;
  SaveParams;
end;

end.
