unit SupplierController;

interface

uses
  SysUtils,
  Classes,
  Contnrs,
  MyAccess,
  U_Supplier,
  U_DBMapping;

type
  TSupplierController = class
   public
    Suppliers : TObjectList;

    constructor Create();

    procedure UpdateSuppliers(Connection : TCustomMyConnection);

    function FindSupplier(SupplierId: Int64): TSupplier;

    function IsFilter : Boolean;

    function GetFilter(FieldName : String) : String;
  end;

function GetSupplierController : TSupplierController;

implementation

var
  FSupplierController : TSupplierController;

function GetSupplierController : TSupplierController;
begin
  Result := FSupplierController;
end;


{ TSupplierController }

constructor TSupplierController.Create;
begin
  Suppliers := TObjectList.Create(True);
end;

function TSupplierController.FindSupplier(SupplierId: Int64): TSupplier;
var
  I : Integer;
begin
  for I := 0 to Suppliers.Count-1 do
    if TSupplier(Suppliers[i]).Id = SupplierId then begin
      Result := TSupplier(Suppliers[i]);
      Exit;
    end;
  Result := nil;
end;

function TSupplierController.GetFilter(FieldName: String): String;
var
  I : Integer;
begin
  if not IsFilter then
    Result := ''
  else begin
    Result := '';
    for I := 0 to Suppliers.Count-1 do
      if TSupplier(Suppliers[i]).Selected then begin
        if (Result = '') then
          Result := IntToStr(TSupplier(Suppliers[i]).Id)
        else
          Result := Result + ', ' + IntToStr(TSupplier(Suppliers[i]).Id);
      end;

    if Result = '' then
      Result := ' (' + FieldName + ' = -1) '
    else
      Result := ' (' + FieldName + ' in (' + Result + ')) ';
  end;
end;

function TSupplierController.IsFilter: Boolean;
var
  I : Integer;
begin
  for I := 0 to Suppliers.Count-1 do
    if not TSupplier(Suppliers[i]).Selected then begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

procedure TSupplierController.UpdateSuppliers(
  Connection: TCustomMyConnection);
var
  NewSuppliers : TObjectList;
  I : Integer;
  currentSupplier,
  findedSupplier : TSupplier;
begin
  NewSuppliers := TDBMapping.GetSuppliers(Connection);
  for I := 0 to NewSuppliers.Count-1 do begin
    currentSupplier := TSupplier(NewSuppliers[i]);
    findedSupplier := FindSupplier(currentSupplier.Id);
    if (Assigned(findedSupplier)) then
      currentSupplier.Selected := findedSupplier.Selected
    else
      currentSupplier.Selected := True;
  end;
  FreeAndNil(Suppliers);
  Suppliers := NewSuppliers;
end;

initialization
  FSupplierController := TSupplierController.Create;
end.
