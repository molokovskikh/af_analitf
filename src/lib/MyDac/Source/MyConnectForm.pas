
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  Connect Form
//////////////////////////////////////////////////

{$IFNDEF CLR}

unit MyConnectForm;
{$ENDIF}

interface

{$IFNDEF LINUX}
  {$DEFINE MSWINDOWS}
{$ENDIF}

{$IFDEF LINUX}
{$IFNDEF FPC}
  {$DEFINE KYLIX}
{$ENDIF}
{$ENDIF}

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QExtCtrls,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  MemUtils, DBAccess, MyCall, MyAccess, TypInfo;

type
  TMyConnectForm = class(TForm)
    Panel: TPanel;
    lbUsername: TLabel;
    lbPassword: TLabel;
    lbServer: TLabel;
    edUsername: TEdit;
    btConnect: TButton;
    btCancel: TButton;
    edPassword: TEdit;
    edServer: TComboBox;
    lbPort: TLabel;
    lbDatabase: TLabel;
    edPort: TEdit;
    edDatabase: TComboBox;
    procedure btConnectClick(Sender: TObject);
    procedure edServerDropDown(Sender: TObject);
    procedure edDatabaseDropDown(Sender: TObject);
    procedure edExit(Sender: TObject);

  private
    FConnectDialog: TCustomConnectDialog;
    FRetries: integer;
    FOldCreateOrder: boolean;
    FRetry: boolean;

    FListGot: boolean;

    procedure SetConnectDialog(Value: TCustomConnectDialog);

  protected
    procedure DoInit; virtual;
    procedure DoConnect; virtual;

  public

  published
    property ConnectDialog: TCustomConnectDialog read FConnectDialog write SetConnectDialog;

    property OldCreateOrder: boolean read FOldCreateOrder write FOldCreateOrder;
  end;

implementation

{$IFNDEF FPC}
{$IFDEF IDE}
{$R *.dfm}
{$ENDIF}
{$IFNDEF LINUX}
{$R MyConnectForm.dfm}
{$ELSE}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

procedure TMyConnectForm.DoInit;
var
  PropInfo: PPropInfo;
  VisibleEditors: integer;
  StepH, DeltaH, T: integer;
begin
  FRetry := False;
  FRetries := FConnectDialog.Retries;
  Caption := FConnectDialog.Caption;
  FListGot := False;

  with FConnectDialog do begin
    lbUsername.Caption := UsernameLabel;
    lbPassword.Caption := PasswordLabel;
    lbServer.Caption := ServerLabel;
    btConnect.Caption := ConnectButton;
    btCancel.Caption := CancelButton;

    edUsername.Text := Connection.Username;
    edPassword.Text := Connection.Password;
    edServer.Text := Connection.Server;

    if (edUsername.Text <> '') and (edPassword.Text = '') then
      ActiveControl := edPassword;
  end;

  VisibleEditors := 3;

  PropInfo := GetPropInfo(FConnectDialog, 'PortLabel');
  if PropInfo <> nil then
    lbPort.Caption := GetStrProp(FConnectDialog, PropInfo);

  PropInfo := GetPropInfo(FConnectDialog, 'DatabaseLabel');
  if PropInfo <> nil then
    lbDatabase.Caption := GetStrProp(FConnectDialog, PropInfo);

  PropInfo := GetPropInfo(FConnectDialog, 'ShowPort');
  if PropInfo <> nil then begin
    lbPort.Visible := Boolean(GetOrdProp(FConnectDialog, PropInfo));
    edPort.Visible := lbPort.Visible;
    if edPort.Visible then
      Inc(VisibleEditors);
  end;

  StepH := edPassword.Top - edUsername.Top;
  PropInfo := GetPropInfo(FConnectDialog, 'ShowDatabase');
  if PropInfo <> nil then begin
    lbDatabase.Visible := Boolean(GetOrdProp(FConnectDialog, PropInfo));
    edDatabase.Visible := lbDatabase.Visible;
    if edDatabase.Visible then begin
      Inc(VisibleEditors);
      if edPort.Visible then
        T := edPort.Top
      else
        T := edServer.Top;
      edDatabase.Top := T + StepH;
      lbDatabase.Top := edDatabase.Top + (lbUsername.Top - edUsername.Top);
    end;
  end;

  DeltaH := ClientHeight - Panel.Height;
  ClientHeight := StepH * VisibleEditors + 19 + DeltaH;

  if FConnectDialog.Connection is TCustomMyConnection then begin
    edDatabase.Text := TCustomMyConnection(FConnectDialog.Connection).Database;
  end;
  if FConnectDialog.Connection.ClassName = 'TMyEmbConnection' then begin
    lbServer.Enabled := False;
    edServer.Enabled := False;
    lbPort.Enabled := False;
    edPort.Enabled := False;
  end
  else begin
    lbServer.Enabled := True;
    edServer.Enabled := True;
    lbPort.Enabled := True;
    edPort.Enabled := True;
  end;

  if FConnectDialog.Connection is TMyConnection then begin
    edPort.Text := IntToStr(TMyConnection(FConnectDialog.Connection).Port);
  end;
end;

procedure TMyConnectForm.DoConnect;
begin
  try
    edExit(nil);
    FConnectDialog.Connection.PerformConnect(FRetry);
    ModalResult := mrOk;
  except
    on E: EDAError do begin
      Dec(FRetries);
      FRetry := True;
      if FRetries = 0 then
        ModalResult:= mrCancel;

      case E.ErrorCode of
        ER_ACCESS_DENIED_ERROR: ActiveControl := edUsername;
        CR_UNKNOWN_HOST: ActiveControl := edServer;
      end;
      raise;
    end
    else
      raise;
  end;
end;

procedure TMyConnectForm.SetConnectDialog(Value: TCustomConnectDialog);
begin
  FConnectDialog := Value;
  DoInit;
end;

procedure TMyConnectForm.btConnectClick(Sender: TObject);
begin
  DoConnect;
end;

procedure TMyConnectForm.edServerDropDown(Sender: TObject);
var
  OldCursor: TCursor;
  List: _TStringList;
begin
  if FListGot then
    Exit;

  FListGot := True;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  List := _TStringList.Create;
  try
    FConnectDialog.GetServerList(List);
    AssignStrings(List, edServer.Items);
  finally
    List.Free;
    Screen.Cursor := OldCursor;
  end;
end;

procedure TMyConnectForm.edDatabaseDropDown(Sender: TObject);
var
  OldCursor: TCursor;
  OldLoginPrompt: boolean;
  List: _TStringList;
begin
  if not (FConnectDialog.Connection is TCustomMyConnection) then
    Exit;

  edDatabase.Items.Clear;
  OldLoginPrompt := FConnectDialog.Connection.LoginPrompt;
  OldCursor := Screen.Cursor;
  Screen.Cursor := crSQLWait;
  List := _TStringList.Create;
  try
    FConnectDialog.Connection.LoginPrompt := False;
    GetDatabasesList(TCustomMyConnection(FConnectDialog.Connection), List);
    AssignStrings(List, edDatabase.Items);
  finally
    List.Free;
    FConnectDialog.Connection.LoginPrompt := OldLoginPrompt;
    Screen.Cursor := OldCursor;
  end;
end;

procedure TMyConnectForm.edExit(Sender: TObject);
begin
  try
    FConnectDialog.Connection.Password := edPassword.Text;
    FConnectDialog.Connection.Server := edServer.Text;
    FConnectDialog.Connection.UserName := edUsername.Text;
    if FConnectDialog.Connection is TCustomMyConnection then begin
      TCustomMyConnection(FConnectDialog.Connection).Database := edDatabase.Text;
    end;
    if FConnectDialog.Connection is TMyConnection then begin
      TMyConnection(FConnectDialog.Connection).Port := StrToInt(edPort.Text);
    end;
  except
    ActiveControl := Sender as TWinControl;
    raise;
  end;
end;

initialization
  if GetClass('TMyConnectForm') = nil then
    Classes.RegisterClass(TMyConnectForm);
{$IFDEF FPC}
  {$i MyConnectForm.lrs}
{$ENDIF}
end.

