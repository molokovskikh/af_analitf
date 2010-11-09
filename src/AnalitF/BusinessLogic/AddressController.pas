unit AddressController;

interface

uses
  SysUtils,
  Classes,
  Contnrs,
  MyAccess,
  AllOrdersParams,
  U_Address,
  U_DBMapping;

type
  TAddressController = class
   private
    FAllOrders : TAllOrdersParams;
    function GetShowAllOrders: Boolean;
    procedure SetShowAllOrders(const Value: Boolean);
   public
    Addresses : TObjectList;
    CurrentAddress : TAddress;

    constructor Create();

    procedure UpdateAddresses(Connection : TCustomMyConnection; CurrentId : Int64);

    function AllowAllOrders : Boolean;

    function FindAddress(AddressId: Int64): TAddress;

    function IsFilter : Boolean;

    function IsCurrent(AddressName : String) : Boolean;

    procedure ChangeCurrent(CurrentId : Int64);

    function GetFilter(FieldName : String) : String; 

    property ShowAllOrders: Boolean read GetShowAllOrders write SetShowAllOrders;

  end;

function GetAddressController : TAddressController;

implementation

var
  FAddressController : TAddressController;

function GetAddressController : TAddressController;
begin
  Result := FAddressController;
end;

{ TAddressController }

function TAddressController.AllowAllOrders: Boolean;
begin
  Result := Addresses.Count > 1;
end;

procedure TAddressController.ChangeCurrent(CurrentId: Int64);
begin
  CurrentAddress := FindAddress(CurrentId);
end;

constructor TAddressController.Create;
begin
  FAllOrders := nil;
  CurrentAddress := nil;
  Addresses := TObjectList.Create(True);
end;

function TAddressController.FindAddress(AddressId: Int64): TAddress;
var
  I : Integer;
begin
  for I := 0 to Addresses.Count-1 do
    if TAddress(Addresses[i]).Id = AddressId then begin
      Result := TAddress(Addresses[i]);
      Exit;
    end;
  Result := nil;
end;

function TAddressController.GetFilter(FieldName: String): String;
var
  I : Integer;
begin
  if not IsFilter then
    Result := ''
  else begin
    Result := '';
    for I := 0 to Addresses.Count-1 do
      if TAddress(Addresses[i]).Selected then begin
        if (Result = '') then
          Result := IntToStr(TAddress(Addresses[i]).Id)
        else
          Result := Result + ', ' + IntToStr(TAddress(Addresses[i]).Id);
      end;

    if Result = '' then
      Result := ' (' + FieldName + ' = -1) '
    else
      Result := ' (' + FieldName + ' in (' + Result + ')) ';
  end;
end;

function TAddressController.GetShowAllOrders: Boolean;
begin
  Result := Assigned(FAllOrders) and FAllOrders.ShowAllOrders;
end;

function TAddressController.IsCurrent(AddressName: String): Boolean;
begin
  Result := Assigned(CurrentAddress) and (CompareText(CurrentAddress.Name, AddressName) = 0);
end;

function TAddressController.IsFilter: Boolean;
var
  I : Integer;
begin
  for I := 0 to Addresses.Count-1 do
    if not TAddress(Addresses[i]).Selected then begin
      Result := True;
      Exit;
    end;
  Result := False;
end;

procedure TAddressController.SetShowAllOrders(const Value: Boolean);
begin
  if (Assigned(FAllOrders)) then begin
    FAllOrders.ShowAllOrders := Value;
    FAllOrders.SaveParams;
  end;
end;

procedure TAddressController.UpdateAddresses(
  Connection: TCustomMyConnection;
  CurrentId : Int64);
var
  NewAddresses : TObjectList;
  I : Integer;
  currentAddress,
  findedAddress : TAddress;
begin
  if not Assigned(FAllOrders) then
    FAllOrders := TAllOrdersParams.Create(Connection)
  else
    FAllOrders.ReadParams;

  Self.CurrentAddress := nil;

  NewAddresses := TDBMapping.GetAddresses(Connection);
  for I := 0 to NewAddresses.Count-1 do begin
    currentAddress := TAddress(NewAddresses[i]);
    findedAddress := FindAddress(currentAddress.Id);
    if (Assigned(findedAddress)) then
      currentAddress.Selected := findedAddress.Selected
    else
      currentAddress.Selected := True;
    if currentAddress.Id = CurrentId then
      Self.CurrentAddress := currentAddress;
  end;
  FreeAndNil(Addresses);
  Addresses := NewAddresses;
end;

initialization
  FAddressController := TAddressController.Create;
end.
