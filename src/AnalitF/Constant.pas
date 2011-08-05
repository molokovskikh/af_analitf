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

  //Цвет, которые используется для раскраски различных групп в сводном прайс-листе и в поиске в прайс-листах
  GroupColor = $00E3C1CC;//RGB = (204, 193, 227) => BGR = (227, 193, 204)

  //Кол-во заказа, котором отображается предупреждение
  WarningOrderCount : Integer = 1000;
  //Максимальное кол-во заказа, которое может принять сервер
  MaxOrderCount : Integer = 65535;

  //Флаги для разрешения печати различных форм
  //Печать сводного прайс-листа
  PrintCombinedPrice = 32768;
  //Печать прайс-листа поставщика
  PrintFirmPrice = 65536;
  //Печать забракованных препаратов
  PrintDefectives = 131072;
  //Печать текущего сводного заказа
  PrintCurrentSummaryOrder = 262144;
  //Печать отправленного сводного заказа
  PrintSendedSummaryOrder = 524288;
  //Печать текущего заказа
  PrintCurrentOrder = 1048576;
  //Печать отправленного заказа
  PrintSendedOrder = 2097152;

implementation

end.
