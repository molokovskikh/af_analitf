{***************************************************************
 *
 * Unit Name: LU_DynamicArrays
 * Purpose  :
 * Author   : Морозов Сергей
 * History  : Специффикация : Цыплаков
              Реализация    : Морозов
              V1.0 - 2001.05.16
              V1.1 - 2001.05.22 - добавлены методы Dump.
                                - Исправлена возможная ошибка при обращении к
                                  данным в момент их модиффикации. Обращения к
                                  данным идут через критические секции.
              V1.11 - 2001.05.23 - добавлен виртуланый метод Initialize для
                                   инициализации наследников.
                                 - базовый тип TLengthType сменен с Word на
                                   Cardinal. Появились константы
                                   MaxByteArraySize и MaxWordArraySize.
                                 - результат работы метода Dump содержит
                                   инфомацию о длине пакета.
                                 - добавлено свойство Items[Index : TLengthType]
                                 - добавлены методы чтения из потока и из файла
                                   LoadFromFile и LoadFromStream, а также
                                   сохранения в поток или в файл SaveToFile и
                                   SaveToStream.
              V1.12 - 2001.05.24 - исправлена ошибка в методе Dump(неправильно
                                   выделялась память).
              V1.13 - 2001.06.01 - Константы MaxByteArraySize и MaxWordArraySize
                                   установленны оптимальным образом.
                                   Функция Dump выводит только 1 Кб из массива.
                                   Функция Dump сделана virtual.
              V1.131- 2001.06.04 - исправлена ошибка в методе Dump(неправильно
                                   обрабатывалась ситуация с длиной массива=0).
                                   При вставке в конец массива происходит
                                   добавление.
                                   У Dump'a убран virtual. Вместо него добавлены
                                   виртуальные функции DumpHeader и DumpFooter.
              V1.132- 2001.06.08 - Добавлен объект TArrayWatcher для проверки
                                   утечки памяти. Для запуска этого объекта
                                   в опциях проекта следует определить Debug.
              V1.133- 2001.06.28 - Добавлена процедура ChopHead
                      2001.11.14 - К TSGByteArray добавлены:
                                   конструктор Summon(Str : String); overload;
                                   процедура AppendChar(Sign : Char);
                                   процедура AppendString(Str : String);
              WishList :
               - методы для поиска в массиве байтов
                  FindWord  (
                     s  : string или
                     AB : TSGByteArray или
                     AB : array of byte )
                  FindWordN ( тоже, но дополнительный параметр N : integer
                     Номер слова которое надо искать (как в Rx)
               - метод копирующий содержимое с другого массива
                 в параметрах указывается - из какого массива, с какого символа
                 по какой, в какое место вставить.

 ****************************************************************}

unit LU_DynamicArrays;

interface

uses
  Classes, SysUtils, SyncObjs,LU_TSGEvent;

{$R+}

type
  //Базовый тип TLengthType может меняться на типы больше Word.
  //ВНИМАНИЕ !!!!!!!!
  //При изменении базового типа TLengthType на забудьте поменять константы
  //MaxByteArraySize и MaxWordArraySize, иначе может быть неправильная работа
  //классов.
  TLengthType = type Cardinal;
const
  //Эти константы задают максимальные размеры массивов. Массив слов в два раза
  //меньше массива байт, чтобы они имели одинаковую емкость в байтах.
  //ВНИМАНИЕ !!!!!!!!
  //Оптимальный максимальный размер
  //         у TByteArray = High(Cardinal) div 128
  //         у TWordArray = High(Cardinal) div 256
  //Если значения больше этих велечин, то могут быть проблемы в виде
  //        "Out of memory."
  MaxByteArraySize = High(Cardinal) div 128;//Максимальная длина массива байт
  MaxWordArraySize = High(Cardinal) div 256;//Максимальная длина массива слов
  //Максимальное количество байт, выдаваемое в Dump
  MaxOutputByteInDump = 1024*1024;
type
  PWorkByteArray = ^TWorkByteArray;
  TWorkByteArray = array[0..MaxByteArraySize-1] of Byte;
  PWorkWordArray = ^TWorkWordArray;
  TWorkWordArray = array[0..MaxWordArraySize-1] of Word;
  TByteOrder    = (boLow, boHigh);
  PTwoByteArray = ^TTwoByteArray;
  TTwoByteArray = array[TByteOrder] of byte;

const
  ByteArrayMSGHeader = 'LU_DynamicArrays:TSGByteArray.%s - %s';
  WordArrayMSGHeader = 'LU_DynamicArrays:TSGWordArray.%s - %s';
  CapacityError      = 'Новая емкость массива(%d) меньше длины массива(%d).';
  MaxCapacityError   =
     'Новая емкость массива(%d) больше максимальной длины массива(%d).';
  LengthError        =
     'Новая длина массива(%d) меньше текущей длины массива(%d).';
  NewLength          =
     'Новая длина массива превышает допустимое значение в %d на %d.';
  RangeCheckError    = 'Выход за границу массива.';
  FullArray          = 'Массив заполнен на максимальную длину в %d.';
  InsertHimself      = 'Объект не может вставить сам себя.';
  OddArray           = 'Количество байт в исходном массиве является нечетным.';
  OddStream          = 'Количество байт в исходном потоке является нечетным.';
  ErrorLoadFromFile  = 'Ошибка при чтении из файла %s.';
  ErrorLoadFromStream= 'Ошибка при чтении из потока.';
  ErrorSaveToFile    = 'Ошибка записи в файл %s.';
  ErrorSaveToStream  = 'Ошибка записи в поток.';
  FirstStringInDump  = 'Длина пакета составляет %d %s.'#13#10;
  DumpStrLength      = 8; //Количество слов или байт одной строке
  CharInByte         = 2; //Длина байт в строке
  CharInWord         = 4; //Длина слов в строке
  OutInDump          = 'Емкость массива(%d байт), выводимого в Dump, превышает'+
                        ' допустимую емкость(%d байт) на %d байт.'#13#10;


type

  TSGWordArray = class;

  TSGByteArray = class(TSGEvent)
   private
    FCriticalSection : TCriticalSection;//Рабочая критическая секция
    FCapacity,                          //Емкость массива
    FLength : TLengthType;              //Используемая длина массива
    FArray : PWorkByteArray;            //Указатель на массив
    //Процедура наращивает емкость массива на 3 текущей длины
    procedure   Grow;
    //Изменяет емкость массива на NewCapacity
    procedure   SetCapacity(NewCapacity : TLengthType);
    //Вызывает исключение с сообщением, формируемым с помощью ByteArrayMSGHeader
    //ProcName - имя процедуры, в которой произшла ошибка, Msg - сообщение.
    procedure   Error(const ProcName, Msg : String);
    //Вызывает процедуру Error, но сначала делает Format(Msg, Args), чтобы
    //подставить параметры в сообщение Msg
    procedure   ErrorFmt(
       const ProcName, Msg : String;
       const Args : array of const);
    //Читает свойство из потока
    procedure   ReadArrayData(Reader : TReader);
    //Сохраняет свойство в поток
    procedure   WriteArrayData(Writer : TWriter);
    //Инициализирует атрибуты экземпляра класса. Вызывается из конструкторов.
    procedure   Init;
   protected
    //Объявляет свойство, которое будет сохранено в поток
    procedure   DefineProperties(Filer : TFiler); override;
   public
    //Инициализация объектов, которые являются наследниками от TSGByteArray;
    procedure   Initialize;virtual;
    //Создает пустой массив
    constructor Create ( AOwner : TComponent ); override;
    //Создает массив и наполняет его переданными байтами
    constructor Summon(AB : array of byte); overload;
    //Создает массив и содержимым переданной строки
    constructor Summon(Str : String); overload;
    //Уничтожает объект и освобождает занимаемую память
    destructor  Destroy; override;
    //Устанавливает длину массива равной вновь переданной.
    //Если новая длина больше чем старая, размечает хвост нулями.
    //Если меньше, то вызыватеся ошибка. Для обрезания данных
    //надо испрользовать Crop
    procedure   SetLength(ALength : TLengthType);
    //Возвращает длину массива
    function    Length : TLengthType;
    //Дописывает байт в хвост массива
    procedure   AppendByte(Ab : Byte);
    //Дописывает байт-byte(Char) в хвост массива
    procedure   AppendChar(Sign : Char);
    //Дописывает байты из указанного массива в свой хвост.
    procedure   AppendArray(AB : TSGByteArray); overload;
    procedure   AppendArray(AB : array of byte); overload;
    //Дописывает байты из указанной строки хвост массива.
    procedure   AppendString(Str : String);
    //Устанавливает I-тый байт равным Avalue
    procedure   SetValue(I : TLengthType; AValue : byte);
    //Возвращает значение I-того байта
    function    Bytes(I : TLengthType) : byte;
    //Устанавливает значение массива в точности равным переданному.
    //Старые данные убиваются.
    procedure   AssignArray(AB : array of byte); overload;
    procedure   AssignArray(AB : TSGByteArray);    overload;
    //Очищает массив, устанавливает длину равной 0.
    procedure   Clear;
    //Вставляет байт b в I-тую позицию, сдвигая хвост и соотв.
    //увеличивая длину на 1
    procedure   InsertByte(I : TLengthType; b : Byte);
    //Вставляет в I-тую позицию байты из указанного массива.
    procedure   InsertArray(I : TLengthType; AB : TSGByteArray);   overload;
    procedure   InsertArray(I : TLengthType; AB : array of byte);overload;
    //Возвращает копию массива
    function    Clone : TSGByteArray;
    //Возвращает копию с позиции AFrom по позицию ATo включительно
    function    ClonePart(AFrom, ATo : TLengthType) : TSGByteArray;
    //Отрезает часть массива начиная с позиции I и до конца
    procedure   Crop(I : TLengthType);
    //Отрезает часть массива с начала до позиции I(ChopHead - отрезать голову)
    procedure   ChopHead(I : TLengthType);
    //Удаляет из массива кусок от AFrom до ATo включительно, соотв.
    //уменьшая длину массива. При этом очевидно AFrom <= Ato
    procedure   Delete(AFrom, ATo : TLengthType);
    //Возвращает указатель на область памяти в которой собственно лежит массив.
    //Нужно для функций конвертирования. В обиходе напрямую не должно
    //использоваться.
    function    RawData : Pointer;
    //Нижняя граница массива (всегда 0)
    function    Low : TLengthType;
    //Верхняя граница массива (=Length-1)
    function    High : TLengthType;
    //Перераспределяет память под существующий массив.
    procedure   Realloc;
    //Возвращает True, если переданный массив равен внутреннему
    function    EqualTo(AB : TSGByteArray) : Boolean;
    //Преобразует массив TSGWordArray к TSGByteArray. Причем сначала идет
    //старший байт потом младший
    procedure   AssignWordHighLow(AB : TSGWordArray);
    //
    //Преобразует массив TSGWordArray к TSGByteArray. Причем сначала идет
    //младший байт потом старший
    procedure   AssignWordLowHigh(AB : TSGWordArray);
    //Показывает дамп информации, содержащейся в массиве
    function    Dump : String;override;
    //Эта строка добавляется в начало Dump'a. Перекрывается у потомков.
    function    DumpHeader : String; virtual;
    //Эта строка добавляется в конец Dump'a. Перекрывается у потомков.
    function    DumpFooter : String; virtual;  
    //Возвращает весь массив в виде строки
    function    AsString : String;
    //Загрузить данные из файла
    procedure   LoadFromFile(FileName : String);
    //Загрузить данные из потока
    procedure   LoadFromStream(Stream : TStream);
    //Сохранить данные в файл
    procedure   SaveToFile(FileName : String);
    //Сохранить данные в поток
    procedure   SaveToStream(Stream : TStream);
    //Дописать данные в поток с текущей позиции потока
    procedure AppendToStream(Stream: TStream);
    //свойство, которое дает и изменяет значения массива
    property    Items[Index : TLengthType]:Byte read Bytes write SetValue;
      default;
    //Ищет в массиве указанный байт и если находит, возвращает его
    //индекс, если нет, возвращает -1
    function    FindByte ( b : byte ):Int64;
  end;

  TSGWordArray = class(TSGEvent)
   private
    FCriticalSection : TCriticalSection;//Рабочая критическая секция
    FCapacity,                          //Емкость массива
    FLength : TLengthType;              //Используемая длина массива
    FArray : PWorkWordArray;            //Указатель на массив
    //Процедура наращивает емкость массива на 3 текущей длины
    procedure   Grow;
    //Изменяет емкость массива на NewCapacity
    procedure   SetCapacity(NewCapacity : TLengthType);
    //Вызывает исключение с сообщением, формируемым с помощью WordArrayMSGHeader
    //ProcName - имя процедуры, в которой произшла ошибка, Msg - сообщение.
    procedure   Error(const ProcName, Msg : String);
    //Вызывает процедуру Error, но сначала делает Format(Msg, Args), чтобы
    //подставить параметры в сообщение Msg
    procedure   ErrorFmt(
      const ProcName, Msg : String;
      const Args : array of const);
    //Читает свойство из потока
    procedure   ReadArrayData(Reader : TReader);
    //Сохраняет свойство в поток
    procedure   WriteArrayData(Writer : TWriter);
    //Инициализирует атрибуты экземпляра класса. Вызывается из конструкторов.
    procedure   Init;
   protected
    //Объявляет свойство, которое будет сохранено в поток
    procedure   DefineProperties(Filer : TFiler); override;
   public
    //Инициализация объектов, которые являются наследниками от TSGWordArray;
    procedure   Initialize;virtual;
    //Создает пустой массив
    constructor Create ( AOwner : TComponent ); override;
    //Создает массив и наполняет его переданными байтами
    constructor Summon(AB : array of Word);
    //Уничтожает объект и освобождает занимаемую память
    destructor  Destroy; override;
    //Устанавливает длину массива равной вновь переданной.
    //Если новая длина больше чем старая, размечает хвост нулями.
    //Если меньше, то вызыватеся ошибка.
    //Для обрезания данных надо испрользовать Crop
    procedure   SetLength(ALength : TLengthType);
    //Возвращает длину массива
    function    Length : TLengthType;
    //Дописывает байт в хвост массива
    procedure   AppendWord(Ab : Word);
    //Дописывает байты из указанного массива в свой хвост.
    procedure   AppendArray(AB : TSGWordArray);   overload;
    procedure   AppendArray(AB : array of Word);overload;
    //Устанавливает I-тый байт равным Avalue
    procedure   SetValue(I : TLengthType; AValue : Word);
    //Возвращает значение I-того байта
    function    Words(I : TLengthType) : Word;
    //Устанавливает значение массива в точности равным переданному.
    //Старые данные убиваются.
    procedure   AssignArray(AB : array of Word); overload;
    procedure   AssignArray(AB : TSGWordArray);    overload;
    //Очищает массив, устанавливает длину равной 0.
    procedure   Clear;
    //Вставляет байт b в I-тую позицию, сдвигая хвост и соотв.
    //увеличивая длину на 1
    procedure   InsertWord(I : TLengthType; b : Word);
    //Вставляет в I-тую позицию байты из указанного массива.
    procedure   InsertArray(I : TLengthType; AB : TSGWordArray);   overload;
    procedure   InsertArray(I : TLengthType; AB : array of Word);overload;
    //Возвращает копию массива
    function    Clone : TSGWordArray;
    //Возвращает копию с позиции AFrom по позицию ATo включительно
    function    ClonePart(AFrom, ATo : TLengthType) : TSGWordArray;
    //Отрезает часть массива начиная с позиции I и до конца
    procedure   Crop(I : TLengthType);
    //Отрезает часть массива с начала до позиции I(ChopHead - отрезать голову)
    procedure   ChopHead(I : TLengthType);
    //Удаляет из массива кусок от AFrom до ATo включительно, соотв.
    //уменьшая длину массива. При этом очевидно AFrom <= Ato
    procedure   Delete(AFrom, ATo : TLengthType);
    //Возвращает указатель на область памяти в которой собственно лежит массив.
    //Нужно для функций конвертирования.
    //В обиходе напрямую не должно использоваться.
    function    RawData : Pointer;
    //Нижняя граница массива (всегда 0)
    function    Low : TLengthType;
    //Верхняя граница массива (=Length-1)
    function    High : TLengthType;
    //Перераспределяет память под существующий массив.
    procedure   Realloc;
    //Возвращает True, если переданный массив равен внутреннему
    function    EqualTo(AB : TSGWordArray) : Boolean;
    //Преобразует массив TSGByteArray к TSGWordArray. Причем сначала идет
    //старший байт потом младший
    procedure   AssignByteHighLow(AB : TSGByteArray);
    //
    //Преобразует массив TSGByteArray к TSGWordArray. Причем сначала идет
    //младший байт потом старший
    procedure   AssignByteLowHigh(AB : TSGByteArray);
    //Показывает дамп информации, содержащейся в массиве
    function    Dump : String; override;
    //Эта строка добавляется в начало Dump'a. Перекрывается у потомков.
    function    DumpHeader : String; virtual;
    //Эта строка добавляется в конец Dump'a. Перекрывается у потомков.
    function    DumpFooter : String; virtual;
    //Загрузить данные из файла
    procedure   LoadFromFileLowHigh(FileName : String);
    //Загрузить данные из потока
    procedure   LoadFromStreamLowHigh(Stream : TStream);
    //Загрузить данные из файла
    procedure   LoadFromFileHighLow(FileName : String);
    //Загрузить данные из потока
    procedure   LoadFromStreamHighLow(Stream : TStream);
    //Сохранить данные в файл
    procedure   SaveToFileLowHigh(FileName : String);
    //Сохранить данные в поток
    procedure   SaveToStreamLowHigh(Stream : TStream);
    //Сохранить данные в файл
    procedure   SaveToFileHighLow(FileName : String);
    //Сохранить данные в поток
    procedure   SaveToStreamHighLow(Stream : TStream);
    //свойство, которое дает и изменяет значения массива
    property    Items[Index : TLengthType]:Word read Words write SetValue;
      default;
  end;

implementation

{ TSGByteArray }

procedure TSGByteArray.AppendArray(AB: TSGByteArray);
var
  AddLength,
  NewCapacity : TLengthType;
begin
  FCriticalSection.Enter;
  try
    AddLength := AB.Length;
    try
      NewCapacity := FLength + AddLength;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      System.Move(AB.FArray^, FArray^[FLength], AddLength*SizeOf(Byte));
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AppendArray', NewLength,
          [System.High ( TLengthType ),
           FLength - System.High(TLengthType) + AddLength]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.AppendArray(AB: array of byte);
var
  I,
  NewCapacity : TLengthType;
begin
  if System.Length(AB) = 0 then Exit;
  FCriticalSection.Enter;
  try
    try
      NewCapacity := FLength + Cardinal(System.Length(AB));
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      for I := System.Low(AB) to System.High(AB) do FArray^[FLength+i] := AB[i];
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AppendArray', NewLength,
          [System.High ( TLengthType ),
           FLength - System.High(TLengthType) + Cardinal(System.Length(AB))]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.AppendByte(Ab: Byte);
begin
  FCriticalSection.Enter;
  try
    if FLength = FCapacity then
      Grow;
    FArray^[FLength] := Ab;
    Inc(FLength);
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.AssignArray(AB: array of byte);
var
  I,
  NewCapacity : TLengthType;
begin
  FCriticalSection.Enter;
  try
    try
      NewCapacity := System.Length(AB);
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      if NewCapacity <> 0 then
        for I := System.Low(AB) to System.High(AB) do FArray^[i] := AB[i];
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AssignArray', NewLength,
          [System.High ( TLengthType ),
           Cardinal(System.Length(AB))- System.High(TLengthType)]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.AssignArray(AB: TSGByteArray);
var
  NewCapacity : TLengthType;
begin
  if AB = Self then Exit;
  FCriticalSection.Enter;
  try
    try
      NewCapacity := AB.Length;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      System.Move(AB.FArray^, FArray^, NewCapacity*SizeOf(Byte));
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AssignArray', NewLength,
          [System.High ( TLengthType ), AB.Length-System.High(TLengthType)]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

function TSGByteArray.Bytes(I: TLengthType): byte;
begin
  //Комментарий {(I < 0) or } стоит для того, чтобы напоминать, что I не может
  // быть меньше 0. Это не может тип TLengthType
  if {(I < 0) or }(I >= FLength) then
    Error('Bytes', RangeCheckError);
  Result := FArray^[i];
end;

procedure TSGByteArray.Clear;
begin
  FCriticalSection.Enter;
  try
    FillChar(FArray^, FCapacity*SizeOf(Byte), 0);
    FLength := 0;
  finally
    FCriticalSection.Leave;
  end;
end;

function TSGByteArray.Clone: TSGByteArray;
begin
  if Length > 0 then
    Result := ClonePart(Low, High)
  else
    Result := TSGByteArray.Create(nil);
end;

function TSGByteArray.ClonePart(AFrom, ATo: TLengthType): TSGByteArray;
begin
  if (AFrom > ATo) or (AFrom < Low) or (ATo > High) then
    Error('ClonePart', RangeCheckError);
  Result := TSGByteArray.Create ( NIL );
  if FLength <> 0 then begin
    FCriticalSection.Enter;
    try
      Result.SetLength(ATo-AFrom+1);
      System.Move(FArray^[AFrom], Result.FArray^, Result.Length*SizeOf(Byte));
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TSGByteArray.Init;
begin
  FCriticalSection := TCriticalSection.Create;
  FLength := 0;
  FCapacity := 16;
  FArray := nil;
  ReallocMem(FArray, FCapacity*SizeOf(Byte));
  Initialize;
end;

constructor TSGByteArray.Summon(AB: array of byte);
begin
  inherited Create(nil);
  Init;
  AssignArray(AB);
end;

constructor TSGByteArray.Create( AOwner : TComponent );
begin
  inherited Create(nil);
  Init;
end;

procedure TSGByteArray.Crop(I: TLengthType);
begin
  Delete(I, High);
//  if {(I < 0) or }(I >= FLength) then
{
    Error('Crop', RangeCheckError);
  FCriticalSection.Enter;
  try
    FLength := I;
    SetCapacity(I);
  finally
    FCriticalSection.Leave;
  end;
}  
end;

procedure TSGByteArray.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('ArrayData', ReadArrayData, WriteArrayData, True)
end;

procedure TSGByteArray.Delete(AFrom, ATo: TLengthType);
begin
  if (AFrom > ATo) or (AFrom < Low) or (ATo > High) or (FLength = 0)then
    Error('Delete', RangeCheckError);
  FCriticalSection.Enter;
  try
    if ATo < FLength-1 then
      System.Move(FArray^[ATo + 1], FArray^[AFrom],
        (FLength - 1 - ATo) * SizeOf(Byte));
    FLength := FLength - (ATo - AFrom + 1);
  finally
    FCriticalSection.Leave;
  end;
end;

destructor TSGByteArray.Destroy;
begin
  FLength := 0;
  FCapacity := 0;
  FreeMem(FArray);
  FCriticalSection.Free;
  inherited;  
end;

function TSGByteArray.EqualTo(AB: TSGByteArray): Boolean;
begin
  if AB = Self then
    Result := True
  else
    if AB.Length <> FLength then
      Result := False
    else
      Result := CompareMem(FArray, AB.FArray, FLength);
end;

procedure TSGByteArray.Error(const ProcName, Msg : String);
begin
  raise Exception.CreateFmt(ByteArrayMSGHeader, [ProcName, Msg])
end;

procedure TSGByteArray.ErrorFmt(const ProcName, Msg : String;
  const Args : array of const);
var
  Str : String;
begin
  Str := Format(Msg, Args);
  Error(ProcName, Str);
end;

procedure TSGByteArray.Grow;
var
  Delta,
  NewCapacity : TLengthType;
begin
  try
    if FCapacity > 64 then
      Delta := FCapacity div 4
    else
      if FCapacity > 8 then
        Delta := 16
      else
        Delta := 4;
    NewCapacity := FCapacity + Delta;
    SetCapacity(NewCapacity);
  except
    if FCapacity = MaxByteArraySize{System.High ( TLengthType )} then
      ErrorFmt('Grow', FullArray, [FCapacity])
    else begin
      NewCapacity := MaxByteArraySize; //System.High ( TLengthType );
      SetCapacity(NewCapacity);
    end;
  end;
end;

function TSGByteArray.High: TLengthType;
begin
  if FLength = 0 then
    Result := 0
  else
    Result := FLength-1;
end;

procedure TSGByteArray.InsertArray(I: TLengthType; AB: TSGByteArray);
var
  NewCapacity, AddLength : TLengthType;
begin
  if AB = Self then
    Error('InsertArray', InsertHimself);
  {TODO : Подумать над тем, как обрабатывать эту ситуацию: если будут вставлять
    его самого. Замечание на будущее.
  }
  if {(I < 0) or }(I > FLength) then
    Error('InsertArray', RangeCheckError)
  else
    if (I = FLength) then
      AppendArray(AB)
    else begin
      FCriticalSection.Enter;
      try
        AddLength := AB.Length;
        try
          NewCapacity := FLength + AddLength;
          if NewCapacity > FCapacity then
            SetCapacity(NewCapacity);
          System.Move(FArray^[I], FArray^[I + AddLength],
            (FLength - I) * SizeOf(Byte));
          System.Move(AB.FArray^, FArray^[I], AddLength* SizeOf(Byte));
          Inc(FLength, AddLength);
        except
          on ERangeError do
            ErrorFmt('InsertArray', NewLength,
              [System.High ( TLengthType ),
               FLength - System.High(TLengthType) + AddLength]);
          on E:Exception do
            raise Exception.Create(E.Message);
        end;
      finally
        FCriticalSection.Leave;
      end;
    end;
end;

procedure TSGByteArray.InsertArray(I: TLengthType; AB: array of byte);
var
  NewCapacity,
  J,
  AddLength : TLengthType;
begin
  if {(I < 0) or }(I > FLength) then
    Error('InsertArray', RangeCheckError)
  else
    if (I = FLength) then
      AppendArray(AB)
    else begin
      FCriticalSection.Enter;
      try
        AddLength := System.Length(AB);
        if AddLength <> 0 then
          try
            NewCapacity := FLength + AddLength;
            if NewCapacity > FCapacity then
              SetCapacity(NewCapacity);
            System.Move(FArray^[I], FArray^[I + AddLength],
              (FLength - I) * SizeOf(Byte));
            for J := System.Low(AB) to System.High(AB) do
              FArray^[i+j] := AB[j];
            Inc(FLength, AddLength);
          except
            on ERangeError do
              ErrorFmt('InsertArray', NewLength,
                [System.High ( TLengthType ),
                 FLength - System.High(TLengthType) + AddLength]);
            on E:Exception do
              raise Exception.Create(E.Message);
          end;
      finally
        FCriticalSection.Leave;
      end;
    end;
end;

procedure TSGByteArray.InsertByte(I: TLengthType; b: Byte);
begin
  if {(I < 0) or }(I > FLength) then
    Error('InsertByte', RangeCheckError)
  else
    if (I = FLength) then
      AppendByte(B)
    else begin
      FCriticalSection.Enter;
      try
        if FLength = FCapacity then
          Grow;
        System.Move(FArray^[I], FArray^[I + 1],
          (FLength - I) * SizeOf(Byte));
        FArray^[i] := b;
        Inc(FLength);
      finally
        FCriticalSection.Leave;
      end;
    end;
end;

function TSGByteArray.Length: TLengthType;
begin
  Result := FLength;
end;

function TSGByteArray.Low: TLengthType;
begin
  if FLength = 0 then
    Result := 1
  else
    Result := 0;
  //TODO : Помнить о значениях, возвращаемых в зависимости от длины
  //Если длина равна 0, то Low = 1, High = 0
end;

function TSGByteArray.RawData: Pointer;
begin
  Result := FArray;
end;

procedure TSGByteArray.ReadArrayData(Reader: TReader);
var
  NewCapacity : TLengthType;
begin
  Reader.Read(NewCapacity, SizeOf(TLengthType));
  FCriticalSection.Enter;
  try
    if NewCapacity > FCapacity then
      SetCapacity(NewCapacity);
    Reader.Read(FArray^, NewCapacity*SizeOf(Byte));
    FLength := NewCapacity;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.Realloc;
begin
  FCriticalSection.Enter;
  try
    ReallocMem(FArray, FCapacity*SizeOf(Byte));
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.SetCapacity(NewCapacity: TLengthType);
begin
  if (NewCapacity < FLength) then
    ErrorFmt('SetCapacity', CapacityError, [NewCapacity, FLength])
  else
    if (NewCapacity > MaxByteArraySize) then
      ErrorFmt('SetCapacity', MaxCapacityError,[NewCapacity, MaxByteArraySize]);
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FArray, NewCapacity * SizeOf(Byte));
    FCapacity := NewCapacity;
  end;
end;

procedure TSGByteArray.SetLength(ALength: TLengthType);
begin
  if (ALength < FLength) then
    ErrorFmt('SetLength', LengthError, [ALength, FLength]);
  FCriticalSection.Enter;
  try
    if ALength > FCapacity then
      SetCapacity(ALength);
    if ALength > FLength then
      FillChar(FArray^[FLength], (ALength - FLength) * SizeOf(Byte), 0);
    FLength := ALength;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.SetValue(I: TLengthType; AValue: byte);
begin
  if {(I < 0) or }(I >= FLength) then
    Error('SetValue', RangeCheckError);
  FCriticalSection.Enter;
  try
    FArray^[i] := AValue;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.WriteArrayData(Writer: TWriter);
begin
  Writer.Write(FLength, SizeOf(TLengthType));
  Writer.Write(FArray^, FLength*SizeOf(Byte));
end;

procedure TSGByteArray.AssignWordHighLow(AB: TSGWordArray);
var
  I,
  NewCapacity : TLengthType;
  WorkWord : Word;
begin
  FCriticalSection.Enter;
  try
    try
      NewCapacity := AB.Length * 2;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      if NewCapacity <> 0 then
        for I := AB.Low to AB.High do begin
          WorkWord := AB.FArray^[i];
          FArray^[i*2] := PTwoByteArray( Addr ( WorkWord ) )^[boHigh];
          FArray^[i*2+1] := PTwoByteArray( Addr ( WorkWord ) )^[boLow];
        end;
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AssignWordHighLow', NewLength,
          [System.High ( TLengthType ),
          (AB.Length*2)-System.High(TLengthType)]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.AssignWordLowHigh(AB: TSGWordArray);
var
  NewCapacity : TLengthType;
begin
  FCriticalSection.Enter;
  try
    try
      NewCapacity := AB.Length * 2;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      System.Move(AB.FArray^, FArray^, NewCapacity*SizeOf(Byte));
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AssignWordLowHigh', NewLength,
          [System.High ( TLengthType ),
          (AB.Length*2)-System.High(TLengthType)]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

function TSGByteArray.Dump: String;
{Вызов функции Dump должен выдавать следующую строку:
Длина пакета составляет 14 байт.
C7.81.03.02.00.57.00.00___........
00.0E.00.36.00.00.        ......

Точки после трех разделительных пробелом ставятся только если код символа
меньше 32.
}
var
  I : TLengthType;
  OutPutLen,            //Действительное число выданных слов
  LeftOverSpaceCount,
  LeftOver,
  j,
  CurrPos,             //Текущая позиция курсора в строке
  CharCount : LongInt; //Количество символов в строке
  HeaderStr,           //заголовок
  FooterStr,           //окончание
  ErrorStr,            //Строка ошибки
  SignStr,             //Строка, в которой байты как символы
  ByteStr : String;
begin
  FCriticalSection.Enter;
  Result := '';
  ErrorStr := '';
  try
    HeaderStr := DumpHeader;
    FooterStr := DumpFooter;
    if FLength <= MaxOutputByteInDump then
      OutPutLen := LongInt(FLength)
    else begin
      ErrorStr := Format(OutInDump, [FLength, MaxOutputByteInDump,
                                     FLength - MaxOutputByteInDump]);
      OutPutLen := MaxOutputByteInDump;
    end;
{
    Это альтернативный код, который использует конкатенацию строк.
    Оставлен на всякий случай.
    Работает очень медленно.

    Result := Format(FirstStringInDump, [OutPutLen, 'байт']);
    SignStr := '';
    LeftOver := OutPutLen mod DumpStrLength;
    LeftOverSpaceCount := (DumpStrLength-LeftOver)*(CharInByte+1);
    for I := 0 to OutPutLen-1 do begin
      ByteStr := IntToHex(FArray^[i], CharInByte) + '.';
      if FArray^[i] >= Ord(' ') then
        SignStr := SignStr + Chr(FArray^[i])
      else
        SignStr := SignStr + '.';
      Result := Concat(Result, ByteStr);
      if (((I+1) mod DumpStrLength) = 0) then begin
        Result := Copy(Result, 1, System.Length(Result));
        Result := Concat(Result, '  ', SignStr, #13#10);
        SignStr := '';
      end;
    end;
    if LeftOver > 0 then begin
      ByteStr := '';
      for j := 1 to LeftOverSpaceCount + 2 do
        ByteStr := ByteStr + ' ';
      Result := Concat(Result, ByteStr, SignStr);
    end;
}

{
}
    ByteStr := Format(FirstStringInDump, [OutPutLen, 'байт']);
         // Всего символов  байт->hex    .  Chr(Bytes(i))
    CharCount := OutPutLen*(CharInByte + 1 + 1);
      //Добавляем два пробела после символов и #13#10 в конце строки
    CharCount := CharCount + LongInt((OutPutLen div DumpStrLength)*4);
    //Добавляем начальную строку
    CharCount := CharCount + System.Length(ByteStr);
    //Добавляем заголовок
    CharCount := CharCount + System.Length(HeaderStr);
    //Добавляем окончание
    CharCount := CharCount + System.Length(FooterStr);
    //Добавляем строку ошибки
    if ErrorStr <> '' then
      CharCount := CharCount + System.Length(ErrorStr);
    //Считает остаток
    LeftOver := OutPutLen mod DumpStrLength;
    //Остаток забиваем пробелами
    LeftOverSpaceCount := (DumpStrLength-LeftOver)*(CharInByte+1);

    if LeftOver > 0 then
      //Добавляем отаточные пробелы и разделительные пробелы
      Inc(CharCount, 2 + LeftOverSpaceCount);
               //   ^^^ Разделительный пробел
    System.SetString (Result, nil, CharCount);
    CurrPos := 1;

    //Вставляем заголовок
    for j := 1 to System.Length(HeaderStr) do
      Result[CurrPos+j-1] := HeaderStr[j];
    Inc(CurrPos, System.Length(HeaderStr));

    //Вставляем строку ошибки
    if ErrorStr <> '' then begin
      for j := 1 to System.Length(ErrorStr) do
        Result[CurrPos+j-1] := ErrorStr[j];
      Inc(CurrPos, System.Length(ErrorStr));
    end;

    //Вставляем начальную строку
    for j := 1 to System.Length(ByteStr) do
      Result[CurrPos+j-1] := ByteStr[j];
    Inc(CurrPos, System.Length(ByteStr));
    SignStr := '';

    //Цикл по каждому байту массива
    if OutPutLen > 0 then
    for I := 0 to OutPutLen-1 do begin
      ByteStr := IntToHex(FArray^[i], CharInByte) + '.';
      if FArray^[i] >= Ord(' ') then
        SignStr := SignStr + Chr(FArray^[i])
      else
        SignStr := SignStr + '.';
      //Преносим символьное представление байта в строку
      for J := 1 to CharInByte + 1 do
        Result[CurrPos+j-1] := ByteStr[j];
      Inc(CurrPos, CharInByte + 1);
      //Если обработали 8 байт
      if (((I+1) mod DumpStrLength) = 0) then begin
        //Уменьшаем позицию и затираем последнюю точку.
        Dec(CurrPos);
        //заполняем три разделительных пробела
        for j := 1 to 3 do
          Result[CurrPos+j-1] := ' ';
        Inc(CurrPos, 3);
        //заполняем строку символов
        for J := 1 to DumpStrLength do
          Result[CurrPos+j-1] := SignStr[j];
        SignStr := '';
        Inc(CurrPos, DumpStrLength);
        //Возврат коретки
        Result[CurrPos] := #13;
        Result[CurrPos+1] := #10;
        Inc(CurrPos, 2);
      end;
    end;
    if LeftOver > 0 then begin
      //Вносим пробелы на место, где нет байтов и разделитьтельные проблелы
      for j := 1 to LeftOverSpaceCount + 2 do
        Result[CurrPos+j-1] := ' ';
      Inc(CurrPos, LeftOverSpaceCount + 2);
      //заполняем остаточную строку символов
      for J := 1 to LeftOver do
        Result[CurrPos+j-1] := SignStr[j];
      SignStr := '';
    end;
    //Вставляем окончание
    for j := 1 to System.Length(FooterStr) do
      Result[CurrPos+j-1] := FooterStr[j];
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.Initialize;
begin
  {Пустая часть. У наследников может быть заполнена}
end;

procedure TSGByteArray.LoadFromFile(FileName: String);
var
  Stream: TStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  except
    on EStreamError do
      ErrorFmt('LoadFromFile', ErrorLoadFromFile, [FileName]);
    on E:Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TSGByteArray.LoadFromStream(Stream: TStream);
var
  NewCapacity : TLengthType;
begin
  FCriticalSection.Enter;
  try
    try
      NewCapacity := Stream.Size;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      Stream.Position := 0;
      Stream.ReadBuffer(FArray^, NewCapacity*SizeOf(Byte));
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('LoadFromStream', NewLength,
          [System.High ( TLengthType ),
           Cardinal(Stream.Size)-System.High(TLengthType)]);
      on EReadError do
        Error('LoadFromStream', ErrorLoadFromStream);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.SaveToFile(FileName: String);
var
  Stream: TStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmCreate);
    try                      
      SaveToStream(Stream);
    finally
      Stream.Free;
    end;
  except
    on EStreamError do
      ErrorFmt('SaveToFile', ErrorSaveToFile, [FileName]);
    on E:Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TSGByteArray.SaveToStream(Stream: TStream);
begin
  FCriticalSection.Enter;
  try
    try
      Stream.Position := 0;
      Stream.WriteBuffer(FArray^, FLength*SizeOf(Byte));
    except
      Error('SaveToStream', ErrorSaveToStream);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGByteArray.AppendToStream(Stream: TStream);
begin
  FCriticalSection.Enter;
  try
    try
      Stream.WriteBuffer(FArray^, FLength*SizeOf(Byte));
    except
      Error('SaveToStream', ErrorSaveToStream);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

function TSGByteArray.DumpFooter: String;
begin
  //Перекрывается у потомков.
  Result := '';
end;

function TSGByteArray.DumpHeader: String;
begin
  //Перекрывается у потомков.
  Result := '';
end;

procedure TSGByteArray.ChopHead(I: TLengthType);
begin
  Delete(Low, I);
end;

constructor TSGByteArray.Summon(Str: String);
begin
  inherited Create(nil);
  Init;
  AppendString(Str);
end;

procedure TSGByteArray.AppendChar(Sign: Char);
begin
  AppendByte(byte(Sign));
end;

procedure TSGByteArray.AppendString(Str: String);
var
  I,
  NewCapacity : TLengthType;
begin
  if System.Length(Str) = 0 then Exit;
  FCriticalSection.Enter;
  try
    try
      NewCapacity := FLength + Cardinal(System.Length(Str));
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      for I := 1 to System.Length(Str) do FArray^[FLength+i-1] := byte(Str[i]);
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AppendString', NewLength,
          [System.High ( TLengthType ),
           FLength - System.High(TLengthType) + Cardinal(System.Length(Str))]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;


function TSGByteArray.AsString: String;
begin
  FCriticalSection.Enter;
  try
    Result := '';
    SetString(Result, PChar(FArray), Length);
  except
    FCriticalSection.Leave;
  end;
end;

function TSGByteArray.FindByte(b: byte): Int64;
var
 i : integer;
begin
 FCriticalSection.Enter;
 try
   if Length = 0 then
    begin
     Result := -1;
     exit;
    end;
   for i := 0 to Length - 1 do
    if FArray^[i] = b then
     begin
      Result := i;
      exit;
     end;
   Result := -1;
  finally
   FCriticalSection.Leave;
 end;
end;

{ TSGWordArray }

procedure TSGWordArray.AppendArray(AB: TSGWordArray);
var
  AddLength,
  NewCapacity : TLengthType;
begin
  FCriticalSection.Enter;
  try
    AddLength := AB.Length;
    try
      NewCapacity := FLength + AddLength;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      System.Move(AB.FArray^, FArray^[FLength], AddLength*SizeOf(Word));
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AppendArray', NewLength,
          [System.High ( TLengthType ),
           FLength - System.High(TLengthType) + AddLength]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.AppendArray(AB: array of Word);
var
  I,
  NewCapacity : TLengthType;
begin
  if System.Length(AB) = 0 then Exit;
  FCriticalSection.Enter;
  try
    try
      NewCapacity := FLength + Cardinal(System.Length(AB));
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      for I := System.Low(AB) to System.High(AB) do FArray^[FLength+i] := AB[i];
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AppendArray', NewLength,
          [System.High ( TLengthType ),
           FLength - System.High(TLengthType) + Cardinal(System.Length(AB))]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.AppendWord(Ab: Word);
begin
  FCriticalSection.Enter;
  try
    if FLength = FCapacity then
      Grow;
    FArray^[FLength] := Ab;
    Inc(FLength);
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.AssignArray(AB: array of Word);
var
  I,
  NewCapacity : TLengthType;
begin
  FCriticalSection.Enter;
  try
    try
      NewCapacity := System.Length(AB);
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      if NewCapacity <> 0 then
        for I := System.Low(AB) to System.High(AB) do FArray^[i] := AB[i];
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AssignArray', NewLength,
          [System.High ( TLengthType ),
           System.Length(AB)- LongInt(System.High(TLengthType))]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.AssignArray(AB: TSGWordArray);
var
  NewCapacity : TLengthType;
begin
  if AB = Self then Exit;
  FCriticalSection.Enter;
  try
    try
      NewCapacity := AB.Length;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      System.Move(AB.FArray^, FArray^, NewCapacity*SizeOf(Word));
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AssignArray', NewLength,
          [System.High ( TLengthType ), AB.Length-System.High(TLengthType)]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

function TSGWordArray.Words(I: TLengthType): Word;
begin
  if {(I < 0) or }(I >= FLength) then
    Error('Words', RangeCheckError);
  Result := FArray^[i];
end;

procedure TSGWordArray.Clear;
begin
  FCriticalSection.Enter;
  try
    FillChar(FArray^, FCapacity*SizeOf(Word), 0);
    FLength := 0;
  finally
    FCriticalSection.Leave;
  end;
end;

function TSGWordArray.Clone: TSGWordArray;
begin
  if Length > 0 then
    Result := ClonePart(Low, High)
  else
    Result := TSGWordArray.Create(nil);
end;

function TSGWordArray.ClonePart(AFrom, ATo: TLengthType): TSGWordArray;
begin
  if (AFrom > ATo) or (AFrom < Low) or (ATo > High) then
    Error('ClonePart', RangeCheckError);
  Result := TSGWordArray.Create ( NIL );
  if FLength <> 0 then begin
    FCriticalSection.Enter;
    try
      Result.SetLength(ATo-AFrom+1);
      System.Move(FArray^[AFrom], Result.FArray^, Result.Length*SizeOf(Word));
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TSGWordArray.Init;
begin
  FCriticalSection := TCriticalSection.Create;
  FLength := 0;
  FCapacity := 16;
  FArray := nil;
  ReallocMem(FArray, FCapacity*SizeOf(Word));
  Initialize;
end;

constructor TSGWordArray.Summon(AB: array of Word);
begin
  inherited Create(nil);
  Init;
  AssignArray(AB);
end;

constructor TSGWordArray.Create( AOwner : TComponent );
begin
  inherited Create(nil);
  Init;
end;

procedure TSGWordArray.Crop(I: TLengthType);
begin
  Delete(I, High);
//  if {(I < 0) or }(I >= FLength) then
{
    Error('Crop', RangeCheckError);
  FCriticalSection.Enter;
  try
    FLength := I;
    SetCapacity(I);
  finally
    FCriticalSection.Leave;
  end;
}  
end;

procedure TSGWordArray.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('ArrayData', ReadArrayData, WriteArrayData, True)
end;

procedure TSGWordArray.Delete(AFrom, ATo: TLengthType);
begin
  if (AFrom > ATo) or (AFrom < Low) or (ATo > High) or (FLength = 0)then
    Error('Delete', RangeCheckError);
  FCriticalSection.Enter;
  try
    if ATo < FLength-1 then
      System.Move(FArray^[ATo + 1], FArray^[AFrom],
        (FLength - 1 - ATo) * SizeOf(Word));
    FLength := FLength - (ATo - AFrom + 1);
  finally
    FCriticalSection.Leave;
  end;
end;

destructor TSGWordArray.Destroy;
begin
  FLength := 0;
  FCapacity := 0;
  FreeMem(FArray);
  FCriticalSection.Free;
  inherited;  
end;

function TSGWordArray.EqualTo(AB: TSGWordArray): Boolean;
begin
  if AB = Self then
    Result := True
  else
    if AB.Length <> FLength then
      Result := False
    else
      Result := CompareMem(FArray, AB.FArray, FLength);
end;

procedure TSGWordArray.Error(const ProcName, Msg : String);
begin
  raise Exception.CreateFmt(WordArrayMSGHeader, [ProcName, Msg])
end;

procedure TSGWordArray.ErrorFmt(const ProcName, Msg : String;
  const Args : array of const);
var
  Str : String;
begin
  Str := Format(Msg, Args);
  Error(ProcName, Str);
end;

procedure TSGWordArray.Grow;
var
  Delta,
  NewCapacity : TLengthType;
begin
  try
    if FCapacity > 64 then
      Delta := FCapacity div 4
    else
      if FCapacity > 8 then
        Delta := 16
      else
        Delta := 4;
    NewCapacity := FCapacity + Delta;
    SetCapacity(NewCapacity);
  except
    if FCapacity = MaxWordArraySize then
      ErrorFmt('Grow', FullArray, [FCapacity])
    else begin
      NewCapacity := MaxWordArraySize;
      SetCapacity(NewCapacity);
    end;
  end;
end;

function TSGWordArray.High: TLengthType;
begin
  if FLength = 0 then
    Result := 0
  else
    Result := FLength-1;
end;

procedure TSGWordArray.InsertArray(I: TLengthType; AB: TSGWordArray);
var
  NewCapacity, AddLength : TLengthType;
begin
  if AB = Self then
    Error('InsertArray', InsertHimself);
  {TODO : Подумать над тем, как обрабатывать эту ситуацию : см. выше}
  if {(I < 0) or }(I > FLength) then
    Error('InsertArray', RangeCheckError)
  else
    if (I = FLength) then
      AppendArray(AB)
    else begin
      FCriticalSection.Enter;
      try
        AddLength := AB.Length;
        try
          NewCapacity := FLength + AddLength;
          if NewCapacity > FCapacity then
            SetCapacity(NewCapacity);
          System.Move(FArray^[I], FArray^[I + AddLength],
            (FLength - I) * SizeOf(Word));
          System.Move(AB.FArray^, FArray^[I], AddLength* SizeOf(Word));
          Inc(FLength, AddLength);
        except
          on ERangeError do
            ErrorFmt('InsertArray', NewLength,
              [System.High ( TLengthType ),
               FLength - System.High(TLengthType) + AddLength]);
          on E:Exception do
            raise Exception.Create(E.Message);
        end;
      finally
        FCriticalSection.Leave;
      end;
    end;
end;

procedure TSGWordArray.InsertArray(I: TLengthType; AB: array of Word);
var
  NewCapacity,
  J,
  AddLength : TLengthType;
begin
  if System.Length(AB) = 0 then Exit;
  if {(I < 0) or }(I > FLength) then
    Error('InsertArray', RangeCheckError)
  else
    if (I = FLength) then
      AppendArray(AB)
    else begin
      FCriticalSection.Enter;
      try
        AddLength := System.Length(AB);
        if AddLength <> 0 then
          try
            NewCapacity := FLength + AddLength;
            if NewCapacity > FCapacity then
              SetCapacity(NewCapacity);
            System.Move(FArray^[I], FArray^[I + AddLength],
              (FLength - I) * SizeOf(Word));
            for J := System.Low(AB) to System.High(AB) do
              FArray^[i+j] := AB[j];
            Inc(FLength, AddLength);
          except
            on ERangeError do
              ErrorFmt('InsertArray', NewLength,
                [System.High ( TLengthType ),
                 FLength - System.High(TLengthType) + AddLength]);
            on E:Exception do
              raise Exception.Create(E.Message);
          end;
      finally
        FCriticalSection.Leave;
      end;
    end;
end;

procedure TSGWordArray.InsertWord(I: TLengthType; b: Word);
begin
  if {(I < 0) or }(I > FLength) then
    Error('InsertWord', RangeCheckError)
  else
    if (I = FLength) then
      AppendWord(B)
    else begin
      FCriticalSection.Enter;
      try
        if FLength = FCapacity then
          Grow;
        System.Move(FArray^[I], FArray^[I + 1],
          (FLength - I) * SizeOf(Word));
        FArray^[i] := b;
        Inc(FLength);
      finally
        FCriticalSection.Leave;
      end;
    end;
end;

function TSGWordArray.Length: TLengthType;
begin
  Result := FLength;
end;

function TSGWordArray.Low: TLengthType;
begin
  if FLength = 0 then
    Result := 1
  else
    Result := 0;
  //TODO : Помнить о значениях, возвращаемых в зависимости от длины : см. выше
end;

function TSGWordArray.RawData: Pointer;
begin
  Result := FArray;
end;

procedure TSGWordArray.ReadArrayData(Reader: TReader);
var
  NewCapacity : TLengthType;
begin
  Reader.Read(NewCapacity, SizeOf(TLengthType));
  FCriticalSection.Enter;
  try
    if NewCapacity > FCapacity then
      SetCapacity(NewCapacity);
    Reader.Read(FArray^, NewCapacity*SizeOf(Word));
    FLength := NewCapacity;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.Realloc;
begin
  FCriticalSection.Enter;
  try
    ReallocMem(FArray, FCapacity*SizeOf(Word));
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.SetCapacity(NewCapacity: TLengthType);
begin
  if (NewCapacity < FLength) then
    ErrorFmt('SetCapacity', CapacityError, [NewCapacity, FLength])
  else
    if (NewCapacity > MaxWordArraySize) then
      ErrorFmt('SetCapacity', MaxCapacityError,[NewCapacity, MaxWordArraySize]);
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FArray, NewCapacity * SizeOf(Word));
    FCapacity := NewCapacity;
  end;
end;

procedure TSGWordArray.SetLength(ALength: TLengthType);
begin
  if (ALength < FLength) then
    ErrorFmt('SetLength', LengthError, [ALength, FLength]);
  FCriticalSection.Enter;
  try
    if ALength > FCapacity then
      SetCapacity(ALength);
    if ALength > FLength then
      FillChar(FArray^[FLength], (ALength - FLength) * SizeOf(Word), 0);
    FLength := ALength;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.SetValue(I: TLengthType; AValue: Word);
begin
  if {(I < 0) or }(I >= FLength) then
    Error('SetValue', RangeCheckError);
  FCriticalSection.Enter;
  try
    FArray^[i] := AValue;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.WriteArrayData(Writer: TWriter);
begin
  Writer.Write(FLength, SizeOf(TLengthType));
  Writer.Write(FArray^, FLength*SizeOf(Word));
end;

procedure TSGWordArray.AssignByteHighLow(AB: TSGByteArray);
var
  I,
  NewCapacity : TLengthType;
  WorkWord : Word;
begin
  FCriticalSection.Enter;
  try
    if AB.Length mod 2 <> 0 then
      Error('AssignByteHighLow', OddArray);
    try
      NewCapacity := AB.Length div 2;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      if NewCapacity <> 0 then
        for I := 0 to NewCapacity-1 do begin
          PTwoByteArray( Addr ( WorkWord ) )^[boHigh] := AB.FArray^[i*2];
          PTwoByteArray( Addr ( WorkWord ) )^[boLow] := AB.FArray^[i*2+1];
          FArray^[i] := WorkWord;
        end;
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AssignByteHighLow', NewLength,
          [System.High ( TLengthType ),
          (AB.Length div 2)-System.High(TLengthType)]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.AssignByteLowHigh(AB: TSGByteArray);
var
  NewCapacity : TLengthType;
begin
  FCriticalSection.Enter;
  try
    if AB.Length mod 2 <> 0 then
      Error('AssignByteLowHigh', OddArray);
    try
      NewCapacity := AB.Length div 2;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      System.Move(AB.FArray^, FArray^, (NewCapacity)*SizeOf(Word));
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('AssignByteLowHigh', NewLength,
          [System.High ( TLengthType ),
          (AB.Length div 2)-System.High(TLengthType)]);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

function TSGWordArray.Dump: String;
var
  I : TLengthType;
  OutPutLen,            //Действительное число выданных слов
  j,
  CurrPos,              //Текущая позиция курсора в строке
  CharCount : LongInt;  //Количество символов в строке
  HeaderStr,           //заголовок
  FooterStr,           //окончание
  ErrorStr,             //Строка ошибки
  WordStr : String;
begin
  FCriticalSection.Enter;
  Result := '';
  ErrorStr := '';
  try
    HeaderStr := DumpHeader;
    FooterStr := DumpFooter;
    if FLength*2 <= MaxOutputByteInDump then
      OutPutLen := LongInt(FLength)
    else begin
      ErrorStr := Format(OutInDump, [FLength*2, MaxOutputByteInDump,
                                     FLength*2 - MaxOutputByteInDump]);
      OutPutLen := MaxOutputByteInDump div 2;
    end;
    WordStr := Format(FirstStringInDump, [OutPutLen, 'слов']);

         // Всего символов  слов->hex    .  
    CharCount := OutPutLen*(CharInWord + 1) +
                        //Добавляем #13#10 в конце строки
                        LongInt(OutPutLen div DumpStrLength);//*2;
    //Добавляем начальную строку
    CharCount := CharCount + System.Length(WordStr);
    //Добавляем заголовок
    CharCount := CharCount + System.Length(HeaderStr);
    //Добавляем окончание
    CharCount := CharCount + System.Length(FooterStr);
    //Добавляем строку ошибки
    if ErrorStr <> '' then
      CharCount := CharCount + System.Length(ErrorStr);
    System.SetString(Result, nil, CharCount);
    CurrPos := 1;

    //Вставляем заголовок
    for j := 1 to System.Length(HeaderStr) do
      Result[CurrPos+j-1] := HeaderStr[j];
    Inc(CurrPos, System.Length(HeaderStr));

    //Вставляем строку ошибки
    if ErrorStr <> '' then begin
      for j := 1 to System.Length(ErrorStr) do
        Result[CurrPos+j-1] := ErrorStr[j];
      Inc(CurrPos, System.Length(ErrorStr));
    end;

    //Переносим заголовок Dump'a
    for j := 1 to System.Length(WordStr) do
      Result[CurrPos+j-1] := WordStr[j];
    Inc(CurrPos, System.Length(WordStr));

    //Цикл по каждому слову массива
    if OutPutLen > 0 then
    for I := 0 to OutPutLen-1 do begin
      //Преобразуем слово в Hex-строку
      WordStr := IntToHex(FArray^[i], CharInWord) + '.';
      //Переносим в результирующую строку
      for J := 1 to CharInWord + 1 do
        Result[CurrPos+j-1] := WordStr[j];
      Inc(CurrPos, CharInWord + 1);
      //Если напечатали определенное количество символов в строке, то переходим
      //на следующую строку
      if (((I+1) mod DumpStrLength) = 0) then begin
        Dec(CurrPos);
        Result[CurrPos] := #13;
        Result[CurrPos+1] := #10;
        Inc(CurrPos, 2);
      end;
    end;
    //Вставляем окончание
    for j := 1 to System.Length(FooterStr) do
      Result[CurrPos+j-1] := FooterStr[j];
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.Initialize;
begin
  {Пустая часть. У наследников может быть заполнена}
end;

procedure TSGWordArray.LoadFromFileHighLow(FileName: String);
var
  Stream: TStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      LoadFromStreamHighLow(Stream);
    finally
      Stream.Free;
    end;
  except
    on EStreamError do
      ErrorFmt('LoadFromFileHighLow', ErrorLoadFromFile, [FileName]);
    on E:Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TSGWordArray.LoadFromFileLowHigh(FileName: String);
var
  Stream: TStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      LoadFromStreamLowHigh(Stream);
    finally
      Stream.Free;
    end;
  except
    on EStreamError do
      ErrorFmt('LoadFromFileLowHigh', ErrorLoadFromFile, [FileName]);
    on E:Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TSGWordArray.LoadFromStreamHighLow(Stream: TStream);
var
{
  I,
  NewCapacity : TLengthType;
  WorkWord : Word;
  HighByte, LowByte : Byte;
}  
  Buffer : TSGByteArray;
begin
  Buffer := TSGByteArray.Create(nil);
  FCriticalSection.Enter;
  try
    if Stream.Size mod 2 <> 0 then
      Error('LoadFromStreamHighLow', OddStream);
    try
      Buffer.LoadFromStream(Stream);
      Self.AssignByteHighLow(Buffer);
{
  Это старая секция чтения из потока. Оставлено на всякий случай.
  Переход на новую был осуществлен из-за медленной скорости обращения
  к потоку побайтно.
      NewCapacity := Stream.Size div 2;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      Stream.Position := 0;
      if NewCapacity <> 0 then
        for I := 0 to NewCapacity-1 do begin
          Stream.Position := i*2;
          Stream.ReadBuffer( HighByte, SizeOf(HighByte));
          Stream.Position := i*2 + 1;
          Stream.ReadBuffer( LowByte, SizeOf(LowByte));
          PTwoByteArray( Addr ( WorkWord ) )^[boHigh] := HighByte;
          PTwoByteArray( Addr ( WorkWord ) )^[boLow] := LowByte;
          FArray^[i] := WorkWord;
        end;
      FLength := NewCapacity;
}
    except
      on ERangeError do
        ErrorFmt('LoadFromStreamHighLow', NewLength,
          [System.High ( TLengthType ),
           Cardinal(Stream.Size div 2)-System.High(TLengthType)]);
      on EReadError do
        Error('LoadFromStreamHighLow', ErrorLoadFromStream);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    Buffer.Free;
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.LoadFromStreamLowHigh(Stream: TStream);
var
  NewCapacity : TLengthType;
begin
  FCriticalSection.Enter;
  try
    if Stream.Size mod 2 <> 0 then
      Error('LoadFromStreamLowHigh', OddStream);
    try
      NewCapacity := Stream.Size div 2;
      if NewCapacity > FCapacity then
        SetCapacity(NewCapacity);
      Stream.Position := 0;
      Stream.ReadBuffer(FArray^, NewCapacity*SizeOf(Word));
      FLength := NewCapacity;
    except
      on ERangeError do
        ErrorFmt('LoadFromStreamLowHigh', NewLength,
          [System.High ( TLengthType ),
           Cardinal(Stream.Size div 2)-System.High(TLengthType)]);
      on EReadError do
        Error('LoadFromStreamLowHigh', ErrorLoadFromStream);
      on E:Exception do
        raise Exception.Create(E.Message);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.SaveToFileHighLow(FileName: String);
var
  Stream: TStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmCreate);
    try
      SaveToStreamHighLow(Stream);
    finally
      Stream.Free;
    end;
  except
    on EStreamError do
      ErrorFmt('SaveToFileHighLow', ErrorSaveToFile, [FileName]);
    on E:Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TSGWordArray.SaveToFileLowHigh(FileName: String);
var
  Stream: TStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmCreate);
    try
      SaveToStreamLowHigh(Stream);
    finally
      Stream.Free;
    end;
  except
    on EStreamError do
      ErrorFmt('SaveToFileLowHigh', ErrorSaveToFile, [FileName]);
    on E:Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TSGWordArray.SaveToStreamHighLow(Stream: TStream);
var
{
  I : TLengthType;
  WorkWord : Word;
  HighByte, LowByte : Byte;
}  
  Buffer : TSGByteArray;
begin
  Buffer := TSGByteArray.Create(nil);
  FCriticalSection.Enter;
  try
    try
      Buffer.AssignWordHighLow(Self);
      Buffer.SaveToStream(Stream);
{
  Это старая секция сохранения в поток. Оставлено на всякий случай.
  Переход на новую был осуществлен из-за медленной скорости обращения
  к потоку побайтно.
      Stream.Position := 0;
      for I := Low to High do begin
        WorkWord := FArray^[i];
        HighByte := PTwoByteArray( Addr ( WorkWord ) )^[boHigh];
        LowByte := PTwoByteArray( Addr ( WorkWord ) )^[boLow];
        Stream.Position := i*2;
        Stream.WriteBuffer( HighByte, SizeOf(HighByte));
        Stream.Position := i*2 + 1;
        Stream.WriteBuffer( LowByte, SizeOf(LowByte));
      end;
}
    except
      Error('SaveToStreamHighLow', ErrorSaveToStream);
    end;
  finally
    Buffer.Free;
    FCriticalSection.Leave;
  end;
end;

procedure TSGWordArray.SaveToStreamLowHigh(Stream: TStream);
begin
  FCriticalSection.Enter;
  try
    try
      Stream.Position := 0;
      Stream.WriteBuffer(FArray^, FLength*SizeOf(Word));
    except
      Error('SaveToStreamLowHigh', ErrorSaveToStream);
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

function TSGWordArray.DumpFooter: String;
begin
// Перекрывается у потомков.
  Result := '';
end;

function TSGWordArray.DumpHeader: String;
begin
// Перекрывается у потомков.
  Result := '';
end;

procedure TSGWordArray.ChopHead(I: TLengthType);
begin
  Delete(Low, I);
end;

initialization
  RegisterClass(TSGByteArray);
  RegisterClass(TSGWordArray);
end.
