unit DocumentTypes;

interface

type
  TDocumentType = (dtUnknown, dtWaybill, dtReject, dtDoc);

const
  DocumentFolders : array[TDocumentType] of string =
  ( 'Unknown', 'Waybills', 'Rejects', 'Docs');
  RussianDocumentType : array[TDocumentType] of string =
  ( 'Неизвестный', 'Накладная', 'Отказ', 'Документ');
  RussianDocumentTypeForHeaderForm : array[TDocumentType] of string =
  ( 'неизвестного', 'накладной', 'отказа', 'документа');

implementation

end.
