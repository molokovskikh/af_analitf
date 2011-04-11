unit U_ShowPromotionsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Contnrs,
  Dialogs,
  Printers,
  StdCtrls,
  Buttons,
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
  TImageEx = class(TImage)
  end;

  TDisplayedPromotion = class
   public
    Promotion : TSupplierPromotion;
    PromoBox : TPanel;

    constructor Create(promotion : TSupplierPromotion);
    destructor Destroy; override;

    function PromotionId() : Int64;
  end;

  TImageHandler = class(TComponent)
   public
    Canvas : TCanvas;
    PrintDialog : TPrintDialog;
    sbPrint : TSpeedButton;
    iImage : TImage;
    constructor Create(
      AOwner : TComponent;
      Parent : TPanel;
      print : TSpeedButton;
      image : TImage);  reintroduce; overload;
    destructor Destroy; override;
    procedure PrintClick(Sender : TObject);
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
  public
    { Public declarations }
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
  pImage : TPanel;
  pHeaderImage : TPanel;
  sbPrint : TSpeedButton;
  handler : TImageHandler;
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
        pImage := TPanel.Create(Owner);
        pImage.Name := 'pImage';
        pImage.Caption := '';
        pImage.BevelOuter := bvNone;
        pImage.Align := alClient;
        pImage.ControlStyle := pImage.ControlStyle - [csParentBackground] + [csOpaque];
        pImage.Parent := Parent;

        pHeaderImage := TPanel.Create(pImage);
        pHeaderImage.Name := 'pHeaderImage';
        pHeaderImage.Caption := '';
        pHeaderImage.BevelOuter := bvNone;
        pHeaderImage.Align := alTop;
        pHeaderImage.ControlStyle := pHeaderImage.ControlStyle - [csParentBackground] + [csOpaque];
        pHeaderImage.Parent := pImage;

        sbPrint := TSpeedButton.Create(pImage);
        sbPrint.Parent := pHeaderImage;
        sbPrint.Caption := 'Печатать';
        sbPrint.Height := 25;
        sbPrint.Left := 5;
        sbPrint.Top := 5;

        pHeaderImage.Height := sbPrint.Height + 2*sbPrint.Top;

        iImage := TImage.Create(pImage);
        iImage.Name := 'iImage' + IntToStr(promotion.Id);
        iImage.Parent := pImage;
        iImage.Align := alClient;
        iImage.AutoSize := False;
        iImage.Center := True;
        iImage.Proportional := True;
        jpg := TJpegImage.Create;
        try
          jpg.LoadFromFile(osPromoFile);
          iImage.Picture.Bitmap.Assign(jpg);
        finally
          jpg.Free;
        end;

        handler := TImageHandler.Create(pImage, pImage, sbPrint, iImage);

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
  list : TObjectList;
begin
  FCatalogId := catalogId;
  FPromotionId := promotionId;
  FSelectedPromotion := nil;

  Self.Caption := 'Акция ';

  list := TDBMapping.GetPromotionsById(DM.MainConnection, promotionId);
  list.OwnsObjects := False;
  try
    if list.Count > 0 then begin
      FSelectedPromotion := CreatePromotion(TSupplierPromotion(list[0]));
      Self.Caption := Self.Caption
        + FSelectedPromotion.Promotion.SupplierShortName
        + ': ' + FSelectedPromotion.Promotion.Name;
    end;
  finally
    list.Free;
  end;
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

  Result.PromoBox := TPanel.Create(Self);
  Result.PromoBox.Name := 'PromoBox';
  Result.PromoBox.Parent := Self;
  Result.PromoBox.Caption := '';
  Result.PromoBox.Align := alClient;
  Result.PromoBox.ControlStyle := Result.PromoBox.ControlStyle - [csParentBackground] + [csOpaque];

  gbDesc := TGroupBox.Create(Self);
  gbDesc.Parent := Result.PromoBox;
  gbDesc.Caption := ' Описание ';
  gbDesc.Align := alBottom;

  lDesc := TLabel.Create(Self);
  lDesc.Parent := gbDesc;
  lDesc.Left := 10;
  lDesc.Top := 15;
  lDesc.Caption := promotion.Annotation;

  gbDesc.Height := 2*lDesc.Top + lDesc.Height;

  promoControl := GetPromoInfoControl(promotion, Self, Result.PromoBox);
end;

{ TDisplayedPromotion }

constructor TDisplayedPromotion.Create(promotion : TSupplierPromotion);
begin
  Self.Promotion := promotion;
end;

destructor TDisplayedPromotion.Destroy;
begin
  if Assigned(Promotion) then
    Promotion.Free;
  inherited;
end;

function TDisplayedPromotion.PromotionId: Int64;
begin
  Result := Promotion.Id;
end;

procedure TShowPromotionsForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FSelectedPromotion) then
    FSelectedPromotion.Free;
  inherited;
end;

{ TImageHandler }

constructor TImageHandler.Create(AOwner: TComponent; Parent: TPanel;
  print: TSpeedButton; image : TImage);
begin
  inherited Create(AOwner);
  Canvas := TControlCanvas.Create;
  TControlCanvas(Canvas).Control := Parent;
  PrintDialog := TPrintDialog.Create(AOwner);
  sbPrint := print;
  sbPrint.Width := Canvas.TextWidth(sbPrint.Caption) + 20;
  sbPrint.OnClick := PrintClick;
  iImage := image;
end;

destructor TImageHandler.Destroy;
begin
  if Assigned(Canvas) then
    Canvas.Free;
  inherited;
end;

procedure TImageHandler.PrintClick(Sender: TObject);
var
  printImage : TImageEx;
begin
  if Assigned(PrintDialog) and PrintDialog.Execute then begin
    printImage := TImageEx.Create(Self);
    try
      printImage.AutoSize := False;
      printImage.Proportional := True;
      printImage.Picture := iImage.Picture;
      printImage.Width := Printer.PageWidth;
      printImage.Height := Printer.PageHeight;

      Printer.BeginDoc;  // **
      try
        Printer.Canvas.StretchDraw(printImage.DestRect, iImage.Picture.Bitmap);  // **
      finally
        Printer.EndDoc;  // **
      end;
    finally
      printImage.Free;
    end;
  end;
end;

end.
