{$I DacDemo.inc}

unit Query;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Buttons,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MyDacVcl,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, MyDacClx, QButtons,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DAScript, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  DBAccess, DB, MyAccess, DemoFrame, MyScript;

type
  TQueryFrame = class(TDemoFrame)
    MyQuery: TMyQuery;
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    meSQL: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    btExecute: TSpeedButton;
    btClose: TSpeedButton;
    btOpen: TSpeedButton;
    Panel3: TPanel;
    DBNavigator1: TDBNavigator;
    btRefreshRecord: TSpeedButton;
    btPrepare: TSpeedButton;
    btUnPrepare: TSpeedButton;
    btSaveToXML: TSpeedButton;
    Panel4: TPanel;
    Panel5: TPanel;
    cbFetchAll: TCheckBox;
    SaveDialog: TSaveDialog;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure meSQLExit(Sender: TObject);
    procedure MyQueryAfterExecute(Sender: TObject; Result: Boolean);
    procedure btRefreshRecordClick(Sender: TObject);
    procedure btPrepareClick(Sender: TObject);
    procedure btUnPrepareClick(Sender: TObject);
    procedure btSaveToXMLClick(Sender: TObject);
    procedure cbFetchAllClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowState;
  public
    // Demo management
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

implementation

uses
  MyDacDemoForm;

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

procedure TQueryFrame.ShowState;
var
  St:string;

  procedure AddSt(S:string);
  begin
    if St <> '' then
      St := St + ', ';
    St := St + S;
  end;

begin
  St := '';

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

  MyDACForm.StatusBar.Panels[1].Text := St;
end;

procedure TQueryFrame.meSQLExit(Sender: TObject);
begin
  if Trim(MyQuery.SQL.Text) <> Trim(meSQL.Lines.Text) then
    MyQuery.SQL.Text := meSQL.Lines.Text;
  ShowState;
end;

procedure TQueryFrame.btOpenClick(Sender: TObject);
begin
  if Trim(MyQuery.SQL.Text) <> Trim(meSQL.Lines.Text) then
    MyQuery.SQL.Text := meSQL.Lines.Text;
  try
    MyQuery.Open;
  finally
    ShowState;
  end;
end;

procedure TQueryFrame.btCloseClick(Sender: TObject);
begin
  MyQuery.Close;
  ShowState;
end;

procedure TQueryFrame.btExecuteClick(Sender: TObject);
begin
  if Trim(MyQuery.SQL.Text) <> Trim(meSQL.Lines.Text) then
    MyQuery.SQL.Text := meSQL.Lines.Text;
  try
    MyQuery.Execute;
  finally
    ShowState;
  end;
end;

procedure TQueryFrame.MyQueryAfterExecute(Sender: TObject; Result: Boolean);
begin
  ShowState;

  if Result then
    MyDACForm.StatusBar.Panels[1].Text := MyDACForm.StatusBar.Panels[1].Text + '   >>>> Success'
  else
    MyDACForm.StatusBar.Panels[1].Text := MyDACForm.StatusBar.Panels[1].Text + '   >>>> Fail';
end;

procedure TQueryFrame.btRefreshRecordClick(Sender: TObject);
begin
  MyQuery.RefreshRecord;
end;

procedure TQueryFrame.btPrepareClick(Sender: TObject);
begin
  try
    MyQuery.SQL.Text := meSQL.Lines.Text;
    MyQuery.Prepare;
  finally
    ShowState;
  end;
end;

procedure TQueryFrame.btUnPrepareClick(Sender: TObject);
begin
  MyQuery.UnPrepare;
  ShowState;
end;

procedure TQueryFrame.btSaveToXMLClick(Sender: TObject);
begin
  if SaveDialog.Execute then
    MyQuery.SaveToXML(SaveDialog.FileName);
end;

// Demo management
procedure TQueryFrame.Initialize;
begin
  MyQuery.Connection := Connection as TCustomMyConnection;;
  meSQL.Lines.Assign(MyQuery.SQL);
  cbFetchAll.Checked := MyQuery.FetchAll;
  ShowState;
end;

procedure TQueryFrame.SetDebug(Value: boolean);
begin
  MyQuery.Debug := Value;
end;

procedure TQueryFrame.cbFetchAllClick(Sender: TObject);
begin
  try
    MyQuery.FetchAll := cbFetchAll.Checked;
  finally
    cbFetchAll.Checked := MyQuery.FetchAll;
  end;
end;

{$IFDEF FPC}
initialization
  {$i Query.lrs}
{$ENDIF}

end.

