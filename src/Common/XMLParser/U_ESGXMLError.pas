unit U_ESGXMLError;

interface

uses
  SysUtils;


type

  {Коды ошибки при разборе XML-документа}
  TXMLErrorType = (xeInDTD, xeInXML, xeCompare);
  {Возможные значения типа TXMLError:
   - xeInDTD   - синтаксическая ошибка при разборе DTD,
   - xeInXML   - синтаксическая ошибка при разборе XML,
   - xeCompare - ошибка при соответствии XML с DTD.
  }

  ESGXMLError = class(Exception)
   private
    FXMLErrorType : TXMLErrorType;
    FLineNumber,                  {Номер строки, в которой произошла ошибка}
    FCharNumber   : Integer;
    function GetAdvMessage: String;      {Позиция символа, на котором произошла ошибка}
   public
    constructor Create(
      XMLErrorType : TXMLErrorType;
      LineNumber,
      CharNumber   : Integer;
      Msg          : String);
    property    XMLErrorType : TXMLErrorType read FXMLErrorType;
    property    LineNumber   : Integer       read FLineNumber;
    property    CharNumber   : Integer       read FCharNumber;
    property    AdvMessage   : String        read GetAdvMessage;
  end;

implementation


{ SGXMLException }

constructor ESGXMLError.Create(XMLErrorType: TXMLErrorType;
                                LineNumber, CharNumber : Integer; Msg: String);
begin
  FXMLErrorType := XMLErrorType;
  FLineNumber := LineNumber;
  FCharNumber := CharNumber;
  Message := Msg;
end;

function ESGXMLError.GetAdvMessage: String;
begin
  Result := Format('(Line:%d, Col:%d) %s', [LineNumber, CharNumber, Message]);
end;

end.