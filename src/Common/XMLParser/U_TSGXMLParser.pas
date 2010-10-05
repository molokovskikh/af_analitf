unit U_TSGXMLParser;

interface

uses
  SysUtils, Classes, U_ESGXMLError, U_XMLElementStructs, U_TSGXMLDocument,
  U_SGXMLGeneral;

const
  ErrorLoadFromFile   = 'U_TSGXMLParser:TSGXMLParser.LoadFromFile - '+
                        'Ошибка при чтении из файла.';
  ErrorLoadFromStream = 'U_TSGXMLParser:TSGXMLParser.LoadFromStream - '+
                        'Ошибка при чтении из потока.';
  ErrorMinXMLLen      = 'U_TSGXMLParser:TSGXMLParser.ParseXML - '+
                        'Документ меньше минимального размера.';
  NotXMLChar          = 'U_TSGXMLParser:TSGXMLParser.GetSymbol - '+
                        'Символ "%s" не является символом языка.';
  WaitAttribute       = 'U_TSGXMLParser:TSGXMLParser.%s - '+
                        'Ожидался аттрибут ''%s''.';
  WaitConstruction    = 'U_TSGXMLParser:TSGXMLParser.%s - '+
                        'Ожидалась конструкция %s.';
  NotAttributeType    = 'U_TSGXMLParser:TSGXMLParser.%s - '+
                        'Значение аттрибута %s не соответствует типу %s.';
  NotEnumAttributeType= 'U_TSGXMLParser:TSGXMLParser.%s - '+
                        'Значение аттрибута %s не принадлежит значениям (%s).';
  PointerNil          = 'U_TSGXMLParser:TSGXMLParser.ParserXML - '+
                        'Указатель содержит nil.';
  ErrorID             = 'U_TSGXMLParser:TSGXMLParser.AnalyseDefaultDecl - '+
                        'Аттрибут с типом ID должен быть #REQUIRED или '+
                        '#IMPLIED.';
  ValidMsg            = 'U_TSGXMLParser:TSGXMLParser.%s - %s';
  NotCompareDefault   = 'U_TSGXMLParser:TSGXMLParser.AnalyseDefaultDecl - '+
                        'Значение по умолчанию аттрибута %s не соотвествует '+
                        'типу %s.';

  //<?xml version="1"?><a/>
  //12345678901234567890123
  MinXMLLen           = 23;//Минимальная длина XML документа

type
  TXMLSymbol = ( //Cимволы языка XML
   xsUnknown,     //Неизвестный символ
   xsEOF,         //Конец файла
   xsPrologStart, //Начало заголовка XML-файла  '<?'
   xsPrologEnd,   //Конец заголовка XML-файла   '?>'
   xsComment,     //Секция комментария          '<!-- (Words - ['-'])-->'
   xsSTagStart,   //Начало стартого тега        '<'
   xsTagEnd,      //Конец тега                  '>'
   xsEmptyTagEnd, //Конец пустого тега          '/>'
   xsETagStart,   //Начало конечного тега       '</'
   xsDocType,     //Начало секции DTD           '<!DOCTYPE'
   xsElement,     //Начало секции DTD           '<!ELEMENT'
   xsAttList,     //Начало секции DTD           '<!ATTLIST'
   xsName,        //Символ языка Name
   xsNMToken,     //Символ языка NMToken
   xsWord,        //Cимвол языка Word(любые символьные данные)
   xsLeftBracket, //Терминальный символ языка   '('
   xsRightBracket,//Терминальный символ языка   ')'
   xsLeftRectBracket,//Терминальный символ языка'['
   xsRightRectBracket,//Терминальный символ языка']'
   xsQuot,        //Терминальный символ языка   '"'
   xsApos,        //Терминальный символ языка   ''''
   xsEntity,      //Нетерминальный символ языка макрос  '&' Name ';'
   xsSemicolon,   //Терминальный символ языка   ';'
   xsStar,        //Терминальный символ языка   '*'
   xsPlus,        //Терминальный символ языка   '+'
   xsQuestion,    //Терминальный символ языка   '?'
   xsEq,          //Терминальный символ языка   '='
   xsSeq,         //Терминальный символ языка   ','
   xsChoice,      //Терминальный символ языка   '|'
   xsPCData,      //Терминальный символ языка   '#PCDATA'
   xsRequired,    //Терминальный символ языка   '#REQUIRED'
   xsImplied,     //Терминальный символ языка   '#IMPLIED'
   xsFixed        //Терминальный символ языка   '#FIXED'
  );

  TSGXMLParser = class
   private
    FXMLDoc     : TSGXMLDocument;
    FText       : String;// Исходный текст
    FTokenString: String;//Содержит исходную строку символов xsName, xsNMToken,
                         //xsWord
    FStartPos,     // Переменые хранят начальную и конечную позиции в строке
    FEndPos,       // FText значений аттрибутов и секций PCData
    FCurrPos,             // Текущая позиция в строке FText
    FSourceLine,            // Текущая строка в тексте
    FSourcePos  : Integer; //  Текущая позиция в тексте
    FCurrChar   : Char;     // Теущий символ
    FCurrSymbol : TXMLSymbol; //Текущий прочитанный символ языка
    {Процедура разбирает аттрибуты элемента:
    [24]	Attribute 	::= Name Eq AttValue
    }
    procedure   AnalyseAttributes(AXMLElement: TSGXMLElement);
    {Процедура анализирует элемент :
    [22]  	element	 	::=  EmptyElemTag | STag content ETag
    [23]	STag 		::= '<' Name (S Attribute)* [S] '>'
    [25]	AttValue	::= '"' Words '"'
    [26]	ETag 		::= '</' Name [S] '>'
    [27]	content 	::= (element | Words | Comment)*
    [28]	EmptyElemTag 	::= '<' Name (S Attribute)* [S] '/>'
    }
    procedure   AnalyseElement(AXMLElement : TSGXMLElement);
    {Разбирает кодировку документа :
    [20]	EncodingDecl 	::= S 'encoding' Eq '"' EncName '"'}
    procedure   AnalyseEncodingDecl;
    {Процедура анализирует заголовок XML-документа и возвращает его параметры.
    [13]	prolog		::=  XMLDecl Misc? [doctypedecl Misc?]
    }
    procedure   AnalyseProlog;
    {Разбирает конструкцию, содержащую аттрибут standalone :
    [19]	SDDecl 	 	::=  S 'standalone' Eq ('"' ('yes' | 'no') '"'))
    }
    procedure   AnalyseSDDecl;
    {Разбирает заголовок XML-документа :
    [15]  	XMLDecl     	::=  '<?xml' VersionInfo [EncodingDecl]
                                                             [SDDecl] [S] '?>'
    }
    procedure   AnalyseXMLDecl;


    {Процедура вызывает исключение SGXMLException с заданными параметрами}
    procedure   Error(
      AXMLErrorType : TXMLErrorType;
      ALineNumber,
      ACharNumber   : Integer;
      AMsg          : String);
    {Вызывает ошибку, если парсер не получил ожидаемый аттрибут}
    procedure   ErrorAttribute(
      AProcName,
      AAttName : String);
    {Вызывает ошибку на несоответствие типа аттрибута}
    procedure   ErrorAttributeType(
      AProcName,
      AAttName,
      AAttType  : String);
    {Вызывает ошибку на, если парсер не получил ожидаемую
      конструкцию AConstruction }
    procedure   ErrorConstruction(
      AXMLErrorType : TXMLErrorType;
      AProcName,
      AConstruction : String);
    {Вызывает ошибку на несоответствие аттрибута заданным значениям}
    procedure   ErrorEnumAttributeType(
      AProcName,
      AAttName,
      AEnumValues  : String);
    {Вызывает ошибку на несоответвие XML-документа DTD-описанию}
    procedure   ErrorValid(
      AProcName,
      AMsg      : String);

    {Инициализирует переменые перед парсингом}
    procedure   InitParse;
    {Функция разбирает констуркцию :
    [25]	AttValue	::= '"' Words '"'
    ,возвращает тип аттрибута, а в переменую FTokenString заносит значение
    аттрибута}
    function    GetAttributeType : TEAType;
    {Функция заносит в переменную FCurrChar следуюший символ}
    function    GetChar : Char;
    {Процедура разбирает комментарии}
    procedure   GetComment;
    {Процедура из исходной строки формирует символ языка Name}
    procedure   GetName;
    {Процедура из исходной строки формирует символ языка NNToken}
    procedure   GetNMToken;
    {Процедура обрабатывает специальные символы языка}
    procedure   GetSpecialChar;
    {Процедура фомирует различные стартовые теги}
    procedure   GetStartTags;
    {функция формирует символ языка, заносит его в переменную FCurrSymbol}
    function    GetSymbol : TXMLSymbol;
    {формирует слово xsWord}
    procedure   GetWord;
   public
    constructor Create;
    {Загружает текст из файла}
    procedure   LoadFromFile(FileName : TFileName);
    {Загружает текст из потока}
    procedure   LoadFromStream(Stream : TStream);
    {Производит разбор текста и заносит данные в XMLDocument.
     Анализирует конструкцию :
     [12]	document	::=  prolog element Misc?
     }
    procedure   ParseXML(AXMLDocument : TSGXMLDocument);
    property    Text : String read FText;
    property    CurrSymbol : TXMLSymbol read FCurrSymbol;
    property    TokenString : String read FTokenString;
  end;

procedure ParseFileToXMLDoc  ( AFileName : String; XDoc : TSGXMLDocument );

procedure ParseStringToXMLDoc( AXMLText  : String; XDoc : TSGXMLDocument );

implementation

procedure ParseFileToXMLDoc ( AFileName : String; XDoc : TSGXMLDocument );
var
  XParser : TSGXMLParser;
begin
  XParser := TSGXMLParser.Create;
  try
    XParser.LoadFromFile ( AFileName );
    XParser.ParseXML ( XDoc );
  finally
    XParser.Free;
  end;
end;

procedure ParseStringToXMLDoc( AXMLText  : String; XDoc : TSGXMLDocument );
var
  XParser : TSGXMLParser;
  SM      : TStringStream;
begin
  XParser := TSGXMLParser.Create;
  try
    SM := TStringStream.Create(AXMLText);
    try
      XParser.LoadFromStream ( SM );
      XParser.ParseXML ( XDoc );
    finally
      SM.Free;
    end;
  finally
    XParser.Free;
  end;
end;

{ TSGXMLParser }

procedure TSGXMLParser.AnalyseAttributes(AXMLElement: TSGXMLElement);
var
  AttName,
  AttValue : String;
  AttType  : TEAType;
  TmpLine,
  TmpPos   : Integer;
begin
  while FCurrSymbol = xsName do begin
    TmpLine := FSourceLine;
    TmpPos  := FSourcePos;
    AttName := FTokenString;
    if GetSymbol = xsEq then begin
      AttType := GetAttributeType;
      AttValue := FTokenString;
      try
        AXMLElement.AddAttribute(AttName, AttType, AttValue);
      except
        on E:Exception do begin
          FTokenString := AttName;
          FSourcePos := TmpPos;
          FSourceLine := TmpLine;
          ErrorValid('AnalyseAttributes', E.Message);
        end;
      end;
      GetSymbol;
    end
    else ErrorConstruction(xeInXML, 'AnalyseAttributes', '''=''');
  end;
end;

procedure TSGXMLParser.AnalyseElement(AXMLElement: TSGXMLElement);
var
  TmpStr : String;
  TmpStart,
  TmpEnd : Integer;
begin
  GetSymbol;
  AnalyseAttributes(AXMLElement);
  if FCurrSymbol = xsTagEnd then begin
      GetSymbol;
    while true do begin
      case FCurrSymbol of
        xsSTagStart : if GetSymbol = xsName then begin
                        AnalyseElement(AXMLElement.AddElement(FTokenString));
                        GetSymbol;
                      end
                      else ErrorConstruction(xeInXML, 'AnalyseElement', 'Name');
        xsETagStart : if (GetSymbol = xsName) and
                        (FTokenString = AXMLElement.XMLElemName) then
                        if GetSymbol = xsTagEnd then Break
                        else ErrorConstruction(xeInXML,'AnalyseElement','''>''')
                      else ErrorConstruction(xeInXML, 'AnalyseElement',
                             AXMLElement.XMLElemName);
{
    Раньше было так:
        xsName..xsRightRectBracket,
        xsEntity..xsFixed:

    Но потом оказалось, что символы (') и (") тоже могут быть в тексте элемента
}
        xsPrologEnd,
        xsTagEnd,
        xsEmptyTagEnd,
        xsName..xsFixed:
          begin
            TmpStart := FCurrPos - Length(FTokenString);
            TmpEnd := FCurrPos;
{
            while (FCurrSymbol in [xsName..xsRightRectBracket,
                  xsEntity..xsFixed])do begin
}
            while (FCurrSymbol in [xsPrologEnd, xsTagEnd, xsEmptyTagEnd, xsName..xsFixed])do begin
              TmpEnd := FCurrPos;
              GetSymbol;
            end;
            TmpStr := Copy(FText, TmpStart, TmpEnd-TmpStart);
            //Перед тем как добавить элемент PCData удаляю WhiteSpaces в начале
            //и в конце
            AXMLElement.AddPCData( Trim(TmpStr) );
          end;
        xsComment   : GetSymbol;
        else ErrorConstruction(xeInXML, 'AnalyseElement', '''</''Name');
      end;
    end;
  end
  else if FCurrSymbol <> xsEmptyTagEnd then
         ErrorConstruction(xeInXML, 'AnalyseElement', '''/>''');
end;

procedure TSGXMLParser.AnalyseEncodingDecl;
begin
  if GetSymbol = xsEq then
    if GetAttributeType = eatIDREF then
      FXMLDoc.Encoding := FTokenString
    else ErrorAttributeType('AnalyseEncodingDecl', 'encoding', 'IDREF')
  else ErrorConstruction(xeInXML, 'AnalyseEncodingDecl', '''=''');
  GetSymbol;
end;

procedure TSGXMLParser.AnalyseProlog;
begin
  AnalyseXMLDecl;{Анализируем заголовок документа}
  while FCurrSymbol = xsComment do GetSymbol;
end;

procedure TSGXMLParser.AnalyseSDDecl;
begin
  if GetSymbol = xsEq then
    if GetAttributeType = eatIDREF then
      if (FTokenString = 'yes') then
        FXMLDoc.Standalone := True
      else if (FTokenString = 'no') then
             FXMLDoc.Standalone := False
           else ErrorEnumAttributeType('AnalyseSDDecl', 'standalone', 'no|yes')
    else ErrorAttributeType('AnalyseSDDecl', 'standalone', 'IDREF')
  else ErrorConstruction(xeInXML, 'AnalyseSDDecl', '''=''');
  GetSymbol;
end;

procedure TSGXMLParser.AnalyseXMLDecl;
begin
  FXMLDoc.Version := '';
  FXMLDoc.Encoding := '';
  FXMLDoc.Standalone := False;
  if GetSymbol = xsPrologStart then begin{Нашли начало заголовка}
    if (GetSymbol = xsName) and (FTokenString = 'version') then
      if GetSymbol = xsEq then
        if GetAttributeType = eatNMTOKEN then begin
          FXMLDoc.Version := FTokenString;
          if (GetSymbol = xsName) and (FTokenString = 'encoding') then
            AnalyseEncodingDecl;
          if (FCurrSymbol = xsName) and (FTokenString = 'standalone') then
            AnalyseSDDecl;
          if FCurrSymbol <> xsPrologEnd then
            ErrorConstruction(xeInXML, 'AnalyseXMLDecl', '''?>''');
         end
        else ErrorAttributeType('AnalyseXMLDecl', 'version', 'NMTOKEN')
      else ErrorConstruction(xeInXML, 'AnalyseXMLDecl', '''=''')
    else ErrorAttribute('AnalyseXMLDecl', 'version');
  end
  else ErrorConstruction(xeInXML, 'AnalyseXMLDecl', '''<?xml''');
  GetSymbol;
end;

constructor TSGXMLParser.Create;
begin
  FText := '';
  FXMLDoc := nil;
end;

procedure TSGXMLParser.Error(AXMLErrorType: TXMLErrorType; ALineNumber,
  ACharNumber: Integer; AMsg: String);
begin
  raise ESGXMLError.Create(AXMLErrorType, ALineNumber, ACharNumber, AMsg);
end;

procedure TSGXMLParser.ErrorAttribute(AProcName, AAttName: String);
begin
  Error(xeCompare, FSourceLine, FSourcePos-Length(FTokenString),
    Format(WaitAttribute, [AProcName, AAttName]))
end;

procedure TSGXMLParser.ErrorAttributeType(AProcName, AAttName,
  AAttType: String);
begin
  Error(xeInXML, FStartPos, FEndPos, Format(NotAttributeType, [AProcName,
                                       AAttName, AAttType]));
end;

procedure TSGXMLParser.ErrorConstruction(AXMLErrorType : TXMLErrorType;
AProcName, AConstruction: String);
begin
  Error(AXMLErrorType, FSourceLine, FSourcePos-Length(FTokenString),
    Format(WaitConstruction, [AProcName, AConstruction]));
end;

procedure TSGXMLParser.ErrorEnumAttributeType(AProcName, AAttName,
  AEnumValues: String);
begin
  Error(xeInXML, FStartPos, FEndPos, Format(NotEnumAttributeType, [AProcName,
                                       AAttName, AEnumValues]));
end;

procedure TSGXMLParser.ErrorValid(AProcName, AMsg: String);
begin
  Error(xeCompare, FSourceLine, FSourcePos-Length(FTokenString),
    Format(ValidMsg, [AProcName, AMsg]));
end;

function TSGXMLParser.GetAttributeType: TEAType;
var
  TmpLine,
  TmpNumber : Integer;
  TmpStr    : String;
begin
  Result := eatNone;
  if GetSymbol = xsQuot then begin
    TmpLine := FSourceLine;  // Сохраняем позиции линии и номера символа,
    TmpNumber := FSourcePos; // чтобы при ошибки указать начало аттрибута
    FStartPos := FCurrPos;   //Сохраняем начальную позицию
    while GetSymbol in [xsName..xsRightRectBracket, xsEntity..xsFixed]do begin
      case Result of
        eatNone : case FCurrSymbol of //Обрабатываем первое слово
                    xsName    : Result := eatIDREF;
                    xsNMToken : Result := eatNMTOKEN;
                    else        Result := eatCDATA;
                  end;
        eatIDREF : case FCurrSymbol of  //Если слово пришло не одно
                    xsName    : Result := eatIDREFS;
                    xsNMToken : Result := eatNMTOKENS;
                    else        Result := eatCDATA;
                  end;
        eatNMTOKEN : case FCurrSymbol of  //Если слово пришло не одно1
                        xsName,
                        xsNMToken : Result := eatNMTOKENS;
                        else        Result := eatCDATA;
                      end;
      end;
    end;
//    FEndPos := FCurrPos - 1; //Получаем коннечную позицию,
       //и если все нормально, то в FTokenString все значение аттрибута
    TmpStr := Copy(FText, FStartPos, FEndPos-FStartPos);
    FStartPos := TmpLine;
    FEndPos := TmpNumber;
    if FCurrSymbol <> xsQuot then
      ErrorConstruction(xeInXML, 'GetAttributeType', '''"''');
    FTokenString := TmpStr;
  end
  else ErrorConstruction(xeInXML, 'GetAttributeType', '''"''');
end;

function TSGXMLParser.GetChar : Char;
begin
  Inc(FSourcePos);
  Inc(FCurrPos);
  FCurrChar := FText[FCurrPos];
  Result := FCurrChar;
end;

procedure TSGXMLParser.GetComment;
begin
  if GetChar = '-' then begin
    FTokenString := FTokenString + FCurrChar;
    while True do
      if GetChar <> #0 then begin
        if FCurrChar = '-' then
          if GetChar = '-' then
            if GetChar = '>' then begin
              FCurrSymbol:=xsComment; GetChar;
              FTokenString := FTokenString + '-->';
              FStartPos := FCurrPos; exit;
            end
            else FTokenString := FTokenString + '--'
          else FTokenString := FTokenString + '-';
        if FCurrChar = #10 then begin Inc(FSourceLine); FSourcePos := 0; end;
        FTokenString := FTokenString + FCurrChar;
      end
      else begin FCurrSymbol := xsUnknown; exit; end
  end
  else FCurrSymbol := xsUnknown
end;

procedure TSGXMLParser.GetName;
begin
  while FCurrChar in NameChar do begin
    FTokenString := FTokenString + FCurrChar;
    GetChar;
  end;
  {Если конец слова, т.е. встретился какой-то разделитель}
  if (FCurrChar in (WhiteSpaces+SpecialChar-['#'])) then
    FCurrSymbol := xsName
  else {Если встретился другой символ}
//    if (FCurrChar in (RussianLetter+Separators+['#'])) then
    if not (FCurrChar in (PrivateChar+WhiteSpaces)) then
      GetWord
    else FCurrSymbol := xsUnknown;
end;

procedure TSGXMLParser.GetNMToken;
begin
  while FCurrChar in NameChar do begin
    FTokenString := FTokenString + FCurrChar;
    GetChar;
  end;
  {Если конец слова, т.е. встретился какой-то разделитель}
  if (FCurrChar in (WhiteSpaces+SpecialChar-['#'])) then
    FCurrSymbol := xsNMToken
  else {Если встретился другой символ}
//    if (FCurrChar in (RussianLetter+Separators+['#'])) then
    if not (FCurrChar in (PrivateChar+WhiteSpaces)) then
      GetWord
    else FCurrSymbol := xsUnknown;
end;

procedure TSGXMLParser.GetSpecialChar;
var
  TmpChar : Char;

  function IsInteger(AStr : String) : Boolean;
  begin
    try
      StrToInt(AStr);
      Result := True;
    except
      Result := False;
    end;
  end;

begin
  FEndPos := FCurrPos;
  TmpChar := FCurrChar;
  case FCurrChar of
    '<': GetStartTags;
    '>': begin FCurrSymbol := xsTagEnd;        GetChar; FStartPos:=FCurrPos;end;
    '/': if GetChar = '>'then{Формирование окончания пустого или другого тега}
           begin
             FCurrSymbol:=xsEmptyTagEnd;     GetChar; FStartPos:=FCurrPos;end
         else GetWord;
    '#': if GetChar in EnglishLetter then begin//Формирование зарезервированых
           GetName;                            //слов
           if FCurrSymbol = xsName then begin
             if FTokenString = 'PCDATA'   then FCurrSymbol := xsPCData;
             if FTokenString = 'REQUIRED' then FCurrSymbol := xsRequired;
             if FTokenString = 'IMPLIED'  then FCurrSymbol := xsImplied;
             if FTokenString = 'FIXED'    then FCurrSymbol := xsFixed;
           end;
         end
         else GetWord;
    '(': begin FCurrSymbol := xsLeftBracket;          GetChar;end;
    ')': begin FCurrSymbol := xsRightBracket;         GetChar;end;
    '[': begin FCurrSymbol := xsLeftRectBracket;      GetChar;end;
    ']': begin FCurrSymbol := xsRightRectBracket;     GetChar;end;
    '"': begin FCurrSymbol := xsQuot;                 GetChar;end;
    '''': begin FCurrSymbol := xsApos;                GetChar;end;
    '&': if GetChar in EnglishLetter then begin
           //Формирование стандартного макроса
           GetName;
           if (FCurrSymbol = xsName) and (FCurrChar = ';') then begin
             FTokenString := FTokenString + ';';
             GetChar;
             if FXMLDoc.FindEntity('&'+FTokenString) <> -1 then
               FCurrSymbol := xsEntity
             else FCurrSymbol := xsUnknown;
           end
           else FCurrSymbol := xsUnknown;
         end
         else
           if FCurrChar = '#' then begin
             GetChar;
             //Формирование макроса из одного символа
             GetNMToken;
             if (FCurrSymbol = xsNMToken) and (FCurrChar = ';')
               and (IsInteger(FTokenString))
             then begin
               FTokenString := '#' + FTokenString + ';';
               FCurrSymbol := xsEntity;
               GetChar;
             end
             else FCurrSymbol := xsUnknown;
           end
           else
             FCurrSymbol := xsUnknown;
    ';': begin FCurrSymbol := xsSemicolon;            GetChar;end;
    '*': begin FCurrSymbol := xsStar;                 GetChar;end;
    '+': begin FCurrSymbol := xsPlus;                 GetChar;end;
    '?': if GetChar <> '>' then
           FCurrSymbol := xsQuestion
         else begin FCurrSymbol := xsPrologEnd;       GetChar;end;
    '=': begin FCurrSymbol := xsEq;                   GetChar;end;
    ',': begin FCurrSymbol := xsSeq;                  GetChar;end;
    '|': begin FCurrSymbol := xsChoice;               GetChar;end;
  end;
  FTokenString := TmpChar + FTokenString;
end;

procedure TSGXMLParser.GetStartTags;
var
  TmpChar : Char;
begin
  if Not (GetChar in EnglishLetter) then begin{Формирование начала тега}
    TmpChar := FCurrChar;
    case FCurrChar of
     '!': if GetChar in EnglishLetter then begin
            GetName; {Формирование тегов секции DTD}
            if (FCurrSymbol = xsName)  then
              if (FTokenString = 'DOCTYPE') then
                FCurrSymbol := xsDocType
              else if (FTokenString = 'ELEMENT') then
                      FCurrSymbol := xsElement
                   else if (FTokenString = 'ATTLIST') then
                          FCurrSymbol := xsAttList
                        else FCurrSymbol := xsUnknown
            else FCurrSymbol := xsUnknown;
          end
          else if FCurrChar = '-' then begin {Сформировать комментарий}
                 FTokenString := FTokenString + FCurrChar;
                 GetComment;
               end
               else FCurrSymbol := xsUnknown;
     '/': if GetChar in EnglishLetter then  {Начало конечного тега}
            FCurrSymbol := xsETagStart
          else FCurrSymbol := xsUnknown;
     '?': if GetChar in EnglishLetter then begin
            GetName; {Формирование стартового тега секции Prolog}
            if (FCurrSymbol = xsName) and (FTokenString = 'xml') then
              FCurrSymbol := xsPrologStart
            else FCurrSymbol := xsUnknown;
          end
          else FCurrSymbol := xsUnknown;
     else FCurrSymbol := xsUnknown;
    end;
    if TmpChar <> ' ' then
      FTokenString := TmpChar + FTokenString;
  end
  else FCurrSymbol := xsSTagStart;
end;

function TSGXMLParser.GetSymbol : TXMLSymbol;
begin
  FTokenString := '';
  while True do begin
    case FCurrChar of
      #0  : begin FCurrSymbol := xsEOF; Break; end;//Конец файла
      #10 : begin Inc(FSourceLine); FSourcePos := 0;end;        //Конец строки
      #33..#255 :  //Какой-то символ языка
                    if FCurrChar in EnglishLetter then begin//Формируем Name
                      GetName; Break; end else
                    if FCurrChar in NameChar then begin//Формируем NNToken
                      GetNMToken; Break;end else
                    if FCurrChar in SpecialChar then //Обрабатываем спецсимвол
                      begin GetSpecialChar; Break; end
                    else
//                    if FCurrChar in (RussianLetter + Separators) then
                    begin //формируем слово
                      GetWord; Break;
                    end;
    end;
    GetChar;
  end;
  Result := FCurrSymbol;
end;

procedure TSGXMLParser.GetWord;
begin
  while not (FCurrChar in (PrivateChar+WhiteSpaces)) do begin
    FTokenString := FTokenString + FCurrChar;
    GetChar;
  end;
  {Если конец слова, т.е. встретился какой-то разделитель}
  if FCurrChar in (WhiteSpaces+SpecialChar-['#']) then
    FCurrSymbol := xsWord
  else FCurrSymbol := xsUnknown; {Получен неизвестный символ}
end;

procedure TSGXMLParser.InitParse;
begin
  FSourceLine := 1;
  FCurrPos    := 0;
  FSourcePos  := 0;
  FCurrChar   := ' ';
end;

procedure TSGXMLParser.LoadFromFile(FileName: TFileName);
var
  Stream : TStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  except
    raise Exception.Create(ErrorLoadFromFile);
  end;
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TSGXMLParser.LoadFromStream(Stream: TStream);
begin
  FText := '';
  try
    if Stream.Size > 0 then begin
     SetLength ( FText, Stream.Size);
     Stream.ReadBuffer( Pointer(FText)^ , Stream.Size);
    end;
    FText := FText + #0;
  except
    raise Exception.Create(ErrorLoadFromStream);
  end;
end;

procedure TSGXMLParser.ParseXML(AXMLDocument: TSGXMLDocument);
begin
  if AXMLDocument <> nil then
    if Length(FText) > MinXMLLen then begin
      InitParse;
      FXMLDoc := AXMLDocument;
      FXMLDoc.Clear;
      AnalyseProlog; //Анализируем заголовок XML-документа
      if FCurrSymbol = xsSTagStart then // Нашли стартовый таг
        if GetSymbol = xsName then begin //Нашли имя корня
          FXMLDoc.RootName := FTokenString;
          AnalyseElement(TSGXMLElement(FXMLDoc));//Анализируем корневой элемент
        end
        else ErrorConstruction(xeInXML, 'ParserXML', 'Name')
      else ErrorConstruction(xeInXML, 'ParserXML', '''<''Name');
      GetSymbol;
      while FCurrSymbol = xsComment do GetSymbol;
      if FCurrSymbol <> xsEOF then
        ErrorConstruction(xeInXML, 'ParseXML', '''<!--''');
    end
    else Error(xeInXML, 1, 1,
        'U_TSGXMLParser:TSGXMLParser.ParseXML - ' + ErrorMinXMLLen)
  else raise Exception.Create(PointerNil);
end;

end.
