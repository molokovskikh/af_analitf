
{******************************************}
{                                          }
{             FastReport v3.20             }
{      DAC components design editors       }
{                                          }

// Created by: Devart
// E-mail: support@devart.com

{                                          }
{******************************************}

unit frxDACEditor;

interface

{$I frx.inc}

uses
  Windows, Classes, SysUtils, Forms, Dialogs, frxDACComponents, frxCustomDB,
  frxDsgnIntf, frxRes
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxDatabaseProperty = class(TfrxComponentProperty)
  public
    function GetValue: String; override;
  end;

  TfrxTableNameProperty = class(TfrxStringProperty)
  public
    function GetAttributes: TfrxPropertyAttributes; override;
    procedure SetValue(const Value: String); override;
  end;

implementation

{ TfrxDatabaseProperty }

function TfrxDatabaseProperty.GetValue: String;
var
  db: TfrxDACDatabase;
begin
  db := TfrxDACDatabase(GetOrdValue);
  if db = nil then
  begin
    if (DACComponents <> nil) and (DACComponents.DefaultDatabase <> nil) then
      Result := DACComponents.DefaultDatabase.Name
    else
      Result := frxResources.Get('prNotAssigned');
  end
  else
    Result := inherited GetValue;
end;

{ TfrxTableNameProperty }

function TfrxTableNameProperty.GetAttributes: TfrxPropertyAttributes;
begin
  Result := [paMultiSelect, paValueList, paSortList];
end;

procedure TfrxTableNameProperty.SetValue(const Value: String);
begin
  inherited;
  Designer.UpdateDataTree;
end;

end.
