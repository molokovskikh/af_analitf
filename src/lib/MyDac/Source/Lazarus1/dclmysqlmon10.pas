unit dclmysqlmon10; 

interface

uses
  MySQLMonReg, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('MySQLMonReg', @MySQLMonReg.Register); 
end; 

initialization
  RegisterPackage('dclmysqlmon10', @Register); 
end.
