unit U_frameBaseLegend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  DModule,
  U_LegendHolder;

type
  TframeBaseLegend = class(TFrame)
    gbLegend: TGroupBox;
    LegendColorDialog: TColorDialog;
  private
    { Private declarations }
  protected
    Canvas: TCanvas;
    LabelHeight : Integer;
    topLabel : Integer;
    newLeftLabel : Integer;
    procedure OnLegendDblClick(Sender : TObject);
  public
    { Public declarations }
    UpdateGrids : TNotifyEvent;
    constructor Create(AOwner: TComponent); override;
    function CreateLegendLabel(
      legend : String;
      legendColor : TColor;
      legendTextColor : TColor) : TLabel; overload;
    function CreateLegendLabel(
      legend : String;
      legendColor : TColor;
      legendTextColor : TColor;
      hint : String) : TLabel; overload;
    function CreateLegendLabel(aLegendName : TLegendName) : TLabel; overload;

  end;

implementation

{$R *.dfm}

{ TframeBaseLegend }

constructor TframeBaseLegend.Create(AOwner: TComponent);
var
  textHeight : Integer;
begin
  inherited;
  gbLegend.ControlStyle := gbLegend.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];

  newLeftLabel := 8;
  
  Canvas := TControlCanvas.Create();
  TControlCanvas(Canvas).Control := Self;
  textHeight := Canvas.TextHeight('Wg');

{
  //Если захочется вернуть к виду как на форме АвтоЗаказ
  LabelHeight := textHeight + 10;
  Self.Constraints.MaxHeight := 2*LabelHeight;
  Self.Constraints.MinHeight := Self.Constraints.MaxHeight;
  topLabel := textHeight + (gbLegend.Height - textHeight - LabelHeight - 3) div 2;
}

  LabelHeight := textHeight {+ 10};
  Self.Constraints.MaxHeight := 2*LabelHeight + 7;
  Self.Constraints.MinHeight := Self.Constraints.MaxHeight;
  topLabel := 13;
end;

function TframeBaseLegend.CreateLegendLabel(legend: String; legendColor,
  legendTextColor: TColor): TLabel;
begin
  Result := TLabel.Create(Self);
  Result.Parent := gbLegend;
  Result.AutoSize := False;
  Result.Top := topLabel;
  Result.Left := newLeftLabel;
  Result.Caption := legend;
  Result.ParentColor := False;
  Result.ParentFont := False;
  Result.Transparent := False;
  Result.Color := legendColor;
  Result.Font.Color := legendTextColor;
  Result.Alignment := taCenter;
  Result.Layout := tlCenter;
  Result.Width := Result.Canvas.TextWidth(legend) + 60;
  Result.Height := LabelHeight;
  newLeftLabel := Result.Left + Result.Width + 6;
  Result.OnDblClick := OnLegendDblClick;
end;

function TframeBaseLegend.CreateLegendLabel(legend: String; legendColor,
  legendTextColor: TColor; hint: String): TLabel;
begin
  Result := CreateLegendLabel(legend, legendColor, legendTextColor);
  if Length(hint) > 0 then begin
    Result.Hint := hint;
    Result.ShowHint := True;
  end;
end;

function TframeBaseLegend.CreateLegendLabel(
  aLegendName: TLegendName): TLabel;
var
  legendInfo : TLegendInfo;
begin
  legendInfo := LegendHolder.GetLegendInfo(aLegendName);
  Result := TLabel.Create(Self);
  Result.Parent := gbLegend;
  Result.AutoSize := False;
  Result.Top := topLabel;
  Result.Left := newLeftLabel;
  Result.ParentColor := False;
  Result.ParentFont := False;
  Result.Transparent := False;
  Result.Alignment := taCenter;
  Result.Layout := tlCenter;

  legendInfo.SetLabel(Result);

  Result.Tag := Integer(legendInfo);

  Result.Width := Result.Canvas.TextWidth(Result.Caption) + 60;
  Result.Height := LabelHeight;
  newLeftLabel := Result.Left + Result.Width + 6;
  Result.OnDblClick := OnLegendDblClick;
end;

procedure TframeBaseLegend.OnLegendDblClick(Sender: TObject);
var
  legendLabel : TLabel;
  legendInfo : TLegendInfo;
begin
  if Sender is TLabel then begin
    legendLabel := TLabel(Sender);
    if legendLabel.Tag > 0 then begin
      legendInfo := TLegendInfo(legendLabel.Tag);
      LegendColorDialog.Color := legendInfo.LegendColor;
      if LegendColorDialog.Execute then begin
        legendInfo.LegendColor := LegendColorDialog.Color;
        legendInfo.SetLabel(legendLabel);
        LegendHolder.SaveLegend(DM.MainConnection, legendInfo);
        if Assigned(UpdateGrids) then
          UpdateGrids(Self);
      end;
    end;
  end;
end;

end.
