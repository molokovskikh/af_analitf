program Testdbf;

uses
  Forms,
  Testdbf1 in 'TESTDBF1.PAS' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
