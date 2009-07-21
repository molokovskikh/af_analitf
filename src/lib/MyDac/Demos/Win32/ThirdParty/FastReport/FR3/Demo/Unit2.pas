unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  frxDBSet, DBTables, Db, frxClass, MemDS, DBAccess, MyAccess;

type
  TReportData = class(TDataModule)
    MyConnection: TMyConnection;
    Dept: TMyTable;
    Emp: TMyTable;
    DeptSource: TDataSource;
    EmpSource: TDataSource;
    DeptDS: TfrxDBDataset;
    EmpDS: TfrxDBDataset;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReportData: TReportData;

implementation

{$R *.DFM}

end.
