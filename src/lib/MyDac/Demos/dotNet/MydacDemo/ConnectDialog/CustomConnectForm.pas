{$I DacDemo.inc}

unit CustomConnectForm;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, Buttons, MyDACVCL,
  {$IFNDEF FPC}Mask,{$ENDIF}
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, MyDacClx, QButtons, QMask,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  MemUtils, MyClasses, MyAccess, MyCall;

type

  { TfmCustomConnect }

  TfmCustomConnect = class(TForm)
    Panel: TPanel;
    lbUsername: TLabel;
    lbPassword: TLabel;
    lbServer: TLabel;
    Bevel1: TBevel;
    edUsername: TEdit;
    edServer: TComboBox;
    lbDatabase: TLabel;
    lbPort: TLabel;
    edPort: TEdit;
    btConnect: TBitBtn;
    btCancel: TBitBtn;
    edDatabase: TEdit;
  {$IFNDEF FPC}
    edPassword: TMaskEdit;
  {$ELSE}
    edPassword: TEdit;
  {$ENDIF}
    procedure btConnectClick(Sender: TObject);
  private
    FConnectDialog: TMyConnectDialog;
    FRetries:integer;
    FRetry: boolean;

    procedure SetConnectDialog(Value: TMyConnectDialog);

  protected
    procedure DoInit; virtual;
    procedure DoConnect; virtual;

  public

  published
    property ConnectDialog: TMyConnectDialog read FConnectDialog write SetConnectDialog;

  end;

var
  fmCustomConnect: TfmCustomConnect;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ENDIF}
{$IFDEF WIN32}
{$R *.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R CustomConnectForm.xfm}
{$ENDIF}
{$ENDIF}

procedure TfmCustomConnect.DoInit;
var
  List: _TStringList;
begin
  FRetry := False;
  FRetries := FConnectDialog.Retries;
  Caption := FConnectDialog.Caption;

  lbUsername.Caption := FConnectDialog.UsernameLabel;
  lbPassword.Caption := FConnectDialog.PasswordLabel;
  lbServer.Caption := FConnectDialog.ServerLabel;
  btConnect.Caption := FConnectDialog.ConnectButton;
  btCancel.Caption := FConnectDialog.CancelButton;

  List := _TStringList.Create;
  try
    FConnectDialog.GetServerList(List);
    AssignStrings(List, edServer.Items);
  finally
    List.Free;
  end;

  edUsername.Text := FConnectDialog.Connection.Username;
  edPassword.Text := FConnectDialog.Connection.Password;
  edServer.Text := FConnectDialog.Connection.Server;

  if (edUsername.Text <> '') and (edPassword.Text = '') then
    ActiveControl := edPassword;
end;

procedure TfmCustomConnect.DoConnect;
begin
  FConnectDialog.Connection.Password := edPassword.Text;
  FConnectDialog.Connection.Server := edServer.Text;
  FConnectDialog.Connection.UserName := edUsername.Text;
  (FConnectDialog.Connection as TMyConnection).Port := StrToInt(edPort.Text);
  FConnectDialog.Connection.Database := edDatabase.Text;
  try
    FConnectDialog.Connection.PerformConnect(FRetry);
    ModalResult := mrOk;
  except
    on E: EMyError do begin
      Dec(FRetries);
      FRetry := True;
      if FRetries = 0 then
        ModalResult := mrCancel;
      if E.ErrorCode = CR_CONN_HOST_ERROR then
        ActiveControl := edServer
      else
      if E.ErrorCode = ER_ACCESS_DENIED_ERROR then
        if ActiveControl <> edUsername then
          ActiveControl := edPassword;
      raise;
    end
    else
      raise;
  end;
end;

procedure TfmCustomConnect.SetConnectDialog(Value: TMyConnectDialog);
begin
  FConnectDialog:= Value;
  DoInit;
end;

procedure TfmCustomConnect.btConnectClick(Sender: TObject);
begin
  DoConnect;
end;

initialization
  if GetClass('TfmMyConnect') = nil then begin
    {$IFDEF VER6P}
    Classes.StartClassGroup(TfmMyConnect);
    {$ENDIF}
    Classes.RegisterClass(TfmCustomConnect);
    {$IFDEF VER6P}
    ActivateClassGroup(TfmMyConnect);
    {$ENDIF}
  end;
{$IFDEF FPC}
  {$i CustomConnectForm.lrs}
{$ENDIF}

end.

