unit U_frameOrderHeadLegend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, U_frameBaseLegend, StdCtrls,
  Constant;

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

var
  frameOrderHeadLegend: TframeOrderHeadLegend;

implementation

{$R *.dfm}

{ TframeOrderHeadLegend }

constructor TframeOrderHeadLegend.Create(AOwner: TComponent);
begin
  inherited;
  lMinReq := CreateLegendLabel('�� ������������� ����������� �����', clRed, clWindowText);
  lFrozenOrder := CreateLegendLabel('"���������"', FrozenOrderColor, clWindowText);
  lNeedCorrect := CreateLegendLabel('�������� ������� � ��������������� �� ���� �/��� �� ����������', NeedCorrectColor, clWindowText);
end;

end.
