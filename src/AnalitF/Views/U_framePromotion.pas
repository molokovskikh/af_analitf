unit U_framePromotion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  DB,
  Contnrs,
  StdCtrls,
  ExtCtrls,
  MyAccess,
  DbGridEh,
  ToughDBGrid,
  DBGridHelper,
  DModule,
  U_SupplierPromotion,
  U_DBMapping,
  PromotionLabel,
  U_ShowPromotionsForm;

type
  TframePromotion = class(TFrame)
  private
    { Private declarations }
    FSingleParent: TWinControl;
    FAdvertisingPanel: TWinControl;
    FFocusedControl: TWinControl;

    pBorder : TPanel;

    pHide : TPanel;
    lHide : TLabel;

    gbPromotions : TGroupBox;
    pHeader : TPanel;
    pInfoControl : TPanel;
    lPromotionInfo : TLabel;

    pGrid : TPanel;
    dbgPromotions : TToughDBGrid;
    dsPromotions : TDataSource;
    promoData : TMyQuery;

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
  for I := ComponentCount-1 downto 0 do
    if (Components[i] is TPromotionLabel)
      and (TPromotionLabel(Components[i]).Parent = pHeader)
    then begin
      TPromotionLabel(Components[i]).Visible := False;
      TPromotionLabel(Components[i]).Parent := nil;
      TPromotionLabel(Components[i]).Free;
    end;

  for I := ComponentCount-1 downto 0 do
    if (Components[i] is TControl)
      and (TControl(Components[i]).Parent = pInfoControl)
    then begin
      TControl(Components[i]).Visible := False;
      TControl(Components[i]).Parent := nil;
      TControl(Components[i]).Free;
    end;

  pHide.Visible := False;
  pHeader.Constraints.MinHeight := 0;  
  pHeader.Visible := False;
  pInfoControl.Constraints.MinHeight := 0;
  pInfoControl.Visible := False;
  pInfoControl.Align := alNone;
  pGrid.Visible := False;
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

  gbPromotions := TGroupBox.Create(Self);
  gbPromotions.Parent := pBorder;
  gbPromotions.Align := alClient;
  gbPromotions.Name := 'gbPromotions';
  gbPromotions.Caption := ' Акции поставщиков ';
  gbPromotions.ControlStyle := gbPromotions.ControlStyle - [csParentBackground] + [csOpaque];

  pHeader := TPanel.Create(Self);
  pHeader.Name := 'pHeader';
  pHeader.Caption := '';
  pHeader.BevelOuter := bvNone;
  pHeader.Parent := gbPromotions;
  pHeader.Align := alTop;

  pInfoControl := TPanel.Create(Self);
  pInfoControl.Name := 'pInfoControl';
  pInfoControl.Caption := '';
  pInfoControl.BevelOuter := bvNone;
  pInfoControl.Parent := gbPromotions;
  pInfoControl.Visible := False;

  lPromotionInfo := TLabel.Create(Self);
  lPromotionInfo.Name := 'lPromotionInfo';
  lPromotionInfo.Parent := pHeader;

  dsPromotions := TDataSource.Create(Self);

  pGrid := TPanel.Create(Self);
  pGrid.Name := 'pGrid';
  pGrid.BevelOuter := bvNone;
  pGrid.Parent := gbPromotions;
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

    Self.Visible := True;
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

  lproviderInfo : TPromotionLabel;
  nextLeft : Integer;

  list : TObjectList;
  promotion : TSupplierPromotion;

  infoControl : TControl;
begin
    if promoCount = 0 then begin
      Self.Align := alNone;
      Self.Parent := FSingleParent;
      Self.Visible := True;
      pHeader.Visible := True;
      pHide.Visible := True;
      gbPromotions.Caption := ' Акция поставщика ';

      promotion := TDBMapping.GetSinglePromotionByNameId(DM.MainConnection, nameId);
      try
        FLastPromotionId := promotion.Id;
        FLastPromoCatalogId := promotion.CatalogId;

        if promoCatalogId <> promotion.CatalogId then
          gbPromotions.Caption := ' Акция поставщика по препарату ' + promotion.CatalogFullName + ' ';

        lproviderInfo := TPromotionLabel.Create(
          Self,
          promoCatalogId,
          promotion.SupplierShortName,
          startLeft,
          startTop,
          pHeader);

        lPromotionInfo.Caption := promotion.Name;
        lPromotionInfo.Left := startLeft;
        lPromotionInfo.Top := lproviderInfo.Top + lproviderInfo.Height + 10;
        lPromotionInfo.Visible := True;

        pHeader.Height := lPromotionInfo.Top + lPromotionInfo.Height + 5;
        pHeader.Constraints.MinHeight := pHeader.Height;

        Self.Width := (FSingleParent.ClientWidth - 50);
        Self.Left := (FSingleParent.ClientWidth - Self.Width) div 2;

        pInfoControl.Align := alClient;
        pInfoControl.Visible := True;
        infoControl := GetPromoInfoControl(promotion, Self, pInfoControl);
        if not Assigned(infoControl) then begin
          pInfoControl.Constraints.MinHeight := 1;
          Self.Height := pHide.Height + pHeader.Height + 1;
        end
        else begin

          if infoControl is TImage then
            TImage(infoControl).OnClick := OnImageClick;

          if infoControl.Constraints.MaxHeight > 0 then begin
            pInfoControl.Constraints.MinHeight := infoControl.Constraints.MaxHeight;
            infoControl.Constraints.MaxHeight := 0;
            infoControl.Constraints.MaxWidth := 0;
            infoControl.Align := alNone;
            infoControl.Align := alClient;
            if Self.Height > (FSingleParent.ClientHeight div 3) * 2 then begin
              pInfoControl.Constraints.MinHeight := 20;
              Self.Height := (FSingleParent.ClientHeight div 3) * 2;
            end;
          end
          else
            Self.Height := (FSingleParent.ClientHeight div 3) * 2;
        end;
        Self.Top := FSingleParent.ClientHeight - Self.Height;
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
      gbPromotions.Caption := ' Акции поставщиков ';


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
