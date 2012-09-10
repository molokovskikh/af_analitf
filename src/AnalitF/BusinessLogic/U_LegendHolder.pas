unit U_LegendHolder;

interface

uses
  SysUtils,
  Classes,
  StrUtils,
  Windows,
  Contnrs,
  TypInfo,
  Graphics,
  StdCtrls,
  U_ExchangeLog,
  GlobalParams,
  MyAccess;


type
  TLegendName = (lnVitallyImportant, lnJunk, lnAwait, lnLeader, lnNeedCorrect,
    lnFrozenOrder, lnMinReq, lnBuyingBan, lnMatchWaybill, lnNonMain, lnNewLetter,
    lnImportantMail,
    //lnVIPSender,
    lnCreatedByUserWaybill, lnNotSetNDS, lnSupplierPriceMarkup,
    lnRetailMarkup, lnRetailPrice, lnCertificateNotFound );

  TLegendApplying = (laBackground, laText);


  TLegendInfo = class
   public
    Legend : TLegendName;
    LegendApplying : TLegendApplying;
    DefaultLegendColor : TColor;
    LegendColor : TColor;
    LegendText : String;
    LegendHint : String;
    constructor Create(
      aLegendName : TLegendName;
      aLegengApplying : TLegendApplying;
      aDefaultColor : TColor;
      aLegendText : String;
      aLegendHint : String);
    function GetLegendName() : String;
    procedure SetLabel(aLabel : TLabel);
  end;

  TLegendHolder = class
   private
    procedure UpdateLegends;
   public
    LegendInfos : TObjectList;
    Legends : array[TLegendName] of TColor;
    constructor Create();
    procedure ReadLegends(Connection : TCustomMyConnection);
    procedure ReadLegend(Connection : TCustomMyConnection; Legend : TLegendInfo);
    procedure SaveLegend(Connection : TCustomMyConnection; Legend : TLegendInfo);
    function  GetLegendInfo(legendName : TLegendName) : TLegendInfo;
  end;

var
  LegendHolder : TLegendHolder;

implementation

{ TLegendInfo }

constructor TLegendInfo.Create(aLegendName: TLegendName;
  aLegengApplying: TLegendApplying; aDefaultColor: TColor; aLegendText,
  aLegendHint: String);
begin
  Legend := aLegendName;
  LegendApplying := aLegengApplying;
  DefaultLegendColor := aDefaultColor;
  LegendColor := DefaultLegendColor;
  LegendText := aLegendText;
  LegendHint := aLegendHint;
end;

function TLegendInfo.GetLegendName: String;
begin
  Result := GetEnumName(TypeInfo(TLegendName), Ord(Legend));
end;

procedure TLegendInfo.SetLabel(aLabel: TLabel);
begin
  aLabel.Caption := LegendText;
  if LegendApplying = laBackground then
    aLabel.Color := LegendColor
  else
    aLabel.Font.Color := LegendColor;
  if Length(LegendHint) > 0 then begin
    aLabel.Hint := LegendHint;
    aLabel.ShowHint := True;
  end;
end;

{ TLegendHolder }

constructor TLegendHolder.Create;
begin
  LegendInfos := TObjectList.Create(True);

  LegendInfos.Add(TLegendInfo.Create(lnVitallyImportant, laText, clGreen, '�������� ������ ���������', ''));
  LegendInfos.Add(TLegendInfo.Create(lnJunk, laBackground, $00669ef2, '��������� ���������', ''));
  LegendInfos.Add(TLegendInfo.Create(lnAwait, laBackground, $00b8ff71, '��������� �������', ''));
  LegendInfos.Add(TLegendInfo.Create(lnLeader, laBackground, clMoneyGreen, '�����-���� - �����', ''));
  LegendInfos.Add(TLegendInfo.Create(lnNeedCorrect, laBackground, clMedGray, '�������� ������� � ��������������� �� ���� �/��� �� ����������', ''));
  LegendInfos.Add(TLegendInfo.Create(lnFrozenOrder, laBackground, clSilver, '"���������"', ''));
  LegendInfos.Add(TLegendInfo.Create(lnMinReq, laBackground, clRed, '�� ������������� ����������� �����', ''));
  LegendInfos.Add(TLegendInfo.Create(lnBuyingBan, laBackground, clRed, '�������� �������� � ������', ''));
  LegendInfos.Add(TLegendInfo.Create(lnMatchWaybill, laBackground, $008EEEF9, '�������������� � ���������', ''));
  LegendInfos.Add(TLegendInfo.Create(lnNonMain, laBackground, clBtnFace, '���������� ���������', ''));
  LegendInfos.Add(TLegendInfo.Create(lnNewLetter, laBackground, $00E3C1CC, '����� ������', '����� ������'));
  LegendInfos.Add(TLegendInfo.Create(lnImportantMail, laBackground, clLime, '������ ������', '������ ������'));
  //LegendInfos.Add(TLegendInfo.Create(lnVIPSender, laBackground, clLime, '����. �����������', '����. �����������'));
  LegendInfos.Add(TLegendInfo.Create(lnCreatedByUserWaybill, laBackground, clMoneyGreen, '���������, ��������� �������������', '���������, ��������� �������������'));
  LegendInfos.Add(TLegendInfo.Create(lnNotSetNDS, laBackground, clRed, '���: �� ���������� ��� �����', '��� �����-������� ����������� ����������� �������� ���'));
  LegendInfos.Add(TLegendInfo.Create(lnSupplierPriceMarkup, laBackground, clRed, '�������� ������� ��������: ���������� ������� ��������', '�������� �������� ������� �������� ��������� ������������ ������� �������� �����'));
  LegendInfos.Add(TLegendInfo.Create(lnRetailMarkup, laBackground, clRed, '��������� �������: ���������� ������������ ��������� �������', '�������� ��������� ������� ��������� ������������ ��������� �������'));
  LegendInfos.Add(TLegendInfo.Create(lnRetailPrice, laBackground, clRed, '��������� ����: �� ����������', '�������� ��������� �������, ��������� ����, ��������� ����� � �������� ������� �� ���� ��������� �������������'));
  LegendInfos.Add(TLegendInfo.Create(lnCertificateNotFound, laBackground, clGray, '���������� �� ��� ������', '���������� �� ��� ������'));

  UpdateLegends;
end;

function TLegendHolder.GetLegendInfo(legendName: TLegendName): TLegendInfo;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to LegendInfos.Count-1 do
    if TLegendInfo(LegendInfos[i]).Legend = legendName then begin
      Result := TLegendInfo(LegendInfos[i]);
      Exit;
    end;
end;

procedure TLegendHolder.ReadLegend(Connection: TCustomMyConnection;
  Legend: TLegendInfo);
begin
  Legend.LegendColor := TGlobalParamsHelper.GetParamDef(Connection, Legend.GetLegendName(), Legend.DefaultLegendColor);
  Legends[Legend.Legend] := Legend.LegendColor;
end;

procedure TLegendHolder.ReadLegends(Connection: TCustomMyConnection);
var
  I : Integer;
begin
  for I := 0 to LegendInfos.Count-1 do
    ReadLegend(Connection, TLegendInfo(LegendInfos[i]));
end;

procedure TLegendHolder.SaveLegend(Connection: TCustomMyConnection;
  Legend: TLegendInfo);
begin
  TGlobalParamsHelper.SaveParam(Connection, Legend.GetLegendName(), Legend.LegendColor);
  Legends[Legend.Legend] := Legend.LegendColor;
end;

procedure TLegendHolder.UpdateLegends;
var
  I : Integer;
begin
  for I := 0 to LegendInfos.Count-1 do
    Legends[TLegendInfo(LegendInfos[i]).Legend] := TLegendInfo(LegendInfos[i]).LegendColor;
end;

initialization
  LegendHolder := TLegendHolder.Create;
end.
