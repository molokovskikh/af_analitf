unit ServerForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, ExtCtrls, DBCtrls, Db,
  Buttons;

type
  TfmServer = class(TForm)
    ToolBar: TPanel;
    meSQL: TMemo;
    DBGrid: TDBGrid;
    ToolBar1: TPanel;
    DataSource: TDataSource;
    StatusBar: TStatusBar;
    Panel1: TPanel;
    btClose: TSpeedButton;
    btOpen: TSpeedButton;
    btDisconnect: TSpeedButton;
    btConnect: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    DBNavigator: TDBNavigator;
    cbDebug: TCheckBox;
    rbDSResolve: TRadioButton;
    rbSQLResolve: TRadioButton;
    procedure btConnectClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure cbDebugClick(Sender: TObject);
    procedure meSQLExit(Sender: TObject);
    procedure rbDSResolveClick(Sender: TObject);
    procedure rbSQLResolveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmServer: TfmServer;

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

uses
{$IFDEF XPMAN}
  UxTheme,
{$ENDIF}
  Data;

procedure TfmServer.btConnectClick(Sender: TObject);
begin
  if Assigned(Datas) and (Assigned(Datas.MyConnection)) then
    Datas.MyConnection.Connect;
end;

procedure TfmServer.btDisconnectClick(Sender: TObject);
begin
  if Assigned(Datas) and (Assigned(Datas.MyConnection)) then
    Datas.MyConnection.Disconnect;
end;

procedure TfmServer.btOpenClick(Sender: TObject);
begin
  if Assigned(Datas) and Assigned(Datas.Query) then
    Datas.Query.Open;
end;

procedure TfmServer.btCloseClick(Sender: TObject);
begin
  if Assigned(Datas) and Assigned(Datas.Query) then
    Datas.Query.Close;
end;

procedure TfmServer.cbDebugClick(Sender: TObject);
begin
  if Assigned(Datas) and Assigned(Datas.Query) then
    Datas.Query.Debug:= cbDebug.Checked;
end;

procedure TfmServer.meSQLExit(Sender: TObject);
begin
  if Assigned(Datas) then
    if meSQL.Lines.Text <> Datas.Query.SQL.Text then
      Datas.Query.SQL.Assign(meSQL.Lines);
end;

procedure TfmServer.rbDSResolveClick(Sender: TObject);
begin
  if Assigned(Datas) then
    Datas.MyDataSetProvider.ResolveToDataset:= rbDSResolve.Checked;
end;

procedure TfmServer.rbSQLResolveClick(Sender: TObject);
begin
  if Assigned(Datas) then
    Datas.MyDataSetProvider.ResolveToDataset:= not rbSQLResolve.Checked;
end;

procedure TfmServer.FormCreate(Sender: TObject);
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
{$IFDEF XPMAN}
  if UseThemes then
    UpdateStyle(Self);
{$ENDIF}
end;

end.

