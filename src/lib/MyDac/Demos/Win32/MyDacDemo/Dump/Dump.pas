{$I DacDemo.inc}

unit Dump;

interface

uses
  Classes, SysUtils, Db,
{$IFNDEF WIN32}
  Types,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFDEF KYLIX}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls, QButtons,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, MydacClx,
{$ELSE}
  Graphics, Controls, Forms, Dialogs, Buttons, DBCtrls,
  ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MydacVcl,
{$ENDIF}
{$IFDEF CLR}
  System.ComponentModel,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  DBAccess, MyAccess, MyDump, DADump, DemoFrame;

type
  TDumpFrame = class(TDemoFrame)
    MyDump: TMyDump;
    meSQL: TMemo;
    Panel2: TPanel;
    Panel3: TPanel;
    btBackup: TSpeedButton;
    btBackupSQL: TSpeedButton;
    btRestore: TSpeedButton;
    Panel4: TPanel;
    cbTbBackup: TCheckBox;
    Panel5: TPanel;
    cbDataBackUp: TCheckBox;
    Panel6: TPanel;
    edTbNames: TEdit;
    Label1: TLabel;
    Panel7: TPanel;
    Label2: TLabel;
    edQuery: TEdit;
    pnResult: TPanel;
    ProgressBar: TProgressBar;
    lbTableName: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure btBackupClick(Sender: TObject);
    procedure btRestoreClick(Sender: TObject);
    procedure btBackupSQLClick(Sender: TObject);
    procedure MyDumpRestoreProgress(Sender: TObject; Percent: Integer);
    procedure MyDumpBackupProgress(Sender: TObject; TableName: String;
      ObjectNum, TableCount, Percent: Integer);
  private
    { Private declarations }
  public
    procedure SetOptions;

    // Demo management
    procedure Initialize; override;
  end;

var
  fmMyDumpDemo: TDumpFrame;

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

uses
  MyDacDemoForm;

procedure TDumpFrame.SetOptions;
begin
  MyDump.Objects := [];
  if  cbTbBackup.Checked then
    MyDump.Objects := MyDump.Objects + [doTables];
  if  cbDataBackUp.Checked then
    MyDump.Objects := MyDump.Objects + [doData];
  MyDump.TableNames := edTbNames.Text;
end;

procedure TDumpFrame.btBackupClick(Sender: TObject);
begin
  try
    SetOptions;
    MyDump.SQL.Clear;
    MyDump.Backup;
  finally
    ProgressBar.Position := 0;
    lbTableName.Caption := '';
    lbTableName.Parent.Repaint;
    meSQL.Lines.Assign(MyDump.SQL);
  end;
end;

procedure TDumpFrame.btRestoreClick(Sender: TObject);
begin
  ProgressBar.Position := 0;
  lbTableName.Caption := '';
  lbTableName.Parent.Repaint;
  MyDump.SQL.Assign(meSQL.Lines);
  try
    MyDump.Restore;
  finally
    ProgressBar.Position := 0;
  end;
end;

procedure TDumpFrame.btBackupSQLClick(Sender: TObject);
begin
  try
    SetOptions;
    MyDump.BackupQuery(edQuery.Text);
  finally
    ProgressBar.Position := 0;
    lbTableName.Caption := '';
    lbTableName.Parent.Repaint;
    meSQL.Lines.Assign(MyDump.SQL);
  end;
end;

procedure TDumpFrame.MyDumpRestoreProgress(Sender: TObject; Percent: Integer);
begin
  ProgressBar.Position := Percent;
end;

procedure TDumpFrame.MyDumpBackupProgress(Sender: TObject;
  TableName: String; ObjectNum, TableCount, Percent: Integer);
begin
  if lbTableName.Caption <> TableName then begin
    lbTableName.Caption := TableName;
    pnResult.Repaint;
  end;
  ProgressBar.Position := Percent;
end;

// Demo management
procedure TDumpFrame.Initialize;
begin
  MyDump.Connection := Connection as TCustomMyConnection;
end;

{$IFDEF FPC}
initialization
  {$i Dump.lrs}
{$ENDIF}

end.
