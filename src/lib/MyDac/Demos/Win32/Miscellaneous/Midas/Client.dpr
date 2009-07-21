program Client;

uses
  Forms,
  ClientForm in 'ClientForm.pas' {fmClient};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmClient, fmClient);
  Application.Run;
end.
