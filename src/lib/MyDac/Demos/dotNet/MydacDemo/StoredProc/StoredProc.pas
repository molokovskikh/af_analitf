{$I DacDemo.inc}

unit StoredProc;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, Buttons,
  MyDacVcl,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, QButtons, MyDacClx,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, DBAccess, MyAccess, DB, 
  MyScript, DemoFrame, MyDacDemoForm, DAScript;

type
  TStoredProcFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    MyStoredProc: TMyStoredProc;
    Panel1: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    btPrepare: TSpeedButton;
    btUnPrepare: TSpeedButton;
    btExecute: TSpeedButton;
    btPrepareSQL: TSpeedButton;
    Panel2: TPanel;
    DBNavigator: TDBNavigator;
    Panel3: TPanel;
    Panel4: TPanel;
    edStoredProcName: TEdit;
    Label1: TLabel;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btPrepareClick(Sender: TObject);
    procedure btUnPrepareClick(Sender: TObject);
    procedure btExecuteClick(Sender: TObject);
    procedure btPrepareSQLClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowState;
  public
   // Demo management
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

implementation

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

procedure TStoredProcFrame.ShowState;
var
  St: string;

  procedure AddSt(S:string);
  begin
    if St <> '' then
      St := St + ', ';
    St := St + S;
  end;

begin
  St := '';

  if MyStoredProc.Prepared then begin
    AddSt('Prepared');

    if MyStoredProc.IsQuery then
      AddSt('IsQuery');

  end;

  if MyStoredProc.Active then
    AddSt('Active')
  else
    AddSt('Inactive');

  MydacForm.StatusBar.Panels[1].Text := St;
end;

procedure TStoredProcFrame.btOpenClick(Sender: TObject);
begin
  MyStoredProc.StoredProcName := edStoredProcName.Text;
  try
    MyStoredProc.Open;
  finally
    ShowState;
  end;
end;

procedure TStoredProcFrame.btCloseClick(Sender: TObject);
begin
  MyStoredProc.Close;
  ShowState;
end;

procedure TStoredProcFrame.btPrepareClick(Sender: TObject);
begin
  MyStoredProc.StoredProcName := edStoredProcName.Text;
  try
    MyStoredProc.Prepare;
  finally
    ShowState;
  end;
end;

procedure TStoredProcFrame.btUnPrepareClick(Sender: TObject);
begin
  MyStoredProc.UnPrepare;
  ShowState;
end;

procedure TStoredProcFrame.btExecuteClick(Sender: TObject);
begin
  MyStoredProc.StoredProcName := edStoredProcName.Text;
  try
    MyStoredProc.Execute;
  finally
    ShowState;
  end;
end;

procedure TStoredProcFrame.Initialize;
begin
  inherited;
  MyStoredProc.Connection := Connection as TCustomMyConnection;;
  edStoredProcName.Text := MyStoredProc.StoredProcName;
  ShowState;
end;

procedure TStoredProcFrame.btPrepareSQLClick(Sender: TObject);
begin
  MyStoredProc.StoredProcName := edStoredProcName.Text;
  MyStoredProc.PrepareSQL;
  ShowState;
end;

procedure TStoredProcFrame.SetDebug(Value: boolean);
begin
  MyStoredProc.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i StoredProc.lrs}
{$ENDIF}

end.
