unit U_frameOrderHeadLegend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_frameBaseLegend, StdCtrls,
  Constant,
  U_LegendHolder;

type
  TframeOrderHeadLegend = class(TframeBaseLegend)
  private
    { Private declarations }
  public
    { Public declarations }
    lMinReq : TLabel;
    lFrozenOrder : TLabel;
    lNeedCorrect : TLabel;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

{ TframeOrderHeadLegend }

constructor TframeOrderHeadLegend.Create(AOwner: TComponent);
begin
  inherited;
  lMinReq := CreateLegendLabel(lnMinReq);
  lFrozenOrder := CreateLegendLabel(lnFrozenOrder);
  lNeedCorrect := CreateLegendLabel(lnNeedCorrect);
end;

end.
