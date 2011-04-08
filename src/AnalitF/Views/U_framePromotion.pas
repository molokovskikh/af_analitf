unit U_framePromotion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  DB,
  Contnrs,
  StdCtrls,
  ExtCtrls,
  Math,
  MyAccess,
  DbGridEh,
  ToughDBGrid,
  DBGridHelper,
  DModule,
  U_SupplierPromotion,
  U_DBMapping,
  PromotionLabel,
  U_ShowPromotionsForm,
  U_frameBlockPromotion;

type
  TframePromotion = class(TFrame)
  private
    { Private declarations }
    FSingleParent: TWinControl;
    FAdvertisingPanel: TWinControl;
    FFocusedControl: TWinControl;

    pBorder : TPanel;

    pHide : TPanel;
    lHeaderHide : TLabel;
    lHide : TLabel;

    pGrid : TPanel;
    dbgPromotions : TToughDBGrid;
    dsPromotions : TDataSource;
    promoData : TMyQuery;

    PromoScrollBox : TScrollBox;

    FLastNameId : Int64;
    FLastPromoCatalogId : Int64;
    FLastPromotionId : Int64;

    procedure CreateVisualComponent;
    procedure ClearFrame;
    procedure UpdateContorls(nameId, promoCatalogId, promoCount : Integer);
    procedure HideClick(Sender : TObject);
    procedure PromotionsCellClick(Column : TColumnEh);
    procedure OnImageClick(Sender : TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    class function AddFrame(
      Owner: TComponent;
      SingleParent: TWinControl;
      AdvertisingPanel: TWinControl;
      FocusedControl: TWinControl) : TframePromotion;
    procedure SetAdvertisingPanel(AdvertisingPanel: TWinControl; FocusedControl: TWinControl);
    procedure ShowPromotion(nameId, promoCatalogId, promoCount : Integer);
    procedure HidePromotion();
  end;

implementation

{$R *.dfm}

{ TframePromotion }

class function TframePromotion.AddFrame(Owner: TComponent; SingleParent,
  AdvertisingPanel: TWinControl; FocusedControl: TWinControl): TframePromotion;
begin
  Result := TframePromotion.Create(Owner);
  Result.Visible := False;
  Result.Name := 'framePromotion';
  Result.FSingleParent := SingleParent;
  Result.FAdvertisingPanel := AdvertisingPanel;
  Result.FFocusedControl := FocusedControl;
  Result.Parent := Result.FAdvertisingPanel;
  Result.Align := alClient;
end;

procedure TframePromotion.ClearFrame;
var
  I : Integer;
begin
{
  for I := ComponentCount-1 downto 0 do
    if (Components[i] is TPromotionLabel)
      and (TPromotionLabel(Components[i]).Parent = pHeader)
    then begin
      TPromotionLabel(Components[i]).Visible := False;
      TPromotionLabel(Components[i]).Parent := nil;
      TPromotionLabel(Components[i]).Free;
    end;
}    

{
  for I := ComponentCount-1 downto 0 do
    if (Components[i] is TControl)
      and (TControl(Components[i]).Parent = pInfoControl)
    then begin
      TControl(Components[i]).Visible := False;
      TControl(Components[i]).Parent := nil;
      TControl(Components[i]).Free;
    end;
}

  for I := ComponentCount-1 downto 0 do
    if (Components[i] is TframeBlockPromotion)
      and (TframeBlockPromotion(Components[i]).Parent = PromoScrollBox)
    then begin
      TframeBlockPromotion(Components[i]).Visible := False;
      TframeBlockPromotion(Components[i]).Parent := nil;
      TframeBlockPromotion(Components[i]).Free;
    end;

  pHide.Visible := False;
  lHeaderHide.Caption := '';
  pGrid.Visible := False;
  Self.Width := 50;
  Self.Height := 50;
  PromoScrollBox.Visible := False;
  PromoScrollBox.AutoScroll := True;
 // PromoScrollBox.ClientHeight := 10;
  //PromoScrollBox.ClientWidth := 10;
  PromoScrollBox.HorzScrollBar.Range := 0;
  PromoScrollBox.VertScrollBar.Range := 0;
  dsPromotions.DataSet := nil;
  if Assigned(promoData) then
    FreeAndNil(promoData);
end;

constructor TframePromotion.Create(AOwner: TComponent);
begin
  inherited;

  CreateVisualComponent;

  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframePromotion.CreateVisualComponent;
var
  column : TColumnEh;
begin
  pBorder := TPanel.Create(Self);
  pBorder.Name := 'pBorder';
  pBorder.Caption := '';
  pBorder.BevelOuter := bvNone;
  pBorder.Parent := Self;
  pBorder.Align := alClient;
  pBorder.ControlStyle := pBorder.ControlStyle - [csParentBackground] + [csOpaque];

  pHide := TPanel.Create(Self);
  pHide.Name := 'pHide';
  pHide.Caption := '';
  pHide.BevelOuter := bvNone;
  pHide.Parent := pBorder;
  pHide.Align := alTop;

  lHeaderHide := TLabel.Create(Self);
  lHeaderHide.Name := 'lHeaderHide';
  lHeaderHide.Caption := 'По препарату Аспирин проводятся акции';
  lHeaderHide.Parent := pHide;
  lHeaderHide.Top := 3;
  lHeaderHide.Left := 10;

  lHide := TLabel.Create(Self);
  lHide.Name := 'lHide';
  lHide.Caption := 'Свернуть';
  lHide.Parent := pHide;
  lHide.Top := 3;
  lHide.Left := pHide.Width - lHide.Width - 10;
  lHide.Anchors := [akTop, akRight];
  lHide.Font.Color := clHotLight;
  lHide.Font.Style := lHide.Font.Style + [fsUnderline];
  lHide.Cursor := crHandPoint;
  lHide.OnClick := HideClick; 

  pHide.Height := 2*lHide.Top + lHide.Height;
  pHide.Constraints.MinHeight := pHide.Height;
  pHide.Visible := False;

  PromoScrollBox := TScrollBox.Create(Self);
  PromoScrollBox.Name := 'PromoScrollBox';
  PromoScrollBox.Parent := pBorder;
  PromoScrollBox.Align := alClient;
  PromoScrollBox.Visible := False;


  dsPromotions := TDataSource.Create(Self);

  pGrid := TPanel.Create(Self);
  pGrid.Name := 'pGrid';
  pGrid.BevelOuter := bvNone;
  pGrid.Parent := pBorder;
  pGrid.Align := alClient;
  pGrid.Visible := False;

  dbgPromotions := TToughDBGrid.Create(Self);
  dbgPromotions.Name := 'dbgPromotions';
  dbgPromotions.Parent := pGrid;
  dbgPromotions.Align := alClient;
  TDBGridHelper.SetDefaultSettingsToGrid(dbgPromotions);

  column := TDBGridHelper.AddColumn(dbgPromotions, 'SupplierShortName', 'Поставщик', dbgPromotions.Canvas.TextWidth('Большое имя поставщика'));
  column.Font.Color := clHotLight;
  column.Font.Style := column.Font.Style + [fsUnderline];
  TDBGridHelper.AddColumn(dbgPromotions, 'Name', 'Название', dbgPromotions.Canvas.TextWidth('Большое название акции'));
  TDBGridHelper.AddColumn(dbgPromotions, 'Begin', 'Начало', dbgPromotions.Canvas.TextWidth('00.00.0000'));
  TDBGridHelper.AddColumn(dbgPromotions, 'End', 'Окончание', dbgPromotions.Canvas.TextWidth('00.00.0000'));
  TDBGridHelper.AddColumn(dbgPromotions, 'CatalogFullName', 'Наименование', dbgPromotions.Canvas.TextWidth('Большое наименование препарата'));

  dbgPromotions.OnCellClick := PromotionsCellClick;

  dbgPromotions.DataSource := dsPromotions;
end;

procedure TframePromotion.HideClick(Sender: TObject);
begin
  if not FFocusedControl.Focused and FFocusedControl.CanFocus() then
    try FFocusedControl.SetFocus() except end;
  Hide();
end;

procedure TframePromotion.HidePromotion;
begin
  FLastNameId := 0;
  FLastPromoCatalogId := 0;
  FLastPromotionId := 0;
  Hide();
end;

procedure TframePromotion.SetAdvertisingPanel(
  AdvertisingPanel: TWinControl; FocusedControl: TWinControl);
begin
  Hide();
  FAdvertisingPanel := AdvertisingPanel;
  FFocusedControl := FocusedControl;
end;

procedure TframePromotion.ShowPromotion(
  nameId,
  promoCatalogId,
  promoCount: Integer);
begin
  if nameId <> FLastNameId then begin
    ClearFrame;

    UpdateContorls(nameId, promoCatalogId, promoCount);
    FLastNameId := nameId;

    Self.BringToFront;
  end;
end;

procedure TframePromotion.UpdateContorls(
  nameId,
  promoCatalogId,
  promoCount: Integer);
const
  startLeft = 10;
  startTop = 5;
var
  I : Integer;

  list : TObjectList;
  promotion : TSupplierPromotion;
  blockFrame : TframeBlockPromotion;

  nextTop,
  maxWidth,
  countHeight : Integer;

  lastTop : Integer;
  newTop : Integer;
  oldPoint, newPoint : TPoint;
  r : Integer;

begin
  pBorder.BevelInner := bvLowered;
  pBorder.BevelOuter := bvRaised;
  Self.Align := alNone;
  Self.Parent := FSingleParent;
  PromoScrollBox.Visible := True;
  //PromoScrollBox.Height := 100;

  list := TDBMapping.GetPromotionsByNameId(DM.MainConnection, nameId);
  try
    if list.Count > 0 then begin
      list.OwnsObjects := False;

      lHeaderHide.Caption := 'По препарату ' + TSupplierPromotion(list[0]).CatalogName + ' проводятся акции';

      nextTop := 0;
      maxWidth := 0;
      countHeight := 0;

      for I := 0 to list.Count-1 do begin
        promotion := TSupplierPromotion(list[i]);
        blockFrame := TframeBlockPromotion.AddFrame(Self, PromoScrollBox, promotion);
        blockFrame.Top := nextTop;
        nextTop := blockFrame.Top + blockFrame.Height;
        countHeight := countHeight + blockFrame.Height;
        if blockFrame.Tag > maxWidth then
          maxWidth := blockFrame.Tag;

        blockFrame.Align := alTop;
      end;
    end;
  finally
    list.Free;
  end;

  Self.Visible := True;
  pHide.Visible := True;

  Inc(maxWidth, 10);
  Inc(countHeight, 10);

  Self.Constraints.MaxHeight := (FSingleParent.ClientHeight div 3) * 2;
  Self.Constraints.MaxWidth := (FSingleParent.ClientWidth - 50);

  //PromoScrollBox.VertScrollBar.Visible := False;
//  PromoScrollBox.Height := PromoScrollBox.VertScrollBar.Range;

  //Self.Width := (FSingleParent.ClientWidth - 50);

  Self.Width := Max(maxWidth, lHeaderHide.Left + lHeaderHide.Width + 10 + lHide.Width + 10);
  Self.Height := pHide.Height + countHeight;

  Self.Left := (FSingleParent.ClientWidth - Self.Width) div 2;

  //Self.Top := FSingleParent.ClientHeight - Self.Height;
  lastTop := (FSingleParent.ClientHeight - Self.Height) div 2;

  if FFocusedControl is TCustomDBGridEh then begin
    r := TCustomDBGridEh(FFocusedControl).DataRowCount;
    newTop := TCustomDBGridEh(FFocusedControl).CellRect(0, r+1).Top;
    newTop := FSingleParent.ScreenToClient(TCustomDBGridEh(FFocusedControl).ClientToScreen(Point(0, newTop))).Y;
    if newTop + Self.Height < FSingleParent.ClientHeight then
      lastTop := newTop;
    //lastTop := (FSingleParent.ClientHeight - Self.Height) div 2;
  end;

  Self.Top := lastTop;

  Exit;

    if promoCount = 0 then begin
      Self.Align := alNone;
      Self.Parent := FSingleParent;
      Self.Visible := True;
      pHide.Visible := True;

      promotion := TDBMapping.GetSinglePromotionByNameId(DM.MainConnection, nameId);
      try
        FLastPromotionId := promotion.Id;
        FLastPromoCatalogId := promotion.CatalogId;

      finally
        promotion.Free
      end;
    end
    else begin
      promoData := TDBMapping.GetSqlDataSetPromotionsByNameId(
        DM.MainConnection,
        nameId);
      dsPromotions.DataSet := promoData;
      pGrid.Visible := True;


{
      Self.Parent := FAdvertisingPanel;
      Self.Align := alClient;
}


      Self.Align := alNone;
      Self.Parent := FSingleParent;
      Self.Visible := True;
      pHide.Visible := True;

      pBorder.BevelInner := bvLowered;
      pBorder.BevelOuter := bvRaised;

      Self.Width := (FSingleParent.ClientWidth - 50);
      Self.Left := (FSingleParent.ClientWidth - Self.Width) div 2;

      Self.Constraints.MaxHeight := (FSingleParent.ClientHeight div 3) * 2;
      Self.Height := pHide.Height
        + (2 + promoData.RecordCount) * TDBGridHelper.GetStdDefaultRowHeight(dbgPromotions);
      Self.Top := FSingleParent.ClientHeight - Self.Height;
{
}



{
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
}
    end;
end;

procedure TframePromotion.PromotionsCellClick(Column: TColumnEh);
begin
  if Assigned(FFocusedControl) and FFocusedControl.CanFocus() then
    FFocusedControl.SetFocus();

  if (Column.FieldName = 'SupplierShortName') then begin
    ShowPromotions(
      promoData.FieldByName('CatalogId').AsInteger,
      promoData.FieldByName('Id').AsInteger);
  end;
end;

procedure TframePromotion.OnImageClick(Sender: TObject);
begin
  if (Sender is TImage) and (FLastPromotionId > 0) then
    ShowPromotions(FLastPromoCatalogId, FLastPromotionId); 
end;

end.
