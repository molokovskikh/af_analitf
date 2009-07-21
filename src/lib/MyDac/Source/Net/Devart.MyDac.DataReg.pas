
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//  MyDAC registration
//////////////////////////////////////////////////

unit Devart.MyDac.DataReg;

interface

uses
  Classes;

procedure Register;

implementation

uses
  Devart.MyDac.DataAdapter;

procedure Register;
begin
  RegisterComponents('Data Access', [MyDataAdapter]);
end;

end.