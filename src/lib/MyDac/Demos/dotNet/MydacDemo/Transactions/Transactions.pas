{$I DacDemo.inc}

unit Transactions;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, Buttons, MyDacVcl,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, QButtons, MyDacClx,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DAScript, DBAccess, MyAccess, DB, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  MyScript, DemoFrame;

type
  TTransactionsFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    MyQuery: TMyQuery;
    Panel1: TPanel;
    RefreshRecord: TSpeedButton;
    DBNavigator: TDBNavigator;
    btClose: TSpeedButton;
    btOpen: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Panel4: TPanel;
    btRollbackTrans: TSpeedButton;
    btCommitTrans: TSpeedButton;
    btStartTrans: TSpeedButton;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btStartTransClick(Sender: TObject);
    procedure btCommitTransClick(Sender: TObject);
    procedure btRollbackTransClick(Sender: TObject);
    procedure DataSourceDataChange(Sender: TObject; Field: TField);
    procedure DataSourceStateChange(Sender: TObject);
    procedure btRevertRecordClick(Sender: TObject);
    procedure RefreshRecordClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowTrans;
    procedure ShowPending;
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

procedure TTransactionsFrame.ShowTrans;
begin
  if MyDACForm.MyConnection.InTransaction then
    MyDACForm.StatusBar.Panels[2].Text:= 'In Transaction'
  else
    MyDACForm.StatusBar.Panels[2].Text:= '';
end;

procedure TTransactionsFrame.ShowPending;
begin
  if MyQuery.UpdatesPending then
    MyDACForm.StatusBar.Panels[1].Text:= 'Updates Pending'
  else
    MyDACForm.StatusBar.Panels[1].Text:= '';
end;

procedure TTransactionsFrame.btOpenClick(Sender: TObject);
begin
  MyQuery.Open;
end;

procedure TTransactionsFrame.btCloseClick(Sender: TObject);
begin
  MyQuery.Close;
end;

procedure TTransactionsFrame.btStartTransClick(Sender: TObject);
begin
  MyDACForm.MyConnection.StartTransaction;
  ShowTrans;
end;

procedure TTransactionsFrame.btCommitTransClick(Sender: TObject);
begin
  MyDACForm.MyConnection.Commit;
  ShowTrans;
end;

procedure TTransactionsFrame.btRollbackTransClick(Sender: TObject);
begin
  MyDACForm.MyConnection.Rollback;
  ShowTrans;
end;

procedure TTransactionsFrame.DataSourceStateChange(Sender: TObject);
begin
  ShowPending;
  MyDACForm.StatusBar.Panels[3].Text:= 'Record: ' + IntToStr(MyQuery.RecNo) + ' of '+ IntToStr(MyQuery.RecordCount);
end;

procedure TTransactionsFrame.DataSourceDataChange(Sender: TObject; Field: TField);
begin
  DataSourceStateChange(nil);
end;

procedure TTransactionsFrame.btRevertRecordClick(Sender: TObject);
begin
  MyQuery.RevertRecord;
  ShowPending;
end;

procedure TTransactionsFrame.RefreshRecordClick(Sender: TObject);
begin
  MyQuery.RefreshRecord;
end;

// Demo management
procedure TTransactionsFrame.Initialize;
begin
  MyQuery.Connection:= Connection as TCustomMyConnection;
end;

procedure TTransactionsFrame.SetDebug(Value: boolean);
begin
  MyQuery.Debug:= Value;
end;

{$IFDEF FPC}
initialization
  {$i Transactions.lrs}
{$ENDIF}

end.


