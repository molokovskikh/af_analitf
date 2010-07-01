unit U_frameBaseLegend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TframeBaseLegend = class(TFrame)
    gbLegend: TGroupBox;
  private
    { Private declarations }
  protected
    Canvas: TCanvas;
    LabelHeight : Integer;
    topLabel : Integer;
    newLeftLabel : Integer;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    function CreateLegendLabel(
      legend : String;
      legendColor : TColor;
      legendTextColor : TColor) : TLabel;
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
  //���� ��������� ������� � ���� ��� �� ����� ���������
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
end;

end.
