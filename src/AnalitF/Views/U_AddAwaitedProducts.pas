unit U_AddAwaitedProducts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_VistaCorrectForm, StdCtrls, DB, MemDS, DBAccess, MyAccess,
  ExtCtrls;

type
  TAddAwaitedProducts = class(TVistaCorrectForm)
    gbAdd: TGroupBox;
    Label1: TLabel;
    cbCatalogs: TComboBox;
    Label2: TLabel;
    cbProducers: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    adsCatalogs: TMyQuery;
    tmrUpdateCatalog: TTimer;
    adsProducers: TMyQuery;
    tmrUpdateProducers: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrUpdateCatalogTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cbCatalogsKeyPress(Sender: TObject; var Key: Char);
    procedure tmrUpdateProducersTimer(Sender: TObject);
    procedure cbProducersKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    function CheckExistsAwaitedProduct() : String;
  public
    { Public declarations }
    SelectedCatalogId : Variant;
    SelectedProducerId : Variant;
    function GetCatalogId() : Variant;
    function GetProducerId() : Variant;
  end;

var
  AddAwaitedProducts: TAddAwaitedProducts;

implementation

uses
  DModule,
  AProc,
  DBProc;

{$R *.dfm}

procedure TAddAwaitedProducts.FormCreate(Sender: TObject);
begin
  inherited;
  cbCatalogs.Clear;
  adsCatalogs.Connection := DM.MainConnection;
  adsProducers.Connection := DM.MainConnection;
end;

procedure TAddAwaitedProducts.tmrUpdateCatalogTimer(Sender: TObject);
begin
  tmrUpdateCatalog.Enabled := False;
  adsCatalogs.Close;
  adsCatalogs.ParamByName('LikeParam').Value := '%' + cbCatalogs.Text + '%';
  adsCatalogs.Open;
  cbCatalogs.Clear;
  while not adsCatalogs.Eof do begin
    cbCatalogs.Items.Add(adsCatalogs.FieldByName('CatalogName').AsString);
    adsCatalogs.Next;
  end;
end;

procedure TAddAwaitedProducts.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  reason : String;
begin
  if (ModalResult = mrOK) and CanClose then begin
    SelectedCatalogId := GetCatalogId();
    SelectedProducerId := GetProducerId();
    if VarIsNull(SelectedCatalogId) then begin
      CanClose := False;
      cbCatalogs.SetFocus();
      AProc.MessageBox('Не выбрано наименование.', MB_ICONWARNING)
    end;
    if CanClose then begin
      reason := CheckExistsAwaitedProduct();
      if Length(reason) > 0 then begin
        CanClose := False;
        cbCatalogs.SetFocus;
        AProc.MessageBox(reason, MB_ICONWARNING)
      end;
    end;
  end;
end;

function TAddAwaitedProducts.GetCatalogId: Variant;
begin
  Result := Null;

  adsCatalogs.Close;
  adsCatalogs.ParamByName('LikeParam').Value := cbCatalogs.Text;
  adsCatalogs.Open;
  if not adsCatalogs.IsEmpty then
    Result := adsCatalogs.FieldByName('FullCode').AsVariant;
end;

procedure TAddAwaitedProducts.cbCatalogsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key > #32) and (Length(cbCatalogs.Text) > 2) then begin
    tmrUpdateCatalog.Enabled := False;
    tmrUpdateCatalog.Enabled := True;
  end;
end;

function TAddAwaitedProducts.GetProducerId: Variant;
begin
  Result := Null;

  adsProducers.Close;
  adsProducers.ParamByName('LikeParam').Value := cbProducers.Text;
  adsProducers.Open;
  if not adsProducers.IsEmpty then
    Result := adsProducers.FieldByName('Id').AsVariant;
end;

procedure TAddAwaitedProducts.tmrUpdateProducersTimer(Sender: TObject);
begin
  tmrUpdateProducers.Enabled := False;
  adsProducers.Close;
  adsProducers.ParamByName('LikeParam').Value := '%' + cbProducers.Text + '%';
  adsProducers.Open;
  cbProducers.Clear;
  cbProducers.Items.Add('Все производители');
  while not adsProducers.Eof do begin
    cbProducers.Items.Add(adsProducers.FieldByName('Name').AsString);
    adsProducers.Next;
  end;
end;

procedure TAddAwaitedProducts.cbProducersKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key > #32) and (Length(cbCatalogs.Text) > 2) then begin
    tmrUpdateProducers.Enabled := False;
    tmrUpdateProducers.Enabled := True;
  end;
end;

function TAddAwaitedProducts.CheckExistsAwaitedProduct: String;
var
  existsId : Variant;
begin
  Result := '';

  if VarIsNull(SelectedProducerId) then begin
    existsId := DBProc.QueryValue(
      DM.MainConnection,
      'select Id from awaitedproducts where CatalogId = :CatalogId',
      ['CatalogId'],
      [SelectedCatalogId]);
    if not VarIsNull(existsId) then
      Result := 'Выбранное наименование уже присутствует в списке ожидаемых позиций';
  end
  else begin
    existsId := DBProc.QueryValue(
      DM.MainConnection,
      'select Id from awaitedproducts where CatalogId = :CatalogId and ProducerId = :ProducerId',
      ['CatalogId', 'ProducerId'],
      [SelectedCatalogId, SelectedProducerId]);
    if not VarIsNull(existsId) then
      Result := 'Выбранная связка наименование и производитель уже присутствует в списке ожидаемых позиций'
    else begin
      existsId := DBProc.QueryValue(
        DM.MainConnection,
        'select Id from awaitedproducts where CatalogId = :CatalogId and ProducerId is null',
        ['CatalogId'],
        [SelectedCatalogId]);
      if not VarIsNull(existsId) then
        Result := 'Выбранная связка наименование и производитель не может быть добавлена, т.к. в списке ожидаемых позиций существует наименование без указания производителя'
    end;
  end;
end;

end.
