unit U_SGXMLGeneral;

interface

type

  {TEAType �������� ��������� ���� ����������}
  TEAType 	 = (eatNone, eatCDATA, eatID, eatIDREF, eatIDREFS, eatENTITY,
                    eatENTITIES, eatNMTOKEN, eatNMTOKENS, eatEnum);
{TEAType ������ �������� �������� ����� ���������:
  eatNone       - ��� ����,
  eatCDATA      - ����� ���������� ������,
  eatID         - �������� ���������� �������������� � ���������,
  eatIDREF      - �������� ���������� ��������������, ��������� � ��� ���������,
  eatIDREFS     - ��������� IDREF, ����������� ���������,
  eatENTITY     - �������� ��� ENTITY, ��������� � ���������,
  eatENTITIES   - ��������� ENTITY, ����������� ���������,
  eatNMTOKEN    - �������� ���� �����,
  eatNMTOKENS   - ������� ��������� ����, ����������� ���������,
  eatEnum       - �������� ����� ������������ ���
}

  TEASpecification = (easNone, easRequired, easImplied, easFixed);
  {TEASpecification �������� ��������� ������������ ����������:
    easNone 	- ��� �����������;
    easRequired	- �������� �������� ������������;
    easImplied	- �������� �� �������� ������������;
    easFixed	- �������� ����� ������������� ��������.
  }

const
  {�������� ��� ���� ���������, ��� ����������������� �����}
  TypeNames : array[TEAType] of String = ( 'None', 'CDATA', 'ID', 'IDREF',
                                           'IDREFS', 'ENTITY', 'ENTITIES',
                                           'NMTOKEN', 'NMTOKENS', 'Enum');

  GeneralEntitiesCount = 5;//���������� ������������� ��������
  //������������� �������
  GeneralEntities : array[0..GeneralEntitiesCount-1] of string = (
    '&lt;', //::= '<'
    '&gt;',// ::= '>'
    '&apos;',// ::= ''''
    '&quot;',// ::= '"'
    '&amp;'// ::= '&'
  );
   //���������� �����
  ReplacementText : array[0..GeneralEntitiesCount-1] of string =
                         ('<', '>', '''', '"','&');

  Digit         = ['0'..'9'];
  EnglishLetter = ['a'..'z', 'A'..'Z'];
  RussianLetter = ['�','�','�','�','�','�','�','�','�','�','�','�','�','�','�']+
                  ['�','�','�','�','�','�','�','�','�','�','�','�','�','�','�']+
                  ['�','�','�','�','�','�','�','�','�','�','�','�','�','�','�']+
                  ['�','�','�','�','�','�','�','�','�','�','�','�','�','�','�']+
                  ['�','�','�','�','�','�'];
  Separators    = ['!', '\', '^', '`', '{', '}', '~', '$', '%', '@'];
  SpecialChar   = ['(', ')', '[', ']', '"', '*', '+', '?', '/', '<', '>', '=']+
                  ['|', ',', '#', '''', '&', ';'];
  PrivateChar   = ['''', '<', '>', '&', '"'];
  WhiteSpaces   = [#32,#9,#13,#10];
  NameChar      = Digit + EnglishLetter + ['_', ':', '.', '-'];
  Letter        = RussianLetter+NameChar+Separators + SpecialChar;

implementation

end.
 