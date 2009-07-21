unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uData, uBase, uQuery, uCachedUpdates, uMasterDetail,
  IWCompLabel, IWControl, IWCompRectangle,
  DB, MemDS, DBAccess, MyAccess, MyConnectionPool, IWHTMLControls, IWCompButton,
  IWGrids, IWDBGrids, IWDBStdCtrls, IWCompMemo, IWCompEdit, IWContainer,
  IWRegion, IWCompCheckbox, IWCompListbox;

type
  TfmMain = class(TfmBase)
    edUsername: TIWEdit;
    edPassword: TIWEdit;
    edServer: TIWEdit;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWRegion4: TIWRegion;
    IWRectangle3: TIWRectangle;
    cbFailover: TIWCheckBox;
    cbDisconnectedMode: TIWCheckBox;
    cbPooling: TIWCheckBox;
    IWRegion1: TIWRegion;
    IWRectangle1: TIWRectangle;
    edConnectionLifeTime: TIWEdit;
    IWLabel4: TIWLabel;
    edMaxPoolSize: TIWEdit;
    edMinPoolSize: TIWEdit;
    IWLabel6: TIWLabel;
    IWLabel7: TIWLabel;
    IWLabel5: TIWLabel;
    edDatabase: TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormRender(Sender: TObject);
  protected
    procedure ReadFromControls; override;
  end;

implementation
{$R *.dfm}

uses
  ServerController, IWForm;

{ TfmMain }

procedure TfmMain.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  UserSession.fmMain := Self;
end;

procedure TfmMain.IWAppFormRender(Sender: TObject);
begin
  inherited;
  edUsername.Text := UserSession.Username;
  edPassword.Text := UserSession.Password;
  edServer.Text := UserSession.Server;
  edDatabase.Text := UserSession.Database;
  cbPooling.Checked := UserSession.Pooling;
  cbDisconnectedMode.Checked := UserSession.DisconnectedMode;
  cbFailover.Checked := UserSession.FailOver;

  edConnectionLifeTime.Text := IntToStr(UserSession.PoolingOptions.ConnectionLifetime);
  edMaxPoolSize.Text := IntToStr(UserSession.PoolingOptions.MaxPoolSize);
  edMinpoolSize.Text := IntToStr(UserSession.PoolingOptions.MinPoolSize);
end;

procedure TfmMain.ReadFromControls;
begin
  inherited;
  UserSession.Username := edUsername.Text;
  UserSession.Password := edPassword.Text;
  UserSession.Server := edServer.Text;
  UserSession.Database := edDatabase.Text;
  UserSession.Pooling := cbPooling.Checked;
  UserSession.DisconnectedMode := cbDisconnectedMode.Checked;
  UserSession.FailOver := cbFailover.Checked;

  try UserSession.PoolingOptions.ConnectionLifetime := StrToInt(edConnectionLifeTime.Text); except {Silent} end;
  try UserSession.PoolingOptions.ConnectionLifetime := StrToInt(edConnectionLifeTime.Text); except {Silent} end;
  try UserSession.PoolingOptions.MaxPoolSize := StrToInt(edMaxPoolSize.Text); except {Silent} end;
  try UserSession.PoolingOptions.MinPoolSize := StrToInt(edMinPoolSize.Text); except {Silent} end;
end;

end.
