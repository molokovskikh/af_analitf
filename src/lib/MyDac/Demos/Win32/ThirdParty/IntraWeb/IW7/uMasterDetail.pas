unit uMasterDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBase, IWHTMLControls, IWCompLabel, IWControl, IWCompRectangle,
  IWCompCheckbox, IWCompEdit, IWCompMemo, IWGrids, IWDBGrids, DB, MemDS,
  DBAccess, MyAccess, IWDBStdCtrls, IWCompButton, IWContainer, IWRegion,
  IWVCLBaseContainer, IWHTMLContainer, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl;

type
  TfmMasterDetail = class(TfmBase)
    cbLocalMasterDetail: TIWCheckBox;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    edMasterFields: TIWEdit;
    IWDBGrid1: TIWDBGrid;
    IWDBGrid2: TIWDBGrid;
    IWLabel3: TIWLabel;
    IWLabel4: TIWLabel;
    edDetailFields: TIWEdit;
    IWDBNavigator1: TIWDBNavigator;
    quMaster: TMyQuery;
    quDetail: TMyQuery;
    dsMaster: TDataSource;
    dsDetail: TDataSource;
    cbCachedCalcFields: TIWCheckBox;
    btOpen: TIWButton;
    btClose: TIWButton;
    IWRegion1: TIWRegion;
    IWRegion2: TIWRegion;
    IWRegion3: TIWRegion;
    IWRectangle1: TIWRectangle;
    IWRectangle2: TIWRectangle;
    IWRectangle3: TIWRectangle;
    lbResult: TIWLabel;
    IWRegion4: TIWRegion;
    meMaster: TIWMemo;
    IWRegion5: TIWRegion;
    meDetail: TIWMemo;
    procedure IWAppFormCreate(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure IWAppFormRender(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure IWDBNavigator1Refresh(Sender: TObject);
  protected
    procedure ReadFromControls; override;
  end;

implementation

{$R *.dfm}

uses
  ServerController, StdConvs;

procedure TfmMasterDetail.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  quMaster.Connection := DM.Connection;
  quDetail.Connection := DM.Connection;
end;

procedure TfmMasterDetail.btOpenClick(Sender: TObject);
begin
  ReadFromControls;
  UserSession.IsGoodMasterDetail := False;
  try
    quMaster.SQL.Text := UserSession.MasterSQL;
    quDetail.SQL.Text := UserSession.DetailSQL;
    quDetail.MasterFields := UserSession.MasterFields;
    quDetail.DetailFields := UserSession.DetailFields;
    quMaster.Options.LocalMasterDetail := UserSession.LocalMasterDetail;
    quDetail.Options.LocalMasterDetail := UserSession.LocalMasterDetail;
    quMaster.Options.CacheCalcFields := UserSession.CacheCalcFields;
    quDetail.Options.CacheCalcFields := UserSession.CacheCalcFields;
    quMaster.Open;
    quDetail.Open;
    UserSession.IsGoodMasterDetail := True;
    UserSession.MasterDetailResult := 'Tables are opened';
  except
    on E:Exception do
      UserSession.MasterDetailResult := 'Error: '+ E.Message;
  end;
end;

procedure TfmMasterDetail.btCloseClick(Sender: TObject);
begin
  ReadFromControls;
  quMaster.Close;
  quDetail.Close;
end;

procedure TfmMasterDetail.IWAppFormRender(Sender: TObject);
begin
  inherited;
  cbLocalMasterDetail.Checked := UserSession.LocalMasterDetail;
  cbCachedCalcFields.Checked := UserSession.CacheCalcFields;
  edMasterFields.Text := UserSession.MasterFields;
  edDetailFields.Text := UserSession.DetailFields;
  meMaster.Lines.Text := UserSession.MasterSQL;
  meDetail.Lines.Text := UserSession.DetailSQL;
  IWDBGrid1.Visible := quMaster.Active;
  IWDBNavigator1.Enabled := quMaster.Active;
  IWDBGrid2.Visible := quDetail.Active;
  lbResult.Font.Color := ResultColors[UserSession.IsGoodMasterDetail];
  lbResult.Caption := UserSession.MasterDetailResult;
end;

procedure TfmMasterDetail.ReadFromControls;
begin
  inherited;
  UserSession.LocalMasterDetail := cbLocalMasterDetail.Checked;
  UserSession.CacheCalcFields := cbCachedCalcFields.Checked;
  UserSession.MasterFields := edMasterFields.Text;
  UserSession.DetailFields := edDetailFields.Text;
  UserSession.MasterSQL := meMaster.Lines.Text;
  UserSession.DetailSQL := meDetail.Lines.Text;
end;

procedure TfmMasterDetail.IWDBNavigator1Refresh(Sender: TObject);
begin
  ReadFromControls;
end;

end.
