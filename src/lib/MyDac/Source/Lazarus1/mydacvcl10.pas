{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit mydacvcl10; 

interface

uses
  MyBuilderIntf, MyBuilderClient, MyConnectForm, MyDacVcl, LazarusPackageIntf;

implementation

procedure Register; 
begin
end; 

initialization
  RegisterPackage('mydacvcl10', @Register); 
end.
