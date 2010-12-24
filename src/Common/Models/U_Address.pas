unit U_Address;

interface

type

  TAddress = class
   public
    Id : Int64;
    Name : String;
    FullName : String;
    SelfAddressId : String;
    RegionCode : Int64;
    ReqMask : Int64;
    Selected : Boolean;
  end;

implementation

end.