unit GlobalParams;

interface

uses
  SysUtils,
  Classes,
  StrUtils,
  MyAccess,
  DBProc,
  DatabaseObjects;

type
  TGlobalParams = class
   protected
    FConnection : TCustomMyConnection;
    function GetParam(ParamName : String; Schema : String = '') : Variant;
   public
    constructor Create(Connection : TCustomMyConnection);
    procedure ReadParams; virtual; abstract;
    procedure SaveParams; virtual;
    function GetParamDef(ParamName : String; DefaultValue : Variant) : Variant;
    procedure SaveParam(ParamName : String; ParamValue : Variant);
  end;


implementation

uses
  Variants;

{ TGlobalParams }

constructor TGlobalParams.Create(Connection: TCustomMyConnection);
begin
  FConnection := Connection;
  ReadParams;
end;

function TGlobalParams.GetParam(ParamName: String; Schema : String = ''): Variant;
begin
  Result := DBProc.QueryValue(
    FConnection,
    'select Value from ' + IfThen(Schema <> '', Schema + '.') + 'GlobalParams where Name = :Name',
    ['Name'],
    [ParamName]);
end;

function TGlobalParams.GetParamDef(ParamName: String;
  DefaultValue: Variant): Variant;
var
  value : Variant;
begin
  value := GetParam(ParamName);
  if VarIsNull(value) then
    Result := DefaultValue
  else
    Result := value;
end;

procedure TGlobalParams.SaveParam(ParamName: String; ParamValue: Variant);
var
  updateRecord : Integer;
begin
  updateRecord := DBProc.UpdateValue(
    FConnection,
    'update GlobalParams set Value = :Value where Name = :Name',
    ['Name', 'Value'],
    [ParamName, ParamValue]);
  if updateRecord = 0 then
    DBProc.UpdateValue(
      FConnection,
      'insert into GlobalParams (Name, Value) values (:Name, :Value)',
      ['Name', 'Value'],
      [ParamName, ParamValue]);
end;

procedure TGlobalParams.SaveParams;
begin
  DatabaseController.BackupDataTable(doiGlobalParams);
end;

end.
