unit Devart.MyDac.DataAdapter;

interface

uses 
  DB, System.Data.Common, System.Data, Devart.Dac.DataAdapter,
  Variants, System.ComponentModel;

type
  TDataTableArr = array of DataTable;
  IDataParameterArr = array of IDataParameter;

  MyDataAdapter = class (DADataAdapter)
  published
    property DataSet;
  end;

implementation

uses Classes, SysUtils, MyAccess;

{$R ..\..\Images\Devart.MyDac.DataAdapter.MyDataAdapter.bmp}

end.
