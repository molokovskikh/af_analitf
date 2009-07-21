{$I DacDemo.inc}

unit Lock;

interface

uses
  {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  DBAccess, DB, MyAccess, DASQLMonitor, MySQLMonitor, DemoFrame,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFDEF KYLIX}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, MyDacClx, QButtons,
{$ELSE}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MyDacVcl, Buttons,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DAScript, MyScript;

type
  TLockFrame = class(TDemoFrame)
    MyQuery1: TMyQuery;
    DataSource1: TDataSource;
    ToolBar: TPanel;
    Panel5: TPanel;
    Memo1: TMemo;
    Panel6: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    rbLockDelayed: TRadioButton;
    rbLockImmediately: TRadioButton;
    Panel3: TPanel;
    btClose: TSpeedButton;
    btOpen: TSpeedButton;
    DBGrid: TDBGrid;
    Label2: TLabel;
    Splitter1: TSplitter;
    Panel7: TPanel;
    Panel8: TPanel;
    Label3: TLabel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel14: TPanel;
    Label4: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    DBNavigator2: TDBNavigator;
    DBGrid1: TDBGrid;
    MyQuery2: TMyQuery;
    MyConnection2: TMyConnection;
    meSQL: TMemo;
    Panel11: TPanel;
    DataSource2: TDataSource;
    Panel12: TPanel;
    DBNavigator1: TDBNavigator;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure meSQLExit(Sender: TObject);
    procedure MyQuery1AfterExecute(Sender: TObject; Result: Boolean);
    procedure MyQuery1BeforeEdit(DataSet: TDataSet);
    procedure MyQuery1AfterPost(DataSet: TDataSet);
    procedure MyQuery1AfterCancel(DataSet: TDataSet);
    procedure Connection1AfterDisconnect(Sender: TObject);
  private
    { Private declarations }
    OldAfterDisconnectEvent: TNotifyEvent;
    procedure ShowState;
  public
    // Demo management
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
    destructor Destroy; override;
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

procedure TLockFrame.ShowState;
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

  if MyQuery1.Prepared then begin
    AddSt('Prepared');

    if MyQuery1.IsQuery then
      AddSt('IsQuery');
  end;

  if MyQuery1.Active then
    AddSt('Active')
  else
    AddSt('Inactive');

  if MyQuery1.Executing then
    AddSt('Executing');

  if MyQuery1.Fetching then
    AddSt('Fetching');

  MyDACForm.StatusBar.Panels[1].Text := St;
end;

procedure TLockFrame.meSQLExit(Sender: TObject);
begin
  if Trim(MyQuery1.SQL.Text) <> Trim(meSQL.Lines.Text) then
    MyQuery1.SQL.Text := meSQL.Lines.Text;
  if Trim(MyQuery2.SQL.Text) <> Trim(meSQL.Lines.Text) then
    MyQuery2.SQL.Text := meSQL.Lines.Text;
  ShowState;
end;

procedure TLockFrame.btOpenClick(Sender: TObject);
begin
  if Trim(MyQuery1.SQL.Text) <> Trim(meSQL.Lines.Text) then
    MyQuery1.SQL.Text := meSQL.Lines.Text;
  if Trim(MyQuery2.SQL.Text) <> Trim(meSQL.Lines.Text) then
    MyQuery2.SQL.Text := meSQL.Lines.Text;
  try
    MyQuery1.Open;
    if MyQuery1.Active then begin
//      MyConnection2.Assign(Connection);           commented to avoid events assignation
      MyConnection2.Username := Connection.Username;
      MyConnection2.Password := Connection.Password;
      MyConnection2.Server := Connection.Server;
      MyConnection2.Database := (Connection as TMyConnection).Database;
      MyConnection2.Port := (Connection as TMyConnection).Port;
      MyConnection2.LoginPrompt := False;
      MyQuery2.Assign(MyQuery1);
      MyQuery2.Connection := MyConnection2;
      MyQuery2.Open;
    end;
  finally
    ShowState;
  end;
end;

procedure TLockFrame.btCloseClick(Sender: TObject);
begin
  MyQuery1.Close;
  MyQuery2.Close;
  ShowState;
end;

procedure TLockFrame.MyQuery1AfterExecute(Sender: TObject; Result: Boolean);
begin
  ShowState;

  if Result then
    MyDACForm.StatusBar.Panels[1].Text := MyDACForm.StatusBar.Panels[1].Text + '   >>>> Success'
  else
    MyDACForm.StatusBar.Panels[1].Text := MyDACForm.StatusBar.Panels[1].Text + '   >>>> Fail';
end;

procedure TLockFrame.MyQuery1BeforeEdit(DataSet: TDataSet);
var
  MyQuery: TMyQuery;
begin
  MyQuery := (DataSet as TMyQuery);
  if not MyQuery.Connection.InTransaction then
    MyQuery.Connection.StartTransaction;
  if rbLockImmediately.Checked then
    MyQuery.Lock(lrImmediately) else
    if rbLockDelayed.Checked then
      MyQuery.Lock(lrDelayed);
  MyQuery.RefreshRecord;
end;

procedure TLockFrame.MyQuery1AfterPost(DataSet: TDataSet);
var
  MyQuery: TMyQuery;
begin
  MyQuery := (DataSet as TMyQuery);
  if MyQuery.Connection.InTransaction then
    MyQuery.Connection.Commit;
end;

procedure TLockFrame.MyQuery1AfterCancel(DataSet: TDataSet);
var
  MyQuery: TMyQuery;
begin
  MyQuery := (DataSet as TMyQuery);
  if MyQuery.Connection.InTransaction then
    MyQuery.Connection.Rollback;
end;

// Demo management

procedure TLockFrame.Initialize;
begin
  MyQuery1.Connection := Connection as TCustomMyConnection;
  meSQL.Lines.Assign(MyQuery1.SQL);
  OldAfterDisconnectEvent := MyQuery1.Connection.AfterDisconnect;
  MyQuery1.Connection.AfterDisconnect := Connection1AfterDisconnect;
  ShowState;
end;

procedure TLockFrame.SetDebug(Value: boolean);
begin
  MyQuery1.Debug := Value;
  MyQuery2.Debug := Value;
end;

procedure TLockFrame.Connection1AfterDisconnect(Sender: TObject);
begin
  try
    OldAfterDisconnectEvent(self);
  finally
    if Assigned(MyConnection2) then begin
      MyConnection2.Disconnect;
      ShowState;
    end;
  end;
end;

destructor TLockFrame.Destroy;
begin
  if not (csDestroying in Self.Parent.ComponentState) then
    MyQuery1.Connection.AfterDisconnect := OldAfterDisconnectEvent;
  inherited;
end;

{$IFDEF FPC}
initialization
  {$i Lock.lrs}
{$ENDIF}

end.

