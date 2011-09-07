unit U_frameBlockPromotion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Math,
  U_SupplierPromotion,
  U_DBMapping,
  PromotionLabel;

type
  TframeBlockPromotion = class(TFrame)
  private
    { Private declarations }
    Promotion : TSupplierPromotion;

    pBorder : TPanel;

    lProviderLabel : TLabel;
    lPromotionLabel : TPromotionLabel;

    lPromotionName : TLabel;
    lAnnotation : TLabel;

    procedure CreateVisualComponent;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PrepareFrame;
    class function AddFrame(
      Owner: TComponent;
      Parent: TWinControl;
      Promotion : TSupplierPromotion) : TframeBlockPromotion;
  end;

implementation

{$R *.dfm}

{ TframeBlockPromotion }

class function TframeBlockPromotion.AddFrame(Owner: TComponent;
  Parent: TWinControl;
  Promotion: TSupplierPromotion): TframeBlockPromotion;
begin
  Result := TframeBlockPromotion.Create(Owner);
  Result.Parent := Parent;
  Result.Promotion := Promotion;
  Result.PrepareFrame;
end;

constructor TframeBlockPromotion.Create(AOwner: TComponent);
begin
  inherited;

  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframeBlockPromotion.CreateVisualComponent;
begin
  pBorder := TPanel.Create(Self);
  pBorder.Name := 'pBorder' + IntToStr(Promotion.Id);
  pBorder.Caption := '';
  pBorder.BevelInner := bvLowered;
  pBorder.BevelOuter := bvRaised;
  pBorder.Parent := Self;
  pBorder.Align := alClient;
  pBorder.ControlStyle := pBorder.ControlStyle - [csParentBackground] + [csOpaque];

  lProviderLabel := TLabel.Create(Self);
  lProviderLabel.Name := 'lProviderLabel' + IntToStr(Promotion.Id);
  lProviderLabel.Parent := pBorder;
  lProviderLabel.Font.Style := lProviderLabel.Font.Style + [fsBold];
  lProviderLabel.Caption := Promotion.SupplierShortName;
  lProviderLabel.Top := 5;
  lProviderLabel.Left := 10;

  lPromotionLabel := TPromotionLabel.Create(
    Self,
    Promotion.CatalogId,
    Promotion.Id,
    'lPromotionLabel',
    'Подробнее...',
    lProviderLabel.Left + lProviderLabel.Width + 10,
    5,
    pBorder);

  lPromotionName := TLabel.Create(Self);
  lPromotionName.Name := 'lPromotionName' + IntToStr(Promotion.Id);
  lPromotionName.Caption := Promotion.Name;
  lPromotionName.Parent := pBorder;
  lPromotionName.Top := 5;
  lPromotionName.Left := pBorder.Width - lPromotionName.Width - 10;
  lPromotionName.Anchors := [akTop, akRight];

  lAnnotation := TLabel.Create(Self);
  lAnnotation.Name := 'lAnnotation' + IntToStr(Promotion.Id);
  lAnnotation.Caption := Promotion.Annotation;
  lAnnotation.Parent := pBorder;
  lAnnotation.Left := 10;
  lAnnotation.Top := Max(
    lPromotionLabel.Top + lPromotionLabel.Height + 5,
    lPromotionName.Top + lPromotionName.Height + 5);

  pBorder.Constraints.MinHeight := lAnnotation.Top + lAnnotation.Height + 5;
  pBorder.Constraints.MinWidth :=
    lProviderLabel.Left + lProviderLabel.Width + 10
    + lPromotionLabel.Width + 10 + lPromotionName.Width + 10;
  Self.Height := pBorder.Constraints.MinHeight;
  Self.Tag := Max(pBorder.Constraints.MinWidth, lAnnotation.Left + lAnnotation.Width + 10);

  if Length(Promotion.PromoFile) = 0 then
    lPromotionLabel.Visible := False;
end;

destructor TframeBlockPromotion.Destroy;
begin
  if Assigned(Promotion) then
    Promotion.Free;
  inherited;
end;

procedure TframeBlockPromotion.PrepareFrame;
begin
  Self.Name := 'frameBlockPromotion' + IntToStr(Promotion.Id);

  CreateVisualComponent;
end;

end.
