
//���� ���������� ���������� USEMEMORYCRYPTDLL, �� ���� ���������� USENEWMYSQLTYPES
//������ �� ���������� USENEWMYSQLTYPES � ��� ������ ����������� mysql-������� ��������� ������:
//A call to an mysql_server_init failed
//��-�� ����, ��� ���������� ��������� ������������� � ������������������ ������, ������� �� �� ��������
{$ifdef USEMEMORYCRYPTDLL}
  {$ifndef USENEWMYSQLTYPES}
    {$define USENEWMYSQLTYPES}
  {$endif}
{$endif}
