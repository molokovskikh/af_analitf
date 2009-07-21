
{******************************************}
{                                          }
{             FastReport v4.0              }
{      MYDAC components design editors     }
{                                          }

// Created by: Devart
// E-mail: mydac@devart.com

{                                          }
{******************************************}

unit frxMYDACEditor;

interface

{$I frx.inc}

implementation

uses
  Windows, Classes, SysUtils, Forms, Dialogs, frxCustomDB,  frxDsgnIntf, frxRes,
  MyAccess, MyClasses, MyCall, MydacVcl, frxMYDACComponents, frxDACEditor
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfrxMyDatabaseProperty = class(TfrxComponentProperty)
  public
    function GetValue: String; override;
  end;

  TfrxMyTableNameProperty = class(TfrxTableNameProperty)
  public
    procedure GetValues; override;
  end;

{ TfrxMyDatabaseProperty }

function TfrxMyDatabaseProperty.GetValue: String;
var
  db: TfrxMyDACDatabase;
begin
  db := TfrxMyDACDatabase(GetOrdValue);
  if db = nil then begin
    if (MyDACComponents <> nil) and (MyDACComponents.DefaultDatabase <> nil) then
      Result := MyDACComponents.DefaultDatabase.Name
    else
      Result := frxResources.Get('prNotAssigned');
  end
  else
    Result := inherited GetValue;
end;

{ TfrxMyTableNameProperty }

procedure TfrxMyTableNameProperty.GetValues;
begin
  inherited;
  with TfrxMyDACTable(Component).Table do
    if Connection <> nil then
      Connection.GetTableNames(Values);
end;

initialization
  frxPropertyEditors.Register(TypeInfo(TfrxMyDACDatabase), TfrxMyDACTable, 'Database',
    TfrxMyDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(TfrxMyDACDatabase), TfrxMyDACQuery, 'Database',
    TfrxMyDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxMyDACTable, 'TableName',
    TfrxMyTableNameProperty);

end.
