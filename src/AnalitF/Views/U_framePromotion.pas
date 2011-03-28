unit U_framePromotion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  Contnrs,
  StdCtrls,
  DModule,
  U_SupplierPromotion,
  U_DBMapping,
  PromotionLabel;

type
  TframePromotion = class(TFrame)
  private
    { Private declarations }
    FSingleParent: TWinControl;
    FAdvertisingPanel: TWinControl;

    gbPromotions : TGroupBox;
    lPromotionInfo : TLabel;

    procedure CreateVisualComponent;
    procedure ClearFrame;
    procedure UpdateContorls(promoCatalogId, promoCount : Integer);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    class function AddFrame(
      Owner: TComponent;
      SingleParent: TWinControl;
      AdvertisingPanel: TWinControl) : TframePromotion;
    procedure SetAdvertisingPanel(AdvertisingPanel: TWinControl);
    procedure ShowPromotion(promoCatalogId, promoCount : Integer);
  end;

implementation

{$R *.dfm}

{ TframePromotion }

class function TframePromotion.AddFrame(Owner: TComponent; SingleParent,
  AdvertisingPanel: TWinControl): TframePromotion;
begin
  Result := TframePromotion.Create(Owner);
  Result.Visible := False;
  Result.Name := 'framePromotion';
  Result.FSingleParent := SingleParent;
  Result.FAdvertisingPanel := AdvertisingPanel;
  Result.Parent := Result.FAdvertisingPanel;
  Result.Align := alClient;
end;

procedure TframePromotion.ClearFrame;
var
  I : Integer;
begin
  for I := ComponentCount-1 downto 0 do
    if (Components[i] is TPromotionLabel)
      and (TPromotionLabel(Components[i]).Parent = gbPromotions)
    then begin
      TPromotionLabel(Components[i]).Visible := False;
      TPromotionLabel(Components[i]).Parent := nil;
      TPromotionLabel(Components[i]).Free;
    end;
end;

constructor TframePromotion.Create(AOwner: TComponent);
begin
  inherited;

  CreateVisualComponent;

  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframePromotion.CreateVisualComponent;
begin
  gbPromotions := TGroupBox.Create(Self);
  gbPromotions.Parent := Self;
  gbPromotions.Align := alClient;
  gbPromotions.Name := 'gbPromotions';
  gbPromotions.Caption := ' Акции поставщиков ';
  gbPromotions.ControlStyle := gbPromotions.ControlStyle - [csParentBackground] + [csOpaque];

  lPromotionInfo := TLabel.Create(Self);
  lPromotionInfo.Name := 'lPromotionInfo';
  lPromotionInfo.Parent := gbPromotions;
end;

procedure TframePromotion.SetAdvertisingPanel(
  AdvertisingPanel: TWinControl);
begin
  FAdvertisingPanel := AdvertisingPanel;
end;

procedure TframePromotion.ShowPromotion(promoCatalogId,
  promoCount: Integer);
begin
  ClearFrame;

  UpdateContorls(promoCatalogId, promoCount);

  Self.Visible := True;
  Self.BringToFront;
end;

procedure TframePromotion.UpdateContorls(promoCatalogId,
  promoCount: Integer);
const
  startLeft = 10;
  startTop = 20;
var
  I : Integer;

  lproviderInfo : TPromotionLabel;
  nextLeft : Integer;

  list : TObjectList;
  promotion : TSupplierPromotion;
begin
  list := TDBMapping.GetPromotionsByCatalogId(DM.MainConnection, promoCatalogId);

  try
    if promoCount = 1 then begin
      gbPromotions.Caption := ' Акция поставщика ';
      promotion := TSupplierPromotion(list[0]);

      lproviderInfo := TPromotionLabel.Create(
        Self,
        promoCatalogId,
        promotion.SupplierShortName,
        startLeft,
        startTop,
        gbPromotions);

      lPromotionInfo.Caption := promotion.Annotation;
      lPromotionInfo.Left := startLeft;
      lPromotionInfo.Top := lproviderInfo.Top + lproviderInfo.Height + 10;
      lPromotionInfo.Visible := True;
    end
    else begin
      gbPromotions.Caption := ' Акции поставщиков ';
      lPromotionInfo.Visible := False;

      promotion := TSupplierPromotion(list[0]);
      lproviderInfo := TPromotionLabel.Create(
        Self,
        promoCatalogId,
        promotion.Id,
        'lproviderInfo',
        promotion.SupplierShortName,
        startLeft,
        startTop,
        gbPromotions);
      nextLeft := lproviderInfo.Left + lproviderInfo.Width + 10;

      for I := 1 to list.Count-1 do begin
        promotion := TSupplierPromotion(list[i]);
        lproviderInfo := TPromotionLabel.Create(
          Self,
          promoCatalogId,
          promotion.Id,
          'lproviderInfo',
          promotion.SupplierShortName,
          nextLeft,
          startTop,
          gbPromotions);
        nextLeft := lproviderInfo.Left + lproviderInfo.Width + 10;
      end;
    end;
  finally
    list.Free;
  end;
end;

end.
