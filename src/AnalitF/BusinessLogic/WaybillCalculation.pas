unit WaybillCalculation;

interface

uses
  SysUtils,
  Windows,
  Classes,
  Math,
  DB,
  MyAccess,
  DModule,
  U_ExchangeLog,
  DataSetHelper;

type
  TWaybillCalculation = class
   protected
    FDataSet : TDataSet;
    OldOnCalcFields : TDataSetNotifyEvent;
    FWaybillAsVitallyImportant : Boolean;
    FUseProducerCostWithNDS : Boolean;
    FCalculateOnProducerCost : Boolean;
    FClearRetailPrice : Boolean;
    procedure WaybillCalcFields(DataSet: TDataSet);
    procedure DataSetCalcFields(DataSet: TDataSet);
   public
    RetailSummField : TCurrencyField;
    MaxRetailMarkupField : TCurrencyField;
    RetailPriceField : TFloatField;
    RealMarkupField : TFloatField;

    class function GetSelectSql(): String;
    class function GetRefreshSql() : String;
    class function GetUpdateSql() : String;
    class function GetMarkupValue(afValue : Currency; individualMarkup : TFloatField) : Currency;
    class function GetMinProducerCostByField(RegistryCost, ProducerCost: TFloatField): Double;

    function GetMinProducerCostByFieldForMarkup(
      RegistryCost, ProducerCost : TFloatField;
      NDSValue : TField) : Double;

    function GetRetailPriceByMarkupForReport(var markup : Double) : Double;

    constructor Create(
      dataSet : TDataSet;
      AWaybillAsVitallyImportant : Boolean;
      AUseProducerCostWithNDS : Boolean;
      ACalculateOnProducerCost : Boolean;
      AClearRetailPrice : Boolean);
    destructor Destroy; override;
  end;

function RoundToOneDigit(const AValue: Double): Double;

implementation

{
  Стандартная фунция RoundTo работала не корректно
  Пример:
    1.23 -> 1.2
    1.29 -> 1.2
    1.2  -> 1.1
  Пришлось ее доработать, чтобы в случае 1.2 получалось 1.2
}
function RoundToOneDigit(const AValue: Double): Double;
var
  LFactor: Double;
begin
  LFactor := IntPower(10, -1);
  if (1 - Frac(AValue / LFactor)) > 0.001  then
    Result := Int(AValue / LFactor) * LFactor
  else
    Result := (AValue / LFactor) * LFactor;
end;

{ TWaybillCalculation }

constructor TWaybillCalculation.Create(dataSet: TDataSet;
  AWaybillAsVitallyImportant : Boolean;
  AUseProducerCostWithNDS : Boolean;
  ACalculateOnProducerCost : Boolean;
  AClearRetailPrice : Boolean);
begin
  OldOnCalcFields := nil;
  FDataSet := dataSet;
  FWaybillAsVitallyImportant := AWaybillAsVitallyImportant;
  FUseProducerCostWithNDS := AUseProducerCostWithNDS;
  FCalculateOnProducerCost := ACalculateOnProducerCost;
  FClearRetailPrice := AClearRetailPrice;
  if FDataSet is TMyQuery then begin
    TMyQuery(FDataSet).SQL.Text := GetSelectSql();
    TMyQuery(FDataSet).SQLRefresh.Text := GetRefreshSql();
    TMyQuery(FDataSet).SQLUpdate.Text := GetUpdateSql();
  end;

  RetailSummField := TDataSetHelper.AddCalculatedCurrencyField(FDataSet, 'RetailSumm');
  MaxRetailMarkupField := TDataSetHelper.AddCalculatedCurrencyField(FDataSet, 'MaxRetailMarkup');
  RetailPriceField := TDataSetHelper.AddCalculatedFloatField(FDataSet, 'RetailPrice');
  RealMarkupField := TDataSetHelper.AddCalculatedFloatField(FDataSet, 'RealMarkup');

  OldOnCalcFields := FDataSet.OnCalcFields;
  FDataSet.OnCalcFields := DataSetCalcFields;
end;

procedure TWaybillCalculation.DataSetCalcFields(DataSet: TDataSet);
begin
  WaybillCalcFields(DataSet);
  if Assigned(OldOnCalcFields) then
    OldOnCalcFields(DataSet);
end;

destructor TWaybillCalculation.Destroy;
begin
  FDataSet.OnCalcFields := OldOnCalcFields;
  inherited;
end;

class function TWaybillCalculation.GetMarkupValue(afValue: Currency;
  individualMarkup: TFloatField): Currency;
begin
  if not individualMarkup.IsNull then
    Result := individualMarkup.Value
  else
    Result := afValue;
end;

class function TWaybillCalculation.GetMinProducerCostByField(RegistryCost,
  ProducerCost: TFloatField): Double;
begin
  if not RegistryCost.IsNull
    and (RegistryCost.Value > 0)
    and (RegistryCost.Value < ProducerCost.Value)
  then
    Result := RegistryCost.Value
  else
    Result := ProducerCost.Value;
end;

function TWaybillCalculation.GetMinProducerCostByFieldForMarkup(
  RegistryCost, ProducerCost: TFloatField; NDSValue: TField): Double;
var
  minProducerCost : Double;
begin
  minProducerCost := GetMinProducerCostByField(RegistryCost, ProducerCost);
  if FUseProducerCostWithNDS then
    minProducerCost := minProducerCost * (1 + NDSValue.AsInteger/100);
  Result := minProducerCost;
end;

class function TWaybillCalculation.GetRefreshSql: String;
begin
  Result := '';
end;

function TWaybillCalculation.GetRetailPriceByMarkupForReport(
  var markup: Double): Double;
var
  vitallyNDS : Integer;
  vitallyNDSMultiplier : Double;
  nonVitallyNDSMultiplier : Double;
  minProducerCost : Double;
  supplierCostWithNDSMultiplier : Double;
begin
  if FDataSet.FieldByName('VitallyImportant').AsBoolean
  or (FWaybillAsVitallyImportant and FDataSet.FieldByName('VitallyImportant').IsNull)
  or (FDataSet.FieldByName('VitallyImportant').IsNull and FDataSet.FieldByName('VitallyImportantByUser').AsBoolean)
  then begin

    if not FDataSet.FieldByName('NDS').IsNull then
      vitallyNDS := FDataSet.FieldByName('NDS').AsInteger
    else
      vitallyNDS := 10;

    minProducerCost :=
      GetMinProducerCostByField(
        TFloatField(FDataSet.FieldByName('RegistryCost')),
        TFloatField(FDataSet.FieldByName('ProducerCost'))
      );

    //Если cпособ налогообложения ЕНВД и флаг "CalculateWithNDS" сброшен, то множитель = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDS.Value then
      vitallyNDSMultiplier := 1
    else
      vitallyNDSMultiplier := (1 + vitallyNDS/100);

    //ЕНВД
    if (DM.adtClientsMethodOfTaxation.Value = 0) then begin
      Result :=
        FDataSet.FieldByName('SupplierCost').AsFloat + minProducerCost*vitallyNDSMultiplier*(markup/100);

      if FClearRetailPrice and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        //markup := ((Result - FDataSet.FieldByName('SupplierCost.Value) / FDataSet.FieldByName('ProducerCost.Value)*100;
        markup :=
          ((Result - FDataSet.FieldByName('SupplierCost').AsFloat)*100)
          / (minProducerCost * vitallyNDSMultiplier)
      end;

    end
    else begin
    //НДС
      Result :=
        (FDataSet.FieldByName('SupplierCostWithoutNDS').AsFloat
        + minProducerCost*(markup/100)) * vitallyNDSMultiplier;

      if FClearRetailPrice and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        //markup := ((Result/1.1 - FDataSet.FieldByName('SupplierCostWithoutNDS.Value) / FDataSet.FieldByName('ProducerCost.Value)*100;
        markup :=
          ((Result/vitallyNDSMultiplier - FDataSet.FieldByName('SupplierCostWithoutNDS').AsFloat) *100)
          / minProducerCost;
      end;
    end;
  end
  else begin

    //Если cпособ налогообложения ЕНВД и флаг "CalculateWithNDSForOther" сброшен, то множитель = 1
    if (DM.adtClientsMethodOfTaxation.Value = 0) and not DM.adtClientsCalculateWithNDSForOther.Value then begin
      nonVitallyNDSMultiplier := 1;
      supplierCostWithNDSMultiplier := FDataSet.FieldByName('SupplierCostWithoutNDS').AsFloat;
    end
    else begin
      nonVitallyNDSMultiplier := (1 + FDataSet.FieldByName('NDS').AsInteger/100);
      supplierCostWithNDSMultiplier := FDataSet.FieldByName('SupplierCost').AsFloat;
    end;

    //По цене производителя
    if FCalculateOnProducerCost then begin
      Result := FDataSet.FieldByName('SupplierCost').AsFloat + FDataSet.FieldByName('ProducerCost').AsFloat*nonVitallyNDSMultiplier*(markup/100);

      if FClearRetailPrice and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        markup := ((Result - FDataSet.FieldByName('SupplierCost').AsFloat)*100)/(FDataSet.FieldByName('ProducerCost').AsFloat * nonVitallyNDSMultiplier);
      end;
    end
    else begin
    //По цене поставщика без НДС
      Result := FDataSet.FieldByName('SupplierCost').AsFloat + supplierCostWithNDSMultiplier*(markup/100);

      if FClearRetailPrice and (Abs(Result - RoundToOneDigit(Result)) > 0.001)
      then begin
        Result := RoundToOneDigit(Result);
        markup := ((Result - FDataSet.FieldByName('SupplierCost').AsFloat)*100)/(supplierCostWithNDSMultiplier);
      end;
    end;
  end;
end;

class function TWaybillCalculation.GetSelectSql: String;
begin
  Result := '';
end;

class function TWaybillCalculation.GetUpdateSql: String;
begin
  Result := '' +
'update ' +
'  DocumentBodies dbodies ' +
'set ' +
'  RetailMarkup     = :RetailMarkup, ' +
'  ManualCorrection = :ManualCorrection, ' +
'  ManualRetailPrice = :ManualRetailPrice, ' +
'  RetailAmount = :RetailAmount, ' +
'  Printed = :Printed, ' +
'  RequestCertificate = :RequestCertificate ' +
'where ' +
'  dbodies.Id = :OLD_Id ';
end;

procedure TWaybillCalculation.WaybillCalcFields(DataSet: TDataSet);
var
  maxMarkup : Currency;
  price,
  markup : Double;
begin
  try
    if not FDataSet.FieldByName('ProducerCost').IsNull then begin
      if FDataSet.FieldByName('VitallyImportant').AsBoolean
      or (FWaybillAsVitallyImportant and FDataSet.FieldByName('VitallyImportant').IsNull)
      or (FDataSet.FieldByName('VitallyImportant').IsNull and FDataSet.FieldByName('VitallyImportantByUser').AsBoolean)
      then begin
        maxMarkup := GetMarkupValue(DM.GetMaxVitallyImportantMarkup(
          GetMinProducerCostByFieldForMarkup(
            TFloatField(FDataSet.FieldByName('RegistryCost')),
            TFloatField(FDataSet.FieldByName('ProducerCost')),
            FDataSet.FieldByName('NDS')
          )
        ),
        TFloatField(FDataSet.FieldByName('CatalogMaxMarkup')))
      end
      else begin
        if FCalculateOnProducerCost then begin
          maxMarkup := GetMarkupValue(DM.GetMaxRetailMarkup(FDataSet.FieldByName('ProducerCost').AsFloat), TFloatField(FDataSet.FieldByName('CatalogMaxMarkup')))
        end
        else begin
          maxMarkup := GetMarkupValue(DM.GetMaxRetailMarkup(FDataSet.FieldByName('SupplierCostWithoutNDS').AsFloat), TFloatField(FDataSet.FieldByName('CatalogMaxMarkup')));
        end;
      end;
      MaxRetailMarkupField.Value := maxMarkup;
    end
    else begin
      if not FCalculateOnProducerCost and not FDataSet.FieldByName('VitallyImportant').AsBoolean
      then begin
        maxMarkup := GetMarkupValue(DM.GetMaxRetailMarkup(FDataSet.FieldByName('SupplierCostWithoutNDS').AsFloat), TFloatField(FDataSet.FieldByName('CatalogMaxMarkup')));
        MaxRetailMarkupField.Value := maxMarkup;
      end;
    end;

    if not FDataSet.FieldByName('RetailMarkup').IsNull then begin
      markup := FDataSet.FieldByName('RetailMarkup').AsFloat;
      price := GetRetailPriceByMarkupForReport(markup);
      RetailPriceField.Value := price;
      RetailSummField.Value := RoundTo(price, -2) * FDataSet.FieldByName('Quantity').AsInteger;
      RealMarkupField.Value := ((price - FDataSet.FieldByName('SupplierCost').AsFloat) * 100)/ FDataSet.FieldByName('SupplierCost').AsFloat;
    end
    else begin
      if not FDataSet.FieldByName('ManualRetailPrice').IsNull then begin
        price := FDataSet.FieldByName('ManualRetailPrice').AsFloat;
        RetailPriceField.Value := price;
        retailSummField.Value := RoundTo(price, -2) * FDataSet.FieldByName('Quantity').AsInteger;
      end;
    end;

  except
    on E : Exception do
      WriteExchangeLog('TWaybillCalculation.CalcFields', 'Ошибка: ' + E.Message);
  end;
end;

end.
