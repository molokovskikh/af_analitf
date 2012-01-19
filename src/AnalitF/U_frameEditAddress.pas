unit U_frameEditAddress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GridsEh, DBGridEh, ToughDBGrid,
  DBGridHelper, RxMemDS, DB, DModule, DBProc, AProc, Buttons, MyAccess,
  DBCtrls, DatabaseObjects,
  NetworkSettings;

type
  TframeEditAddress = class(TFrame)
  private
    { Private declarations }
    procedure AddComponents;
    procedure AddNonVisualComponents;
    procedure AddLabelAndDBEdit(
      Parents : TWinControl;
      DataSource : TDataSource;
      var nextTop: Integer;
      var labelInfo : TLabel;
      var dbedit : TDBEdit;
      LabelCaption,
      DataField : String);
  public
    { Public declarations }
    adsMethods : TRxMemoryData;
    dsMethods : TDataSource;

    adsEditClients : TMyQuery;
    dsEditClients : TDataSource;

    gbEditClients : TGroupBox;

    lClientId : TLabel;
    dblClientId : TDBLookupComboBox;

    lAddress : TLabel;
    dbeAddress : TDBEdit;

    lDirector : TLabel;
    dbeDirector : TDBEdit;
    lDeputyDirector : TLabel;
    dbeDeputyDirector : TDBEdit;
    lAccountant : TLabel;
    dbeAccountant : TDBEdit;

    lEditName : TLabel;
    dbeEditName : TDBEdit;

    lMethodOfTaxation : TLabel;
    dblMethodOfTaxation : TDBLookupComboBox;

    dbchbCalculateWithNDS : TDBCheckBox;
    dbchbCalculateWithNDSForOther : TDBCheckBox;

    lSelfAddressId : TLabel;
    dbeSelfAddressId : TDBEdit;

    constructor Create(AOwner: TComponent); override;
    procedure SaveChanges;
    procedure CancelChanges;
  end;

implementation

{$R *.dfm}

{ TframeEditAddress }

procedure TframeEditAddress.AddComponents;
var
  nextTop : Integer;
begin
  adsEditClients := TMyQuery.Create(Self);
  adsEditClients.Connection := DM.MainConnection;
  dsEditClients := TDataSource.Create(Self);
  dsEditClients.DataSet := adsEditClients;

  if not DM.adsUser.IsEmpty then begin
    //Открываем дата сет
    adsEditClients.CachedUpdates := True;
    adsEditClients.SQL.Text := DM.adtClients.SQL.Text;
    adsEditClients.SQLRefresh.Text := DM.adtClients.SQLRefresh.Text;
    adsEditClients.SQLUpdate.Text := DM.adtClients.SQLUpdate.Text;
    adsEditClients.Open;

    gbEditClients := TGroupBox.Create(Self);
    gbEditClients.Caption := ' Настройка печати ';
    gbEditClients.Parent := Self;

    lClientId := TLabel.Create(Self);
    lClientId.Caption := 'ClientId:';
    lClientId.Parent := gbEditClients;
    lClientId.Top := 16;
    lClientId.Left := 10;

    gbEditClients.Width := lClientId.Canvas.TextWidth('Включать входную НДС в расчет розничной надбавки для ЖНВЛС при ЕНВД') + 60;
    gbEditClients.Constraints.MinWidth := gbEditClients.Width;

    dblClientId := TDBLookupComboBox.Create(Self);
    dblClientId.Parent := gbEditClients;
    dblClientId.Anchors := [akLeft, akTop, akRight];
    dblClientId.Top := lClientId.Top + 3 + lClientId.Canvas.TextHeight(lClientId.Caption);
    dblClientId.Left := lClientId.Left;
    dblClientId.Width := gbEditClients.Width - 20;
    dblClientId.DataField := 'ClientId';
    dblClientId.KeyField := 'ClientId';
    dblClientId.ListField := 'Name';
    dblClientId.ListSource := dsEditClients;
    dblClientId.KeyValue := adsEditClients.FieldByName('ClientId').Value;

    nextTop := dblClientId.Top + dblClientId.Height + 7;

    if DM.adsUser.FieldByName('IsFutureClient').AsBoolean then
      lClientId.Caption := 'Адрес заказа:'
    else begin
      lClientId.Caption := 'Клиент:';
    end;

    AddLabelAndDBEdit(gbEditClients, dsEditClients, nextTop, lEditName, dbeEditName, 'Наименование:', 'EditName');
    AddLabelAndDBEdit(gbEditClients, dsEditClients, nextTop, lAddress, dbeAddress, 'Адрес:', 'Address');
    AddLabelAndDBEdit(gbEditClients, dsEditClients, nextTop, lDirector, dbeDirector, 'Заведующая:', 'Director');
    AddLabelAndDBEdit(gbEditClients, dsEditClients, nextTop, lDeputyDirector, dbeDeputyDirector, 'Зам. заведующей:', 'DeputyDirector');
    AddLabelAndDBEdit(gbEditClients, dsEditClients, nextTop, lAccountant, dbeAccountant, 'Бухгалтер:', 'Accountant');

    lMethodOfTaxation := TLabel.Create(Self);
    lMethodOfTaxation.Caption := 'Способ налогообложения:';
    lMethodOfTaxation.Parent := gbEditClients;
    lMethodOfTaxation.Top := nextTop;
    lMethodOfTaxation.Left := 10;

    dblMethodOfTaxation := TDBLookupComboBox.Create(Self);
    dblMethodOfTaxation.Parent := gbEditClients;
    dblMethodOfTaxation.Anchors := [akLeft, akTop, akRight];
    dblMethodOfTaxation.Top := lMethodOfTaxation.Top + 3 + lMethodOfTaxation.Canvas.TextHeight(lMethodOfTaxation.Caption);
    dblMethodOfTaxation.Left := lMethodOfTaxation.Left;
    dblMethodOfTaxation.Width := gbEditClients.Width - 20;
    dblMethodOfTaxation.DataField := 'MethodOfTaxation';
    dblMethodOfTaxation.KeyField := 'MethodOfTaxation';
    dblMethodOfTaxation.ListField := 'Method';
    dblMethodOfTaxation.ListSource := dsMethods;
    dblMethodOfTaxation.DataSource := dsEditClients;


    dbchbCalculateWithNDS := TDBCheckBox.Create(Self);
    dbchbCalculateWithNDS.Parent := gbEditClients;
    dbchbCalculateWithNDS.Anchors := [akLeft, akTop, akRight];
    dbchbCalculateWithNDS.Top := dblMethodOfTaxation.Top + dblMethodOfTaxation.Height + 10;
    dbchbCalculateWithNDS.Left := lMethodOfTaxation.Left;
    dbchbCalculateWithNDS.Width := gbEditClients.Width - 20;
    dbchbCalculateWithNDS.Caption := 'Включать входную НДС в расчет розничной надбавки для ЖНВЛС при ЕНВД';
    dbchbCalculateWithNDS.DataField := 'CalculateWithNDS';
    dbchbCalculateWithNDS.DataSource := dsEditClients;

    dbchbCalculateWithNDSForOther := TDBCheckBox.Create(Self);
    dbchbCalculateWithNDSForOther.Parent := gbEditClients;
    dbchbCalculateWithNDSForOther.Anchors := [akLeft, akTop, akRight];
    dbchbCalculateWithNDSForOther.Top := dbchbCalculateWithNDS.Top + dbchbCalculateWithNDS.Height + 10;
    dbchbCalculateWithNDSForOther.Left := dbchbCalculateWithNDS.Left;
    dbchbCalculateWithNDSForOther.Width := gbEditClients.Width - 20;
    dbchbCalculateWithNDSForOther.Caption := 'Включать входную НДС в расчет розничной надбавки для НеЖНВЛС при ЕНВД';
    dbchbCalculateWithNDSForOther.DataField := 'CalculateWithNDSForOther';
    dbchbCalculateWithNDSForOther.DataSource := dsEditClients;


    if GetNetworkSettings().IsNetworkVersion then begin
      nextTop := dbchbCalculateWithNDSForOther.Top + dbchbCalculateWithNDSForOther.Height + 10;
      AddLabelAndDBEdit(gbEditClients, dsEditClients, nextTop, lSelfAddressId, dbeSelfAddressId, 'Собственный код аптеки:', 'SelfAddressId');
      dbeSelfAddressId.ReadOnly := True;
      dbeSelfAddressId.Color := clBtnFace;
      gbEditClients.Height := dbeSelfAddressId.Top + dbeSelfAddressId.Height + 7;
    end
    else
      gbEditClients.Height := dbchbCalculateWithNDSForOther.Top + dbchbCalculateWithNDSForOther.Height + 7;

    gbEditClients.Constraints.MinHeight := gbEditClients.Height;
    gbEditClients.Align := alClient;
    Self.Constraints.MinHeight := Self.Height;
    Self.Constraints.MinWidth := Self.Width;
  end;
end;

procedure TframeEditAddress.AddLabelAndDBEdit(Parents: TWinControl;
  DataSource: TDataSource; var nextTop: Integer; var labelInfo: TLabel;
  var dbedit: TDBEdit; LabelCaption, DataField: String);
begin
  labelInfo := TLabel.Create(Self);
  labelInfo.Caption := LabelCaption;
  labelInfo.Parent := Parents;
  labelInfo.Top := nextTop;
  labelInfo.Left := 10;

  dbedit := TDBEdit.Create(Self);
  dbedit.Parent := Parents;
  dbedit.Anchors := [akLeft, akTop, akRight];
  dbedit.Top := labelInfo.Top + 3 + labelInfo.Canvas.TextHeight(labelInfo.Caption);
  dbedit.Left := 10;
  dbedit.DataSource := DataSource;
  dbedit.DataField := DataField;
  dbedit.Width := Parents.Width - 20;

  nextTop := dbedit.Top + dbedit.Height + 7;
end;

procedure TframeEditAddress.AddNonVisualComponents;
var
  field : TField;
begin
  adsMethods := TRxMemoryData.Create(Self);
  field := TSmallintField.Create(adsMethods);
  field.fieldname := 'MethodOfTaxation';
  field.Dataset := adsMethods;
  field := TStringField.Create(adsMethods);
  field.fieldname := 'Method';
  field.Dataset := adsMethods;

  adsMethods.Open;
  adsMethods.AppendRecord([0, 'ЕНВД']);
  adsMethods.AppendRecord([1, 'НДС']);

  dsMethods := TDataSource.Create(Self);
  dsMethods.DataSet := adsMethods;
end;

procedure TframeEditAddress.CancelChanges;
begin
  if adsEditClients.Active then
    adsEditClients.CancelUpdates;
end;

constructor TframeEditAddress.Create(AOwner: TComponent);
begin
  inherited;

  AddNonVisualComponents;
  
  AddComponents;

  gbEditClients.ControlStyle := gbEditClients.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframeEditAddress.SaveChanges;
begin
  if adsEditClients.Active then begin
    SoftPost(adsEditClients);
    adsEditClients.ApplyUpdates;
    DatabaseController.BackupDataTable(doiClientSettings);
  end;
end;

end.
