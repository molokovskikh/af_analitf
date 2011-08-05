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

  //����, ������� ������������ ��� ��������� ��������� ����� � ������� �����-����� � � ������ � �����-������
  GroupColor = $00E3C1CC;//RGB = (204, 193, 227) => BGR = (227, 193, 204)

  //���-�� ������, ������� ������������ ��������������
  WarningOrderCount : Integer = 1000;
  //������������ ���-�� ������, ������� ����� ������� ������
  MaxOrderCount : Integer = 65535;

  //����� ��� ���������� ������ ��������� ����
  //������ �������� �����-�����
  PrintCombinedPrice = 32768;
  //������ �����-����� ����������
  PrintFirmPrice = 65536;
  //������ ������������� ����������
  PrintDefectives = 131072;
  //������ �������� �������� ������
  PrintCurrentSummaryOrder = 262144;
  //������ ������������� �������� ������
  PrintSendedSummaryOrder = 524288;
  //������ �������� ������
  PrintCurrentOrder = 1048576;
  //������ ������������� ������
  PrintSendedOrder = 2097152;

implementation

end.
