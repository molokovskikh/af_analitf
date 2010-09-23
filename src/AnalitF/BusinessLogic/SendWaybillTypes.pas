unit SendWaybillTypes;

interface

type
  TSendWaybillsStatus = (
    swsNotFiles   = -1, //��� ������ ��� �������� �� ������
    swsOk         = 0,  //��� ������
    swsRepeat     = 1,  //��������� �������� �������
    swsRetryLater = 2   //�������� ��������� �������
  );

const
  //����������� �����������
  SendWaybillsStatusText : array[TSendWaybillsStatus] of string =
  ('��� ������ ��� ��������',
   '��� ������',
   '����������, ��������� �������� ��������� �������.',
   '����������, �������� ��������� �������.');

implementation

end.
