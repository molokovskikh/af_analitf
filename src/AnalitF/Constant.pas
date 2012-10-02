unit Constant;

interface

uses Graphics;

const
  REG_CLR = clLime;
  COMPACT_PERIOD = 3;

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

  OrderJunkMessage = '�� �������� �������� � ������������ ������ ��������'#13#10' ��� � ������������ ��������� ��������.';
  ExcessAvgCostMessage = '���������� ������� ����!';
  ExcessAvgOrderCountMessage = '���������� �������� ������!';
  WarningOrderCountMessage = '��������! �� �������� ������� ���������� ���������.';
  DisableProductOrderMessage = '�������� �������� � ������.';

implementation

end.
