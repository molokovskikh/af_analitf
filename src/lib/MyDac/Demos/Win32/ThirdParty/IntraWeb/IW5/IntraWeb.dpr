program IntraWeb;
{PUBDIST}

uses
  IWInitStandAlone,
  ServerController in 'ServerController.pas' {IWServerController: TIWServerControllerBase},
  uBase in 'uBase.pas' {fmBase: TIWAppForm},
  uMain in 'uMain.pas' {fmMain: TIWAppForm},
  uMasterDetail in 'uMasterDetail.pas' {fmMasterDetail: TIWAppForm},
  uCachedUpdates in 'uCachedUpdates.pas' {fmCachedUpdates: TIWAppForm},
  uData in 'uData.pas' {DM: TDataModule},
  uQuery in 'uQuery.pas' {fmQuery: TIWAppForm};

{$R *.res}

begin
  IWRun(TfmMain, TIWServerController);
end.
