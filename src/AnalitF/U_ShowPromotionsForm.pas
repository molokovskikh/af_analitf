unit U_ShowPromotionsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Contnrs,
  Dialogs,
  StdCtrls,
  ComCtrls,
  ExtCtrls,
  Jpeg,
  SHDocVw,
  MyAccess,
  AProc,
  DModule,
  U_VistaCorrectForm;

type
  TSupplierPromotion = class
   protected
    function PromotionFileExists(fileExt : String) : Boolean;
   public
    PromotionId : Int64;
    SupplierShortName : String;
    Annotation : String;
    Sheet : TTabSheet;

    constructor Create(
      APromotionId : Int64;
      ASupplierShortName : String;
      AAnnotation : String);

    function PromotionFileName(fileExt : String) : String;
    function HtmlExists() : Boolean;
    function JpgExists() : Boolean;
    function TxtExists() : Boolean;
    function PromotionHtml() : String;
    function PromotionJpg() : String;
    function PromotionTxt() : String;
  end;


  TShowPromotionsForm = class(TVistaCorrectForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  protected
    FCatalogId : Int64;
    FPromotionId : Int64;
    FSelectedPromotion : TSupplierPromotion;

    FPromotionList : TObjectList;
  public
    { Public declarations }
    pcPromotions : TPageControl;

    procedure Prepare(catalogId : Int64; promotionId : Int64);
    function CreatePromotion(query : TMyQuery) : TSupplierPromotion;
  end;

  procedure ShowPromotions(catalogId : Int64); overload;
  procedure ShowPromotions(catalogId : Int64; promotionId : Int64); overload;

implementation

{$R *.dfm}

procedure ShowPromotions(catalogId : Int64);
begin
  ShowPromotions(catalogId, 0);
end;

procedure ShowPromotions(catalogId : Int64; promotionId : Int64);
var
  ShowPromotionsForm: TShowPromotionsForm;
begin
  ShowPromotionsForm := TShowPromotionsForm.Create(Application);
  try
    ShowPromotionsForm.Width := (Application.MainForm.Width div 3) * 2;
    ShowPromotionsForm.Height := (Application.MainForm.Height div 3) * 2;

    ShowPromotionsForm.Prepare(catalogId, promotionId);
    ShowPromotionsForm.ShowModal;
  finally
    ShowPromotionsForm.Free;
  end;
end;


{ TShowPromotionsForm }

procedure TShowPromotionsForm.Prepare(catalogId: Int64; promotionId : Int64);
var
  currentPromotion : TSupplierPromotion;
begin
  FPromotionList := TObjectList.Create(True);
  FCatalogId := catalogId;
  FPromotionId := promotionId;
  FSelectedPromotion := nil;

  pcPromotions := TPageControl.Create(Self);
  pcPromotions.Align := alClient;
  pcPromotions.Parent := Self;
  Self.Caption := 'Акции по препарату';

  DM.adsQueryValue.Close;
  DM.adsQueryValue.SQL.Text := '' +
' select ' +
'   concat(Catalogs.Name, '' '', Catalogs.Form) as FullName, ' +
'   SupplierPromotions.Id, ' +
'   SupplierPromotions.Annotation, ' +
'   Providers.ShortName ' +
' from ' +
'  Catalogs ' +
'  join PromotionCatalogs on PromotionCatalogs.CatalogId = Catalogs.FullCode ' +
'  join SupplierPromotions on SupplierPromotions.Id = PromotionCatalogs.PromotionId ' +
'  join Providers on Providers.FirmCode = SupplierPromotions.SupplierId ' +
' where ' +
'  Catalogs.FullCode = :CatalogId ' +
' order by Providers.ShortName';

  DM.adsQueryValue.ParamByName('CatalogId').Value := catalogId;
  DM.adsQueryValue.Open;
  try
    Self.Caption := 'Акции по препарату ' + DM.adsQueryValue.FieldByName('FullName').AsString;
    while not DM.adsQueryValue.Eof do begin
      currentPromotion := CreatePromotion(DM.adsQueryValue);

      if currentPromotion.PromotionId = promotionId then
        FSelectedPromotion := currentPromotion;

      DM.adsQueryValue.Next;
    end;
  finally
    DM.adsQueryValue.Close;
  end;

  if Assigned(FSelectedPromotion) then
    pcPromotions.ActivePage := FSelectedPromotion.Sheet
  else
    pcPromotions.ActivePageIndex := 0;
end;

procedure TShowPromotionsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

function TShowPromotionsForm.CreatePromotion(
  query: TMyQuery): TSupplierPromotion;
var
  gbDesc : TGroupBox;
  lDesc : TLabel;
  mCurrent : TMemo;

  iImage : TImage;
  jpg: TJpegImage;

  pWebBrowser : TPanel;
  iWebBrowser : TWebBrowser;
begin
  Result := TSupplierPromotion.Create(
    query.FieldByName('Id').AsInteger,
    query.FieldByName('ShortName').AsString,
    query.FieldByName('Annotation').AsString);
  FPromotionList.Add(Result);

  Result.Sheet := TTabSheet.Create(Self);
  Result.Sheet.PageControl := pcPromotions;
  Result.Sheet.Caption := Result.SupplierShortName;

  gbDesc := TGroupBox.Create(Self);
  gbDesc.Parent := Result.Sheet;
  gbDesc.Caption := ' Описание ';
  gbDesc.Align := alTop;

  lDesc := TLabel.Create(Self);
  lDesc.Parent := gbDesc;
  lDesc.Left := 10;
  lDesc.Top := 15;
  lDesc.Caption := Result.Annotation;

  gbDesc.Height := 2*lDesc.Top + lDesc.Height;

  if Result.HtmlExists() then begin
    pWebBrowser := TPanel.Create(Self);
    pWebBrowser.Name := 'pWebBrowser' + IntToStr(Result.PromotionId);
    pWebBrowser.Caption := '';
    pWebBrowser.Align := alClient;
    pWebBrowser.BevelOuter := bvNone;
    pWebBrowser.Parent := Result.Sheet;

    iWebBrowser := TWebBrowser.Create(Self);
    TWinControl(iWebBrowser).Name := 'iWebBrowser' + IntToStr(Result.PromotionId);
    TWinControl(iWebBrowser).Parent := pWebBrowser;
    TWinControl(iWebBrowser).Align := alClient;

    iWebBrowser.Navigate(Result.PromotionHtml());
  end
  else
    if Result.JpgExists() then begin
      iImage := TImage.Create(Self);
      iImage.Parent := Result.Sheet;
      iImage.Align := alClient;
      iImage.AutoSize := False;
      iImage.Center := True;
      iImage.Proportional := True;
      jpg := TJpegImage.Create;
      try
        jpg.LoadFromFile(Result.PromotionJpg());
        iImage.Picture.Bitmap.Assign(jpg);
      finally
        jpg.Free;
      end;
    end
    else
      if Result.TxtExists() then begin
        mCurrent := TMemo.Create(Self);
        mCurrent.Parent := Result.Sheet;
        mCurrent.ReadOnly := True;
        mCurrent.Align := alClient;
        mCurrent.Lines.LoadFromFile(Result.PromotionTxt());
      end;
end;

{ TSupplierPromotion }

constructor TSupplierPromotion.Create(APromotionId: Int64;
  ASupplierShortName, AAnnotation: String);
begin
  PromotionId := APromotionId;
  SupplierShortName := ASupplierShortName;
  Annotation := AAnnotation;
end;

function TSupplierPromotion.HtmlExists: Boolean;
begin
  Result := PromotionFileExists('.htm') or PromotionFileExists('.html');
end;

function TSupplierPromotion.JpgExists: Boolean;
begin
  Result := PromotionFileExists('.jpg') or PromotionFileExists('.jpeg');
end;

function TSupplierPromotion.PromotionFileExists(fileExt: String): Boolean;
begin
  Result := FileExists(PromotionFileName(fileExt));
end;

function TSupplierPromotion.PromotionFileName(fileExt: String): String;
begin
  Result := RootFolder() + SDirPromotions + '\' + IntToStr(PromotionId) + fileExt;
end;

function TSupplierPromotion.PromotionHtml: String;
begin
  if PromotionFileExists('.htm') then
    Result := PromotionFileName('.htm')
  else
    Result := PromotionFileName('.html');
end;

function TSupplierPromotion.PromotionJpg: String;
begin
  if PromotionFileExists('.jpg') then
    Result := PromotionFileName('.jpg')
  else
    Result := PromotionFileName('.jpeg');
end;

function TSupplierPromotion.PromotionTxt: String;
begin
  Result := PromotionFileName('.txt');
end;

function TSupplierPromotion.TxtExists: Boolean;
begin
  Result := PromotionFileExists('.txt');
end;

procedure TShowPromotionsForm.FormDestroy(Sender: TObject);
begin
  inherited;
  FPromotionList.Free;
end;

end.
