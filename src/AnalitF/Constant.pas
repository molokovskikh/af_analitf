unit Constant;

interface

uses Graphics;

const
  JUNK_CLR = $00669ef2;
  AWAIT_CLR = $00b8ff71;
  LEADER_CLR = clMoneyGreen;
  REG_CLR = clLime;
  NeedCorrectColor = clMedGray;
  COMPACT_PERIOD = 3;
  VITALLYIMPORTANT_CLR = clGreen;
  FrozenOrderColor = clSilver;
  BuyingBanColor = clRed;

  //цвет дл€ пометки забракованного препарта в накладных
  RejectColor = $009EABA7; //BGR = (158, 171, 167)

  //цвет дл€ пометки забракованного препарта в накладных
  MatchWaybillColor = $006D7E79; //BGR = (109, 126, 121)

  //÷вет, которые используетс€ дл€ раскраски различных групп в сводном прайс-листе и в поиске в прайс-листах
  GroupColor = $00E3C1CC;//RGB = (204, 193, 227) => BGR = (227, 193, 204)

  // ол-во заказа, котором отображаетс€ предупреждение
  WarningOrderCount : Integer = 1000;
  //ћаксимальное кол-во заказа, которое может прин€ть сервер
  MaxOrderCount : Integer = 65535;

  //‘лаги дл€ разрешени€ печати различных форм
  //ѕечать сводного прайс-листа
  PrintCombinedPrice = 32768;
  //ѕечать прайс-листа поставщика
  PrintFirmPrice = 65536;
  //ѕечать забракованных препаратов
  PrintDefectives = 131072;
  //ѕечать текущего сводного заказа
  PrintCurrentSummaryOrder = 262144;
  //ѕечать отправленного сводного заказа
  PrintSendedSummaryOrder = 524288;
  //ѕечать текущего заказа
  PrintCurrentOrder = 1048576;
  //ѕечать отправленного заказа
  PrintSendedOrder = 2097152;

  OrderJunkMessage = '¬ы заказали препарат с ограниченным сроком годности'#13#10' или с повреждением вторичной упаковки.';
  ExcessAvgCostMessage = 'ѕревышение средней цены!';
  ExcessAvgOrderCountMessage = 'ѕревышение среднего заказа!';
  WarningOrderCountMessage = '¬нимание! ¬ы заказали большое количество препарата.';
  DisableProductOrderMessage = 'ѕрепарат запрещен к заказу.';

implementation

end.
