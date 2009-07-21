unit SSL_Client;

{$I ..\..\Base\SBDemo.inc}
interface

uses
  Classes, SysUtils, DB,
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls,
  Buttons, Spin, DemoFrame, MemDS, DBAccess, MyAccess,
  MyDacVcl, ScBridge, ScCryptoAPIStorage, MySSLIOHandler;

type
  TSSLClientFrame = class(TDemoFrame)
    Panel1: TPanel;
    Panel4: TPanel;
    Panel2: TPanel;
    Panel6: TPanel;
    Panel5: TPanel;
    Label2: TLabel;
    btConnectDB: TSpeedButton;
    btDisconnectDB: TSpeedButton;
    DBGrid: TDBGrid;
    MyConnection: TMyConnection;
    MyTable: TMyTable;
    MyDataSource: TMyDataSource;
    Label10: TLabel;
    edDBHost: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    edDBUserName: TEdit;
    Label13: TLabel;
    edDBPassword: TEdit;
    Label14: TLabel;
    seDBPort: TSpinEdit;
    cbDBDatabase: TComboBox;
    Panel7: TPanel;
    lbTableName: TLabel;
    cbTableName: TComboBox;
    Panel9: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    Panel8: TPanel;
    MySSLIOHandler: TMySSLIOHandler;
    ScCryptoAPIStorage: TScCryptoAPIStorage;
    DBNavigator: TDBNavigator;
    Panel3: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edCACertName: TEdit;
    edKeyName: TEdit;
    cbRandomization: TCheckBox;
    cbSSL: TCheckBox;
    sbCACertName: TSpeedButton;
    edCertName: TEdit;
    sbCertName: TSpeedButton;
    sbKeyName: TSpeedButton;
    OpenDialog: TOpenDialog;
    procedure btConnectDBClick(Sender: TObject);
    procedure btDisconnectDBClick(Sender: TObject);
    procedure MyConnectionAfterConnect(Sender: TObject);
    procedure MyConnectionAfterDisconnect(Sender: TObject);
    procedure MyTableAfterClose(DataSet: TDataSet);
    procedure MyTableAfterOpen(DataSet: TDataSet);
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure cbTableNameDropDown(Sender: TObject);
    procedure cbTableNameChange(Sender: TObject);
    procedure cbDBDatabaseDropDown(Sender: TObject);
    procedure cbDBDatabaseChange(Sender: TObject);
    procedure MyConnectionBeforeConnect(Sender: TObject);
    procedure edDBHostChange(Sender: TObject);
    procedure sbCACertNameClick(Sender: TObject);
    procedure sbKeyNameClick(Sender: TObject);
    procedure sbCertNameClick(Sender: TObject);
  private
    procedure CheckRandomize;
    procedure ShowDBButtons(Connected: boolean);
  {$IFDEF MSWINDOWS}
    function LoadState: boolean;
    function SaveState: boolean;
    function KeyPath: string;
  {$ENDIF}
  public
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Finalize; override;
  end;

var
  SSLClientFrame: TSSLClientFrame;

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
  ScConsts, ScSSHUtil, MyClasses, SSLDacDemoForm;

const
  CertFilter = 'All formats |*.pem;*.crt;*.cer|PEM format (*.pem;*.crt)|*.pem;*.crt|DER format (*.cer)|*.cer|All files (*.*)|*.*';
  KeyFilter = 'All formats |*.key;*.ssl;*.pem;*.ietf;*.pub;*.ietfpub|OpenSSL format (*.ssl)|*.ssl|PKCS8 format (*.pem)|*.pem|IETF format (*.ietf)|*.ietf|Public key (*.pub)|*.pub|Public IETF key (*.ietfpub)|*.ietfpub|All files (*.*)|*.*';

destructor TSSLClientFrame.Destroy;
begin
  MyConnection.Close;
  inherited;
end;

procedure TSSLClientFrame.Initialize;
begin
  inherited;

{$IFDEF MSWINDOWS}
  LoadState;
{$ENDIF}
end;

procedure TSSLClientFrame.Finalize;
begin
{$IFDEF MSWINDOWS}
  SaveState;
{$ENDIF}

  inherited;
end;

procedure TSSLClientFrame.CheckRandomize;
begin
  if not SSLDacForm.Randomized and not cbRandomization.Checked then begin
    SSLDacForm.Randomize;
    if not SSLDacForm.Randomized and not cbRandomization.Checked then
      raise Exception.Create('Data for the random generator has not been generated');
  end;
end;

procedure TSSLClientFrame.ShowDBButtons(Connected: boolean);
begin
  btConnectDB.Enabled := not Connected;
  btDisconnectDB.Enabled := Connected;
  btOpen.Enabled := Connected and (cbTableName.Text <> '');
  cbTableName.Enabled := Connected;
end;

procedure TSSLClientFrame.btConnectDBClick(Sender: TObject);
begin
  MyConnection.Connect;
end;

procedure TSSLClientFrame.btDisconnectDBClick(Sender: TObject);
begin
  MyConnection.Disconnect;
end;

procedure TSSLClientFrame.edDBHostChange(Sender: TObject);
begin
  MyConnection.Disconnect;
end;

procedure TSSLClientFrame.MyConnectionAfterConnect(Sender: TObject);
begin
  ShowDBButtons(True);
end;

procedure TSSLClientFrame.MyConnectionAfterDisconnect(Sender: TObject);
begin
  ShowDBButtons(False);
end;

procedure TSSLClientFrame.MyTableAfterOpen(DataSet: TDataSet);
begin
  btOpen.Enabled := False;
  btClose.Enabled := True;
end;

procedure TSSLClientFrame.MyTableAfterClose(DataSet: TDataSet);
begin
  btOpen.Enabled := not btConnectDB.Enabled and (cbTableName.Text <> '');
  btClose.Enabled := False;
end;

procedure TSSLClientFrame.btOpenClick(Sender: TObject);
begin
  MyTable.Open;
end;

procedure TSSLClientFrame.btCloseClick(Sender: TObject);
begin
  MyTable.Close;
end;

procedure TSSLClientFrame.cbTableNameDropDown(Sender: TObject);
begin
  if MyConnection.Connected then
    MyConnection.GetTableNames(cbTableName.Items)
  else
    cbTableName.Items.Clear;
end;

procedure TSSLClientFrame.cbTableNameChange(Sender: TObject);
begin
  MyTable.TableName := cbTableName.Text;
  btOpen.Enabled := MyConnection.Connected and (cbTableName.Text <> '');
end;

{$IFDEF MSWINDOWS}
function TSSLClientFrame.SaveState: boolean;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    with Registry do begin
      OpenKey(KeyPath + '\' + TSSLClientFrame.ClassName, True);
      WriteString('CACertName', edCACertName.Text);
      WriteString('ClientCertName', edCertName.Text);
      WriteString('CertPrivateKeyName', edKeyName.Text);

      WriteString('DBHost', edDBHost.Text);
      WriteInteger('DBPort', seDBPort.Value);
      WriteString('DBUserName', edDBUserName.Text);
      WriteString('DBDatabase', cbDBDatabase.Text);
      WriteBool('Silent randomization', cbRandomization.Checked);
      WriteBool('Use SSL', cbSSL.Checked);
    end;
  finally
    Registry.Free;
  end;

  Result := True;
end;

function TSSLClientFrame.LoadState: boolean;
var
  Registry: TRegistry;
begin
  Result := False;
  Registry := TRegistry.Create;
  try
    with Registry do begin
      if OpenKey(KeyPath + '\' + TSSLClientFrame.ClassName, False) then begin
        if ValueExists('CACertName') then
          edCACertName.Text := ReadString('CACertName');
        if ValueExists('ClientCertName') then
          edCertName.Text := ReadString('ClientCertName');
        if ValueExists('CertPrivateKeyName') then
          edKeyName.Text := ReadString('CertPrivateKeyName');

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
        if ValueExists('Use SSL') then
          cbSSL.Checked := ReadBool('Use SSL');
        Result := True;
      end;
    end;
  finally
    Registry.Free;
  end;
end;

function TSSLClientFrame.KeyPath: string;
begin
  Result := '\SOFTWARE\Devart\SecureBridge\Demos';
end;
{$ENDIF}

procedure TSSLClientFrame.cbDBDatabaseDropDown(Sender: TObject);
begin
  MyConnection.GetDatabaseNames(cbDBDatabase.Items)
end;

procedure TSSLClientFrame.cbDBDatabaseChange(Sender: TObject);
begin
  MyTable.Close;
  MyConnection.Database := cbDBDatabase.Text;
  cbTableName.Text := '';
end;

procedure TSSLClientFrame.MyConnectionBeforeConnect(Sender: TObject);
var
  Cert: TScCertificate;
begin
  if cbSSL.Checked then begin
    ScCryptoAPIStorage.Certificates.Clear;
    Cert := TScCertificate.Create(ScCryptoAPIStorage.Certificates);
    Cert.CertName := MySSLIOHandler.CACertName;
    Cert.ImportFrom(edCACertName.Text);

    Cert := TScCertificate.Create(ScCryptoAPIStorage.Certificates);
    Cert.CertName := MySSLIOHandler.CertName;
    Cert.ImportFrom(edCertName.Text);
    Cert.Key.ImportFrom(edKeyName.Text);

    CheckRandomize;
    MyConnection.Options.Protocol := mpSSL;
    MyConnection.IOHandler := MySSLIOHandler;
  end
  else begin
    MyConnection.Options.Protocol := mpDefault;
    MyConnection.IOHandler := nil;
  end;

  MyConnection.Server := edDBHost.Text;
  MyConnection.Port := seDBPort.Value;
  MyConnection.Username := edDBUserName.Text;
  MyConnection.Password := edDBPassword.Text;
  MyConnection.Database := cbDBDatabase.Text;
end;

procedure TSSLClientFrame.sbCACertNameClick(Sender: TObject);
begin
  OpenDialog.Filter := CertFilter;
  OpenDialog.Title := 'Import certificate';
  if OpenDialog.Execute then
    edCACertName.Text := OpenDialog.FileName;
end;

procedure TSSLClientFrame.sbCertNameClick(Sender: TObject);
begin
  OpenDialog.Filter := CertFilter;
  OpenDialog.Title := 'Import certificate';
  if OpenDialog.Execute then
    edCertName.Text := OpenDialog.FileName;
end;

procedure TSSLClientFrame.sbKeyNameClick(Sender: TObject);
begin
  OpenDialog.Filter := KeyFilter;
  OpenDialog.Title := 'Import key';
  if OpenDialog.Execute then
    edKeyName.Text := OpenDialog.FileName;
end;

end.
