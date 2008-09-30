unit U_SGXMLGeneral;

interface

type

  {TEAType содержит возможные типы аттрибутов}
  TEAType 	 = (eatNone, eatCDATA, eatID, eatIDREF, eatIDREFS, eatENTITY,
                    eatENTITIES, eatNMTOKEN, eatNMTOKENS, eatEnum);
{TEAType задает возмжные значения типов аттибутов:
  eatNone       - нет типа,
  eatCDATA      - любые символьные данные,
  eatID         - содержит уникальный иденитификатор в документе,
  eatIDREF      - содержит уникальный иденитификатор, описанный в это документе,
  eatIDREFS     - несколько IDREF, разделенных пробелами,
  eatENTITY     - содержит имя ENTITY, описанное в документе,
  eatENTITIES   - несколько ENTITY, разделенных пробелами,
  eatNMTOKEN    - содержит одно слово,
  eatNMTOKENS   - содржит несколько слов, разделенных пробелами,
  eatEnum       - аттрибут имеет перечислимый тип
}

  TEASpecification = (easNone, easRequired, easImplied, easFixed);
  {TEASpecification содержит параметры спецификации аттрибутов:
    easNone 	- нет специфкации;
    easRequired	- аттрибут является обязательным;
    easImplied	- аттрибут не является обязательным;
    easFixed	- аттрибут имеет фиксированное значение.
  }

const
  {Содержит имя типа аттрибуты, как зарезервированное слово}
  TypeNames : array[TEAType] of String = ( 'None', 'CDATA', 'ID', 'IDREF',
                                           'IDREFS', 'ENTITY', 'ENTITIES',
                                           'NMTOKEN', 'NMTOKENS', 'Enum');

  GeneralEntitiesCount = 5;//Количество опеределенных макросов
  //Опеределенные макросы
  GeneralEntities : array[0..GeneralEntitiesCount-1] of string = (
    '&lt;', //::= '<'
    '&gt;',// ::= '>'
    '&apos;',// ::= ''''
    '&quot;',// ::= '"'
    '&amp;'// ::= '&'
  );
   //Заменяемый тектс
  ReplacementText : array[0..GeneralEntitiesCount-1] of string =
                         ('<', '>', '''', '"','&');

  Digit         = ['0'..'9'];
  EnglishLetter = ['a'..'z', 'A'..'Z'];
  RussianLetter = ['А','Б','В','Г','Д','Е','Ё','Ж','З','И','Й','К','Л','М','Н']+
                  ['О','П','Р','С','Т','У','Ф','Х','Ц','Ч','Ш','Щ','Ъ','Ы','Ь']+
                  ['Э','Ю','Я','а','б','в','г','д','е','ё','ж','з','и','й','к']+
                  ['л','м','н','о','п','р','с','т','у','ф','х','ц','ч','ш','щ']+
                  ['ъ','ы','ь','э','ю','я'];
  Separators    = ['!', '\', '^', '`', '{', '}', '~', '$', '%', '@'];
  SpecialChar   = ['(', ')', '[', ']', '"', '*', '+', '?', '/', '<', '>', '=']+
                  ['|', ',', '#', '''', '&', ';'];
  PrivateChar   = ['''', '<', '>', '&', '"'];
  WhiteSpaces   = [#32,#9,#13,#10];
  NameChar      = Digit + EnglishLetter + ['_', ':', '.', '-'];
  Letter        = RussianLetter+NameChar+Separators + SpecialChar;

implementation

end.
 