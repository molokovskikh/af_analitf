unit U_ESGXMLError;

interface

uses
  SysUtils;


type

  {���� ������ ��� ������� XML-���������}
  TXMLErrorType = (xeInDTD, xeInXML, xeCompare);
  {��������� �������� ���� TXMLError:
   - xeInDTD   - �������������� ������ ��� ������� DTD,
   - xeInXML   - �������������� ������ ��� ������� XML,
   - xeCompare - ������ ��� ������������ XML � DTD.
  }

  ESGXMLError = class(Exception)
   private
    FXMLErrorType : TXMLErrorType;
    FLineNumber,                  {����� ������, � ������� ��������� ������}
    FCharNumber   : Integer;
    function GetAdvMessage: String;      {������� �������, �� ������� ��������� ������}
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