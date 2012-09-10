unit U_frameLegend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls,
  Constant,
  U_frameBaseLegend,
  U_LegendHolder;

type
  TframeLegend = class(TframeBaseLegend)
  private
    { Private declarations }
  public
    { Public declarations }
    lJunkLegend: TLabel;
    lAwaitLegend: TLabel;
    lBuyingBanLegend: TLabel;
    lVitallyImportantLegend: TLabel;
    lNotBasicLegend: TLabel;
    lLeaderLegend: TLabel;
    constructor CreateFrame(AOwner: TComponent;
      ShowVitallyImportant, ShowLeader, ShowNotBasic : Boolean);
  end;

implementation

{$R *.dfm}

{ TframeLegend }

constructor TframeLegend.CreateFrame(AOwner: TComponent;
  ShowVitallyImportant, ShowLeader, ShowNotBasic : Boolean);
begin
  inherited Create(AOwner);
  lJunkLegend := CreateLegendLabel(lnJunk);
  lAwaitLegend := CreateLegendLabel(lnAwait);
  lBuyingBanLegend := CreateLegendLabel(lnBuyingBan);
  if ShowVitallyImportant then
    lVitallyImportantLegend := CreateLegendLabel(lnVitallyImportant);
  if ShowLeader then
    lLeaderLegend := CreateLegendLabel(lnLeader);
  if ShowNotBasic then
    lNotBasicLegend := CreateLegendLabel(lnNonMain);
end;

end.
