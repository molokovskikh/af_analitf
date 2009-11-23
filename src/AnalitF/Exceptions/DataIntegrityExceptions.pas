unit DataIntegrityExceptions;

interface

uses
  InforoomException;

type
  //Исключения, связанные с нарушением целостности
  EDataIntegrityException = class(EInforoomException);

  //Исключения, связанные с нарушением целостности в отсрочках
  EDelayOfPaymentsDataIntegrityException = class(EDataIntegrityException);

implementation

end.
