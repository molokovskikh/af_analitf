unit dclmydac10; 

interface

uses
  MyDacReg, MyDesign, MyConnectionEditor, MyEmbConParamsEditor, MyQueryEditor, 
    MyStoredProcEditor, MyCommandEditor, MyParamsFrame, MyUpdateSQLEditor, 
    MyDumpEditor, MyServerControlEditor, MyDesignUtils, MyNamesEditor, 
    LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('MyDacReg', @MyDacReg.Register); 
  RegisterUnit('MyDesign', @MyDesign.Register); 
end; 

initialization
  RegisterPackage('dclmydac10', @Register); 
end.
