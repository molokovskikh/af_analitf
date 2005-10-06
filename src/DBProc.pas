unit DBProc;

interface

uses Windows, Classes, DB, DbGrids, SysUtils, Forms, Controls, ShellAPI,
	DBGridEh, DBGridEhImpExp;

procedure DoPost(DataSet: TDataSet; SaveChanges: Boolean);
procedure SoftEdit(DataSet: TDataSet);
procedure SoftPost(DataSet: TDataSet);
procedure SoftCancel(DataSet: TDataSet);
function ColumnByName(Grid: TDBGrid; FieldName: string): TColumn;
function AddAndCondition(OldCondition,NewCondition: string): string;
procedure DataSetCalc(DataSet: TDataSet; Expressions: array of string;
  var Values: array of Variant);
procedure SetFilter(DataSet: TDataSet; AFilter: string);
procedure SetFilterProc(DataSet: TDataSet; AFilterProc: TFilterRecordEvent);
function GetConnectionProperty(const ConnectionString, PropertyName: string): string;
function SetConnectionProperty(const ConnectionString, PropertyName,
  PropertyValue: string): string;
function SaveGrid(Grid: TCustomDBGridEh): Boolean;

implementation

uses AProc;

//если набор данных находится в режиме редактирование или вставки, то в
//зависимости от значения параметра SaveChanges сохраняет или отменяет изменения
procedure DoPost(DataSet: TDataSet; SaveChanges: Boolean);
begin
  with DataSet do
    if State in [dsEdit, dsInsert] then
      if SaveChanges then Post else Cancel;
end;

//"мягкое" переведение набора данных в различные режимы, т.е. если уже в этом режиме,
//то ничего не происходит.
procedure SoftEdit(DataSet: TDataSet);
begin
  with DataSet do if not(State in [dsEdit, dsInsert]) then Edit;
end;

procedure SoftPost(DataSet: TDataSet);
begin
  with DataSet do if State in [dsEdit, dsInsert] then Post;
end;

procedure SoftCancel(DataSet: TDataSet);
begin
  with DataSet do if State in [dsEdit, dsInsert] then Cancel;
end;

//возвращает колонку из TDBGrid по имени поля
function ColumnByName(Grid: TDBGrid; FieldName: string): TColumn;
var
  I: Integer;
begin
  Result:=nil;
  FieldName:=UpperCase(Trim(FieldName));
  for I:=0 to Grid.Columns.Count-1 do
    if UpperCase(Grid.Columns[I].FieldName)=FieldName then begin
      Result:=Grid.Columns[I];
      Break;
    end;
end;

//добавляет через AND условие к уже имеющемуся
function AddAndCondition(OldCondition,NewCondition: string): string;
begin
  Result:=Trim(OldCondition);
  NewCondition:=Trim(NewCondition);
  if Result<>'' then Result:=Result+'AND';
  Result:=Result+'('+NewCondition+')';
end;

//производит вычисление над набором данных за один проход
//допустимые выражения: COUNT, SUM(FIELD), AVG(FIELD), MIN(FIELD), MAX(FIELD),
//где FIELD - наименование поля без кавычек
//размерность массивов выражений - 0..9
procedure DataSetCalc(DataSet: TDataSet; Expressions: array of string;
  var Values: array of Variant);
type
  TExpressionType=(expNull, expCount, expSum, expAvg, expMin, expMax);
var
  Mark: string;
  I, Count: Integer;
  Types: array of TExpressionType;
  FieldNames: array of string;
begin
  //первичная обработка и формализация выражений
  SetLength(Types,Length(Expressions));
  SetLength(FieldNames,Length(Expressions));
  for I:=Low(Expressions) to High(Expressions) do Values[I]:=0;
  if not DataSet.Active then Exit;
  for I:=Low(Expressions) to High(Expressions) do begin
    Expressions[I]:=UpperCase(Trim(Expressions[I]));
    if Expressions[I]='COUNT' then Types[I]:=expCount
    else if Copy(Expressions[I],1,3)='SUM' then begin
      Types[I]:=expSum;
      FieldNames[I]:=Copy(Expressions[I],5,Length(Expressions[I])-5);
    end
    else if Copy(Expressions[I],1,3)='AVG' then begin
      Types[I]:=expAvg;
      FieldNames[I]:=Copy(Expressions[I],5,Length(Expressions[I])-5);
    end
    else if Copy(Expressions[I],1,3)='MIN' then begin
      Types[I]:=expMin;
      FieldNames[I]:=Copy(Expressions[I],5,Length(Expressions[I])-5);
      Values[I]:=DataSet.FieldByName(FieldNames[I]).AsFloat;
    end
    else if Copy(Expressions[I],1,3)='MAX' then begin
      Types[I]:=expMax;
      FieldNames[I]:=Copy(Expressions[I],5,Length(Expressions[I])-5);
      Values[I]:=DataSet.FieldByName(FieldNames[I]).AsFloat;
    end
    else Types[I]:=expNull;
  end;
  //подсчет
  with DataSet do begin
    Mark:=BookMark;
    DisableControls;
    try
      Count:=0;
      First;
      while not Eof do begin
        Inc(Count);
        for I:=Low(Expressions) to High(Expressions) do
          case Types[I] of
            expSum, expAvg: Values[I]:=Values[I]+FieldByName(FieldNames[I]).AsFloat;
            expMin: if Values[I]<FieldByName(FieldNames[I]).AsFloat then
              Values[I]:=FieldByName(FieldNames[I]).AsFloat;
            expMax: if Values[I]<FieldByName(FieldNames[I]).AsFloat then
              Values[I]:=FieldByName(FieldNames[I]).AsFloat;
          end;
        Next;
      end;
      if Count>0 then
        for I:=Low(Expressions) to High(Expressions) do
          case Types[I] of
            expCount: Values[I]:=Count;
            expAvg: Values[I]:=Values[I]/Count;
          end;
      BookMark:=Mark;
    finally
      EnableControls;
    end;
  end;
end;

procedure SetFilter(DataSet: TDataSet; AFilter: string);
begin
  with DataSet do begin
    DisableControls;
    Screen.Cursor:=crHourGlass;
    try
      Filtered:=False;
      Filter:=AFilter;
      if Filter<>'' then Filtered:=True;
    finally
      EnableControls;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

function GetConnectionProperty(const ConnectionString, PropertyName: string): string;
var
  Strings: TStrings;
begin
  Strings:=TStringList.Create;
  try
    StringToStrings(ConnectionString,Strings);
    Result:=Strings.Values[PropertyName];
  finally
    Strings.Free;
  end;
end;

function SetConnectionProperty(const ConnectionString, PropertyName,
  PropertyValue: string): string;
var
  Strings: TStrings;
begin
  Strings:=TStringList.Create;
  try
    StringToStrings(ConnectionString,Strings);
    Strings.Values[PropertyName]:=PropertyValue;
    Result:=StringsToString(Strings);
  finally
    Strings.Free;
  end;
end;

function SaveGrid(Grid: TCustomDBGridEh): Boolean;
//var
//	Ext: string;
//	SaveDialog: TSaveDialog;
begin
	if Grid = nil then raise Exception.Create( 'Не задана таблица для сохранения');
	result := False;
{	SaveDialog := TSaveDialog.Create( nil);
	SaveDialog.DefaultExt := 'xls';
	SaveDialog.InitialDir := ExePath;
	SaveDialog.Options := SaveDialog.Options + [ofOverWritePrompt];
	SaveDialog.Filter := 'Microsoft Excel|*.xls';}
	try
//		if SaveDialog.Execute then
//		begin
//			Ext := UpperCase( ExtractFileExt( SaveDialog.FileName));
			SaveDBGridEhToExportFile( TDBGridEhExportAsXls,
				TCustomDBGridEh( Grid), ExcludeTrailingPathDelimiter( GetTempDir) +
					'\temp.xls' {SaveDialog.FileName}, True);
{			MessageBox( 'Сохранено записей : ' +
				IntToStr( Grid.DataSource.DataSet.RecordCount), MB_ICONINFORMATION);}
			ShellExecute( 0, 'Open', PChar( ExcludeTrailingPathDelimiter( GetTempDir) +
				'\temp.xls'), nil, nil, SW_SHOWNORMAL);

//		end;
	finally
//		SaveDialog.Free;
	end;
end;

procedure SetFilterProc(DataSet: TDataSet; AFilterProc: TFilterRecordEvent);
begin
  with DataSet do begin
    DisableControls;
    Screen.Cursor:=crHourGlass;
    try
      Filtered:=False;
      OnFilterRecord := AFilterProc;
      if Assigned(OnFilterRecord) then Filtered:=True;
    finally
      EnableControls;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

end.
