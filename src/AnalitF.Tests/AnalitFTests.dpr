program AnalitFTests;

uses
  Forms,
  SysUtils,
  Windows,
  ActiveX,
  Registry,
  SHDocVw,
  TestFrameWork,
  GUITestRunner,

//AnalitF files

  VCLFixPack in '..\AnalitF\Helpers\VCLFixPack.pas',
  LU_MutexSystem in '..\Common\System\LU_MutexSystem.pas',
  Main in '..\AnalitF\Main.pas' {MainForm},
  DModule in '..\AnalitF\DModule.pas' {DM: TDataModule},
  AProc in '..\AnalitF\AProc.pas',
  DBProc in '..\AnalitF\DBProc.pas',
  Config in '..\AnalitF\Config.pas' {ConfigForm},
  Core in '..\AnalitF\Core.pas' {CoreForm: TFrame},
  CoreFirm in '..\AnalitF\CoreFirm.pas' {CoreFirmForm: TFrame},
  Child in '..\AnalitF\Child.pas' {ChildForm},
  NamesForms in '..\AnalitF\NamesForms.pas' {NamesFormsForm},
  Prices in '..\AnalitF\Prices.pas' {PricesForm},
  Defectives in '..\AnalitF\Defectives.pas' {DefectivesForm},
  Registers in '..\AnalitF\Registers.pas' {RegistersForm},
  FormHistory in '..\AnalitF\FormHistory.pas' {FormsHistoryForm},
  Summary in '..\AnalitF\Summary.pas' {SummaryForm},
  OrdersH in '..\AnalitF\OrdersH.pas' {OrdersHForm},
  Orders in '..\AnalitF\Orders.pas' {OrdersForm},
  Expireds in '..\AnalitF\Expireds.pas' {ExpiredsForm},
  Exchange in '..\AnalitF\Exchange.pas' {ExchangeForm},
  NotFound in '..\AnalitF\NotFound.pas' {NotFoundForm},
  ExchangeThread in '..\AnalitF\ExchangeThread.pas',
  Retry in '..\AnalitF\Retry.pas' {RetryForm},
  SOAPThroughHTTP in '..\AnalitF\SOAPThroughHTTP.pas',
  Constant in '..\AnalitF\Constant.pas',
  Compact in '..\AnalitF\Compact.pas' {CompactForm},
  UniqueID in '..\AnalitF\UniqueID.pas',
  CRC32Unit in '..\AnalitF\CRC32Unit.pas',
  RecThread in '..\AnalitF\RecThread.pas',
  NotOrders in '..\AnalitF\NotOrders.pas' {NotOrdersForm},
  SysNames in '..\Common\System\SysNames.pas',
  AlphaUtils in '..\AnalitF\AlphaUtils.pas',
  About in '..\AnalitF\About.pas' {AboutForm},
  Waiting in '..\AnalitF\Waiting.pas' {WaitingForm},
  CompactThread in '..\AnalitF\CompactThread.pas',
  WayBillList in '..\AnalitF\WayBillList.pas' {WayBillListForm},
  LU_Tracer in '..\Common\Classes\LU_Tracer.pas',
  inforoomapi in '..\AnalitF\RC_RND\inforoomapi.pas',
  hlpcodecs in '..\AnalitF\RC_RND\hlpcodecs.pas',
  incrt in '..\AnalitF\RC_RND\incrt.pas',
  inforoomalg in '..\AnalitF\RC_RND\inforoomalg.pas',
  SevenZip in '..\Common\Utils\SevenZip.pas',
  SQLWaiting in '..\AnalitF\SQLWaiting.pas' {frmSQLWaiting},
  infver in '..\AnalitF\RC_RND\infver.pas',
  infvercls in '..\AnalitF\RC_RND\infvercls.pas',
  SynonymSearch in '..\AnalitF\SynonymSearch.pas' {SynonymSearchForm},
  U_UpdateDBThread in '..\AnalitF\U_UpdateDBThread.pas',
  U_frmOldOrdersDelete in '..\AnalitF\U_frmOldOrdersDelete.pas' {frmOldOrdersDelete},
  U_frmSendLetter in '..\AnalitF\U_frmSendLetter.pas' {frmSendLetter},
  U_SXConversions in '..\Common\XMLParser\U_SXConversions.pas',
  U_SGXMLGeneral in '..\Common\XMLParser\U_SGXMLGeneral.pas',
  U_RecvThread in '..\AnalitF\U_RecvThread.pas',
  U_GroupUtils in '..\AnalitF\U_GroupUtils.pas',
  U_ExchangeLog in '..\AnalitF\U_ExchangeLog.pas',
  U_DeleteDBThread in '..\AnalitF\U_DeleteDBThread.pas',
  U_SendArchivedOrdersThread in '..\AnalitF\U_SendArchivedOrdersThread.pas',
  U_frameLegend in '..\AnalitF\U_frameLegend.pas' {frameLegend: TFrame},
  HFileHelper in '..\AnalitF\Helpers\HFileHelper.pas',
  ULoginHelper in '..\AnalitF\Helpers\ULoginHelper.pas',
  U_VistaCorrectForm in '..\AnalitF\U_VistaCorrectForm.pas' {VistaCorrectForm},
  PreviousOrders in '..\AnalitF\PreviousOrders.pas' {PreviousOrdersForm},
  CorrectOrders in '..\AnalitF\CorrectOrders.pas' {CorrectOrdersForm},
  INFHelpers in '..\AnalitF\RC_RND\INFHelpers.pas',
  MDLHelper in '..\Common\DLLHelper\MDLHelper.pas',
  InforoomException in '..\Common\Exceptions\InforoomException.pas',
  DataIntegrityExceptions in '..\Common\Exceptions\DataIntegrityExceptions.pas',
  PostSomeOrdersController in '..\AnalitF\BusinessLogic\PostSomeOrdersController.pas',
  ExchangeParameters in '..\AnalitF\BusinessLogic\ExchangeParameters.pas',
  EhLibMTE in '..\AnalitF\EhLibMT\EhLibMTE.pas',
  DatabaseObjects in '..\Common\DataLayer\DatabaseObjects.pas',
  CriticalDatabaseObjects in '..\Common\DataLayer\CriticalDatabaseObjects.pas',
  BackupDatabaseObjects in '..\Common\DataLayer\BackupDatabaseObjects.pas',
  DatabaseViews in '..\Common\DataLayer\DatabaseViews.pas',
  IgnoreDatabaseObjects in '..\Common\DataLayer\IgnoreDatabaseObjects.pas',
  SynonymDatabaseObjects in '..\Common\DataLayer\SynonymDatabaseObjects.pas',
  GeneralDatabaseObjects in '..\Common\DataLayer\GeneralDatabaseObjects.pas',
  U_framePosition in '..\AnalitF\U_framePosition.pas' {framePosition: TFrame},
  MnnSearch in '..\AnalitF\MnnSearch.pas' {MnnSearchForm},
  DescriptionFrm in '..\AnalitF\DescriptionFrm.pas' {DescriptionForm},
  NetworkAdapterHelpers in '..\AnalitF\Helpers\NetworkAdapterHelpers.pas',
  DocumentHeaders in '..\AnalitF\DocumentHeaders.pas' {DocumentHeaderForm},
  DocumentBodies in '..\AnalitF\DocumentBodies.pas' {DocumentBodiesForm},
  DocumentTypes in '..\Common\DataLayer\DocumentTypes.pas',
  sumprops in '..\AnalitF\Helpers\sumprops.pas',
  EditVitallyImportantMarkups in '..\AnalitF\EditVitallyImportantMarkups.pas' {EditVitallyImportantMarkupsForm},
  DBGridHelper in '..\AnalitF\Helpers\DBGridHelper.pas',
  PostWaybillsController in '..\AnalitF\BusinessLogic\PostWaybillsController.pas',
  U_frameEditVitallyImportantMarkups in '..\AnalitF\U_frameEditVitallyImportantMarkups.pas' {frameEditVitallyImportantMarkups: TFrame},
  U_frameEditAddress in '..\AnalitF\U_frameEditAddress.pas' {frameEditAddress: TFrame},
  EditAddressForm in '..\AnalitF\EditAddressForm.pas' {EditAddressFrm},
  RegistryHelper in '..\AnalitF\Helpers\RegistryHelper.pas',
  U_OrderBatchForm in '..\AnalitF\U_OrderBatchForm.pas' {OrderBatchForm},
  ArchiveHelper in '..\Common\Helpers\ArchiveHelper.pas',
  U_frameBaseLegend in '..\AnalitF\U_frameBaseLegend.pas' {frameBaseLegend: TFrame},
  U_frameOrderHeadLegend in '..\AnalitF\U_frameOrderHeadLegend.pas' {frameOrderHeadLegend: TFrame},
  StartupHelper in '..\AnalitF\Helpers\StartupHelper.pas',
  SendWaybillTypes in '..\AnalitF\BusinessLogic\SendWaybillTypes.pas',
  GlobalExchangeParameters in '..\AnalitF\BusinessLogic\GlobalExchangeParameters.pas',
  GlobalParams in '..\Common\GlobalParams\GlobalParams.pas',
  TicketReportParams in '..\Common\GlobalParams\TicketReportParams.pas',
  EditTicketReportParams in '..\AnalitF\EditTicketReportParams.pas' {EditTicketReportParamsForm},
  NetworkSettings in '..\Common\GlobalParams\NetworkSettings.pas',
  ExclusiveParams in '..\Common\GlobalParams\ExclusiveParams.pas',
  Exclusive in '..\AnalitF\Exclusive.pas' {ExclusiveForm},
  Wait in '..\AnalitF\Wait.pas' {WaitForm},
  U_MinPricesForm in '..\AnalitF\U_MinPricesForm.pas' {MinPricesForm},
  DataSetHelper in '..\Common\Helpers\DataSetHelper.pas',
  NetworkParams in '..\Common\GlobalParams\NetworkParams.pas',
  U_ServiceLogForm in '..\AnalitF\U_ServiceLogForm.pas' {ServiceLogForm},
  U_frameServiceLogLegend in '..\AnalitF\U_frameServiceLogLegend.pas' {frameServiceLogLegend: TFrame},
  U_Address in '..\Common\Models\U_Address.pas',
  U_CurrentOrderHead in '..\Common\Models\U_CurrentOrderHead.pas',
  U_CurrentOrderItem in '..\Common\Models\U_CurrentOrderItem.pas',
  U_DBMapping in '..\Common\Models\U_DBMapping.pas',
  U_Offer in '..\Common\Models\U_Offer.pas',
  AllOrdersParams in '..\Common\GlobalParams\AllOrdersParams.pas',
  AddressController in '..\AnalitF\BusinessLogic\AddressController.pas',
  U_frameFilterAddresses in '..\AnalitF\Views\U_frameFilterAddresses.pas' {frameFilterAddresses: TFrame},
  KeyboardHelper in '..\Common\Helpers\KeyboardHelper.pas',
  UserMessageParams in '..\Common\GlobalParams\UserMessageParams.pas',
  RackCardReportParams in '..\Common\GlobalParams\RackCardReportParams.pas',
  EditRackCardReportParams in '..\AnalitF\EditRackCardReportParams.pas' {EditRackCardReportParamsForm},
  LU_TDataExportAsXls in '..\Common\Classes\LU_TDataExportAsXls.pas',
  U_Supplier in '..\Common\Models\U_Supplier.pas',
  SupplierController in '..\AnalitF\BusinessLogic\SupplierController.pas',
  U_frameFilterSuppliers in '..\AnalitF\Views\U_frameFilterSuppliers.pas' {frameFilterSuppliers: TFrame},
  U_frameContextReclame in '..\AnalitF\Views\U_frameContextReclame.pas' {frameContextReclame: TFrame},
  GlobalSettingParams in '..\Common\GlobalParams\GlobalSettingParams.pas',
  MyEmbConnectionEx in '..\Common\DataLayer\MyEmbConnectionEx.pas',
  U_ShowPromotionsForm in '..\AnalitF\U_ShowPromotionsForm.pas' {ShowPromotionsForm},
  PromotionLabel in '..\AnalitF\Helpers\PromotionLabel.pas',
  U_SupplierPromotion in '..\Common\Models\U_SupplierPromotion.pas',
  VCLHelper in '..\AnalitF\Helpers\VCLHelper.pas',
  U_framePromotion in '..\AnalitF\Views\U_framePromotion.pas' {framePromotion: TFrame},
  U_frameBlockPromotion in '..\AnalitF\Views\U_frameBlockPromotion.pas' {frameBlockPromotion: TFrame},
  DayOfWeekHelper in '..\Common\Helpers\DayOfWeekHelper.pas',
  DayOfWeekDelaysController in '..\AnalitF\BusinessLogic\DayOfWeekDelaysController.pas',
  InternalRepareOrdersController in '..\AnalitF\BusinessLogic\InternalRepareOrdersController.pas',
  DBViewHelper in '..\AnalitF\Helpers\DBViewHelper.pas',
  U_PrintSettingsForm in '..\AnalitF\Views\U_PrintSettingsForm.pas' {PrintSettingsForm},
  U_WaybillPrintSettingsForm in '..\AnalitF\Views\U_WaybillPrintSettingsForm.pas' {WaybillPrintSettingsForm},
  WaybillReportParams in '..\Common\GlobalParams\WaybillReportParams.pas',
  ReestrReportParams in '..\Common\GlobalParams\ReestrReportParams.pas',
  U_ReestrPrintSettingsForm in '..\AnalitF\Views\U_ReestrPrintSettingsForm.pas' {ReestrPrintSettingsForm},
  U_frameAutoComment in '..\AnalitF\Views\U_frameAutoComment.pas' {frameAutoComment: TFrame},
  U_SchedulesController in '..\AnalitF\BusinessLogic\U_SchedulesController.pas',
  ContextMenuGrid in '..\AnalitF\Helpers\ContextMenuGrid.pas',
  UserActions in '..\AnalitF\BusinessLogic\UserActions.pas',
  U_MiniMailForm in '..\AnalitF\U_MiniMailForm.pas' {MiniMailForm},
  U_frameMiniMail in '..\AnalitF\Views\U_frameMiniMail.pas' {frameMiniMail: TFrame},
  SearchFilterController in '..\AnalitF\BusinessLogic\SearchFilterController.pas',
  U_SerialNumberSearch in '..\AnalitF\Views\U_SerialNumberSearch.pas' {SerialNumberSearch},
  FileCountHelper in '..\AnalitF\Helpers\FileCountHelper.pas',
  U_AddWaybillForm in '..\AnalitF\Views\U_AddWaybillForm.pas' {AddWaybillForm},
  VitallyImportantMarkupsParams in '..\Common\GlobalParams\VitallyImportantMarkupsParams.pas',

//end files
  
  ExceptionClassTests in 'ExceptionClassTests.pas',
  LoadDataTests in 'LoadDataTests.pas',
  TimeZoneTests in 'TimeZoneTests.pas',
  SearchFilterControllerTests in 'SearchFilterControllerTests.pas',
  AProcTests in 'AProcTests.pas',
  INFHelpersTests in 'INFHelpersTests.pas',
  MappingTests in 'MappingTests.pas',
  DBRestoreTests in 'DBRestoreTests.pas';

{$R *.res}

begin
{$ifdef USEMEMORYCRYPTDLL}
  //��������� ������������� MemoryLib, �.�. ��� �� ��������
  DatabaseController.DisableMemoryLib();
{$endif}
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.
