unit Main;

interface

uses
{$IFDEF LINUX}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, MyDacClx, QButtons,
{$ELSE}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MyDacVcl,
  Buttons,
{$ENDIF}
  DBAccess, MyAccess, Db, MemDS, MyCall, MyClasses, MyScript,
  MyEmbConnection, DAScript, MySqlApi;

type
  TfmMain = class(TForm)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    StatusBar: TStatusBar;
    MyTable: TMyTable;
    MyScript: TMyScript;
    MyConnection: TMyEmbConnection;
    Memo1: TMemo;
    Panel1: TPanel;
    btClose: TSpeedButton;
    btOpen: TSpeedButton;
    DBNavigator: TDBNavigator;
    pSQL: TPanel;
    mSQL: TMemo;
    btnExec: TButton;
    MyQuery: TMyQuery;
    btnExecute: TButton;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MyConnectionLog(const Text: String);
    procedure FormCreate(Sender: TObject);
    procedure btnExecClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowState;
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$IFDEF CLR}
{$R *.nfm}
{$ENDIF}
{$IFDEF WIN32}
{$R *.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}

{$IFNDEF LINUX}
  {$IFNDEF VER130}
  {$IFNDEF VER140}
  {$IFNDEF CLR}
    {$DEFINE XPMAN}
    {$R WindowsXP.res}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF XPMAN}
uses
  UxTheme;
{$ENDIF}

procedure TfmMain.ShowState;
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

  if MyConnection.Connected then
    AddSt('Connected')
  else
    AddSt('Disconnected');

  StatusBar.Panels[0].Text := St;
end;

procedure TfmMain.btOpenClick(Sender: TObject);
  procedure CreateDatabaseStruct;
  begin
    MyConnection.Open;
    MyScript.Execute;
    MyConnection.Database := 'test';
    MyTable.Open;
  end;

begin
  try
  MyConnection.Open;
  finally
    ShowState;
  end;
{
  try
    CreateDir('.\data');
    CreateDir('.\data\Test');

    try
      MyTable.Open;
    except
      on E: EMyError do begin
        if E.ErrorCode = ER_NO_SUCH_TABLE then begin
          CreateDatabaseStruct;
          MyTable.Open;
        end
        else
          raise;
      end;
    end;

  finally
    ShowState;
  end;
}  
end;

procedure TfmMain.btCloseClick(Sender: TObject);
begin
  MyConnection.Close;
  ShowState;
end;

procedure TfmMain.FormShow(Sender: TObject);
begin
  ShowState;
end;

procedure TfmMain.MyConnectionLog(const Text: String);
begin
  if Memo1 <> nil then
    Memo1.Lines.Add(Text);
end;

procedure TfmMain.FormCreate(Sender: TObject);
{$IFDEF XPMAN}
  procedure UpdateStyle(Control: TWinControl);
  var
    Panel: TPanel;
    i: integer;
  begin
    for i := 0 to Control.ControlCount - 1 do begin
      if Control.Controls[i] is TSpeedButton then
        TSpeedButton(Control.Controls[i]).Flat := False
      else
      if Control.Controls[i] is TDBNavigator then
        TDBNavigator(Control.Controls[i]).Flat := False;
      if Control.Controls[i] is TWinControl then begin
        if (Control.Controls[i] is TPanel) then begin
            Panel := TPanel(Control.Controls[i]);
            Panel.ParentBackground := False;
            Panel.Color := clBtnFace;
          end;
        UpdateStyle(TWinControl(Control.Controls[i]));
      end;
    end;
  end;
{$ENDIF}
begin
  MySqlApi.MySQLEmbDisableEventLog := True;
{$IFDEF XPMAN}
  if UseThemes then
    UpdateStyle(Self);
{$ENDIF}
end;

procedure TfmMain.btnExecClick(Sender: TObject);
begin
  if MyQuery.Active then
    MyQuery.Close;

  MyQuery.SQL.Text := mSQL.Lines.Text;
  MyQuery.Open;
end;

procedure TfmMain.btnExecuteClick(Sender: TObject);
begin
  if MyQuery.Active then
    MyQuery.Close;

  MyQuery.SQL.Text := mSQL.Lines.Text;
  MyQuery.Execute;
end;

end.
