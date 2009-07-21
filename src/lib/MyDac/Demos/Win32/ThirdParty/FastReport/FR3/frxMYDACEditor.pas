
{******************************************}
{                                          }
{             FastReport v3.20             }
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
  TfrxMyTableNameProperty = class(TfrxTableNameProperty)
  public
    procedure GetValues; override;
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
    TfrxDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(TfrxMyDACDatabase), TfrxMyDACQuery, 'Database',
    TfrxDatabaseProperty);
  frxPropertyEditors.Register(TypeInfo(String), TfrxMyDACTable, 'TableName',
    TfrxMyTableNameProperty);

end.
