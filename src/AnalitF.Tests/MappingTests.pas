unit MappingTests;

interface

uses
  SysUtils,
  Windows,
  Classes,
  Variants,
  TestFrameWork,
  U_CurrentOrderItem,
  U_Offer;

type
  TTestMapping = class(TTestCase)
   private
    procedure CheckItemPeriodEquals(
      orderItem : TCurrentOrderItem;
      orderPeriod,
      offerPeriod : String;
      equals : Boolean);
   published
    procedure CheckPeriodEquals;
    procedure CheckOfferToString();
    procedure CheckCurrentOrderItemToString();
  end;


implementation

{ TTestMapping }

procedure TTestMapping.CheckCurrentOrderItemToString;
var
  orderItem : TCurrentOrderItem;
begin
  orderItem := TCurrentOrderItem.Create;
  try
    orderItem.CodeFirmCr := Null;
    orderItem.SynonymCode := Null;
    orderItem.SynonymFirmCrCode := Null;
    orderItem.MinOrderCount := Null;
    orderItem.OrderCost := Null;
    orderItem.RequestRatio := Null;
    orderItem.CoreId := Null;
    orderItem.RawRealPrice := Null;
    orderItem.RawPrice := Null;
    orderItem.DropReason := Null;
    orderItem.ProducerCost := Null;
    CheckEquals(
      '�������  ��: 0  �������: 0  ���-��: 0  ���������: 0  Code:   ' +
      'CodeCr:   ������: ���  ����: ���  ����: ',
      orderItem.ToString());
  finally
    orderItem.Free;
  end;
end;

procedure TTestMapping.CheckItemPeriodEquals(orderItem: TCurrentOrderItem;
  orderPeriod, offerPeriod: String; equals: Boolean);
begin
  orderItem.Period := orderPeriod;
  CheckEquals(equals, orderItem.PeriodEquals(offerPeriod), Format('�� ��������� ���� ��������, � ������ %s, � ����������� %s', [orderPeriod, offerPeriod]));
end;

procedure TTestMapping.CheckOfferToString;
var
  offer : TOffer;
begin
  offer := TOffer.Create;
  try
    offer.CodeFirmCr := Null;
    offer.RawRealCost := Null;
    offer.RawCost := Null;
    offer.ProducerCost := Null;
    offer.SynonymFirmCrCode := Null;
    offer.Quantity := Null;
    offer.RequestRatio := Null;
    offer.OrderCost := Null;
    offer.MinOrderCount := Null;
    CheckEquals(
      '�����������  ��: 0  ���������: 0  ���������: 0  Code:   CodeCr:   ����:   ������: ���  ����: ���',
      offer.ToString());
  finally
    offer.Free;
  end;
end;

procedure TTestMapping.CheckPeriodEquals;
var
  orderItem : TCurrentOrderItem;
begin
  orderItem := TCurrentOrderItem.Create;
  try
    CheckItemPeriodEquals(orderItem, '', '', True);
    CheckItemPeriodEquals(orderItem, '01.04.2012', '', True);
    CheckItemPeriodEquals(orderItem, '', '01.04.2012', True);
    CheckItemPeriodEquals(orderItem, '01.04.2012', '01.04.2012', True);
    CheckItemPeriodEquals(orderItem, '01.04.2012', '02.04.2012', True);
    CheckItemPeriodEquals(orderItem, '02.04.2012', '01.04.2012', False);
    CheckItemPeriodEquals(orderItem, '2012.01.04', '01.04.2012', True);
    CheckItemPeriodEquals(orderItem, '01.04.2012', '2012.01.04', True);
  finally
    orderItem.Free;
  end;
end;

initialization
  TestFramework.RegisterTest(TTestMapping.Suite);
end.
