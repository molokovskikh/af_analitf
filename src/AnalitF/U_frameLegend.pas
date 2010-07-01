unit U_frameLegend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls,
  Constant,
  U_frameBaseLegend;

type
  TframeLegend = class(TframeBaseLegend)
  private
    { Private declarations }
  public
    { Public declarations }
    lJunkLegend: TLabel;
    lAwaitLegend: TLabel;
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
  lJunkLegend := CreateLegendLabel('��������� ���������', JUNK_CLR, clWindowText);
  lAwaitLegend := CreateLegendLabel('��������� �������', AWAIT_CLR, clWindowText);
  if ShowVitallyImportant then
    lVitallyImportantLegend := CreateLegendLabel('�������� ������ ���������', clWindow, VITALLYIMPORTANT_CLR);
  if ShowLeader then
    lLeaderLegend := CreateLegendLabel('�����-���� - �����', LEADER_CLR, clWindowText);
  if ShowNotBasic then
    lNotBasicLegend := CreateLegendLabel('���������� ���������', clBtnFace, clWindowText);
end;

end.
