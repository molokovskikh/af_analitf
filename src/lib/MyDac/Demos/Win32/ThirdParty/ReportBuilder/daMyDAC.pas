
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998,2000 Devart. All right reserved.
//  ReportBuilder support
//  Based on Digital Metaphors Corporation's demos
//////////////////////////////////////////////////

unit daMyDAC;

interface
uses
  Classes, SysUtils, Forms, ExtCtrls, DB,
  ppClass, ppComm, ppDBPipe, ppDB, ppClasUt, ppTypes,
  daDB, daDataView, daQueryDataView, daPreviewDataDlg,
  MyAccess;

type
  {Data Access Components for MySQL (MyDAC) DataView Classes:
     1.  MyDAC TDataSet descendants
           - TDataSets that can be children of a DataView.
           - Override the HasParent method of TComponent to return True
           - Must be registerd with the Delphi IDE using the RegisterNoIcon procedure

       a. TdaChildMyDACQuery        - TMyQuery descendant that can be a child of a DataView
       b. TdaChildMyDACTable        - TMyTable descendant that can be a child of a DataView

     3.  TdaMyDACSession
           - descendant of TppSession
           - implements GetDatabaseNames, GetTableNames, etc.

     4.  TdaMyDACDataSet
          - descendant of TppDataSet
          - implements GetFieldNames for SQL

     5.  TdaMyDACQueryDataView
          - descendant of TppQueryDataView
          - uses the above classes to create the required
            Query -> DataSource -> Pipeline -> Report connection
          - uses the TdaSQL object built by the QueryWizard to assign
            SQL to the TMyDACQuery etc.
      }

  { TdaChildMyDACQuery }
  TdaChildMyDACQuery = class(TMyQuery)
  public
    function HasParent: Boolean; override;
  end;  {class, TdaChildMyDACQuery}

  { TdaChildMyDACTable }
  TdaChildMyDACTable = class(TMyTable)
  public
    function HasParent: Boolean; override;
  end;  {class, TdaChildMyDACTable}

  { TdaMyDACSession }
  TdaMyDACSession = class(TdaSession)
  private

    procedure AddDatabase(aDatabase: TComponent);

  protected
    procedure SetDataOwner(aDataOwner: TComponent); override;

  public
    class function ClassDescription: String; override;
    class function DataSetClass: TdaDataSetClass; override;
    class function DatabaseClass: TComponentClass; override;

    procedure GetDatabaseNames(aList: TStrings); override;
    function  GetDatabaseType(const aDatabaseName: String): TppDatabaseType; override;
    procedure GetTableNames(const aDatabaseName: String; aList: TStrings); override;
    function  ValidDatabaseTypes: TppDatabaseTypes; override;
  end; {class, TdaMyDACSession}

  { TdaMyDACDataSet }
  TdaMyDACDataSet = class(TdaDataSet)
  private
    FQuery: TMyQuery;
    FConnection: TMyConnection;

    function GetQuery: TMyQuery;

  protected
    procedure BuildFieldList; override;
    function  GetActive: Boolean; override;
    procedure SetActive(Value: Boolean); override;
    procedure SetDatabase(aDatabase: TComponent); override;
    procedure SetDataName(const aDataName: String); override;

    property Query: TMyQuery read GetQuery;

  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    class function ClassDescription: String; override;

    procedure GetFieldNamesForSQL(aList: TStrings; aSQL: TStrings); override;
    procedure GetFieldsForSQL(aList: TList; aSQL: TStrings); override;
  end; {class, TdaMyDACDataSet}

  { TdaMyDACQueryDataView }
  TdaMyDACQueryDataView = class(TdaQueryDataView)
    private
      FDataSource: TppChildDataSource;
      FQuery: TdaChildMyDACQuery;

    protected
      procedure SQLChanged; override;

    public
      constructor Create(aOwner: TComponent); override;
      destructor Destroy; override;

      class function PreviewFormClass: TFormClass; override;
      class function SessionClass: TClass; override;

      procedure Init; override;
      procedure ConnectPipelinesToData; override;

    published
      property DataSource: TppChildDataSource read FDataSource;

  end; {class, TdaMyDACQueryDataView}


  {global functions to access default MyDAC connection}
  function daGetDefaultMyDACConnection: TMyConnection;

  {utility routines}
  procedure daGetMyDACConnectionNames(aList: TStrings);
  function daGetMyDACConnectionForName(aDatabaseName: String): TMyConnection;
  function daMyDACConnectToDatabase(aDatabaseName: String): Boolean;

  function daGetMyDACConnectionList: TppComponentList;

  {Delphi design time registration}
  procedure Register;

implementation

const
  cDefaultConnection = 'DefaultMyDACConnection';

var
  FMyDACConnection: TMyConnection;
  FMyDACConnectionList: TppComponentList;


{******************************************************************************
 *
 ** R E G I S T E R
 *
{******************************************************************************}

procedure Register;
begin
  {MyDAC DataAccess Components}
  RegisterNoIcon([TdaChildMyDACQuery, TdaChildMyDACTable]);

  {MyDAC DataViews}
  RegisterNoIcon([TdaMyDACQueryDataView]);
end;


{******************************************************************************
 *
 ** C H I L D  M y D A C  D A T A   A C C E S S   C O M P O N E N T S
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TdaChildMyDACQuery.HasParent }

function TdaChildMyDACQuery.HasParent: Boolean;
begin
  Result := True;
end; {function, HasParent}

{------------------------------------------------------------------------------}
{ TdaChildMyDACTable.HasParent }

function TdaChildMyDACTable.HasParent: Boolean;
begin
  Result := True;
end; {function, HasParent}

{******************************************************************************
 *
 ** M y D A C  S E S S I O N
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TdaMyDACSession.ClassDescription }

class function TdaMyDACSession.ClassDescription: String;
begin
  Result := 'MyDACSession';
end; {class function, ClassDescription}

{------------------------------------------------------------------------------}
{ TdaMyDACSession.DataSetClass }

class function TdaMyDACSession.DataSetClass: TdaDataSetClass;
begin
  Result := TdaMyDACDataSet;
end; {class function, DataSetClass}

{------------------------------------------------------------------------------}
{ TdaMyDACSession.DatabaseClass }

class function TdaMyDACSession.DatabaseClass: TComponentClass;
begin
  Result := TMyConnection;
end;

{------------------------------------------------------------------------------}
{ TdaMyDACSession.GetDatabaseType }

function TdaMyDACSession.GetDatabaseType(const aDatabaseName: String): TppDatabaseType;
begin
  Result := dtMySQL;
end; {procedure, GetDatabaseType}

{------------------------------------------------------------------------------}
{ TdaMyDACSession.GetTableNames }

procedure TdaMyDACSession.GetTableNames(const aDatabaseName: String; aList: TStrings);
begin
  aList.Clear;

  {get list of table names from a table object}
  if not daMyDACConnectToDatabase(aDatabaseName) then Exit;

  GetTablesList(daGetMyDACConnectionForName(aDatabaseName), aList);
end; {procedure, GetTableNames}

{------------------------------------------------------------------------------}
{ TdaMyDACSession.AddDatabase }

procedure TdaMyDACSession.AddDatabase(aDatabase: TComponent);
begin
  if daGetMyDACConnectionList.IndexOf(aDatabase) < 0 then
    FMyDACConnectionList.Add(aDatabase);
end; {procedure, AddDatabase}

{------------------------------------------------------------------------------}
{ TdaMyDACSession.GetDatabaseNames }

procedure TdaMyDACSession.GetDatabaseNames(aList: TStrings);
var
  liIndex: Integer;
begin
//  GetDatabasesList(FMyDACConnection, aList);
  
  {call utility routine to get list of database names}
  //daGetMyDACConnectionNames(aList);

  daGetDatabaseObjectsFromOwner(TdaSessionClass(Self.ClassType), aList, DataOwner);

  for liIndex := 0 to aList.Count-1 do
    if aList.Objects[liIndex] <> nil then
      AddDatabase(TComponent(aList.Objects[liIndex]));//*)
end; {procedure, GetDatabaseNames}

{------------------------------------------------------------------------------}
{ TdaMyDACSession.SetDataOwner }

procedure TdaMyDACSession.SetDataOwner(aDataOwner: TComponent);
var
  lList: TStringList;
begin
  inherited SetDataOwner(aDataOwner);

  lList := TStringList.Create;

  GetDatabaseNames(lList);

  lList.Free;
end; {procedure, SetDataOwner}

{------------------------------------------------------------------------------}
{ TdaMyDACSession.ValidDatabaseTypes }

function TdaMyDACSession.ValidDatabaseTypes: TppDatabaseTypes;
begin
  Result := [dtMySQL];
end; {function, ValidDatabaseTypes}

{******************************************************************************
 *
 ** M y D A C  D A T A S E T
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.Create }

constructor TdaMyDACDataSet.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  FQuery := nil;
end; {constructor, Create}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.Destroy }

destructor TdaMyDACDataSet.Destroy;
begin
  FQuery.Free;

  inherited Destroy;
end; {destructor, Destroy}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.ClassDescription }

class function TdaMyDACDataSet.ClassDescription: String;
begin
  Result := 'MyDACDataSet';
end; {class function, ClassDescription}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.GetActive }

function TdaMyDACDataSet.GetActive: Boolean;
begin
  Result := GetQuery.Active
end; {function, GetActive}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.SetActive }

procedure TdaMyDACDataSet.SetActive(Value: Boolean);
begin
  GetQuery.Active := Value;
end; {procedure, SetActive}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.GetQuery }

function TdaMyDACDataSet.GetQuery: TMyQuery;
begin
  {create MyDACDataSet, if needed}
  if (FQuery = nil) then
    FQuery := TMyQuery.Create(Self);

  Result := FQuery;
end; {procedure, GetQuery}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.SetDatabase }

procedure TdaMyDACDataSet.SetDatabase(aDatabase: TComponent);
begin
  inherited SetDatabase(aDatabase);

  {table cannot be active to set database property}
  if GetQuery.Active then
    FQuery.Active := False;

  FConnection := (aDatabase as TMyConnection);
  {get MyDAC Connection for name}
  FQuery.Connection := FConnection;
end; {procedure, SetDatabaseName}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.SetDataName }

procedure TdaMyDACDataSet.SetDataName(const aDataName: String);
begin
  inherited SetDataName(aDataName);

  {dataset cannot be active to set data name}
  if GetQuery.Active then
    FQuery.Active := False;

  {construct an SQL statment that returns an empty result set,
   this is used to get the field information }
  FQuery.SQL.Text := 'SELECT * FROM ' + aDataName +
                     ' WHERE ''c'' <> ''c'' ';
end; {procedure, SetDataName}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.BuildFieldList }

procedure TdaMyDACDataSet.BuildFieldList;
var
  liIndex: Integer;
  lQueryField: TField;
  lField: TppField;
begin
  inherited BuildFieldList;


  {set table to active}
  if not(GetQuery.Active) then
    FQuery.Active := True;

  {create TppField objects for each field in the table}
  for liIndex := 0 to FQuery.FieldCount - 1 do begin
    lQueryField := FQuery.Fields[liIndex];

    lField := TppField.Create(nil);

    lField.TableName    := DataName;
    lField.FieldName    := lQueryField.FieldName;
    lField.DataType     := ppConvertFieldType(lQueryField.DataType);

    AddField(lField);
  end;
end; {function, BuildFieldList}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.GetFieldNamesForSQL }

procedure TdaMyDACDataSet.GetFieldNamesForSQL(aList: TStrings; aSQL: TStrings);
var
  lQuery: TMyQuery;
begin
  aList.Clear;

  {create a temporary query}
  lQuery := TMyQuery.Create(Self);

  {set the database and SQL properties}
  lQuery.Connection := FConnection;
  lQuery.SQL := aSQL;

  {get the field names}
  lQuery.GetFieldNames(aList);

  lQuery.Free;
end; {procedure, GetFieldNamesForSQL}

{------------------------------------------------------------------------------}
{ TdaMyDACDataSet.GetFieldsForSQL }

procedure TdaMyDACDataSet.GetFieldsForSQL(aList: TList; aSQL: TStrings);
var
  lQuery: TMyQuery;
  lQueryField: TField;
  lField: TppField;
  liIndex: Integer;
begin
  aList.Clear;

  {create a temporary query}
  lQuery := TMyQuery.Create(Self);

  {assign databae and SQL properties}
  lQuery.Connection := FConnection;
  lQuery.SQL := aSQL;

  {set query to active}
  lQuery.Active := True;

  {create a TppField object for each field in the query}
  for liIndex := 0 to lQuery.FieldCount - 1 do begin
    lQueryField := lQuery.Fields[liIndex];

    lField := TppField.Create(nil);

    lField.FieldName    := lQueryField.FieldName;
    lField.DataType     := ppConvertFieldType(lQueryField.DataType);

    aList.Add(lField);
  end;

  lQuery.Free;
end; {procedure, GetFieldsForSQL}



{******************************************************************************
 *
 ** M y D A C  Q U E R Y   D A T A V I E W
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ TdaMyDACQueryDataView.Create }

constructor TdaMyDACQueryDataView.Create(aOwner: TComponent);
begin

  inherited Create(aOwner);

  {notes: 1. must use ChildQuery, ChildDataSource, ChildPipeline etc.
          2. use Self as owner for Query, DataSource etc.
          3. do NOT assign a Name }

  FQuery := TdaChildMyDACQuery.Create(Self);

  FDataSource := TppChildDataSource.Create(Self);
  FDataSource.DataSet := FQuery;

end; {constructor, Create}

{------------------------------------------------------------------------------}
{ TdaMyDACQueryDataView.Destroy }

destructor TdaMyDACQueryDataView.Destroy;
begin
  FDataSource.Free;
  FQuery.Free;

  inherited Destroy;

end; {destructor, Destroy}

{------------------------------------------------------------------------------}
{ TdaMyDACQueryDataView.PreviewFormClass }

class function TdaMyDACQueryDataView.PreviewFormClass: TFormClass;
begin
  Result := TFormClass(GetClass('TdaPreviewDataDialog'));
end; {class function, PreviewFormClass}

{------------------------------------------------------------------------------}
{ TdaMyDACQueryDataView.SessionClass }

class function TdaMyDACQueryDataView.SessionClass: TClass;
begin
  Result := TdaMyDACSession;
end; {class function, SessionClass}

{------------------------------------------------------------------------------}
{ TdaMyDACQueryDataView.ConnectPipelinesToData }

procedure TdaMyDACQueryDataView.ConnectPipelinesToData;
begin

  if DataPipelineCount = 0 then Exit;

  {need to reconnect here}
  TppDBPipeline(DataPipelines[0]).DataSource := FDataSource;

end; {procedure, ConnectPipelinesToData}

{------------------------------------------------------------------------------}
{ TdaMyDACQueryDataView.Init }

procedure TdaMyDACQueryDataView.Init;
var
  lDataPipeline: TppChildDBPipeline;

begin

  inherited Init;

  if DataPipelineCount > 0 then Exit;

  {note: DataView's owner must own the DataPipeline }
  lDataPipeline := TppChildDBPipeline(ppComponentCreate(Self, TppChildDBPipeline));
  lDataPipeline.DataSource := FDataSource;
 
  lDataPipeline.AutoCreateFields := False;

  {add DataPipeline to the dataview }
  lDataPipeline.DataView := Self;

end; {procedure, Init}

{------------------------------------------------------------------------------}
{ TdaMyDACQueryDataView.SQLChanged }

procedure TdaMyDACQueryDataView.SQLChanged;
begin

  if FQuery.Active then
    FQuery.Close;

  FQuery.Connection := daGetMyDACConnectionForName(SQL.DatabaseName);
  FQuery.SQL := SQL.MagicSQLText;

end; {procedure, SQLChanged}


{******************************************************************************
 *
 ** P R O C E D U R E S   A N D   F U N C T I O N S
 *
{******************************************************************************}

{------------------------------------------------------------------------------}
{ daGetDefaultMyDACConnection }

function daGetDefaultMyDACConnection: TMyConnection;
begin
  {create the default Connection, if needed}
  if (FMyDACConnection = nil) then begin
    {create default MyDAC Connection}
    FMyDACConnection := TMyConnection.Create(nil);
    FMyDACConnection.Name := cDefaultConnection;
  end;

  Result := FMyDACConnection;
end; {function, daGetDefaultMyDACConnection}

{------------------------------------------------------------------------------}
{ daGetMyDACConnectionNames }

procedure daGetMyDACConnectionNames(aList: TStrings);
begin
end; {procedure, daGetMyDACConnectionNames}

{------------------------------------------------------------------------------}
{ daGetMyDACConnectionForName }

function daGetMyDACConnectionForName(aDatabaseName: String): TMyConnection;
var
  liIndex: Integer;
begin
  Result := nil;

  liIndex := 0;

 {check for a database object with this name}
  while (Result = nil) and (liIndex < daGetMyDACConnectionList.Count) do
  begin
    if (AnsiCompareStr(FMyDACConnectionList[liIndex].Name, aDatabaseName) = 0) or
       (AnsiCompareStr(TMyConnection(FMyDACConnectionList[liIndex]).Server, aDatabaseName) = 0)
    then
      Result :=  TMyConnection(FMyDACConnectionList[liIndex]);
    Inc(liIndex);
  end;

  if (Result <> nil) then
    Exit;

  {use the default database object}
  Result := daGetDefaultMyDACConnection;

  {set DatabaseName property, if needed}
  if (Result.Server <> aDatabaseName) then begin
    if Result.Connected then
      Result.Connected := False;
    Result.Server := aDatabaseName;
  end;
end; {function, daGetMyDACConnectionForName}

{------------------------------------------------------------------------------}
{ daMyDACConnectToDatabase }

function daMyDACConnectToDatabase(aDatabaseName: String): Boolean;
var
  lConnection: TMyConnection;
begin
  Result := False;

  lConnection := daGetMyDACConnectionForName(aDatabaseName);

  if (lConnection = nil) then
    Exit;

  if not lConnection.Connected then begin
    if (lConnection = daGetDefaultMyDACConnection) then
      lConnection.Connected := True
    else
      lConnection.Connected := True;
  end;

  Result := lConnection.Connected;
end; {function, daMyDACConnectToDatabase}


{------------------------------------------------------------------------------}
{ daGetMyDACConnectionList }

function daGetMyDACConnectionList: TppComponentList;
begin
  if (FMyDACConnectionList = nil) then
    FMyDACConnectionList := TppComponentList.Create(nil);

  Result := FMyDACConnectionList;
end; {function, daGetMyDACConnectionList}


initialization
  {register the MyDAC descendant classes}
  RegisterClasses([TdaChildMyDACQuery, TdaChildMyDACTable]);

  {register DADE descendant session, dataset, dataview}
  daRegisterSession(TdaMyDACSession);
  daRegisterDataSet(TdaMyDACDataSet);
  daRegisterDataView(TdaMyDACQueryDataView);

  {initialize internal reference variables}
  FMyDACConnection     := nil;
  FMyDACConnectionList := nil;

finalization
  {free the default connection object}
  FMyDACConnection.Free;
  FMyDACConnectionList.Free;

  {unregister the MyDAC descendant classes}
  UnRegisterClasses([TdaChildMyDACQuery, TdaChildMyDACTable]);

  {unregister DADE descendant the session, dataset, dataview}
  daUnRegisterSession(TdaMyDACSession);
  daUnRegisterDataSet(TdaMyDACDataSet);
  daUnRegisterDataView(TdaMyDACQueryDataView);
end.
