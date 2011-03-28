unit U_SupplierPromotion;

interface

uses
  SysUtils,
  StrUtils;

type
  TSupplierPromotion = class
   public
    Id : Int64;
    Name : String;
    Annotation : String;
    PromoFile : String;

    CatalogId : Int64;
    CatalogName : String;
    CatalogForm : String;
    CatalogFullName : String;

    SupplierId : Int64;
    SupplierShortName : String;

    function GetPromoExt() : String;
    function GetPromoFile() : String;

    function HtmlExists() : Boolean;
    function JpgExists() : Boolean;
    function TxtExists() : Boolean;
  end;

implementation

{ TSupplierPromotion }

function TSupplierPromotion.GetPromoExt: String;
begin
  Result := ExtractFileExt(PromoFile);
end;

function TSupplierPromotion.GetPromoFile: String;
begin
  Result := IntToStr(Id) + GetPromoExt(); 
end;

function TSupplierPromotion.HtmlExists: Boolean;
begin
  Result := AnsiIndexText(GetPromoExt(), ['.htm', '.html']) > -1;
end;

function TSupplierPromotion.JpgExists: Boolean;
begin
  Result := AnsiIndexText(GetPromoExt(), ['.jpg', '.jpeg']) > -1;
end;

function TSupplierPromotion.TxtExists: Boolean;
begin
  Result := AnsiIndexText(GetPromoExt(), ['.txt']) > -1;
end;

end.
 