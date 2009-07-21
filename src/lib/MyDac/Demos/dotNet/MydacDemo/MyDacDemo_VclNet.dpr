program MyDacDemo_VclNet;

{%DelphiDotNetAssemblyCompiler '$(SystemRoot)\microsoft.net\framework\v1.1.4322\System.Drawing.dll'}

uses
  Forms,
  CategoryFrame in 'Base\CategoryFrame.pas' {CategoryFrame},
  DemoBase in 'Base\DemoBase.pas',
  DemoForm in 'Base\DemoForm.pas' {DemoForm},
  DemoFrame in 'Base\DemoFrame.pas' {DemoFrame},
  HtmlConsts in 'Base\HtmlConsts.pas',
  VTable in 'VirtualTable\VTable.pas',
  MyDacAbout in 'Base\MyDacAbout.pas' {MyDacAboutForm},
  Command in 'Command\Command.pas',
  MyDacDemoForm in 'Base\MyDacDemoForm.pas' {MyDacForm},
{$IFNDEF STD}
  Loader in 'Loader\Loader.pas' {LoaderFrame},
  Fetch in 'Loader\Fetch.pas' {FetchForm},
  Dump in 'Dump\Dump.pas' {DumpFrame},
{$ENDIF}
  Query in 'Query\Query.pas' {QueryFrame},
  Table in 'Table\Table.pas' {TableFrame},
  Text in 'Text\Text.pas' {TextFrame},
  Transactions in 'Transactions\Transactions.pas' {TransactionsFrame},
  UpdateSQL in 'UpdateSQL\UpdateSQL.pas' {UpdateSQLFrame},
  UpdateAction in 'CachedUpdates\UpdateAction.pas' {UpdateActionForm},
  CachedUpdates in 'CachedUpdates\CachedUpdates.pas' {CachedUpdatesFrame},
  MasterDetail in 'MasterDetail\MasterDetail.pas' {MasterDetailFrame},
  Pictures in 'Pictures\Pictures.pas' {PicturesFrame},
  CRDBGrid in 'CRDBGrid\CRDBGrid.pas' {CRDBGrid},
  FilterAndIndex in 'FilterAndIndex\FilterAndIndex.pas' {FilterAndIndex},
  Lock in 'Lock\Lock.pas' {LockFrame},
  StoredProc in 'StoredProc\StoredProc.pas' {StoredProcFrame: TFrame};

{$R *.res}

[STAThread]

begin
  Application.Initialize;
  Application.CreateForm(TMyDACForm, MyDACForm);
  Application.CreateForm(TMyDacAboutForm, MyDacAboutForm);
  Application.Run;
end.
