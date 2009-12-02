program example;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  FakeDll in 'FakeDll.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
