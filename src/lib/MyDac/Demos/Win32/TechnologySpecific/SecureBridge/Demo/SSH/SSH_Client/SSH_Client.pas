unit SSH_Client;

{$I ..\..\Base\SBDemo.inc}
interface

uses
  Classes, SysUtils, DB,
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls,
  Buttons, Spin, DemoFrame, MemDS, DBAccess, MyAccess, MyDacVcl,
  ScBridge, ScSSHClient, ScSSHChannel, MySSHIOHandler, CRVio, CRSSHIOHandler;

type
  TSSHClientFrame = class(TDemoFrame)
    Panel1: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel5: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    edSSHUserName: TEdit;
    Label7: TLabel;
    edSSHPassword: TEdit;
    Label8: TLabel;
    cbPrivateKey: TComboBox;
    pnPassword: TPanel;
    pnPrivateKey: TPanel;
    rbLocalPF: TRadioButton;
    rbDirect: TRadioButton;
    btConnectDB: TSpeedButton;
    btDisconnectDB: TSpeedButton;
    DBGrid: TDBGrid;
    btConnectSSH: TSpeedButton;
    btDisconnectSSH: TSpeedButton;
    ScSSHClient: TScSSHClient;
    MySSHIOHandler: TMySSHIOHandler;
    MyConnection: TMyConnection;
    MyTable: TMyTable;
    MyDataSource: TMyDataSource;
    Label4: TLabel;
    Label5: TLabel;
    edSSHHost: TEdit;
    edSSHPort: TEdit;
    lbListenPort: TLabel;
    Label10: TLabel;
    edDBHost: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    edDBUserName: TEdit;
    Label13: TLabel;
    edDBPassword: TEdit;
    Label14: TLabel;
    Label3: TLabel;
    rbPassword: TRadioButton;
    rbPublicKey: TRadioButton;
    Panel12: TPanel;
    btKeyGen: TSpeedButton;
    seDBPort: TSpinEdit;
    ScFileStorage: TScFileStorage;
    cbDBDatabase: TComboBox;
    s: TPanel;
    lbTableName: TLabel;
    cbTableName: TComboBox;
    Panel9: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    DBNavigator: TDBNavigator;
    Panel8: TPanel;
    ScSSHChannel: TScSSHChannel;
    seListenPort: TSpinEdit;
    cbRandomization: TCheckBox;
    procedure rbLocalPFClick(Sender: TObject);
    procedure rbDirectClick(Sender: TObject);
    procedure rbPasswordClick(Sender: TObject);
    procedure rbPublicKeyClick(Sender: TObject);
    procedure edSSHUserNameChange(Sender: TObject);
    procedure cbPrivateKeyDropDown(Sender: TObject);
    procedure btConnectDBClick(Sender: TObject);
    procedure btDisconnectDBClick(Sender: TObject);
    procedure btConnectSSHClick(Sender: TObject);
    procedure btDisconnectSSHClick(Sender: TObject);
    procedure ScSSHClientAfterConnect(Sender: TObject);
    procedure ScSSHClientAfterDisconnect(Sender: TObject);
    procedure MyConnectionAfterConnect(Sender: TObject);
    procedure MyConnectionAfterDisconnect(Sender: TObject);
    procedure MyTableAfterClose(DataSet: TDataSet);
    procedure MyTableAfterOpen(DataSet: TDataSet);
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure cbTableNameDropDown(Sender: TObject);
    procedure cbTableNameChange(Sender: TObject);
    procedure edListenPortChange(Sender: TObject);
    procedure cbPrivateKeyChange(Sender: TObject);
    procedure btKeyGenClick(Sender: TObject);
    procedure ScSSHClientServerKeyValidate(Sender: TObject;
      NewServerKey: TScKey; var Accept: Boolean);
    procedure cbDBDatabaseDropDown(Sender: TObject);
    procedure cbDBDatabaseChange(Sender: TObject);
    procedure MyConnectionBeforeConnect(Sender: TObject);
    procedure ScSSHClientBeforeConnect(Sender: TObject);
  private
    procedure CheckRandomize;
    procedure ShowPasswordAuth(pa: boolean);
    procedure ShowSSHButtons(Connected: boolean);
    procedure ShowDBButtons(Connected: boolean);
    procedure EnableLPFComponents(Enabled: boolean);
  {$IFDEF MSWINDOWS}
    function LoadState: boolean;
    function SaveState: boolean;
    function KeyPath: string;
  {$ENDIF}
  public
    destructor Destroy; override;
    procedure DisconnectAll;
    procedure Initialize; override;
    procedure Finalize; override;
  end;

var
  SSHClientFrame: TSSHClientFrame;

implementation

{$IFDEF CLR}
{$R *.nfm}
{$ENDIF}
{$IFDEF WIN32}
{$R *.dfm}
{$ENDIF}

uses
{$IFDEF MSWINDOWS}
  Registry,
{$ENDIF}
  ScSSHUtil, ScConsts, SSHDacDemoForm;

destructor TSSHClientFrame.Destroy;
begin
  DisconnectAll;
  inherited;
end;

procedure TSSHClientFrame.Initialize;
begin
  inherited;

{$IFDEF MSWINDOWS}
  LoadState;
{$ENDIF}

  EnableLPFComponents(rbLocalPF.Checked);
  edSSHHost.Text := ScSSHClient.HostName;
  edSSHPort.Text := IntToStr(ScSSHClient.Port);
  edSSHUserName.Text := ScSSHClient.User;
end;

procedure TSSHClientFrame.Finalize;
begin
{$IFDEF MSWINDOWS}
  SaveState;
{$ENDIF}

  inherited;
end;

procedure TSSHClientFrame.CheckRandomize;
begin
  if not SSHDacForm.Randomized and not cbRandomization.Checked then begin
    SSHDacForm.Randomize;
    if not SSHDacForm.Randomized and not cbRandomization.Checked then
      raise Exception.Create('Data for the random generator has not been generated');
  end;
end;

procedure TSSHClientFrame.DisconnectAll;
begin
  MyConnection.Close;
  ScSSHChannel.Disconnect;
  ScSSHClient.Disconnect;
  ShowSSHButtons(False);
end;

procedure TSSHClientFrame.ShowSSHButtons(Connected: boolean);
begin
  btConnectSSH.Enabled := not Connected;
  btDisconnectSSH.Enabled := Connected;
  btConnectDB.Enabled := Connected;
end;

procedure TSSHClientFrame.ShowDBButtons(Connected: boolean);
begin
  btConnectDB.Enabled := not Connected and ScSSHClient.Connected;
  btDisconnectDB.Enabled := Connected;
  btOpen.Enabled := Connected and (cbTableName.Text <> '');
  cbTableName.Enabled := Connected;
end;

procedure TSSHClientFrame.ScSSHClientAfterConnect(Sender: TObject);
begin
  ShowSSHButtons(True);
end;

procedure TSSHClientFrame.ScSSHClientAfterDisconnect(Sender: TObject);
begin
  ShowSSHButtons(False);
  ScSSHChannel.Disconnect;
end;

procedure TSSHClientFrame.btConnectSSHClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  OldCursor := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    ScSSHClient.Connect;
  finally
    Screen.Cursor := OldCursor;
  end;
end;

procedure TSSHClientFrame.btDisconnectSSHClick(Sender: TObject);
begin
  DisconnectAll;
end;

procedure TSSHClientFrame.EnableLPFComponents(Enabled: boolean);
begin
  lbListenPort.Enabled := Enabled;
  seListenPort.Enabled := Enabled;
end;

procedure TSSHClientFrame.rbLocalPFClick(Sender: TObject);
begin
  EnableLPFComponents(True);
  MyConnection.Disconnect;
end;

procedure TSSHClientFrame.rbDirectClick(Sender: TObject);
begin
  EnableLPFComponents(False);
  MyConnection.Disconnect;
end;

procedure TSSHClientFrame.edListenPortChange(Sender: TObject);
begin
  MyConnection.Disconnect;
  ScSSHChannel.Disconnect;
end;

procedure TSSHClientFrame.ShowPasswordAuth(pa: boolean);
begin
  pnPassword.Visible := pa;
  pnPrivateKey.Visible := not pa;
  Repaint;
end;

procedure TSSHClientFrame.rbPasswordClick(Sender: TObject);
begin
  ShowPasswordAuth(True);
  DisconnectAll;
end;

procedure TSSHClientFrame.rbPublicKeyClick(Sender: TObject);
begin
  ShowPasswordAuth(False);
  DisconnectAll;
end;

procedure TSSHClientFrame.edSSHUserNameChange(Sender: TObject);
begin
  DisconnectAll;
end;

procedure TSSHClientFrame.cbPrivateKeyDropDown(Sender: TObject);
begin
  ScFileStorage.Keys.GetKeyNames(cbPrivateKey.Items);
end;

procedure TSSHClientFrame.cbPrivateKeyChange(Sender: TObject);
begin
  DisconnectAll;
end;

procedure TSSHClientFrame.btConnectDBClick(Sender: TObject);
begin
  MyConnection.Connect;
end;

procedure TSSHClientFrame.btDisconnectDBClick(Sender: TObject);
begin
  MyConnection.Disconnect;
end;

procedure TSSHClientFrame.MyConnectionAfterConnect(Sender: TObject);
begin
  ShowDBButtons(True);
end;

procedure TSSHClientFrame.MyConnectionAfterDisconnect(Sender: TObject);
begin
  ShowDBButtons(False);
  MyConnection.IOHandler := nil;
  ScSSHChannel.Disconnect;
end;

procedure TSSHClientFrame.MyTableAfterOpen(DataSet: TDataSet);
begin
  btOpen.Enabled := False;
  btClose.Enabled := True;
end;

procedure TSSHClientFrame.MyTableAfterClose(DataSet: TDataSet);
begin
  btOpen.Enabled := not btConnectDB.Enabled and (cbTableName.Text <> '');
  btClose.Enabled := False;
end;

procedure TSSHClientFrame.btOpenClick(Sender: TObject);
begin
  MyTable.Open;
end;

procedure TSSHClientFrame.btCloseClick(Sender: TObject);
begin
  MyTable.Close;
end;

procedure TSSHClientFrame.cbTableNameDropDown(Sender: TObject);
begin
  if MyConnection.Connected then
    MyConnection.GetTableNames(cbTableName.Items)
  else
    cbTableName.Items.Clear;
end;

procedure TSSHClientFrame.cbTableNameChange(Sender: TObject);
begin
  MyTable.TableName := cbTableName.Text;
  btOpen.Enabled := MyConnection.Connected and (cbTableName.Text <> '');
end;

{$IFDEF MSWINDOWS}
function TSSHClientFrame.SaveState: boolean;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    with Registry do begin
      OpenKey(KeyPath + '\' + TSSHClientFrame.ClassName, True);
      WriteString('SSHHost', ScSSHClient.HostName);
      WriteInteger('SSHPort', ScSSHClient.Port);
      WriteString('SSHUserName', ScSSHClient.User);

      WriteInteger('ListenPort', seListenPort.Value);
      WriteString('DBHost', edDBHost.Text);
      WriteInteger('DBPort', seDBPort.Value);
      WriteString('DBUserName', edDBUserName.Text);
      WriteString('DBDatabase', cbDBDatabase.Text);
      WriteBool('Silent randomization', cbRandomization.Checked);
    end;
  finally
    Registry.Free;
  end;

  Result := True;
end;

function TSSHClientFrame.LoadState: boolean;
var
  Registry: TRegistry;
begin
  Result := False;
  Registry := TRegistry.Create;
  try
    with Registry do begin
      if OpenKey(KeyPath + '\' + TSSHClientFrame.ClassName, False) then begin
        if ValueExists('SSHHost') then
          ScSSHClient.HostName := ReadString('SSHHost');
        if ValueExists('SSHPort') then
          ScSSHClient.Port := ReadInteger('SSHPort');
        if ValueExists('SSHUserName') then
          ScSSHClient.User := ReadString('SSHUserName');

        if ValueExists('ListenPort') then
          seListenPort.Value := ReadInteger('ListenPort');
        if ValueExists('DBHost') then
          edDBHost.Text := ReadString('DBHost');
        if ValueExists('DBPort') then
          seDBPort.Value := ReadInteger('DBPort');
        if ValueExists('DBUserName') then
          edDBUserName.Text := ReadString('DBUserName');
        if ValueExists('DBDatabase') then
          cbDBDatabase.Text := ReadString('DBDatabase');
        if ValueExists('Silent randomization') then
          cbRandomization.Checked := ReadBool('Silent randomization');
        Result := True;
      end;
    end;
  finally
    Registry.Free;
  end;
end;

function TSSHClientFrame.KeyPath: string;
begin
  Result := '\SOFTWARE\Devart\SecureBridge\Demos';
end;
{$ENDIF}

procedure TSSHClientFrame.btKeyGenClick(Sender: TObject);
var
  msg: string;
  OldCursor: TCursor;
  Key: TScKey;
  Algorithm: TScAsymmetricAlgorithm;
  BitCount: integer;
begin
  CheckRandomize;

  OldCursor := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;

    if cbPrivateKey.Text = '' then
      cbPrivateKey.Text := 'client_key';

    Key := ScFileStorage.Keys.FindKey(cbPrivateKey.Text);

    if Key = nil then begin
      Key := TScKey.Create(ScFileStorage.Keys);
      Key.KeyName := cbPrivateKey.Text;
      Algorithm := aaRSA;
      BitCount := 1024;
    end
    else begin
      Key.Ready := True;
      Algorithm := Key.Algorithm;
      BitCount := Key.BitCount;
    end;

    try
      Key.Generate(Algorithm, BitCount);
      Key.ExportTo(Key.KeyName + '.pub', True, '');

      msg := 'The client key file has been generated into the current application directory.'#13#10 +
             'To connect with authentication by key, you should pass the "' + Key.KeyName +
             '.pub" file to the server and set the server to work with this file.';
      MessageDlg(msg, mtInformation, [mbOk], 0);
    except
      on E: Exception do
        MessageDlg('Cannot generate key: ' + E.Message, mtWarning, [mbOk], 0);
    end;
  finally
    Screen.Cursor := OldCursor;
  end;
end;

procedure TSSHClientFrame.ScSSHClientServerKeyValidate(Sender: TObject;
  NewServerKey: TScKey; var Accept: Boolean);
var
  Key: TScKey;
  fp, msg: string;
begin
  Key := ScFileStorage.Keys.FindKey(ScSSHClient.HostName);
  if (Key = nil) or not Key.Ready then begin
    NewServerKey.GetFingerPrint(haMD5, fp);
    msg := 'The authenticity of server can not be established.'#13#10 +
           'Fingerprint for the key received from server: ' + fp +'.'#13#10 +
           'Key length: ' + IntToStr(NewServerKey.BitCount) +' bits.'#13#10 +
           'Are you sure you want to continue connecting?';

    if MessageDlg(msg, mtConfirmation, [mbOk, mbCancel], 0) = mrOk then begin
      NewServerKey.KeyName := ScSSHClient.HostName;
      ScFileStorage.Keys.Add(NewServerKey);
      Accept := True;
    end;
  end;
end;

procedure TSSHClientFrame.cbDBDatabaseDropDown(Sender: TObject);
begin
  MyConnection.GetDatabaseNames(cbDBDatabase.Items)
end;

procedure TSSHClientFrame.cbDBDatabaseChange(Sender: TObject);
begin
  MyTable.Close;
  MyConnection.Database := cbDBDatabase.Text;
  cbTableName.Text := '';
end;

procedure TSSHClientFrame.MyConnectionBeforeConnect(Sender: TObject);
begin
  if rbLocalPF.Checked then begin
    MyConnection.IOHandler := nil;

    ScSSHChannel.SourcePort := seListenPort.Value;
    ScSSHChannel.DestPort := seDBPort.Value;
    ScSSHChannel.DestHost := edDBHost.Text;
    ScSSHChannel.Connect;

    MyConnection.Server := 'localhost';
    MyConnection.Port := ScSSHChannel.SourcePort;
  end
  else begin
    MyConnection.IOHandler := MySSHIOHandler;
    MyConnection.Server := edDBHost.Text;
    MyConnection.Port := seDBPort.Value;
  end;

  MyConnection.Username := edDBUserName.Text;
  MyConnection.Password := edDBPassword.Text;
  MyConnection.Database := cbDBDatabase.Text;
end;

procedure TSSHClientFrame.ScSSHClientBeforeConnect(Sender: TObject);
begin
  CheckRandomize;

  ScSSHClient.HostName := edSSHHost.Text;
  if edSSHPort.Text <> '' then
    ScSSHClient.Port := StrToInt(edSSHPort.Text);
  ScSSHClient.User := edSSHUserName.Text;

  if rbPassword.Checked then begin
    ScSSHClient.Authentication := atPassword;
    ScSSHClient.Password := edSSHPassword.Text;
  end
  else begin
    ScSSHClient.Authentication := atPublicKey;
    ScSSHClient.PrivateKeyName := cbPrivateKey.Text;
    if ScFileStorage.Keys.FindKey(ScSSHClient.PrivateKeyName) = nil then
      raise EScError.Create('Private key can not be empty');
  end;
end;

end.
