unit ExclusiveParams;

interface

uses
  SysUtils,
  Classes,
  MyAccess,
  GlobalParams;

type
  TExclusiveParams = class(TGlobalParams)
   public
    ExclusiveId : String;
    ExclusiveComputerName : String;
    ExclusiveDate : TDateTime;
    procedure ReadParams; override;
    procedure SaveParams; override;
  end;

implementation

uses Variants;

{ TExclusiveParams }

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
    ExclusiveDate := value;
end;

procedure TExclusiveParams.SaveParams;
begin
  SaveParam('ExclusiveId', ExclusiveId);
  SaveParam('ExclusiveComputerName', ExclusiveComputerName);
  SaveParam('ExclusiveDate', ExclusiveDate);
end;

end.
