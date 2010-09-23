unit SendWaybillTypes;

interface

type
  TSendWaybillsStatus = (
    swsNotFiles   = -1, //нет файлов для отправки на сервер
    swsOk         = 0,  //все хорошо
    swsRepeat     = 1,  //повторите отправку позднее
    swsRetryLater = 2   //получите документы позднее
  );

const
  //предложение отсутствует
  SendWaybillsStatusText : array[TSendWaybillsStatus] of string =
  ('нет файлов для загрузки',
   'все хорошо',
   'Пожалуйста, повторите загрузку накладных позднее.',
   'Пожалуйста, получите документы позднее.');

implementation

end.
