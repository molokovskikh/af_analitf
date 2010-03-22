unit DBGridHelper;

interface

uses
  SysUtils, Classes, Windows, Graphics, Grids, DBGrids, GridsEh, DBGridEh, ToughDBGrid;

type
  TDBGridHelper = class
   public
     class procedure SetDefaultSettingsToGrid(Grid : TDBGridEh);
     class function AddColumn(Grid : TDBGridEh; ColumnName, Caption : String; ReadOnly : Boolean = True) : TColumnEh; overload;
     class function AddColumn(Grid : TDBGridEh; ColumnName, Caption : String; Width : Integer; ReadOnly : Boolean = True ) : TColumnEh; overload;
     class function AddColumn(Grid : TDBGridEh; ColumnName, Caption : String; DisplayFormat: String; ReadOnly : Boolean = True) : TColumnEh; overload;
     class function AddColumn(Grid : TDBGridEh; ColumnName, Caption : String; DisplayFormat : String; Width : Integer = 0; ReadOnly : Boolean = True) : TColumnEh; overload;
     class function GetColumnWidths(Grid : TDBGridEh) : Integer;
  end;

implementation

{ TDBGridHelper }

class function TDBGridHelper.AddColumn(Grid: TDBGridEh; ColumnName,
  Caption: String; ReadOnly : Boolean) : TColumnEh;
begin
  Result := Grid.Columns.Add;
  Result.FieldName := ColumnName;
  Result.ReadOnly := ReadOnly;
  Result.Title.Caption := Caption;
  Result.Title.Hint := Caption;
end;

class function TDBGridHelper.AddColumn(Grid: TDBGridEh; ColumnName,
  Caption, DisplayFormat: String; ReadOnly: Boolean): TColumnEh;
begin
  Result := AddColumn(Grid, ColumnName, Caption, ReadOnly);
  Result.DisplayFormat := DisplayFormat;
end;

class function TDBGridHelper.AddColumn(Grid: TDBGridEh; ColumnName,
  Caption: String; Width: Integer; ReadOnly: Boolean): TColumnEh;
begin
  Result := AddColumn(Grid, ColumnName, Caption, ReadOnly);
  if Width <> 0 then
    Result.Width := Width
  else
    Result.Width := Grid.Canvas.TextWidth(Caption) + 20;
end;

class function TDBGridHelper.AddColumn(Grid: TDBGridEh; ColumnName,
  Caption, DisplayFormat: String; Width: Integer; ReadOnly : Boolean): TColumnEh;
begin
  Result := AddColumn(Grid, ColumnName, Caption, DisplayFormat, ReadOnly);
  if Width <> 0 then
    Result.Width := Width
  else
    Result.Width := Grid.Canvas.TextWidth(Caption) + 20;
end;

class function TDBGridHelper.GetColumnWidths(Grid : TDBGridEh): Integer;
var
  I : Integer;
begin
  Result := 0;
  for I := 0 to Grid.Columns.Count-1 do begin
    Grid.Columns[i].Width := Grid.Canvas.TextWidth(Grid.Columns[i].Title.Caption) + 5;
    Inc(Result, Grid.Columns[i].Width);
  end;
end;

class procedure TDBGridHelper.SetDefaultSettingsToGrid(Grid : TDBGridEh);
begin
  Grid.AutoFitColWidths := True;
  Grid.Flat := True;
  Grid.Options := [dgTitles, dgColumnResize, dgColLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgRowLines];
  Grid.OptionsEh := [dghFixed3D, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghRowHighlight];
  Grid.Font.Size := 10;
  Grid.GridLineColors.DarkColor := clBlack;
  Grid.GridLineColors.BrightColor := clDkGray;
  if CheckWin32Version(5, 1) then
    Grid.OptionsEh := Grid.OptionsEh + [dghTraceColSizing];
end;

end.
