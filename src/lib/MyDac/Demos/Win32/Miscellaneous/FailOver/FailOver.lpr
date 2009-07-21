program FailOver;

uses
  Interfaces, // this includes the LCL widgetset
  Forms,
  Main in 'Main.pas' {MainForm},
  Data in 'Data.pas' {DM: TDataModule},
  About in 'About.pas' {AboutForm};

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
