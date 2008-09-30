unit ClientsData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, StdCtrls, DBCtrls, Grids, DBGrids, RXDBCtrl, ADBGrid,
  ActnList, DB, ADODB, Buttons;

type
  TClientsDataForm = class(TChildForm)
    dbgFirms: TADBGrid;
    dbtFullName: TDBText;
    dbtPhones: TDBText;
    dbtEMail: TDBText;
    Label2: TLabel;
    Label1: TLabel;
    dbmAddInfo: TDBMemo;
    dbmComments: TDBMemo;
    cbOnlyLeaders: TCheckBox;
    Label93: TLabel;
    ActionList: TActionList;
    actOnlyLeaders: TAction;
    adsClientsData: TADODataSet;
    dsFirms: TDataSource;
    dbtMinOrder: TDBText;
    adsClientsDataFullName: TWideStringField;
    btnOrder: TSpeedButton;
    cbCurrentOrders: TCheckBox;
    actCurrentOrders: TAction;
    adsClientsDataPositions: TIntegerField;
    adsClientsDataShortName: TWideStringField;
    adsClientsDataStorage: TBooleanField;
    adsClientsDataAdminMail: TWideStringField;
    adsClientsDataSupportPhone: TWideStringField;
    adsClientsDataContactInfo: TMemoField;
    adsClientsDataOperativeInfo: TMemoField;
    adsPrices: TADODataSet;
    dsPrices: TDataSource;
    dbgPrices: TADBGrid;
    adsClientsDataAFirmCode: TIntegerField;
    adsClientsDataEnabled: TBooleanField;
    dbtDatePrice: TDBText;
    Label3: TLabel;
    adsClientsDataForcount: TSmallintField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actOnlyLeadersExecute(Sender: TObject);
    procedure dbgFirmsGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure btnOrderClick(Sender: TObject);
    procedure actCurrentOrdersExecute(Sender: TObject);
    procedure dbtEMailClick(Sender: TObject);
    procedure dbgPricesCanFocusNext(Sender: TObject; Next: Boolean;
      var CanFocus: Boolean);
  private
    procedure SetFirmsFilter;
    procedure GetLastFirm;
    procedure SetLastFirm;
  public
    procedure ShowForm; override;
  end;

var
  ClientsDataForm: TClientsDataForm;

procedure ShowOrderFirm(Current: Boolean=False);

implementation

uses Main, DModule, AProc, DBProc, CoreFirm, Order;

{$R *.dfm}

var
  LastFirmCode: Integer;

procedure ShowOrderFirm(Current: Boolean=False);
begin
  ClientsDataForm:=TClientsDataForm(MainForm.ShowChildForm(TClientsDataForm));
  if Current then with ClientsDataForm do begin
    actCurrentOrders.Checked:=True;
    SetFirmsFilter;
  end;
end;

procedure TClientsDataForm.FormCreate(Sender: TObject);
begin
  inherited;
  CoreFirmForm:=TCoreFirmForm.Create(Application);
  actOnlyLeaders.Checked:=DM.adtUsers.FieldByName('OnlyLeaders').AsBoolean;
  SetFirmsFilter;
  ShowForm;
end;

procedure TClientsDataForm.FormDestroy(Sender: TObject);
begin
  inherited;
  with DM.adtUsers do begin
    Edit;
    FieldByName('OnlyLeaders').AsBoolean:=actOnlyLeaders.Checked;
    Post;
  end;
  SoftPost(adsClientsData);
  GetLastFirm;
end;

procedure TClientsDataForm.ShowForm;
begin
  //открываем список фирм
  with adsClientsData do begin
    Parameters.ParamByName('AClientId').Value:=DM.adtClients.FieldByName('ClientId').Value;
    Screen.Cursor:=crHourglass;
    try
      if Active then begin
        GetLastFirm;
        Requery;
      end
      else
        Open;
      SetLastFirm;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
  //открываем список прайс-листов - регионов
  with adsPrices do begin
    Parameters.ParamByName('TimeZoneBias').Value:=TimeZoneBias;
    Open;
  end;
  inherited;
end;

procedure TClientsDataForm.GetLastFirm;
begin
  LastFirmCode:=adsClientsDataAFirmCode.AsInteger;
end;

procedure TClientsDataForm.SetLastFirm;
begin
  with adsClientsData do
    if not IsEmpty then Locate('AFirmCode',LastFirmCode,[]);
end;

procedure TClientsDataForm.SetFirmsFilter;
begin
  if actCurrentOrders.Checked then
    SetFilter(adsClientsData,'Positions > 0')
  else
    SetFilter(adsClientsData,'')
end;

procedure TClientsDataForm.dbgFirmsGetCellParams(Sender: TObject; Field: TField;
  AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  if not adsClientsDataEnabled.AsBoolean and
    (Field=adsClientsDataShortName) then BackGround:=clBtnFace;
end;

procedure TClientsDataForm.actCurrentOrdersExecute(Sender: TObject);
begin
  actCurrentOrders.Checked:=not actCurrentOrders.Checked;
  SetFirmsFilter;
  dbgFirms.SetFocus;
end;

procedure TClientsDataForm.actOnlyLeadersExecute(Sender: TObject);
begin
  actOnlyLeaders.Checked:=not actOnlyLeaders.Checked;
  dbgFirms.SetFocus;
end;

procedure TClientsDataForm.dbtEMailClick(Sender: TObject);
begin
  MailTo(dbtEMail.Field.AsString,'');
end;

procedure TClientsDataForm.btnOrderClick(Sender: TObject);
begin
  if adsClientsDataAFirmCode.AsInteger<>RegisterId then
    ShowOrder(0,DM.adtClients.FieldByName('ClientId').AsInteger,
      adsPrices.FieldByName('PriceCode').AsInteger,
      adsPrices.FieldByName('RegionCode').AsInteger);
end;

procedure TClientsDataForm.dbgPricesCanFocusNext(Sender: TObject;
  Next: Boolean; var CanFocus: Boolean);
begin
  if Next then
    if adsClientsDataAFirmCode.AsInteger=RegisterId then
      MainForm.actRegistry.Execute
    else
      CoreFirmForm.ShowForm(adsPrices.FieldByName('PriceCode').AsInteger,
        adsPrices.FieldByName('RegionCode').AsInteger, actOnlyLeaders.Checked);
end;

end.
