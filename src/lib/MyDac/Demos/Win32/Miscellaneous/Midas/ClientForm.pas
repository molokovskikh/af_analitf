unit ClientForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ToolWin, ComCtrls, Db, DBClient, ExtCtrls, DBCtrls,
  StdCtrls, MConnect, MidasCon, Buttons;

type
  TfmClient = class(TForm)
    DBGrid: TDBGrid;
    ToolBar1: TPanel;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    StatusBar: TStatusBar;
    RemoteServer: TDCOMConnection;
    ToolBar: TPanel;
    brConnect: TSpeedButton;
    btDisconnect: TSpeedButton;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    btApplyUpd: TSpeedButton;
    btCancelUpd: TSpeedButton;
    Panel1: TPanel;
    EmpNo: TLabel;
    edEmpNo: TEdit;
    DBNavigator1: TDBNavigator;
    procedure brConnectClick(Sender: TObject);
    procedure RemoteServerAfterConnect(Sender: TObject);
    procedure RemoteServerAfterDisconnect(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btApplyUpdClick(Sender: TObject);
    procedure btCancelUpdClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmClient: TfmClient;

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

procedure TfmClient.brConnectClick(Sender: TObject);
begin
  RemoteServer.Connected:= True;
end;

procedure TfmClient.btDisconnectClick(Sender: TObject);
begin
  RemoteServer.Connected:= False;
end;

procedure TfmClient.RemoteServerAfterConnect(Sender: TObject);
begin
  StatusBar.Panels[0].Text:= 'Connected';
end;

procedure TfmClient.RemoteServerAfterDisconnect(Sender: TObject);
begin
  if Assigned(StatusBar) then
    StatusBar.Panels[0].Text:= 'Disconnected';
end;

procedure TfmClient.btOpenClick(Sender: TObject);
begin
  if edEmpNo.Text <> '' then
    ClientDataSet.Params.ParamByName('EmpNo').AsInteger:= StrToInt(edEmpNo.Text);
  ClientDataSet.Open;
  edEmpNo.Text:= IntToStr(ClientDataSet.Params.ParamByName('EmpNo').AsInteger);
end;

procedure TfmClient.btCloseClick(Sender: TObject);
begin
  ClientDataSet.Close;
end;

procedure TfmClient.btApplyUpdClick(Sender: TObject);
begin
  ClientDataSet.ApplyUpdates(0);
end;

procedure TfmClient.btCancelUpdClick(Sender: TObject);
begin
  ClientDataSet.CancelUpdates;
end;

procedure TfmClient.FormCreate(Sender: TObject);
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

