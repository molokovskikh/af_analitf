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
    procedure cbCatalogsCloseUp(Sender: TObject);
  private
    { Private declarations }
    function CheckExistsAwaitedProduct() : String;
    function InternalFind(cobmoBox : TComboBox; findText : String) : Boolean;
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
  Constant,
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
var
  findText : String;
begin
  findText := cbCatalogs.Text;
  tmrUpdateCatalog.Enabled := False;
  if (not InternalFind(cbCatalogs, findText)) and (Length(cbCatalogs.Text) > 2) then begin
    adsCatalogs.Close;
    adsCatalogs.ParamByName('LikeParamFirst').Value := cbCatalogs.Text + '%';
    adsCatalogs.ParamByName('LikeParam').Value := '%' + cbCatalogs.Text + '%';
    adsCatalogs.Open;
    cbCatalogs.Clear;
    while not adsCatalogs.Eof do begin
      cbCatalogs.Items.Add(adsCatalogs.FieldByName('CatalogName').AsString);
      adsCatalogs.Next;
    end;
    cbCatalogs.Text := findText;
    cbCatalogs.SelStart := Length(cbCatalogs.Text);
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
      AProc.MessageBox('�� ������� ������������.', MB_ICONWARNING)
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
  adsCatalogs.ParamByName('LikeParamFirst').Value := cbCatalogs.Text;
  adsCatalogs.ParamByName('LikeParam').Value := cbCatalogs.Text;
  adsCatalogs.Open;
  if not adsCatalogs.IsEmpty then
    Result := adsCatalogs.FieldByName('FullCode').AsVariant;
end;

procedure TAddAwaitedProducts.cbCatalogsKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Length(cbCatalogs.Text) > 1) then begin
    tmrUpdateCatalog.Enabled := False;
    tmrUpdateCatalog.Enabled := True;
  end;
end;

function TAddAwaitedProducts.GetProducerId: Variant;
begin
  Result := Null;

  adsProducers.Close;
  adsProducers.ParamByName('LikeParamFirst').Value := cbProducers.Text;
  adsProducers.ParamByName('LikeParam').Value := cbProducers.Text;
  adsProducers.Open;
  if not adsProducers.IsEmpty then
    Result := adsProducers.FieldByName('Id').AsVariant;
end;

procedure TAddAwaitedProducts.tmrUpdateProducersTimer(Sender: TObject);
var
  findText : String;
begin
  findText := cbProducers.Text;
  tmrUpdateProducers.Enabled := False;

  if (not InternalFind(cbProducers, findText)) and (Length(cbProducers.Text) > 2) then begin
    adsProducers.Close;
    adsProducers.ParamByName('LikeParamFirst').Value := cbProducers.Text + '%';
    adsProducers.ParamByName('LikeParam').Value := '%' + cbProducers.Text + '%';
    adsProducers.Open;
    cbProducers.Clear;
    cbProducers.Items.Add('��� �������������');
    while not adsProducers.Eof do begin
      cbProducers.Items.Add(adsProducers.FieldByName('Name').AsString);
      adsProducers.Next;
    end;

    cbProducers.Text := findText;
    cbProducers.SelStart := Length(cbProducers.Text);
  end;
end;

procedure TAddAwaitedProducts.cbProducersKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Length(cbProducers.Text) > 1) then begin
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
      Result := SelectedProductInAwaitedList;
  end
  else begin
    existsId := DBProc.QueryValue(
      DM.MainConnection,
      'select Id from awaitedproducts where CatalogId = :CatalogId and ProducerId = :ProducerId',
      ['CatalogId', 'ProducerId'],
      [SelectedCatalogId, SelectedProducerId]);
    if not VarIsNull(existsId) then
      Result := '��������� ������ ������������ � ������������� ��� ������������ � ������ ��������� �������'
    else begin
      existsId := DBProc.QueryValue(
        DM.MainConnection,
        'select Id from awaitedproducts where CatalogId = :CatalogId and ProducerId is null',
        ['CatalogId'],
        [SelectedCatalogId]);
      if not VarIsNull(existsId) then
        Result := '��������� ������ ������������ � ������������� �� ����� ���� ���������, �.�. � ������ ��������� ������� ���������� ������������ ��� �������� �������������'
    end;
  end;
end;

procedure TAddAwaitedProducts.cbCatalogsCloseUp(Sender: TObject);
begin
  btnOk.SetFocus;
end;

function TAddAwaitedProducts.InternalFind(cobmoBox: TComboBox;
  findText: String): Boolean;
begin
  Result := (cobmoBox.ItemIndex > -1) and AnsiSameText(findText, cobmoBox.Items[cobmoBox.ItemIndex]);
end;

end.
