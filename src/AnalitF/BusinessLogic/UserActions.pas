unit UserActions;

interface

{
Запрос, по которому из базы выбираются идентификаторы пользовательских действий
SELECT
ua.*,
concat('ua', ua.Identifier, ' = ', ua.Id, ', //', ua.Name) as Pascal
FROM `usersettings`.`UserActions` ua
order by Id;
}

type
  TUserAction =
  (
    uaStart = 1, //Запуск программы
    uaStop = 2, //Завершение программы
    uaGetData = 3, //Запрос накопительного обновления
    uaGetCumulative = 4, //Запрос кумулятивного обновления
    uaSendOrders = 5, //Отправка заказов
    uaSendWaybills = 6, //Загрузка и получение накладных
    uaCatalogSearch = 7, //Список препаратов
    uaSynonymSearch = 8, //Поиск в прайс-листах
    uaMnnSearch = 9, //Поиск по МНН
    uaShowPrices = 10, //Прайс-листы
    uaShowMinPrices = 11, //Минимальные цены
    uaShowSummaryOrder = 12, //Сводный заказ
    uaShowOrders = 13, //Заказы
    uaShowOrderBatch = 14, //АвтоЗаказ
    uaShowExpireds = 15, //Уцененные препараты
    uaShowDefectives = 16, //Забракованные препараты
    uaShowDocuments = 17, //Накладные
    uaHome = 18, //На главную страницу
    uaShowConfig = 19, //Конфигурация
    uaRequestCertificate = 20, //Установили галочку Получить у сертификата
    uaShowAwaitedProducts = 21, //Ожидаемые позиции
    uaRequestAttachment = 22 //Установили/сняли галочку Получить у вложения
  );

implementation

end.
