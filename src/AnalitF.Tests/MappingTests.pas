unit MappingTests;

interface

uses
  SysUtils,
  Windows,
  Classes,
  TestFrameWork,
  U_CurrentOrderItem;

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
  end;


implementation

{ TTestMapping }

procedure TTestMapping.CheckItemPeriodEquals(orderItem: TCurrentOrderItem;
  orderPeriod, offerPeriod: String; equals: Boolean);
begin
  orderItem.Period := orderPeriod;
  CheckEquals(equals, orderItem.PeriodEquals(offerPeriod), Format('Ќе совпадает срок годности, у заказа %s, у предложени€ %s', [orderPeriod, offerPeriod]));
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
