
//////////////////////////////////////////////////
//  Data Access Components for MySQL
//  Copyright © 1998-2009 Devart. All right reserved.
//////////////////////////////////////////////////

{$IFNDEF CLR}

{$I MyDac.inc}

unit MyLoader;
{$ENDIF}

interface

uses
{$IFDEF CLR}
  Variants, System.Text,
{$ELSE}
  CLRClasses,
{$ENDIF}
  Classes, SysUtils, MemUtils, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF},
  CRAccess, DBAccess, DALoader, DB, MemData, MyAccess, MyClasses;

type
  TMyLoaderOption = (loLock, loDelayed);
  TMyLoaderOptions = set of TMyLoaderOption;
  TMyDuplicateKeys = (dkNone, dkIgnore, dkReplace);
{$IFDEF CLR}
  {$HINTS OFF}
{$ENDIF}
 TMyColumn = class (TDAColumn)
 published
   property DataType stored False; 
 end;

 TMyLoader = class (TDALoader)
  private
    function GetConnection: TCustomMyConnection;
    procedure SetConnection(Value: TCustomMyConnection);
    procedure SetRowsPerQuery(Value: integer);
    procedure SetDuplicateKeys(Value: TMyDuplicateKeys);
    procedure SetOptions(Value: TMyLoaderOptions);

  protected
    FOptions: TMyLoaderOptions;
    FRowsPerQuery: integer;
    FDebug: boolean;
    //FCommandTimeout: integer;
    FDuplicateKeys: TMyDuplicateKeys;

    function GetInternalLoaderClass: TCRLoaderClass; override;
    procedure SetInternalLoader(Value: TCRLoader); override;
    class function GetColumnClass: TDAColumnClass; override;
    function GetDataTypesMapClass: TDataTypesMapClass; override;

  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

  published
    property DuplicateKeys: TMyDuplicateKeys read FDuplicateKeys write SetDuplicateKeys default dkNone;
    property Connection: TCustomMyConnection read GetConnection write SetConnection;
    property Options: TMyLoaderOptions read FOptions write SetOptions default [];
    property RowsPerQuery: integer read FRowsPerQuery write SetRowsPerQuery default 0;
    property Debug: boolean read FDebug write FDebug default False;
    //property CommandTimeout: integer read FCommandTimeout write FCommandTimeout;

    property TableName;
    property Columns;

    property OnGetColumnData;
    property OnPutData;
    property OnProgress;
  end;
{$IFDEF CLR}
  {$HINTS ON}
{$ENDIF}

implementation

uses
  DASQLMonitor, MyServices,
  DAConsts{$IFNDEF CLR}{$IFDEF VER6P}, Variants{$ENDIF}{$ENDIF};

{ TMyLoader }

constructor TMyLoader.Create(Owner: TComponent);
begin
  inherited;
end;

destructor TMyLoader.Destroy;
begin
  inherited;
end;

function TMyLoader.GetInternalLoaderClass: TCRLoaderClass;
begin
  Result := TMySQLLoader;
end;

procedure TMyLoader.SetInternalLoader(Value: TCRLoader);
begin
  inherited;

  if FILoader <> nil then begin
    FILoader.SetProp(prLock, loLock in FOptions);
    FILoader.SetProp(prDelayed, loDelayed in FOptions);
    FILoader.SetProp(prRowsPerQuery, FRowsPerQuery);
    FILoader.SetProp(prDuplicateKeys, Variant(FDuplicateKeys));
  end;
end;

class function TMyLoader.GetColumnClass: TDAColumnClass;
begin
  Result := TMyColumn;
end;

function TMyLoader.GetDataTypesMapClass: TDataTypesMapClass;
begin
  Result := TCustomMyDataTypesMap;
end;

function TMyLoader.GetConnection: TCustomMyConnection;
begin
  Result := TCustomMyConnection(inherited Connection);
end;

procedure TMyLoader.SetConnection(Value: TCustomMyConnection);
begin
  inherited Connection := Value;
end;

procedure TMyLoader.SetRowsPerQuery(Value: integer);
begin
  if Value < 0 then
    DatabaseError('Invalid RowsPerQuery value');

  if Value <> FRowsPerQuery then begin
    FRowsPerQuery := Value;
    if FILoader <> nil then
      FILoader.SetProp(prRowsPerQuery, Value);
  end;
end;

procedure TMyLoader.SetDuplicateKeys(Value: TMyDuplicateKeys);
begin
  if Value <> FDuplicateKeys then begin
    FDuplicateKeys := Value;
    if FILoader <> nil then
      FILoader.SetProp(prDuplicateKeys, Variant(Value));
  end;
end;

procedure TMyLoader.SetOptions(Value: TMyLoaderOptions);
begin
  if Value <> FOptions then begin
    FOptions := Value;
    if FILoader <> nil then begin
      FILoader.SetProp(prLock, loLock in Value);
      FILoader.SetProp(prDelayed, loDelayed in Value);
    end;
  end;
end;

end.
