unit DBGridHelper;

interface

uses
  SysUtils, Classes, Windows, Graphics, Grids, DBGrids, GridsEh, DBGridEh,
  DBGridEhImpExp, ShellAPI, Registry, Forms, IniFiles,
  ToughDBGrid, AProc;

const
  DBGridColumnMinWidth = 5;

type
  TCharSet = Set of AnsiChar;

  TDBGridHelper = class
   private
    class function WordPosition(const N: Integer; const S: string; WordDelims: TCharSet): Integer;
    class function ExtractWord(N: Integer; const S: string; WordDelims: TCharSet): string;
    class function GetDefaultSection(Component: TComponent): string;
    class procedure InternalRestoreColumnsLayout(
      Grid: TCustomDBGridEh;
      ARegIni: TObject;
      Section: String;
      RestoreParams: TColumnEhRestoreParams);
   public
    class procedure SetDefaultSettingsToGrid(Grid : TCustomDBGridEh);
    class function AddColumn(Grid : TCustomDBGridEh; ColumnName, Caption : String; ReadOnly : Boolean = True) : TColumnEh; overload;
    class function AddColumn(Grid : TCustomDBGridEh; ColumnName, Caption : String; Width : Integer; ReadOnly : Boolean = True ) : TColumnEh; overload;
    class function AddColumn(Grid : TCustomDBGridEh; ColumnName, Caption : String; DisplayFormat: String; ReadOnly : Boolean = True) : TColumnEh; overload;
    class function AddColumn(Grid : TCustomDBGridEh; ColumnName, Caption : String; DisplayFormat : String; Width : Integer = 0; ReadOnly : Boolean = True) : TColumnEh; overload;
    class function GetColumnWidths(Grid : TCustomDBGridEh) : Integer;
    class procedure SaveGrid(Grid: TCustomDBGridEh);
    class procedure CopyGridToClipboard(Grid: TCustomDBGridEh);

    class procedure SaveColumnsLayout(Grid: TCustomDBGridEh; SectionName : String);
    class procedure RestoreColumnsLayout(Grid: TCustomDBGridEh; SectionName : String);

    class function GetSelectedRows(Grid: TCustomDBGridEh) : TStringList;
    class procedure SetMinWidthToColumns(Grid : TCustomDBGridEh);
    class procedure SetTitleButtonToColumns(Grid : TCustomDBGridEh);

    class function GetStdDefaultRowHeight(Grid : TCustomDBGridEh) : Integer;

    class function GetTempFileToExport() : String;
  end;

implementation

uses
  Main,
  UniqueID;

type
  TCustomDBGridEhEx = class(TCustomDBGridEh);

{ TDBGridHelper }

class function TDBGridHelper.AddColumn(Grid: TCustomDBGridEh; ColumnName,
  Caption: String; ReadOnly : Boolean) : TColumnEh;
begin
  Result := Grid.Columns.Add;
  Result.FieldName := ColumnName;
  Result.ReadOnly := ReadOnly;
  Result.Title.Caption := Caption;
  Result.Title.Hint := Caption;
  Result.MinWidth := DBGridColumnMinWidth;
end;

class function TDBGridHelper.AddColumn(Grid: TCustomDBGridEh; ColumnName,
  Caption, DisplayFormat: String; ReadOnly: Boolean): TColumnEh;
begin
  Result := AddColumn(Grid, ColumnName, Caption, ReadOnly);
  Result.DisplayFormat := DisplayFormat;
end;

class function TDBGridHelper.AddColumn(Grid: TCustomDBGridEh; ColumnName,
  Caption: String; Width: Integer; ReadOnly: Boolean): TColumnEh;
begin
  Result := AddColumn(Grid, ColumnName, Caption, ReadOnly);
  if Width <> 0 then
    Result.Width := Width
  else
    Result.Width := Grid.Canvas.TextWidth(Caption) + 20;
end;

class function TDBGridHelper.AddColumn(Grid: TCustomDBGridEh; ColumnName,
  Caption, DisplayFormat: String; Width: Integer; ReadOnly : Boolean): TColumnEh;
begin
  Result := AddColumn(Grid, ColumnName, Caption, DisplayFormat, ReadOnly);
  if Width <> 0 then
    Result.Width := Width
  else
    Result.Width := Grid.Canvas.TextWidth(Caption) + 20;
end;

class procedure TDBGridHelper.CopyGridToClipboard(Grid: TCustomDBGridEh);
begin
  if Assigned(Grid.DataSource)
    and Assigned(Grid.DataSource.DataSet)
    and Grid.DataSource.DataSet.Active
  then
    DBGridEh_DoCopyAction(Grid, True);
end;

class function TDBGridHelper.ExtractWord(N: Integer; const S: string;
  WordDelims: TCharSet): string;
var
  I: Word;
  Len: Integer;
begin
  Result := '';
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  if I <> 0 then
    { find the end of the current word }
//  while (I <= Length(S)) and not(S[I] in WordDelims) do begin
    while (I <= Length(S)) and not (
{$IFNDEF CIL}
      (ByteType(S, I) = mbSingleByte) and
{$ENDIF}
      (S[I] in WordDelims)) do
    begin
      { add the I'th character to result }
      Inc(Len);
//      SetLength(Result, Len);
//      Result[Len] := S[I];
      Result := Result + S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

class function TDBGridHelper.GetColumnWidths(Grid : TCustomDBGridEh): Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Grid.Columns.Count-1 do begin
    Grid.Columns[i].Width := Grid.Canvas.TextWidth(Grid.Columns[i].Title.Caption) + 5;
    Inc(Result, Grid.Columns[i].Width);
  end;
end;

class function TDBGridHelper.GetDefaultSection(Component: TComponent): string;
var
//  F: TCustomForm;
  Owner: TComponent;
begin
  if Component <> nil then
  begin
    if Component is TCustomForm then
      Result := Component.ClassName
    else
    begin
      Result := Component.Name;
      Owner := Component.Owner;
      while (Owner <> nil) and not (Owner is  TCustomForm) do
      begin
        Result := Owner.Name + '.' + Result;
        Owner := Owner.Owner;
      end;
      if Owner <> nil then
        Result := Owner.ClassName + Result;
{      if Component is TControl then
      begin
        F := GetParentForm(TControl(Component));
        if F <> nil then Result := F.ClassName + Result
        else
        begin
          if TControl(Component).Parent <> nil then
            Result := TControl(Component).Parent.Name + Result;
        end;
      end
      else
      begin
        Owner := Component.Owner;
        if Owner is TForm then
          Result := Format('%s.%s', [Owner.ClassName, Result]);
      end;}
    end;
  end else
    Result := '';
end;

class function TDBGridHelper.GetSelectedRows(
  Grid: TCustomDBGridEh): TStringList;
var
  CurrentBookmark : String;
begin
  Result := TStringList.Create;

  //Если выделение не Rect, то берем только текущую строку, иначе работаем
  //со свойством Grid.Selection.Rect
  if Grid.Selection.SelectionType <> gstRectangle then
    Result.Add(Grid.DataSource.DataSet.Bookmark)
  else begin
    CurrentBookmark := Grid.DataSource.DataSet.Bookmark;
    Grid.DataSource.DataSet.DisableControls;
    try
      Grid.DataSource.DataSet.Bookmark := Grid.Selection.Rect.TopRow;
      repeat
        Result.Add(Grid.DataSource.DataSet.Bookmark);
        if Grid.DataSource.DataSet.Bookmark = Grid.Selection.Rect.BottomRow then
          Break
        else
          Grid.DataSource.DataSet.Next;
      until Grid.DataSource.DataSet.Eof;
    finally
      Grid.DataSource.DataSet.Bookmark := CurrentBookmark;
      Grid.DataSource.DataSet.EnableControls;
    end;
  end;
end;

class function TDBGridHelper.GetStdDefaultRowHeight(
  Grid: TCustomDBGridEh): Integer;
begin
  Result := TCustomDBGridEhEx(Grid).StdDefaultRowHeight;
end;

class function TDBGridHelper.GetTempFileToExport: String;
var
  Path,
  tmpFileName : String;
begin
  Path := ExcludeTrailingPathDelimiter( GetAFTempDir() );
  tmpFileName := StringOfChar(' ', MAX_PATH);
  Win32CheckA(GetTempFileName(PChar(Path), 'tmp', 0, (@tmpFileName[1])) <> 0);
  Result := ChangeFileExt(Trim(tmpFileName), '.xls');
end;

class procedure TDBGridHelper.InternalRestoreColumnsLayout(
  Grid: TCustomDBGridEh;
  ARegIni: TObject;
  Section: String;
  RestoreParams: TColumnEhRestoreParams);
type
  TColumnInfo = record
    Column: TColumnEh;
    NextColumn: TColumnEh;
    EndIndex: Integer;
    SortMarker: TSortMarkerEh;
    SortIndex: Integer;
    Readed : Boolean;
  end;
  PColumnArray = ^TColumnArray;
  TColumnArray = array[0..0] of TColumnInfo;
const
  Delims = [' ', ','];
var
  I, J: Integer;
  S: string;
  ColumnArray: array of TColumnInfo;
  AAutoFitColWidth: Boolean;
begin
  AAutoFitColWidth := False;
  TCustomDBGridEhEx(Grid).BeginUpdate;
  try
    if (Grid.AutoFitColWidths) then
    begin
      Grid.AutoFitColWidths := False;
      AAutoFitColWidth := True;
    end;
    with Grid.Columns do
    begin
      SetLength(ColumnArray, Count);
      try
        for I := 0 to Count - 1 do
        begin
          if (ARegIni is TRegIniFile)
            then S := TRegIniFile(ARegIni).ReadString(Section, Format('%s.%s', [Grid.Name, Items[I].FieldName]), '')
            else S := TCustomIniFile(ARegIni).ReadString(Section, Format('%s.%s', [Grid.Name, Items[I].FieldName]), '');
          ColumnArray[I].Column := Items[I];
          ColumnArray[I].EndIndex := Items[I].Index;
          if S <> '' then
          begin
            ColumnArray[I].Readed := True;
            ColumnArray[I].NextColumn := nil;
            ColumnArray[I].EndIndex := StrToIntDef(ExtractWord(1, S, Delims),
              ColumnArray[I].EndIndex);
            if (crpColWidthsEh in RestoreParams) then
              Items[I].Width := StrToIntDef(ExtractWord(2, S, Delims),
                Items[I].Width);
            if (crpSortMarkerEh in RestoreParams) then
              Items[I].Title.SortMarker := TSortMarkerEh(StrToIntDef(ExtractWord(3, S, Delims),
                Integer(Items[I].Title.SortMarker)));
            if (crpColVisibleEh in RestoreParams) then
              Items[I].Visible := Boolean(StrToIntDef(ExtractWord(4, S, Delims), Integer(Items[I].Visible)));
            if (crpSortMarkerEh in RestoreParams) then
              ColumnArray[I].SortIndex := StrToIntDef(ExtractWord(5, S, Delims), 0);
            if (crpDropDownRowsEh in RestoreParams) then
              Items[I].DropDownRows := StrToIntDef(ExtractWord(6, S, Delims), Items[I].DropDownRows);
            if (crpDropDownWidthEh in RestoreParams) then
              Items[I].DropDownWidth := StrToIntDef(ExtractWord(7, S, Delims), Items[I].DropDownWidth);
          end
          else begin
            ColumnArray[I].Readed := False;
            if I = (Count -1) then
              ColumnArray[I].NextColumn := nil
            else
              ColumnArray[I].NextColumn := Items[I+1];
          end;
        end;

        if (crpSortMarkerEh in RestoreParams) then
          for I := 0 to Count - 1 do
            Items[I].Title.SortIndex := ColumnArray[I].SortIndex;
        if (crpColIndexEh in RestoreParams) then begin
          for I := 0 to Count - 1 do
            for J := 0 to Count - 1 do
              if ColumnArray[J].Readed and (ColumnArray[J].EndIndex = I) then
              begin
                ColumnArray[J].Column.Index := ColumnArray[J].EndIndex;
                Break;
              end;

          for I := Count - 1 downto 0 do
            if not ColumnArray[i].Readed then
              if Assigned(ColumnArray[i].NextColumn) then
                ColumnArray[i].Column.Index := ColumnArray[i].NextColumn.Index
              else
                if ColumnArray[i].Column.Index <> Count - 1 then
                  ColumnArray[i].Column.Index := Count - 1;
        end;

      finally
        //FreeMem(Pointer(ColumnArray));
        SetLength(ColumnArray, 0);
      end;
    end;
  finally
    TCustomDBGridEhEx(Grid).EndUpdate;
    if (AAutoFitColWidth = True)
      then Grid.AutoFitColWidths := True
      else TCustomDBGridEhEx(Grid).LayoutChanged;
  end;
end;

class procedure TDBGridHelper.RestoreColumnsLayout(Grid: TCustomDBGridEh;
  SectionName: String);
var
  Reg: TRegIniFile;
  Section: String;
begin
  Reg := TRegIniFile.Create();
  try
    if Reg.OpenKey('Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + SectionName, False)
    then begin
      Section := GetDefaultSection(Grid);
      if Reg.KeyExists(Section) then
        InternalRestoreColumnsLayout(Grid, Reg, Section, [crpColIndexEh, crpColWidthsEh, crpSortMarkerEh, crpColVisibleEh]);
    end;
  finally
    Reg.Free;
  end;
end;

class procedure TDBGridHelper.SaveColumnsLayout(Grid: TCustomDBGridEh;
  SectionName: String);
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create();
  try
    Reg.OpenKey('Software\Inforoom\AnalitF\' + GetPathCopyID + '\' + SectionName, True);
    Grid.SaveColumnsLayout(Reg);
  finally
    Reg.Free;
  end;
end;

class procedure TDBGridHelper.SaveGrid(Grid: TCustomDBGridEh);
var
  tmpFileName : String;
begin
  if Grid = nil then
    raise Exception.Create( 'Не задана таблица для сохранения');

  tmpFileName := GetTempFileToExport();

  SaveDBGridEhToExportFile(
    TDBGridEhExportAsXls,
    Grid,
    tmpFileName,
    True);

  ShellExecute(
    0,
    'Open',
    PChar(tmpFileName),
    nil, nil, SW_SHOWNORMAL);
end;

class procedure TDBGridHelper.SetDefaultSettingsToGrid(Grid : TCustomDBGridEh);
begin
  Grid.MinAutoFitWidth := DBGridColumnMinWidth;
  Grid.AutoFitColWidths := True;
  Grid.AllowedSelections := [gstRecordBookmarks, gstRectangle]; 
  Grid.Flat := True;
  Grid.Options := [dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgRowLines];
  Grid.OptionsEh := [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight, dghResizeWholeRightPart];
  Grid.Font.Size := 10;
  Grid.GridLineColors.DarkColor := clBlack;
  Grid.GridLineColors.BrightColor := clDkGray;
  if CheckWin32Version(5, 1) then
    Grid.OptionsEh := Grid.OptionsEh + [dghTraceColSizing];
end;

class procedure TDBGridHelper.SetMinWidthToColumns(Grid: TCustomDBGridEh);
var
  I : Integer;
begin
  for I := 0 to Grid.Columns.Count-1 do
    Grid.Columns[i].MinWidth := DBGridColumnMinWidth;
end;

class procedure TDBGridHelper.SetTitleButtonToColumns(
  Grid: TCustomDBGridEh);
var
  I : Integer;
begin
  for I := 0 to Grid.Columns.Count-1 do
    Grid.Columns[i].Title.TitleButton := True;
end;

class function TDBGridHelper.WordPosition(const N: Integer;
  const S: string; WordDelims: TCharSet): Integer;
var
  Count, I: Integer;
begin
  Count := 0;
  I := 1;
  Result := 0;
  while (I <= Length(S)) and (Count <> N) do
  begin
    { skip over delimiters }
//  while (I <= Length(S)) and (S[I] in WordDelims) do Inc(I);
    while (I <= Length(S)) and (
{$IFNDEF CIL}
      (ByteType(S, I) = mbSingleByte) and
{$ENDIF}
      (S[I] in WordDelims)) do Inc(I);
    { if we're not beyond end of S, we're at the start of a word }
    if I <= Length(S) then Inc(Count);
    { if not finished, find the end of the current word }
    if Count <> N then
//    while (I <= Length(S)) and not (S[I] in WordDelims) do Inc(I)
      while (I <= Length(S)) and not (
{$IFNDEF CIL}
        (ByteType(S, I) = mbSingleByte) and
{$ENDIF}
        (S[I] in WordDelims)) do Inc(I)
    else Result := I;
  end;
end;

end.
