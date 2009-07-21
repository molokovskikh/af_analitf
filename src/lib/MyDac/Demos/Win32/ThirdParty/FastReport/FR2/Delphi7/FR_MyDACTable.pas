
//////////////////////////////////////////////////
//  FastReport v2.7 - MyDAC components
//  Copyright (c) 2004 Devart. All right reserved.
//  Table component
//  Created:
//  Last modified:
//////////////////////////////////////////////////

unit FR_MyDACTable;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, StdCtrls, Controls,
  Forms, Menus, Dialogs, FR_Class, FR_DBSet, DB, MyAccess;

type
  TfrMyDACDataset = class(TfrNonVisualControl)
  protected
    FDataSet: TCustomMyDataSet;
    FDataSource: TDataSource;
    FDBDataSet: TfrDBDataset;
    procedure FieldsEditor(Sender: TObject);
    procedure ReadFields(Stream: TStream);
    procedure WriteFields(Stream: TStream);
    procedure SetPropValue(Index: String; Value: Variant); override;
    function GetPropValue(Index: String): Variant; override;
    function DoMethod(MethodName: String; Par1, Par2, Par3: Variant): Variant; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DefineProperties; override;
    procedure Loaded; override;
    procedure ShowEditor; override;
  end;


  TfrMyDACTable = class(TfrMyDACDataSet)
  private
    FTable: TMyTable;
  protected
    procedure SetPropValue(Index: String; Value: Variant); override;
    function GetPropValue(Index: String): Variant; override;
  public
    constructor Create; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure DefineProperties; override;
    procedure Loaded; override;
    property Table: TMyTable read FTable;
  end;


implementation

uses FR_DBUtils, FR_Utils, FR_Const, FR_DBFldEditor
{$IFDEF Delphi6}
, Variants
{$ENDIF};

{ TfrMyDACDataSet }

constructor TfrMyDACDataSet.Create;
begin
  inherited Create;
  FDataSource := TDataSource.Create(frDialogForm);
  FDataSource.DataSet := nil;
  FDBDataSet := TfrDBDataSet.Create(frDialogForm);
  FDBDataSet.DataSource := FDataSource;

  Flags := Flags or flDontUndo;
end;

destructor TfrMyDACDataSet.Destroy;
begin
  FDBDataset.Free;
  FDataSource.Free;
  FDataSet.Free;
  inherited Destroy;
end;

procedure TfrMyDACDataSet.DefineProperties;

  function GetDatabases: String;
  var
    i: Integer;
    sl: TStringList;
  begin
    Result := '';
    sl := TStringList.Create;
    frGetComponents(frDialogForm, TMyConnection, sl, nil);
    sl.Sort;
    for i := 0 to sl.Count - 1 do
      Result := Result + sl[i] + ';';
    sl.Free;
  end;

begin
  inherited DefineProperties;
  AddProperty('Active', [frdtBoolean], nil);
  AddEnumProperty('Connection', GetDatabases, [Null]);
  AddProperty('Fields', [frdtHasEditor, frdtOneObject], FieldsEditor);
  AddProperty('FieldCount', [], nil);
  AddProperty('Filter', [frdtString], nil);
  AddProperty('EOF', [], nil);
  AddProperty('RecordCount', [], nil);
end;

procedure TfrMyDACDataSet.SetPropValue(Index: String; Value: Variant);
var
  d: TMyConnection;
begin
  inherited SetPropValue(Index, Value);
  Index := AnsiUpperCase(Index);
  if Index = 'NAME' then
  begin
    FDataSource.Name := 'S' + FDataSet.Name;
    FDBDataSet.Name := '_' + FDataSet.Name;
  end
  else if Index = 'ACTIVE' then
    FDataSet.Active := Value
  else if Index = 'CONNECTION' then
  begin
    if VarIsNull(Value) then
      FDataSet.Connection := nil
    else begin
      d := frFindComponent(FDataSet.Owner, Value) as TMyConnection;
      FDataSet.Connection := d;
    end;
  end
  else if Index = 'FILTER' then
  begin
    FDataSet.Filter := Value;
    FDataSet.Filtered := Trim(Value) <> '';
  end;
end;

function TfrMyDACDataSet.GetPropValue(Index: String): Variant;
  function frGetDataBaseName(Owner: TComponent; d: TCustomMyConnection): String;
  begin
    Result := '';
    if d <> nil then
    begin
      Result := d.Name;
      if d.Owner <> Owner then
        Result := d.Owner.Name + '.' + Result;
    end;
  end;
begin
  Index := AnsiUpperCase(Index);
  Result := inherited GetPropValue(Index);
  if Result <> Null then Exit;
  if Index = 'ACTIVE' then
    Result := FDataSet.Active
  else if Index = 'CONNECTION' then
    Result := frGetDataBaseName(FDataSet.Owner, FDataSet.Connection)
  else if Index = 'FILTER' then
    Result := FDataSet.Filter
  else if Index = 'EOF' then
    Result := FDataSet.Eof
  else if Index = 'RECORDCOUNT' then
    Result := FDataSet.RecordCount
  else if Index = 'FIELDCOUNT' then
    Result := FDataSet.FieldCount;
end;

function TfrMyDACDataSet.DoMethod(MethodName: String; Par1, Par2, Par3: Variant): Variant;
begin
  Result := inherited DoMethod(MethodName, Par1, Par2, Par3);
  if MethodName = 'GETINDEXPROPERTY' then
  begin
    if Par1 = 'FIELDS' then
      Result := FDataSet.FieldByName(Par2).AsVariant;
  end
  else if MethodName = 'OPEN' then
    FDataSet.Open
  else if MethodName = 'CLOSE' then
    FDataSet.Close
  else if MethodName = 'NEXT' then
    FDataSet.Next
  else if MethodName = 'PRIOR' then
    FDataSet.Prior
  else if MethodName = 'FIRST' then
    FDataSet.First
  else if MethodName = 'LAST' then
    FDataSet.Last
end;

procedure TfrMyDACDataSet.ReadFields(Stream: TStream);
var
  i: Integer;
  n: Word;
  s: String;
  Field: TField;
  ds1: TDataset;
  fName: String;
  fType: TFieldType;
  fLookup: Boolean;
  fSize: Word;
  fDefs: TFieldDefs;
begin
  fDefs := FDataSet.FieldDefs;
  Stream.Read(n, 2);             // FieldCount
  for i := 0 to n - 1 do
  begin
    fType := TFieldType(frReadByte(Stream));                    // DataType
    fName := frReadString(Stream);                              // FieldName
    fLookup := frReadBoolean(Stream);                           // Lookup
    fSize := frReadWord(Stream);                                // Size

    fDefs.Add(fName, fType, fSize, False);
    Field := fDefs[fDefs.Count - 1].CreateField(FDataSet);
    if fLookup then
      with Field do
      begin
        Lookup := True;
        KeyFields := frReadString(Stream);                      // KeyFields
        s := frReadString(Stream);                              // LookupDataset
        ds1 := frFindComponent(FDataSet.Owner, s) as TDataSet;
        FFixupList['.' + FieldName] := s;
        LookupDataset := ds1;
        LookupKeyFields := frReadString(Stream);                // LookupKeyFields
        LookupResultField := frReadString(Stream);              // LookupResultField
      end;
  end;
end;

procedure TfrMyDACDataSet.WriteFields(Stream: TStream);
var
  i: Integer;
  s: String;
  SaveActive: Boolean;
begin
  SaveActive := FDataSet.Active;
  FDataSet.Close;
  frWriteWord(Stream, FDataSet.FieldCount);  // FieldCount
  for i := 0 to FDataSet.FieldCount - 1 do
  with FDataSet.Fields[i] do
  begin
    frWriteByte(Stream, Byte(DataType));          // DataType
    frWriteString(Stream, FieldName);             // FieldName
    frWriteBoolean(Stream, Lookup);               // Lookup
    frWriteWord(Stream, Size);                    // Size

    if Lookup then
    begin
      frWriteString(Stream, KeyFields);           // KeyFields
      if LookupDataset <> nil then
      begin
        s := LookupDataset.Name;
        if LookupDataset.Owner <> FDataSet.Owner then
          s := LookupDataset.Owner.Name + '.' + s;
      end
      else
        s := '';
      frWriteString(Stream, s);                   // LookupDataset
      frWriteString(Stream, LookupKeyFields);     // LookupKeyFields
      frWriteString(Stream, LookupResultField);   // LookupResultField
    end;
  end;
  FDataSet.Active := SaveActive;
end;

procedure TfrMyDACDataSet.Loaded;
var
  i: Integer;
  s: String;
  ds: TDataSet;
  f: TField;
begin
// fixup component references
  try
    Prop['Connection'] := FFixupList['Connection'];
    Prop['Active'] := FFixupList['Active'];
    for i := 0 to FFixupList.Count - 1 do
    begin
      s := FFixupList.Name[i];
      if s[1] = '.' then // lookup field
      begin
        f := FDataSet.FindField(Copy(s, 2, 255));
        ds := frFindComponent(FDataSet.Owner, FFixupList.Value[i]) as TDataSet;
        f.LookupDataset := ds;
      end
    end;
  except;
  end;
end;

procedure TfrMyDACDataSet.ShowEditor;
begin
  FieldsEditor(nil);
end;

procedure TfrMyDACDataSet.FieldsEditor(Sender: TObject);
var
  SaveActive: Boolean;
begin
  SaveActive := FDataSet.Active;
  FDataSet.Close;
  with TfrDBFieldsEditorForm.Create(nil) do
  begin
    DataSet := FDataSet;
    ShowModal;
    frDesigner.Modified := True;
    Free;
  end;
  frDesigner.BeforeChange;
  FDataSet.Active := SaveActive;
end;


{ TfrMyDACTable }

constructor TfrMyDACTable.Create;
begin
  inherited Create;
  FTable := TMyTable.Create(frDialogForm);
  FTable.ReadOnly := true;
  FDataSet := FTable;
  FDataSource.DataSet := FDataSet;

  Component := FTable;
  BaseName := 'Table';
  Bmp.LoadFromResourceName(hInstance, 'FR_MyDACTABLE');
end;

procedure TfrMyDACTable.DefineProperties;

  function GetMasterSource: String;
  var
    i: Integer;
    sl: TStringList;
  begin
    Result := '';
    sl := TStringList.Create;
    frGetComponents(FTable.Owner, TDataSet, sl, FTable);
    sl.Sort;
    for i := 0 to sl.Count - 1 do
      Result := Result + sl[i] + ';';
    sl.Free;
  end;

  function GetTableNames: String;
  var
    List: TStringList;
    i: integer;
  begin
    try
      Result := '';
      List := TStringList.Create;
      try
        FTable.Connection.GetTableNames(List);
        List.Sort;
        for i := 0 to List.Count - 1 do
          Result := Result + List[i] + ';';
      finally
        List.Free;
      end;
    except
    end;
  end;

begin
  inherited DefineProperties;
  AddProperty('MasterFields', [frdtString], nil);
  AddProperty('DetailFields', [frdtString], nil);
  AddEnumProperty('MasterSource', GetMasterSource, [Null]);
  AddEnumProperty('TableName', GetTableNames, [Null]);
end;

procedure TfrMyDACTable.SetPropValue(Index: String; Value: Variant);
var
  d: TDataset;
begin
  inherited SetPropValue(Index, Value);
  Index := AnsiUpperCase(Index);
  if Index = 'MASTERSOURCE' then
  begin
    d := frFindComponent(FTable.Owner, Value) as TDataSet;
    FTable.MasterSource := frGetDataSource(FTable.Owner, d);
  end
  else if Index = 'TABLENAME' then
    FTable.TableName := Value
  else if Index = 'MASTERFIELDS' then
    FTable.MasterFields := Value
  else if Index = 'DETAILFIELDS' then
    FTable.DetailFields := Value;
end;

function TfrMyDACTable.GetPropValue(Index: String): Variant;
begin
  Index := AnsiUpperCase(Index);
  Result := inherited GetPropValue(Index);
  if Result <> Null then Exit;
  if Index = 'MASTERSOURCE' then
    Result := frGetDataSetName(FTable.Owner, FTable.MasterSource)
  else if Index = 'TABLENAME' then
    Result := FTable.TableName
  else if Index = 'MASTERFIELDS' then
    Result := FTable.MasterFields
  else if Index = 'DETAILFIELDS' then
    Result := FTable.DetailFields;
end;

procedure TfrMyDACTable.LoadFromStream(Stream: TStream);
begin
  FFixupList.Clear;
  inherited LoadFromStream(Stream);
  FFixupList['Connection'] := frReadString(Stream);
  Prop['Connection'] := FFixupList['Connection'];

  FTable.Filter := frReadString(Stream);
  FTable.Filtered := Trim(FTable.Filter) <> '';
  FTable.MasterFields := frReadString(Stream);
  FTable.DetailFields := frReadString(Stream);
  FFixupList['MasterSource'] := frReadString(Stream);
  Prop['MasterSource'] := FFixupList['MasterSource'];
  FTable.TableName := frReadString(Stream);
  FFixupList['Active'] := frReadBoolean(Stream);
  ReadFields(Stream);
  try
    FTable.Active := FFixupList['Active'];
  except;
  end;
end;

procedure TfrMyDACTable.SaveToStream(Stream: TStream);
begin
  LVersion := 1;
  inherited SaveToStream(Stream);
  frWriteString(Stream, Prop['Connection']);
  frWriteString(Stream, FTable.Filter);
  frWriteString(Stream, FTable.MasterFields);
  frWriteString(Stream, FTable.DetailFields);
  frWriteString(Stream, Prop['MasterSource']);
  frWriteString(Stream, FTable.TableName);
  frWriteBoolean(Stream, FTable.Active);
  WriteFields(Stream);
end;

procedure TfrMyDACTable.Loaded;
begin
  Prop['MasterSource'] := FFixupList['MasterSource'];
  inherited Loaded;
end;

end.

