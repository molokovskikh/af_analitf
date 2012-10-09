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
  DB,
  U_ExchangeLog,
  GlobalParams,
  MyAccess,
  RxMemDS,
  DataSetHelper;

type
  TLegendName = (lnVitallyImportant, lnJunk, lnAwait, lnLeader, lnNeedCorrect,
    lnFrozenOrder, lnMinReq, lnBuyingBan, lnMatchWaybill, lnNonMain, lnNewLetter,
    lnImportantMail,
    lnCreatedByUserWaybill, lnNotSetNDS, lnSupplierPriceMarkup,
    lnRetailMarkup, lnRetailPrice, lnCertificateNotFound,
    lnSmartOrderOptimalCost, lnSmartOrderAnotherError,
    lnModifiedWaybillByReject,
    lnRejectedWaybillPosition,
    lnUnrejectedWaybillPosition,
    lnRejectedColor,
    lnOrderedLikeFrozen );

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
    class function GetLegendNameByValue(legendName : TLegendName) : String;
  end;

  TLegendHolder = class
   private
    mdLegends : TRxMemoryData;
    procedure UpdateLegends;
    procedure CreateMemoryData();
   public
    LegendInfos : TObjectList;
    Legends : array[TLegendName] of TColor;
    constructor Create();
    procedure ReadLegends(Connection : TCustomMyConnection);
    procedure ReadLegend(Connection : TCustomMyConnection; Legend : TLegendInfo);
    procedure SaveLegend(Connection : TCustomMyConnection; Legend : TLegendInfo);
    function  GetLegendInfo(legendName : TLegendName) : TLegendInfo;
    function  GetDataSet() : TRxMemoryData;
    procedure SaveChangesFromDataSet(Connection : TCustomMyConnection);
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
  Result := GetLegendNameByValue(Legend);
end;

class function TLegendInfo.GetLegendNameByValue(
  legendName: TLegendName): String;
begin
  Result := GetEnumName(TypeInfo(TLegendName), Ord(legendName));
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

  LegendInfos.Add(TLegendInfo.Create(lnVitallyImportant, laText, clGreen, 'Жизненно важные препараты', ''));
  LegendInfos.Add(TLegendInfo.Create(lnJunk, laBackground, $00669ef2, 'Уцененные препараты', ''));
  LegendInfos.Add(TLegendInfo.Create(lnAwait, laBackground, $00b8ff71, 'Ожидаемая позиция', ''));
  LegendInfos.Add(TLegendInfo.Create(lnLeader, laBackground, clMoneyGreen, 'Прайс-лист - лидер', ''));
  LegendInfos.Add(TLegendInfo.Create(lnNeedCorrect, laBackground, clMedGray, 'Имееются позиции с корректировками по цене и/или по количеству', ''));
  LegendInfos.Add(TLegendInfo.Create(lnFrozenOrder, laBackground, clSilver, '"Заморожен"', ''));
  LegendInfos.Add(TLegendInfo.Create(lnMinReq, laBackground, clRed, 'Не удовлетворяет минимальной сумме', ''));
  LegendInfos.Add(TLegendInfo.Create(lnBuyingBan, laBackground, clRed, 'Препарат запрещен к заказу', ''));
  LegendInfos.Add(TLegendInfo.Create(lnMatchWaybill, laBackground, $008EEEF9, 'Несоответствие в накладной', ''));
  LegendInfos.Add(TLegendInfo.Create(lnNonMain, laBackground, clBtnFace, 'Неосновной поставщик', ''));
  LegendInfos.Add(TLegendInfo.Create(lnNewLetter, laBackground, $00E3C1CC, 'Новое письмо', 'Новое письмо'));
  LegendInfos.Add(TLegendInfo.Create(lnImportantMail, laBackground, clLime, 'Важное письмо', 'Важное письмо'));
  LegendInfos.Add(TLegendInfo.Create(lnCreatedByUserWaybill, laBackground, clMoneyGreen, 'Накладная, созданная пользователем', 'Накладная, созданная пользователем'));
  LegendInfos.Add(TLegendInfo.Create(lnNotSetNDS, laBackground, clRed, 'НДС: не установлен для ЖНВЛС', 'Для ЖНВЛС-позиции некорректно установлено значение НДС'));
  LegendInfos.Add(TLegendInfo.Create(lnSupplierPriceMarkup, laBackground, clRed, 'Торговая наценка оптовика: превышение наценки оптовика', 'Значение торговой наценки оптовика превышает максимальную наценку оптового звена'));
  LegendInfos.Add(TLegendInfo.Create(lnRetailMarkup, laBackground, clRed, 'Розничная наценка: превышение максимальной розничной наценки', 'Значение розничной наценки превышает максимальную розничной наценку'));
  LegendInfos.Add(TLegendInfo.Create(lnRetailPrice, laBackground, clRed, 'Розничная цена: не рассчитана', 'Значения розничной наценки, розничной цены, розничной суммы и реальной наценки не были вычислены автоматически'));
  LegendInfos.Add(TLegendInfo.Create(lnCertificateNotFound, laBackground, clGray, 'Сертификат не был найден', 'Сертификат не был найден'));
  LegendInfos.Add(TLegendInfo.Create(lnSmartOrderOptimalCost, laBackground, RGB(172, 255, 151), 'Минимальная цена', 'Минимальная цена'));
  LegendInfos.Add(TLegendInfo.Create(lnSmartOrderAnotherError, laBackground, RGB(255, 128, 128), 'Не заказанные', 'Не заказанные'));
  LegendInfos.Add(TLegendInfo.Create(lnModifiedWaybillByReject, laBackground, clYellow, 'Измененная накладная', 'В накладной есть позиции с измененным статусом забраковки'));
  LegendInfos.Add(TLegendInfo.Create(lnRejectedWaybillPosition, laBackground, clYellow, 'Новая забракованная позиция', 'Новая забракованная позиция'));
  LegendInfos.Add(TLegendInfo.Create(lnUnrejectedWaybillPosition, laBackground, clOlive, 'Новая разбракованная позиция', 'Новая разбракованная позиция'));
  //lnRejectedColor = для этого цвета BGR = (158, 171, 167)
  LegendInfos.Add(TLegendInfo.Create(lnRejectedColor, laBackground, $009EABA7, 'Забракованная позиция', 'Забракованная позиция'));
  LegendInfos.Add(TLegendInfo.Create(lnOrderedLikeFrozen, laBackground, clSilver, 'Присутствует в замороженных заказах', 'Присутствует в замороженных заказах'));

  UpdateLegends;

  CreateMemoryData();
end;

procedure TLegendHolder.CreateMemoryData;
var
  field : TField;
begin
  mdLegends := TRxMemoryData.Create(nil);

  TDataSetHelper.AddIntegerField(mdLegends, 'Id');
  field := TDataSetHelper.AddStringField(mdLegends, 'Name');
  field.Size := 255;
  TDataSetHelper.AddIntegerField(mdLegends, 'LegendApplying');
  TDataSetHelper.AddLargeIntField(mdLegends, 'Color');
end;

function TLegendHolder.GetDataSet(): TRxMemoryData;
var
  I : Integer;
  legendInfo : TLegendInfo;
begin
  mdLegends.Close;

  mdLegends.Open;

  for I := 0 to LegendInfos.Count-1 do begin
    legendInfo := TLegendInfo(LegendInfos[i]);
    mdLegends.AppendRecord([Integer(legendInfo.Legend), legendInfo.LegendText, Integer(legendInfo.LegendApplying), legendInfo.LegendColor]);
  end;

  mdLegends.SortOnFields('Name');

  Result := mdLegends;
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

procedure TLegendHolder.SaveChangesFromDataSet(Connection : TCustomMyConnection);
var
  legendName : TLegendName;
  legendInfo : TLegendInfo;
  color : TColor;
begin
  mdLegends.First;
  while not mdLegends.Eof do begin
    legendName := TLegendName(mdLegends.FieldByName('Id').AsInteger);
    legendInfo := GetLegendInfo(legendName);
    if Assigned(legendInfo) then begin
      color := TColor(TLargeintField(mdLegends.FieldByName('Color')).AsLargeInt);
      legendInfo.LegendColor := color;
      SaveLegend(Connection, legendInfo);
    end
    else
      WriteExchangeLog('TLegendHolder.SaveChangesFromDataSet',
        Format('Не найдена легенда %s (%d)', [
          Integer(legendName),
          TLegendInfo.GetLegendNameByValue(legendName)]));
    mdLegends.Next;
  end;
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
