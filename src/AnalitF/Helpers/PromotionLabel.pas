unit PromotionLabel;

interface

uses
  SysUtils,
  Classes,
  Windows,
  Graphics,
  Controls,
  StdCtrls,
  U_ShowPromotionsForm;

type
  TPromotionLabel = class(TLabel)
   protected
    FCatalogId : Int64;
    FPromotionId : Int64;
    procedure PrepareLabel;
    procedure Click; override;
   public
    constructor Create(AOwner : TComponent); reintroduce; overload;
    constructor Create(AOwner : TComponent; catalogId : Int64);  reintroduce; overload;
    constructor Create(
      AOwner : TComponent;
      catalogId : Int64;
      ACaption : String;
      ALeft,
      ATop : Integer;
      AParent : TWinControl);  reintroduce; overload;
    constructor Create(AOwner : TComponent; catalogId : Int64; promotionId : Int64);  reintroduce; overload;
    constructor Create(
      AOwner : TComponent;
      catalogId : Int64;
      promotionId : Int64;
      namePrefix : String;
      ACaption : String;
      ALeft,
      ATop : Integer;
      AParent : TWinControl);  reintroduce; overload;
    property CatalogId : Int64 read FCatalogId write FCatalogId;
    property PromotionId : Int64 read FPromotionId write FPromotionId;
  end;

implementation

{ TPromotionLabel }

constructor TPromotionLabel.Create(AOwner: TComponent; catalogId: Int64);
begin
  inherited Create(AOwner);
  PrepareLabel;
  FCatalogId := catalogId;
  FPromotionId := 0;
end;

procedure TPromotionLabel.Click;
begin
  if Assigned(OnClick) or Assigned(Action) then
    inherited Click
  else
    if (FPromotionId <> 0) and (FCatalogId <> 0) then
      ShowPromotions(FCatalogId, FPromotionId)
    else
      if (FCatalogId <> 0) then
        ShowPromotions(FCatalogId);
end;

constructor TPromotionLabel.Create(AOwner: TComponent; catalogId,
  promotionId: Int64);
begin
  inherited Create(AOwner);
  PrepareLabel;
  FCatalogId := catalogId;
  FPromotionId := promotionId;
end;

procedure TPromotionLabel.PrepareLabel;
begin
  Self.Font.Color := clHotLight;
  Self.Font.Style := Self.Font.Style + [fsUnderline];
  Self.Cursor := crHandPoint;
end;

constructor TPromotionLabel.Create(AOwner: TComponent);
begin
  inherited;
  PrepareLabel;
end;

constructor TPromotionLabel.Create(AOwner: TComponent; catalogId: Int64;
  ACaption: String; ALeft, ATop: Integer; AParent: TWinControl);
begin
  inherited Create(AOwner);
  PrepareLabel;
  FCatalogId := catalogId;
  FPromotionId := 0;
  Caption := ACaption;
  Left := ALeft;
  Top := ATop;
  Parent := AParent;
end;

constructor TPromotionLabel.Create(AOwner: TComponent; catalogId,
  promotionId: Int64; namePrefix, ACaption: String; ALeft, ATop: Integer;
  AParent: TWinControl);
begin
  inherited Create(AOwner);
  PrepareLabel;
  FCatalogId := catalogId;
  FPromotionId := promotionId;
  Name := namePrefix + IntToStr(FPromotionId);
  Caption := ACaption;
  Left := ALeft;
  Top := ATop;
  Parent := AParent;
end;

end.
