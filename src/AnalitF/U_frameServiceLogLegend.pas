unit U_frameServiceLogLegend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_frameBaseLegend, StdCtrls;

type
  TframeServiceLogLegend = class(TframeBaseLegend)
  private
    { Private declarations }
  public
    { Public declarations }
    lWarning : TLabel;
    lError : TLabel;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frameServiceLogLegend: TframeServiceLogLegend;

implementation

{$R *.dfm}

{ TframeServiceLogLegend }

constructor TframeServiceLogLegend.Create(AOwner: TComponent);
begin
  inherited;
  lWarning := CreateLegendLabel('Предупреждение', clYellow, clWindowText);
  lError := CreateLegendLabel('Ошибка', clRed, clWindowText);
end;

end.
