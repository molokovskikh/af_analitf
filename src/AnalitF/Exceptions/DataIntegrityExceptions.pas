unit DataIntegrityExceptions;

interface

uses
  InforoomException;

type
  //����������, ��������� � ���������� �����������
  EDataIntegrityException = class(EInforoomException);

  //����������, ��������� � ���������� ����������� � ���������
  EDelayOfPaymentsDataIntegrityException = class(EDataIntegrityException);

implementation

end.
