unit UserActions;

interface

{
������, �� �������� �� ���� ���������� �������������� ���������������� ��������
SELECT
ua.*,
concat('ua', ua.Identifier, ' = ', ua.Id, ', //', ua.Name) as Pascal
FROM `usersettings`.`UserActions` ua
order by Id;
}

type
  TUserAction =
  (
    uaStart = 1, //������ ���������
    uaStop = 2, //���������� ���������
    uaGetData = 3, //������ �������������� ����������
    uaGetCumulative = 4, //������ ������������� ����������
    uaSendOrders = 5, //�������� �������
    uaSendWaybills = 6, //�������� � ��������� ���������
    uaCatalogSearch = 7, //������ ����������
    uaSynonymSearch = 8, //����� � �����-������
    uaMnnSearch = 9, //����� �� ���
    uaShowPrices = 10, //�����-�����
    uaShowMinPrices = 11, //����������� ����
    uaShowSummaryOrder = 12, //������� �����
    uaShowOrders = 13, //������
    uaShowOrderBatch = 14, //���������
    uaShowExpireds = 15, //��������� ���������
    uaShowDefectives = 16, //������������� ���������
    uaShowDocuments = 17, //���������
    uaHome = 18, //�� ������� ��������
    uaShowConfig = 19, //������������
    uaRequestCertificate = 20, //���������� ������� �������� � �����������
    uaShowAwaitedProducts = 21, //��������� �������
    uaRequestAttachment = 22 //����������/����� ������� �������� � ��������
  );

implementation

end.
