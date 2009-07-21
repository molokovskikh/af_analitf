{$I DacDemo.inc}

unit UpdateSQL;

interface

uses
  SysUtils,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFDEF KYLIX}
  Libc, Classes, QGraphics, QControls, QForms, QDialogs, QButtons,
  QDBCtrls, QExtCtrls, QGrids, QDBGrids, QStdCtrls, QComCtrls, MyDacClx,
{$ELSE}
  Classes, Graphics, Controls, Forms, Dialogs, Buttons,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MyDacVcl,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DAScript, DBAccess, MyAccess, Db, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  DemoFrame, MyScript;

type
  TUpdateSQLFrame = class(TDemoFrame)
    MyQuery: TMyQuery;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    meSQL: TMemo;
    Panel1: TPanel;
    MyUpdateSQL: TMyUpdateSQL;
    Panel2: TPanel;
    btRefreshRecord: TSpeedButton;
    DBNavigator1: TDBNavigator;
    Panel3: TPanel;
    btExecute: TSpeedButton;
    btClose: TSpeedButton;
    btOpen: TSpeedButton;
    Panel4: TPanel;
    Panel5: TPanel;
    cbDeleteObject: TCheckBox;
    cbInsertObject: TCheckBox;
    cbModifyObject: TCheckBox;
    cbRefreshObject: TCheckBox;
    btPrepare: TSpeedButton;
    btUnPrepare: TSpeedButton;
    DeleteSQL: TMyCommand;
    InsertSQL: TMyCommand;
    RefreshQuery: TMyQuery;
    ModifyQuery: TMyQuery;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure meSQLExit(Sender: TObject);
    procedure btRefreshRecordClick(Sender: TObject);
    procedure cbDeleteObjectClick(Sender: TObject);
    procedure btUnPrepareClick(Sender: TObject);
    procedure btPrepareClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowState;
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

procedure TUpdateSQLFrame.ShowState;
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

  if MyQuery.Prepared then begin
    AddSt('Prepared');

    if MyQuery.IsQuery then
      AddSt('IsQuery');
  end;

  if MyQuery.Active then
    AddSt('Active')
  else
    AddSt('Inactive');

  if MyQuery.Executing then
    AddSt('Executing');

  if MyQuery.Fetching then
    AddSt('Fetching');

  MyDACForm.StatusBar.Panels[1].Text:= St;
end;

procedure TUpdateSQLFrame.meSQLExit(Sender: TObject);
begin
  if Trim(MyQuery.SQL.Text) <> Trim(meSQL.Lines.Text) then
    MyQuery.SQL.Text:= meSQL.Lines.Text;
  ShowState;
end;

procedure TUpdateSQLFrame.btOpenClick(Sender: TObject);
begin
  try
    MyQuery.Open;
  finally
    ShowState;
  end;
end;

procedure TUpdateSQLFrame.btCloseClick(Sender: TObject);
begin
  MyQuery.Close;
  ShowState;
end;

procedure TUpdateSQLFrame.btExecuteClick(Sender: TObject);
begin
  try
    MyQuery.Execute;
  finally
    ShowState;
  end;
end;

procedure TUpdateSQLFrame.btRefreshRecordClick(Sender: TObject);
begin
  MyQuery.RefreshRecord;
end;

procedure TUpdateSQLFrame.cbDeleteObjectClick(Sender: TObject);
  function GetComponent(cbObject: TCheckBox; Component: TComponent): TComponent;
  begin
    if cbObject.Checked then
      Result := Component
    else
      Result := nil;
  end;
begin
  MyUpdateSQL.DeleteObject := GetComponent(cbDeleteObject, DeleteSQL);
  MyUpdateSQL.InsertObject := GetComponent(cbInsertObject, InsertSQL);
  MyUpdateSQL.ModifyObject := GetComponent(cbModifyObject, ModifyQuery);
  MyUpdateSQL.RefreshObject := GetComponent(cbRefreshObject, RefreshQuery);
end;

procedure TUpdateSQLFrame.btUnPrepareClick(Sender: TObject);
begin
  try
    MyQuery.UnPrepare;
  finally
    ShowState;
  end;

end;

procedure TUpdateSQLFrame.btPrepareClick(Sender: TObject);
begin
  try
    MyQuery.Prepare;
  finally
    ShowState;
  end;
end;

// Demo management
procedure TUpdateSQLFrame.SetDebug(Value: boolean);
begin
  MyQuery.Debug := Value;
end;

procedure TUpdateSQLFrame.Initialize;
begin
  MyQuery.Connection := Connection as TCustomMyConnection;
  meSQL.Lines.Assign(MyQuery.SQL);
  ShowState;
end;

{$IFDEF FPC}
initialization
  {$i UpdateSQL.lrs}
{$ENDIF}

end.

