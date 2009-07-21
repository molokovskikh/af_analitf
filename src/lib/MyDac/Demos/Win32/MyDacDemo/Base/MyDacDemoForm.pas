{$I DacDemo.inc}

unit MyDacDemoForm;

interface

uses
  SysUtils, Classes, DB,
{$IFDEF CLR}
  System.ComponentModel,
{$ENDIF}
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  MyDacVcl, Menus, ImgList, Controls, StdCtrls, Buttons,
  ExtCtrls,  ComCtrls, ToolWin, {$IFNDEF VER130}Variants,{$ENDIF} Graphics,
  Forms, Dialogs,
{$ELSE}
  QMenus, QTypes, QImgList, QStdCtrls, QControls, QGraphics,
  QComCtrls, QButtons, QExtCtrls, MyDacClx, QDialogs,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DBAccess,  MyAccess, MydacAbout, DemoFrame, DemoForm, DemoBase, DAScript,
  MyScript, ConnectDialog;

type
  TMyDacForm = class(TDemoForm)
    MyConnection: TMyConnection;
    MyConnectDialog1: TMyConnectDialog;
    scDrop: TMyScript;
    scCreate: TMyScript;
    procedure lbAboutClick(Sender: TObject); override;
    procedure cbDebugClick(Sender: TObject);
  private
    { Private declarations }
  protected
        //Product customization
    function GetConnection: TCustomDAConnection; override;
    function ApplicationTitle: string; override;
    function ProductName: string; override;
    procedure RegisterDemos; override;
  public
    function ProductColor: TColor; override;
    procedure ExecCreateScript; override;
    procedure ExecDropScript; override;
  end;

var
  MyDacForm: TMyDacForm;

implementation

uses
  Command,
{$IFDEF CRDBGRID}
  CRDBGrid,
{$ENDIF}
{$IFNDEF STD}
  Loader, Dump,
{$ENDIF}
  Query, Table, UpdateSQL, VirtualTable, CachedUpdates, MasterDetail,
  Pictures, Text, Transactions, Lock, VTable, FilterAndIndex, StoredProc;

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ENDIF}
{$IFDEF WIN32}
{$R *.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

function TMyDACForm.GetConnection: TCustomDAConnection;
begin
  Result := MyConnection;
end;

function TMyDACForm.ProductColor: TColor;
begin
  Result := $00FD2B0F;
end;

procedure TMyDACForm.ExecCreateScript;
begin
  scCreate.OnError := OnScriptError;
  scCreate.Execute;
end;

procedure TMyDACForm.ExecDropScript;
begin
  scDrop.OnError := OnScriptError;
  scDrop.Execute;
end;

function TMyDACForm.ApplicationTitle: string;
begin
  Result := 'Data Access Components for MySQL demos';
end;

function TMyDACForm.ProductName: string;
begin
  Result := 'MyDAC';
end;

procedure TMyDACForm.RegisterDemos;
begin
  Demos.RegisterCategory('MyDAC Demo', 'MyDAC Demo');

  Demos.RegisterCategory('Working with components', 'Working with components'); // peculiarities of TreeView under Kilyx
  Demos.RegisterDemo('Command', 'Using the TMyCommand component', 'Uses TMyCommand to execute SQL statements. Demonstrates how to execute commands in a separate thread, and how to break long-duration query execution.', 'Working with components', TCommandFrame, 2);
  Demos.RegisterDemo('ConnectDialog', 'Customizing login dialog', 'Demonstrates how to customize the MyDAC connect dialog. Changes the standard MyDAC connect dialog to two custom connect dialogs. The first customized sample dialog is inherited from the TForm class, ' + 'and the second one is inherited from the default MyDAC connect dialog class.', 'Working with components', TConnectDialogFrame, 2);
{$IFDEF CRDBGRID}
  Demos.RegisterDemo('CRDBGrid', 'Using the TCRDBGrid component', 'Demonstrates how to work with the TCRDBGrid component.  Shows off the main TCRDBGrid features, like filtering, searching, stretching, using compound headers, and more.', 'Working with components', TCRDBGridFrame, 3);
{$ENDIF}
{$IFNDEF STD}
  Demos.RegisterDemo('Dump', 'Using the TMyDump component', 'Demonstrates how to backup data and structure from tables with the TMyDump component. Shows how to use scripts created during back up to restore table structure and data. ' + 'This demo lets you back up a table either by specifying the table name or by writing a SELECT query.', 'Working with components', TDumpFrame, 4);
  Demos.RegisterDemo('Loader', 'Using the TMyLoader component', 'Uses the TMyLoader component to quickly load data into a server table. TMyLoader loads data by grouping several data rows into a single INSERT statement and executing this statement.' + ' This way is much faster then execuing one INSERT statement per row. This demo also compares the two TMyLoader data loading handlers: GetColumnData and PutData.', 'Working with components', TLoaderFrame, 5);
{$ENDIF}
  Demos.RegisterDemo('Query', 'Using the TMyQuery component', 'Demonstrates working with TMyQuery, which is one of the most useful MyDAC components. Includes many TMyQuery usage scenarios. Demonstrates how to edit data and export it to XML files. ' + 'Note: This is a very good introductory demo. We recommend starting here when first becoming familiar with MyDAC.', 'Working with components', TQueryFrame, 6);
  Demos.RegisterDemo('StoredProc', 'Using the TMyStoredProc component', 'Uses TMyStoredProc to access an editable recordset from an MySQL stored procedure in the client application.', 'Working with components', TStoredProcFrame, 6);
  Demos.RegisterDemo('Table', 'Using the TMyTable component', 'Demonstrates how to use TMyTable to work with data from a single table on the server without manually writing any SQL queries. Performs server-side data sorting and filtering and retrieves results for browsing and editing.', 'Working with components', TTableFrame, 7);
  Demos.RegisterDemo('UpdateSQL', 'Using the TMyUpdateSQL component', 'Demonstrates using the TMyUpdateSQL component to customize update commands. Lets you optionally use TMyCommand and TMyQuery objects for carrying out insert, delete, query, and update commands.', 'Working with components', TUpdateSQLFrame, 8);
  Demos.RegisterDemo('VirtualTable', 'Using the TVirtualTable component', 'Demonstrates working with the TVirtualTable component. This sample shows how to fill virtual dataset with data from other datasets, filter data by a given criteria, locate specified records, perform file operations, and change data and table structure.', 'Working with components', TVirtualTableFrame, 9, 'VTable');

  Demos.RegisterCategory('General demos', 'General demos');                       // peculiarities of TreeView under Kilyx
  Demos.RegisterDemo('CachedUpdates', 'Cached updates, transaction control', 'Demonstrates how to perform the most important tasks of working with data in CachedUpdates mode, including highlighting uncommitted changes, managing transactions, and committing changes in a batch.', 'General demos', TCachedUpdatesFrame, 1);
  Demos.RegisterDemo('FilterAndIndex', 'Using Filter and IndexFieldNames', 'Demonstrates MyDAC''s local storage functionality. This sample shows how to perform local filtering, sorting and locating by multiple fields, including by calculated and lookup fields.', 'General demos', TFilterAndIndexFrame, 1);
  Demos.RegisterDemo('MasterDetail', 'Master/detail relationship', 'Uses MyDAC functionality to work with master/detail relationships. This sample shows how to use local master/detail functionality. Demonstrates different kinds of master/detail linking, inluding linking by SQL, by simple fields, and by calculated fields.', 'General demos', TMasterDetailFrame, 1);
  Demos.RegisterDemo('Pictures', 'Working with BLOB field', 'Uses MyDAC functionality to work with graphics. The sample demonstrates how to retrieve binary data from MySQL database and display it on visual components. Sample also shows how to load and save pictures to files and to the database.', 'General demos', TPicturesFrame, 1);
  Demos.RegisterDemo('Text', 'Working with the Text fields', 'Uses MyDAC functionality to work with text. The sample demonstrates how to retrieve text data from MySQL database and display it on visual components. Sample also shows how to load and save text to files and to the database.', 'General demos', TTextFrame, 1);
  Demos.RegisterDemo('Transactions', 'Working with transaction control', 'Demonstrates the recommended approach for managing transactions with the TMyConnection component. The TMyConnection interface provides a wrapper for MySQL server commands like START TRANSACTION, COMMIT, ROLLBACK.', 'General demos', TTransactionsFrame, 1);

  Demos.RegisterCategory('MySQL-specific Demos', 'MySQL-specific Demos');            // peculiarities of TreeView under Kilyx
  Demos.RegisterDemo('Lock', 'Editing data with row-level locking', 'Demonstrates two kinds of row-level locking (immediate locking and delayed locking) with the InnoDB storage engine. This functionality is based on the following MySQL commands: SELECT ... FOR UPDATE and SELECT ... LOCK IN SHARE MODE.', 'MySQL-specific Demos', TLockFrame, 1);

// Registering Supplementary Demo Projects

  Demos.RegisterCategory('Miscellaneous', '', -1, True);
{$IFDEF CLR}
  Demos.RegisterDemo('AspNet', 'AspNet', 'Uses MyDataAdapter to create a simple ASP .NET application. This application creates an ASP.NET application that lets you connect to a database and execute queries.' + '  Shows how to display query results in a DataGrid and send user changes back to the database.', 'Miscellaneous', nil, 1, '', True);
{$ENDIF}
{$IFNDEF CLR}
  Demos.RegisterDemo('Dll', 'Dll', 'Demonstrates creating and loading DLLs for MyDAC-based projects. This demo project consists of two parts - an My_Dll project that creates a DLL of a form that sends a query to the server and displays ' + 'its results, and an My_Exe project that can be executed to display a form for loading and running this DLL.  Allows you to build a dll for one MyDAC-based project and load and test it from a separate application.', 'Miscellaneous', nil, 1, '', True);
{$ENDIF}
  Demos.RegisterDemo('FailOver', 'FailOver', 'Demonstrates the recommended approach to working with unstable networks. This sample lets you perform transactions and updates in several different modes, simulate a sudden session termination, ' + 'and view what happens to your data state when connections to the server are unexpectedly lost.  Shows off CachedUpdates, LocalMasterDetail, FetchAll, Pooling, and different Failover modes.', 'Miscellaneous', nil, 1, '', True);
{$IFNDEF CLR}
  Demos.RegisterDemo('Midas', 'Midas', 'Demonstrates using MIDAS technology with MyDAC.  This project consists of two parts: a MIDAS server that processes requests to the database and a thin MIDAS client that displays an interactive grid.  ' + 'This demo shows how to build thin clients that display interactive components and delegate all database interaction to a server application for processing. ', 'Miscellaneous', nil, 1, '', True);
{$ENDIF}
{$IFDEF CLR}
  Demos.RegisterDemo('WinForms', 'WinForms', 'Shows how to use MyDAC to create a  WinForm application. This demo project creates a simple WinForms application and fills a data grid from an MyDataAdapter data source.', 'Miscellaneous', nil, 1, '', True);
{$ENDIF}

{$IFNDEF CLR}
  Demos.RegisterCategory('', '', -1, True);
{$ENDIF}
  Demos.RegisterCategory('TechnologySpecific', '', -1, True);
  Demos.RegisterDemo('Embedded', 'Embedded', 'Demonstrates working with MySQL Embedded server by using the TMyEmbConnection component. This demo creates a database structure, if it does not already exist, opens a table from this database. ' + 'Also this demo shows how to process the log messages of the Embedded server.', 'TechnologySpecific', nil, 1, '', True);
  Demos.RegisterDemo('SecureBridge', 'SecureBridge', 'The demo project demonstrates how to integrate the SecureBridge components with MyDAC to ensure secure connection to MySQL server through an SSH tunnel. '
    + 'This demo consists of two parts. The first part is a package that contains the TMySSHIOHandler component. The TMySSHIOHandler component provides integration with the SecureBridge library. '
    + 'The second part is a sample project that demonstrates how to connect to MySQL server through an SSH server, connect to the SSH server with SecureBridge by password or by key, generate reliable random numbers, enable local port forwarding.', 'TechnologySpecific', nil, 1, '', True);
{$IFDEF WEB}
  Demos.RegisterCategory('', '', -1, True);
{$ENDIF}

{$IFNDEF CLR}
  Demos.RegisterCategory('ThirdParty', '', -1, True);
  Demos.RegisterDemo('FastReport', 'FastReport', 'Demonstrates how MyDAC can be used with FastReport components. This project consists of two parts.  The first part is several packages that integrate MyDAC components into the FastReport editor.' + ' The second part is a demo application that lets you design and preview reports with MyDAC technology in the FastReport editor.', 'ThirdParty', nil, 1, '', True);
  Demos.RegisterDemo('InfoPower', 'InfoPower', 'Uses InfoPower components to display recordsets retrieved with DAC.  This demo project displays an InfoPower grid component and fills it with the result of an MyDAC query.' + '  Shows how to link MyDAC data sources to InfoPower components.', 'ThirdParty', nil, 1, '', True);
  Demos.RegisterDemo('IntraWeb', 'IntraWeb', 'A collection of sample projects that show how to use MyDAC components as data sources for IntraWeb  applications.  Contains IntraWeb samples for setting up a connection, querying ' + 'a database and modifying data and working with CachedUpdates and MasterDetail relationships.', 'ThirdParty', nil, 1, '', True);
  Demos.RegisterDemo('QuickReport', 'QuickReport', 'Lets you launch and view a QuickReport application based on MyDAC.  This demo project lets you modify the application in design-time.', 'ThirdParty', nil, 1, '', True);
  Demos.RegisterDemo('ReportBuilder', 'ReportBuilder', 'Uses MyDAC data sources to create a ReportBuilder report that takes data from a MySQL database. This demo project shows how to set up a ReportBuilder document in design-time and how to integrate ' + 'MyDAC components into the Report Builder editor to perform document design in run-time.', 'ThirdParty', nil, 1, '', True);
{$IFDEF WEB}
  Demos.RegisterCategory('', '', -1, True);
{$ENDIF}
{$ENDIF}

end;

procedure TMyDACForm.lbAboutClick(Sender: TObject);
begin
  inherited;
  MyDacAboutForm.ShowModal;
end;

procedure TMyDacForm.cbDebugClick(Sender: TObject);
begin
  inherited;
  scCreate.Debug := (Sender as TCheckBox).Checked;
  scDrop.Debug := (Sender as TCheckBox).Checked;
end;

{$IFDEF FPC}
initialization
  {$i MyDacDemoForm.lrs}
{$ENDIF}

end.
