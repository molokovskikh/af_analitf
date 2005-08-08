program AnalitF;

{%ToDo 'AnalitF.todo'}

uses
  Forms,
  SysUtils,
  Main in 'Main.pas' {MainForm},
  DModule in 'DModule.pas' {DM: TDataModule},
  AProc in 'AProc.pas',
  DBProc in 'DBProc.pas',
  Client in 'Client.pas' {ClientForm},
  Config in 'Config.pas' {ConfigForm},
  Core in 'Core.pas' {CoreForm: TFrame},
  CoreFirm in 'CoreFirm.pas' {CoreFirmForm: TFrame},
  Child in 'Child.pas' {ChildForm},
  NamesForms in 'NamesForms.pas' {NamesFormsForm},
  Prices in 'Prices.pas' {PricesForm},
  Defectives in 'Defectives.pas' {DefectivesForm},
  Registers in 'Registers.pas' {RegistersForm},
  FormHistory in 'FormHistory.pas' {FormsHistoryForm},
  Summary in 'Summary.pas' {SummaryForm},
  OrdersH in 'OrdersH.pas' {OrdersHForm},
  Orders in 'Orders.pas' {OrdersForm},
  Expireds in 'Expireds.pas' {ExpiredsForm},
  Exchange in 'Exchange.pas' {ExchangeForm},
  NotFound in 'NotFound.pas' {NotFoundForm},
  ActiveUsers in 'ActiveUsers.pas' {ActiveUsersForm},
  ExchangeThread in 'ExchangeThread.pas',
  Retry in 'Retry.pas' {RetryForm},
  SOAPThroughHTTP in 'SOAPThroughHTTP.pas',
  ProVersion in 'ProVersion.pas',
  Constant in 'Constant.pas',
  Compact in 'Compact.pas' {CompactForm},
  UniqueID in 'UniqueID.pas',
  CRC32Unit in 'CRC32Unit.pas',
  RecThread in 'RecThread.pas',
  NotOrders in 'NotOrders.pas' {NotOrdersForm},
  Integr in 'Integr.pas',
  SysNames in 'SysNames.pas',
  Exclusive in 'Exclusive.pas' {ExclusiveForm},
  Wait in 'Wait.pas' {WaitForm},
  AlphaUtils in 'AlphaUtils.pas',
  About in 'About.pas' {AboutForm},
  Waiting in 'Waiting.pas' {WaitingForm},
  CompactThread in 'CompactThread.pas',
  ExternalOrders in 'ExternalOrders.pas',
  ShowLog in 'ShowLog.pas' {frmShowLog},
  WayBillList in 'WayBillList.pas' {WayBillListForm},
  U_FolderMacros in 'U_FolderMacros.pas',
  LU_Tracer in 'common\LU_Tracer.pas';

{$R *.RES}
{$R EraserDLL.RES}
{$R Progress.RES}
{$R Icons.RES}

begin
  Application.Initialize;
  Application.Title := '¿Ì‡ÎËÚ‘¿–Ã¿÷»ﬂ';
  Application.CreateForm(TMainForm, MainForm);
  MainForm.FormPlacement.IniFileName := 'Software\Inforoom\AnalitF\' +
	IntToHex( GetCopyID, 8) + '\';
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
