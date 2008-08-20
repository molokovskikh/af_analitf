unit Constant;

interface

uses Graphics;

const
  JUNK_CLR	= $00669ef2;
	AWAIT_CLR	= $00b8ff71;
	LEADER_CLR	= clMoneyGreen;
	REG_CLR		= clLime;
	COMPACT_PERIOD	= 3;
  VITALLYIMPORTANT_CLR = clGreen;
  //������� ������ ���� ������ ��� ������ ��������
  CURRENT_DB_VERSION = 48;

	JET_SCHEMA_USERROSTER = '{947bb102-5d43-11d1-bdbf-00c04fb92675}';

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
