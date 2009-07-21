// FastReport 2.7 demo
unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Class, FR_DSet, FR_DBSet, Db, DBTables, FR_Chart, FR_Desgn,
  MyDacVcl, Buttons, FR_MyDACDB;

type
  TForm1 = class(TForm)
    frReport1: TfrReport;
    Button1: TButton;
    frDesigner1: TfrDesigner;
    BitBtn1: TBitBtn;
    frMyDACComponents1: TfrMyDACComponents;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  frReport1.DesignReport;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  frReport1.ShowReport;
end;

end.
