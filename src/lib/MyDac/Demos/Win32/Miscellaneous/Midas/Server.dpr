program Server;

uses
  Forms,
  ServerForm in 'ServerForm.pas' {fmServer},
  Server_TLB in 'Server_TLB.pas',
  Data in 'Data.pas' {Datas: TRemoteDataModule} {Datas: CoClass};

{$R *.TLB}

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfmServer, fmServer);
  Application.Run;
end.
