
//////////////////////////////////////////////////
//  FastReport v2.7 - MyDAC components
//  Copyright (c) 2004 Devart. All right reserved.
//  Query component
//  Created:
//  Last modified:
//////////////////////////////////////////////////

unit FR_MyDACQuery;

interface

{$I FR.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, StdCtrls, Controls, Forms,
  Menus, Dialogs, FR_Class, FR_Pars, DB, MyAccess, FR_MyDACTable, FR_DBUtils;

type
  TfrMyDACQuery = class(TfrMyDACDataSet)
  private
    FQuery: TMyQuery;
    FParams: TfrVariables;
    procedure SQLEditor(Sender: TObject);
    procedure ParamsEditor(Sender: TObject);
    procedure ReadParams(Stream: TStream);
    procedure WriteParams(Stream: TStream);
    function GetParamKind(Index: Integer): TfrParamKind;
    procedure SetParamKind(Index: Integer; Value: TfrParamKind);
    function GetParamText(Index: Integer): String;
    procedure SetParamText(Index: Integer; Value: String);
    procedure BeforeOpenQuery(DataSet: TDataSet);
  protected
    procedure SetPropValue(Index: String; Value: Variant); override;
    function GetPropValue(Index: String): Variant; override;
    function DoMethod(MethodName: String; Par1, Par2, Par3: Variant): Variant; override;
    procedure ReplaceParams(DataSet: TDataSet);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    procedure DefineProperties; override;
    procedure Loaded; override;
    property Query: TMyQuery read FQuery;
    property ParamKind[Index: Integer]: TfrParamKind read GetParamKind write SetParamKind;
    property ParamText[Index: Integer]: String read GetParamText write SetParamText;
  end;

implementation

uses
  DBAccess, MyClasses,
  FR_Utils, FR_Const, FR_DBSQLEdit, FR_MyDACQueryParam
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TMyDACSmartQuery = class(TMyQuery)
  private
    FfrQuery: TfrMyDACQuery;
  public
    constructor Create(Owner: TComponent; frQuery: TfrMyDACQuery);
    procedure InitFieldDefs; override;
  end;


constructor TMyDACSmartQuery.Create(Owner: TComponent; frQuery: TfrMyDACQuery);
begin
  inherited Create(Owner);
  FfrQuery := frQuery;
end;

procedure TMyDACSmartQuery.InitFieldDefs;
begin
  FfrQuery.ReplaceParams(Self);

  inherited;
end;

{ TfrMyDACQuery }

constructor TfrMyDACQuery.Create;
begin
  inherited Create;
  FQuery := TMyDACSmartQuery.Create(frDialogForm, Self);
  FQuery.ReadOnly:=true;
  FQuery.BeforeOpen := BeforeOpenQuery;
  FDataSet := FQuery;
  FDataSource.DataSet := FDataSet;

  FParams := TfrVariables.Create;

  Component := FQuery;
  BaseName := 'Query';
  Bmp.LoadFromResourceName(hInstance, 'FR_MyDACQUERY');
end;

destructor TfrMyDACQuery.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

procedure TfrMyDACQuery.DefineProperties;

  function GetMasterSource: String;
  var
    i: Integer;
    sl: TStringList;
  begin
    Result := '';
    sl := TStringList.Create;
    frGetComponents(FQuery.Owner, TDataSet, sl, FQuery);
    sl.Sort;
    for i := 0 to sl.Count - 1 do
      Result := Result + sl[i] + ';';
    sl.Free;
  end;

begin
  inherited DefineProperties;
  AddEnumProperty('MasterSource', GetMasterSource, [Null]);
  AddProperty('DetailFields', [frdtString], nil);
  AddProperty('MasterFields', [frdtString], nil);
  AddProperty('Params', [frdtHasEditor], ParamsEditor);
  AddProperty('SQL', [frdtHasEditor], SQLEditor);
  AddProperty('SQL.Count', [], nil);
  AddProperty('FetchAll', [frdtBoolean], nil);
  AddProperty('FetchRows', [frdtInteger], nil);
end;

procedure TfrMyDACQuery.SetPropValue(Index: String; Value: Variant);
var
  d: TDataset;
begin
  inherited SetPropValue(Index, Value);
  Index := AnsiUpperCase(Index);
  if Index = 'NAME' then
  begin
    FDataSource.Name := 'S' + FDataSet.Name;
    FDBDataSet.Name := '_' + FDataSet.Name;
  end
  else if Index = 'MASTERSOURCE' then
  begin
    d := frFindComponent(FQuery.Owner, Value) as TDataSet;
    FQuery.MasterSource := frGetDataSource(FQuery.Owner, d);
  end
  else if Index = 'SQL' then
    FQuery.SQL.Text := Value
  else if Index = 'MASTERFIELDS' then
    FQuery.MasterFields := Value
  else if Index = 'DETAILFIELD' then
    FQuery.DetailFields := Value
  else if Index = 'FETCHALL' then
    FQuery.FetchAll := Value
  else if Index = 'FETCHROWS' then
    FQuery.FetchRows := Value
end;

function TfrMyDACQuery.GetPropValue(Index: String): Variant;
begin
  Index := AnsiUpperCase(Index);
  Result := inherited GetPropValue(Index);
  if Result <> Null then Exit;
  if Index = 'MASTERSOURCE' then
    Result := frGetDataSetName(FQuery.Owner, FQuery.MasterSource)
  else if Index = 'SQL' then
    Result := FQuery.SQL.Text
  else if Index = 'SQL.COUNT' then
    Result := FQuery.SQL.Count
  else if Index = 'RECORDCOUNT' then
    Result := FDataSet.RecordCount
  else if Index = 'FIELDCOUNT' then
    Result := FDataSet.FieldCount
  else if Index = 'MASTERFIELDS' then
    Result := FQuery.MasterFields
  else if Index = 'DETAILFIELDS' then
    Result := FQuery.DetailFields
  else if Index = 'FETCHALL' then
    Result := FQuery.FetchAll
  else if Index = 'FETCHROWS' then
    Result := FQuery.FetchRows
end;

function TfrMyDACQuery.DoMethod(MethodName: String; Par1, Par2, Par3: Variant): Variant;
var
  S : string;
begin
  Result := inherited DoMethod(MethodName, Par1, Par2, Par3);
  if Result = Null then
    Result := LinesMethod(FQuery.SQL, MethodName, 'SQL', Par1, Par2, Par3);
  if MethodName = 'EXECSQL' then
  begin
    BeforeOpenQuery(FQuery);
    FQuery.Execute;
  end else if MethodName = 'ADDWHERE' then begin
    S := Par1;
    if (Length(S) > 0) and (S[1] = '''') then
      System.Delete(S, 1, 1);
    if (Length(S) > 0) and (S[Length(S)] = '''') then
      SetLength(S, Length(S)-1);
    FQuery.AddWhere(S);
  end;
end;

procedure TfrMyDACQuery.LoadFromStream(Stream: TStream);
var
  S: String;
begin
  FFixupList.Clear;
  inherited LoadFromStream(Stream);

  FFixupList['Connection'] := frReadString(Stream);
  Prop['Connection'] := FFixupList['Connection'];

  FQuery.Filter := frReadString(Stream);
  FQuery.Filtered := Trim(FQuery.Filter) <> '';
  S := frReadString(Stream);
  FFixupList['MasterSource'] := S;
  Prop['MasterSource'] := FFixupList['MasterSource'];

  FQuery.MasterFields := frReadString(Stream);
  FQuery.DetailFields := frReadString(Stream);

  FQuery.FetchAll := frReadBoolean(Stream);
  FQuery.FetchRows := frReadInteger(Stream);

  frReadMemo(Stream, FQuery.SQL);
  FFixupList['Active'] := frReadBoolean(Stream);
  ReadFields(Stream);
  ReadParams(Stream);
  try
    FQuery.Active := FFixupList['Active'];
  except;
  end;
end;

procedure TfrMyDACQuery.SaveToStream(Stream: TStream);
begin
  LVersion := 1;
  inherited SaveToStream(Stream);

  frWriteString(Stream, Prop['Connection']);

  frWriteString(Stream, FQuery.Filter);
  frWriteString(Stream, Prop['MasterSource']);

  frWriteString(Stream, FQuery.MasterFields);
  frWriteString(Stream, FQuery.DetailFields);

  frWriteBoolean(Stream, FQuery.FetchAll);
  frWriteInteger(Stream, FQuery.FetchRows);

  frWriteMemo(Stream, FQuery.SQL);
  frWriteBoolean(Stream, FQuery.Active);
  WriteFields(Stream);
  WriteParams(Stream);
end;

procedure TfrMyDACQuery.Loaded;
begin
  Prop['MasterSource'] := FFixupList['MasterSource'];
  inherited Loaded;
end;

procedure TfrMyDACQuery.SQLEditor(Sender: TObject);
begin
  with TfrDBSQLEditorForm.Create(nil) do
  begin
    Query := FQuery;
    M1.Lines.Assign(FQuery.SQL);
{$IFDEF QBUILDER}
    QBEngine := TfrQBBDEEngine.Create(nil);
    TfrQBBDEEngine(QBEngine).Query := FQuery;
    QBEngine.DatabaseName := FQuery.DatabaseName;
{$ENDIF}
    if (ShowModal = mrOk) and ((Restrictions and frrfDontModify) = 0) then
    begin
      FQuery.SQL := M1.Lines;
      frDesigner.Modified := True;
    end;
{$IFDEF QBUILDER}
    QBEngine.Free;
{$ENDIF}
    Free;
  end;
end;

procedure TfrMyDACQuery.ParamsEditor(Sender: TObject);
var
  Params: TDAParams;
  ParamValues: TfrVariables;
begin
  if FQuery.Params.Count > 0 then
  begin
    Params := TDAParams.Create;
    Params.Assign(FQuery.Params);
    ParamValues := TfrVariables.Create;
    ParamValues.Assign(FParams);
    with TfrMyDACParamsForm.Create(nil) do
    begin
      QueryComp := Self;
      Query := FQuery;
      Caption := Self.Name + ' ' + frLoadStr(SParams);
      if ShowModal = mrOk then
        frDesigner.Modified := True
      else
      begin
        FQuery.Params.Assign(Params);
        FParams.Assign(ParamValues);
      end;
      Free;
    end;
    Params.Free;
    ParamValues.Free;
  end;
end;

function TfrMyDACQuery.GetParamKind(Index: Integer): TfrParamKind;
begin
  Result := pkValue;
end;

procedure TfrMyDACQuery.SetParamKind(Index: Integer; Value: TfrParamKind);
begin
end;

function TfrMyDACQuery.GetParamText(Index: Integer): String;
begin
  Result := '';
  if ParamKind[Index] = pkValue then begin
    if VarIsNull(FParams[FQuery.Params[Index].Name]) then
      Result := ''
    else
      Result := FParams[FQuery.Params[Index].Name];
  end;
end;

procedure TfrMyDACQuery.SetParamText(Index: Integer; Value: String);
begin
  if ParamKind[Index] = pkValue then begin
    if Value <> '' then
      FParams[FQuery.Params[Index].Name] := Value
    else
      FParams[FQuery.Params[Index].Name] := Null;
  end;
end;

procedure TfrMyDACQuery.ReadParams(Stream: TStream);
var
  i: Integer;
  w, n: Word;
begin
  Stream.Read(n, 2);
  for i := 0 to n - 1 do
  with FQuery.Params[i] do
  begin
    Stream.Read(w, 2);
    DataType := ParamTypes[w];
    Stream.Read(w, 2);
    ParamKind[i] := TfrParamKind(w);
    ParamText[i] := frReadString(Stream);
  end;
end;

procedure TfrMyDACQuery.WriteParams(Stream: TStream);
var
  i: Integer;
  w: Word;
begin
  w := FQuery.Params.Count;
  Stream.Write(w, 2);
  for i := 0 to FQuery.Params.Count - 1 do
  with FQuery.Params[i] do
  begin
    for w := 0 to 10 do
      if DataType = ParamTypes[w] then
        break;
    Stream.Write(w, 2);
    w := Word(ParamKind[i]);
    Stream.Write(w, 2);
      frWriteString(Stream, ParamText[i]);
  end;
end;

procedure TfrMyDACQuery.ReplaceParams(DataSet: TDataSet);
  procedure SetSqlformat(Param: TParam; StringValue: string);
  begin
    case Param.DataType of
      ftDateTime:
        Param.AsDateTime := StrToDateTime(StringValue);
      ftDate:
        Param.AsDate := StrToDate(StringValue);
      ftTime:
        Param.AsDate := StrToTime(StringValue);
      else
        Param.AsString := StringValue;
    end;
  end;

  procedure DefParamValue(Param: TParam);
  var
    d: TDateTime;
  begin
    case Param.DataType of
      ftDateTime:
        Param.AsDateTime := Now;
      ftDate:
        Param.AsDate := Trunc(Now);
      ftTime: begin
        d := Now;
        Param.AsTime := d - Trunc(d);
      end;
    else;
    end;
  end;
  
var
  i: integer;
  
begin
  try
    while i < FQuery.Params.Count do begin
      if ParamKind[i] = pkValue then
        if DocMode = dmPrinting then
          SetSqlFormat(FQuery.Params[i], frParser.Calc(ParamText[i]))
        else
          DefParamValue(FQuery.Params[i]);
      Inc(i);
    end;
  except
    Memo.Clear;
    Memo.Add(ParamText[i]);
    raise;
  end;
end;


procedure TfrMyDACQuery.BeforeOpenQuery(DataSet: TDataSet);
var
  i: Integer;
  SaveView: TfrView;
  SavePage: TfrPage;
  SaveBand: TfrBand;

begin
  SaveView := CurView;
  CurView := nil;
  SavePage := CurPage;
  CurPage := ParentPage;
  SaveBand := CurBand;
  CurBand := nil;
  i := 0;
  try
    ReplaceParams(DataSet);
  except
    Memo.Clear;
    Memo.Add(ParamText[i]);
    CurView := Self;
    raise;
  end;
  CurView := SaveView;
  CurPage := SavePage;
  CurBand := SaveBand;
end;

end.

