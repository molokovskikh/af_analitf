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
  VCLHelper,
  DModule,
  U_VistaCorrectForm,
  U_SupplierPromotion,
  U_DBMapping;

type
  TDisplayedPromotion = class
   public
    Promotion : TSupplierPromotion;
    Sheet : TTabSheet;

    constructor Create(promotion : TSupplierPromotion);

    function PromotionId() : Int64;
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
    FSelectedPromotion : TDisplayedPromotion;

    FPromotionList : TObjectList;
  public
    { Public declarations }
    pcPromotions : TPageControl;

    procedure Prepare(catalogId : Int64; promotionId : Int64);
    function CreatePromotion(promotion : TSupplierPromotion) : TDisplayedPromotion;
  end;

  procedure ShowPromotions(catalogId : Int64); overload;
  procedure ShowPromotions(catalogId : Int64; promotionId : Int64); overload;

  function GetPromoInfoControl(promotion : TSupplierPromotion; Owner : TComponent; Parent : TWinControl) : TControl;

implementation

{$R *.dfm}

function GetPromoInfoControl(promotion : TSupplierPromotion; Owner : TComponent; Parent : TWinControl) : TControl;
var
  osPromoFile : String;
  mCurrent : TMemo;

  iImage : TImage;
  jpg: TJpegImage;

  pWebBrowser : TPanel;
  iWebBrowser : TWebBrowser;
begin
  Result := nil;
  osPromoFile := RootFolder() + SDirPromotions + '\' + promotion.GetPromoFile();
  if (FileExists(osPromoFile)) then begin
    if promotion.HtmlExists() then begin
      pWebBrowser := TPanel.Create(Owner);
      pWebBrowser.Name := 'pWebBrowser' + IntToStr(promotion.Id);
      pWebBrowser.Caption := '';
      pWebBrowser.Align := alClient;
      pWebBrowser.BevelOuter := bvNone;
      pWebBrowser.Parent := Parent;

      iWebBrowser := TWebBrowser.Create(pWebBrowser);
      TWinControl(iWebBrowser).Name := 'iWebBrowser' + IntToStr(promotion.Id);
      TWinControl(iWebBrowser).Parent := pWebBrowser;
      TWinControl(iWebBrowser).Align := alClient;

      iWebBrowser.Navigate(osPromoFile);
      Result := pWebBrowser;
    end
    else
      if promotion.JpgExists() then begin
        iImage := TImage.Create(Owner);
        iImage.Name := 'iImage' + IntToStr(promotion.Id);
        iImage.Parent := Parent;
        iImage.Align := alClient;
        iImage.AutoSize := False;
        iImage.Center := True;
        iImage.Proportional := True;
        jpg := TJpegImage.Create;
        try
          jpg.LoadFromFile(osPromoFile);
          iImage.Constraints.MaxHeight := jpg.Height;
          iImage.Constraints.MaxWidth := jpg.Width;
          iImage.Picture.Bitmap.Assign(jpg);
        finally
          jpg.Free;
        end;
        Result := iImage;
      end
      else
        if promotion.TxtExists() then begin
          mCurrent := TMemo.Create(Owner);
          mCurrent.Name := 'mCurrent' + IntToStr(promotion.Id);
          mCurrent.Parent := Parent;
          mCurrent.ReadOnly := True;
          mCurrent.Align := alClient;
          mCurrent.Lines.LoadFromFile(osPromoFile);
          mCurrent.Constraints.MaxHeight := TVCLHelper.GetMemoNeedHeight(mCurrent);
          Result := mCurrent;
        end;
  end;
end;
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
  currentPromotion : TDisplayedPromotion;

  list : TObjectList;
  I : Integer;
  dbPromotion : TSupplierPromotion;
begin
  FPromotionList := TObjectList.Create(True);
  FCatalogId := catalogId;
  FPromotionId := promotionId;
  FSelectedPromotion := nil;

  pcPromotions := TPageControl.Create(Self);
  pcPromotions.Align := alClient;
  pcPromotions.Parent := Self;
  Self.Caption := 'Акции по препарату';

  list := TDBMapping.GetPromotionsByCatalogId(DM.MainConnection, catalogId);
  list.OwnsObjects := False;
  try
    if list.Count > 0 then begin
      Self.Caption := 'Акции по препарату ' + TSupplierPromotion(list[0]).CatalogFullName;

      for I := 0 to list.Count-1 do begin
        dbPromotion := TSupplierPromotion(list[i]);

        currentPromotion := CreatePromotion(dbPromotion);

        if currentPromotion.PromotionId = promotionId then
          FSelectedPromotion := currentPromotion;

      end;

    end;
  finally
    list.Free;
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
  promotion : TSupplierPromotion): TDisplayedPromotion;
var
  gbDesc : TGroupBox;
  lDesc : TLabel;

  promoControl : TControl;
begin
  Result := TDisplayedPromotion.Create(promotion);
  FPromotionList.Add(Result);

  Result.Sheet := TTabSheet.Create(Self);
  Result.Sheet.PageControl := pcPromotions;
  Result.Sheet.Caption := promotion.SupplierShortName;

  gbDesc := TGroupBox.Create(Self);
  gbDesc.Parent := Result.Sheet;
  gbDesc.Caption := ' Описание ';
  gbDesc.Align := alTop;

  lDesc := TLabel.Create(Self);
  lDesc.Parent := gbDesc;
  lDesc.Left := 10;
  lDesc.Top := 15;
  lDesc.Caption := promotion.Annotation;

  gbDesc.Height := 2*lDesc.Top + lDesc.Height;

  promoControl := GetPromoInfoControl(promotion, Self, Result.Sheet);
  if Assigned(promoControl) then begin
    promoControl.Constraints.MaxHeight := 0;
    promoControl.Constraints.MaxWidth := 0;
  end;
end;

{ TDisplayedPromotion }

constructor TDisplayedPromotion.Create(promotion : TSupplierPromotion);
begin
  Self.Promotion := promotion;
end;

function TDisplayedPromotion.PromotionId: Int64;
begin
  Result := Promotion.Id;
end;

procedure TShowPromotionsForm.FormDestroy(Sender: TObject);
begin
  inherited;
  FPromotionList.Free;
end;

end.
