{$I DacDemo.inc}

unit Table;

interface

uses
  Classes, SysUtils, DB,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  Graphics, Controls, Forms, Dialogs, Buttons,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MyDacVcl,
{$ELSE}
  Types, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, MyDacClx, QButtons,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  MemUtils, DBAccess, MyAccess,
  {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, DemoFrame;

type
  TTableFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    Panel1: TPanel;
    MyTable: TMyTable;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    edOrderFields: TComboBox;
    Label3: TLabel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    DBNavigator: TDBNavigator;
    edTableName: TComboBox;
    Panel8: TPanel;
    Panel9: TPanel;
    Label4: TLabel;
    edFilterSQL: TEdit;
    btExecute: TSpeedButton;
    btUnPrepare: TSpeedButton;
    btPrepare: TSpeedButton;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure edTableNameExit(Sender: TObject);
    procedure edOrderFieldsExit(Sender: TObject);
    procedure edTableNameDropDown(Sender: TObject);
    procedure edOrderFieldsDropDown(Sender: TObject);
    procedure btPrepareClick(Sender: TObject);
    procedure btUnPrepareClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowState;
    procedure SetTableProperties;
    procedure FillFieldList;
  public
    // Demo management
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

implementation

uses MyDacDemoForm;

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ENDIF}
{$IFDEF WIN32}
{$R *.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

procedure TTableFrame.ShowState;
var
  St:string;

  procedure AddSt(S:string);
  begin
    if St <> '' then
      St:= St + ', ';
    St:= St + S;
  end;

begin
  St:= '';

  if MyTable.Prepared then begin
    AddSt('Prepared');

    if MyTable.IsQuery then
      AddSt('IsQuery');
  end;

  if MyTable.Active then
    AddSt('Active')
  else
    AddSt('Inactive');

  MyDACForm.StatusBar.Panels[1].Text:= St;
end;

procedure TTableFrame.SetTableProperties;
begin
  MyTable.TableName := edTableName.Text;
  MyTable.FilterSQL := edFilterSQL.Text;
  MyTable.OrderFields := edOrderFields.Text;
end;

procedure TTableFrame.btOpenClick(Sender: TObject);
begin
  SetTableProperties;
  ShowState;
  FillFieldList;
  try
    MyTable.OrderFields:= edOrderFields.Text;
    MyTable.Open;
  finally
    ShowState;
  end;
end;

procedure TTableFrame.btCloseClick(Sender: TObject);
begin
  MyTable.Close;
  ShowState;
end;

procedure TTableFrame.edTableNameExit(Sender: TObject);
begin
  if MyTable.TableName <> edTableName.Text then begin
    MyTable.TableName:= edTableName.Text;
    ShowState;
    FillFieldList;
  end;
end;

procedure TTableFrame.edOrderFieldsExit(Sender: TObject);
begin
  MyTable.OrderFields:= edOrderFields.Text;
  ShowState;
end;

procedure TTableFrame.edTableNameDropDown(Sender: TObject);
var
  List: _TStringList;
begin
  List := _TStringList.Create;
  try
    MyTable.Connection.GetTableNames(List);
    AssignStrings(List, edTableName.Items);
  finally
    List.Free;
  end;
end;

procedure TTableFrame.FillFieldList;
var
  i: integer;
  OrderFieldsTmp: string;
begin
  OrderFieldsTmp := MyTable.OrderFields;
  MyTable.OrderFields := '';
  MyTable.FieldDefs.Update;
  MyTable.OrderFields := OrderFieldsTmp;
  edOrderFields.Items.Clear;
  for i := 0 to MyTable.FieldDefs.Count - 1 do
    edOrderFields.Items.Add(MyTable.FieldDefs[i].Name);
end;

procedure TTableFrame.edOrderFieldsDropDown(Sender: TObject);
var
  oldDebug: boolean;
begin
  oldDebug := MyTable.Debug;
  MyTable.Debug := false;
  try
    FillFieldList;
  finally
    MyTable.Debug := oldDebug;
  end;
end;

procedure TTableFrame.btPrepareClick(Sender: TObject);
begin
  try
    SetTableProperties;
    MyTable.Prepare;
  finally
    ShowState;
  end;
end;

procedure TTableFrame.btUnPrepareClick(Sender: TObject);
begin
  MyTable.UnPrepare;
  ShowState;
end;

procedure TTableFrame.btExecuteClick(Sender: TObject);
begin
  try
    SetTableProperties;
    MyTable.Execute;
  finally
    ShowState;
  end;
end;

// Demo management
procedure TTableFrame.Initialize;
begin
  MyTable.Connection := Connection as TCustomMyConnection;;
  edTableName.Text:= MyTable.TableName;
  edOrderFields.Text:= MyTable.OrderFields;
  ShowState;
end;

procedure TTableFrame.SetDebug(Value: boolean);
begin
  MyTable.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i Table.lrs}
{$ENDIF}

end.

