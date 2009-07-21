{$I DacDemo.inc}

unit Command;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MyDacVcl, Buttons,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QButtons, QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  Db, DAScript, MemUtils, DBAccess, MyAccess, DemoFrame, MyScript, MyDacDemoForm;

type
  TCommandFrame = class(TDemoFrame)
    ToolBar: TPanel;
    meSQL: TMemo;
    Label1: TLabel;
    Splitter1: TSplitter;
    meResult: TMemo;
    Panel1: TPanel;
    btExecute: TSpeedButton;
    MyCommand: TMyCommand;
    btBreakExec: TSpeedButton;
    btExecInThread: TSpeedButton;
    procedure btExecuteClick(Sender: TObject);
    procedure MySQLAfterExecute(Sender: TObject; Result: Boolean);
    procedure btBreakExecClick(Sender: TObject);
    procedure btExecInThreadClick(Sender: TObject);
  private
    { Private declarations }
  public
  // Demo management
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

  { TExecThread }

  TExecThread = class(TThread)
  protected
    procedure Execute; override;
    procedure Terminate;
  end;

var
  CommandFrame: TCommandFrame;

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

procedure LogError(EMessage: string);
begin
  CommandFrame.meResult.Lines.Add('An error with the following message has beein raised during query execution:' + #13#10 + EMessage);
end;

{ TExecThread }

procedure TExecThread.Execute;
begin
  if CommandFrame.MyCommand <> nil then
    try
      CommandFrame.btBreakExec.Enabled := True;
      CommandFrame.MyCommand.Execute;
    except
      on e: Exception do begin
        LogError(e.Message);
      end;
    end;
  Terminate;
end;

procedure TExecThread.Terminate;
begin
  inherited;
  CommandFrame.btBreakExec.Enabled := False;
end;

{ TCommandFrame }

procedure TCommandFrame.btExecuteClick(Sender: TObject);
begin
  AssignStrings(meSQL.Lines, MyCommand.SQL);
  MyDACForm.StatusBar.Panels[2].Text := 'Executing...';
  meResult.Lines.Clear;
  try
    MyCommand.Execute;
  except
    on e: Exception do begin
      LogError(e.Message);
    end;
  end;
end;

procedure TCommandFrame.btBreakExecClick(Sender: TObject);
begin
  MyCommand.BreakExec;
end;

procedure TCommandFrame.btExecInThreadClick(Sender: TObject);
begin
  AssignStrings(meSQL.Lines, MyCommand.SQL);
  MyDACForm.StatusBar.Panels[2].Text := 'Executing...';
  meResult.Lines.Clear;
  TExecThread.Create(False);
end;

procedure TCommandFrame.MySQLAfterExecute(Sender: TObject; Result: Boolean);
var
  s: string;
begin
  if Result then
    s := 'Success' + '  (' + IntToStr(MyCommand.RowsAffected) + ' rows processed)'
  else
    s := 'Execution failed';
  meResult.Lines.Add(s);
  MyDACForm.StatusBar.Panels[2].Text := s;
end;

// Demo management
procedure TCommandFrame.Initialize;
begin
  CommandFrame := self;
  MyCommand.Connection := Connection as TCustomMyConnection;
  AssignStrings(meSQL.Lines, MyCommand.SQL);
end;

procedure TCommandFrame.SetDebug(Value: boolean);
begin
  MyCommand.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i Command.lrs}
{$ENDIF}

end.
