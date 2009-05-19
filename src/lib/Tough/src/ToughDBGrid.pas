unit ToughDBGrid;

interface

uses
	SysUtils, Classes, Controls, Grids, DBGridEh, ExtCtrls, Windows, DB,
	DateUtils, StdCtrls, Dialogs, Math, Menus, Forms, Registry,
	Messages, StrUtils, ForceRus;

const
	FIND_INTERVAL	= 5000;
  MaxInputValue = 1000000;
  INPUT_INTERVAL = 1500;

type

TSearchPosition = ( spBottom, spTop);

TOnSortChangeEvent = procedure( Sender: TObject; SQLOrderBy: string) of object;
TOnCanFocusNextEvent = procedure( Sender: TObject; Next: Boolean; var CanFocus: Boolean) of object;
TOnCanInput = procedure( Sender: TObject; Value: Integer; var CanInput: Boolean) of object;

TToughDBGrid = class( TDBGridEh)
private
	FInputField: string;
	FSearchField: string;
	FAutoSearch: string;
	FForceRus: boolean;
	FLastAuto: TTime;
	FSearchPosition: TSearchPosition;
	FSQLOrderBy: string;
	FPanel: TPanel;
	FEdit: TEdit;
	FPopup: TPopupMenu;
	FColumnsMI: TMenuItem;
	FColumnsForm: TForm;
	FTimer: TTimer;
	FR: TForceRus;

	LastMark: string;
  LastInputTime : TDateTime;

	FOnSortChange: TOnSortChangeEvent;
	FOnCanInput: TOnCanInput;
  FFindInterval: Integer;
  FCheckLastInput : Boolean;
  FInputInterval: Integer;

	procedure WMKillFocus( var Message: TWMSetFocus); message WM_KILLFOCUS;
	procedure WMSetFocus( var Message: TMessage); message WM_SETFOCUS;
	procedure SetupSearch;
	procedure ShowSearch;
	procedure HideSearch;
//	procedure DestroySearch;
	function ColumnByFieldName( FieldName: string): TColumnEh;
	function GetParentForm(Control: TControl): TForm;
	procedure SetSearchPosition( Value: TSearchPosition);
	procedure ColumnsMIClick( Sender: TObject);
	function GetInputValue: Integer;
	procedure SetInputValue( Value: Integer);
	procedure SoftEdit;
	procedure SoftPost;
	procedure SoftCancel;
	procedure PanelEnter( Sender: TObject);
  procedure SetFindInterval(const Value: Integer);
protected
	procedure KeyDown( var Key: Word; Shift: TShiftState); override;
	procedure KeyPress( var Key: Char); override;
	procedure ToughDBGridSortMarkingChanged( Sender: TObject);
	procedure FindOnFind( Sender: TObject);
	procedure OnTimer( Sender: TObject);
public
	constructor Create( AOwner: TComponent); override;
	destructor Destroy; override;

	function InSearch: boolean;
	procedure SaveToRegistry( AReg: TRegistry);
	procedure LoadFromRegistry( AReg: TRegistry);
	procedure ShowFind;
published
	property SQLOrderBy: string read FSQLOrderBy;
	property SearchField: string read FSearchField write FSearchField;
	property InputField: string read FInputField write FInputField;
	property SearchPosition: TSearchPosition read FSearchPosition write SetSearchPosition;
	property ForceRus: boolean read FForceRus write FForceRus default False;
	property CheckLastInput: Boolean read FCheckLastInput write FCheckLastInput default True;
  property InputInterval : Integer read FInputInterval write FInputInterval default INPUT_INTERVAL;
  property FindInterval : Integer read FFindInterval write SetFindInterval default FIND_INTERVAL;

	property OnSortChange: TOnSortChangeEvent read FOnSortChange write FOnSortChange;
	property OnCanInput: TOnCanInput read FOnCanInput write FOnCanInput;
end;

function SearchBuf_( Buf: PChar; BufLen: Integer; SelStart, SelLength: Integer;
	SearchString: String; Options: TStringSearchOptions): PChar;

var
	FindDialog: TFindDialog;

procedure Register;

implementation

uses ToughDBGridColumns;

procedure Register;
begin
	RegisterComponents( 'Tough', [TToughDBGrid]);
end;

{ TToughDBGrid }

constructor TToughDBGrid.Create( AOwner: TComponent);
begin
	inherited;
	Self.Flat := True;
	Self.Options := Self.Options - [dgIndicator];
	Self.OptionsEh := Self.OptionsEh + [dghAutoSortMarking, dghMultiSortMarking];
	Self.OnSortMarkingChanged := ToughDBGridSortMarkingChanged;
	FPanel := nil;
	FEdit := nil;
	FPopup := TPopupMenu.Create( Self);
	Self.PopupMenu := FPopup;
	FColumnsMI := TMenuItem.Create( FPopup);
	FColumnsMI.Caption := 'Столбцы...';
	FColumnsMI.OnClick := ColumnsMIClick;
	FPopup.Items.Add( FColumnsMI);
  FCheckLastInput := True;
  FFindInterval := FIND_INTERVAL;
  FInputInterval := INPUT_INTERVAL;
	FTimer := TTimer.Create( Self);
	FTimer.Enabled := False;
	FTimer.Interval := FFindInterval;
	FTimer.OnTimer := OnTimer;
	FTimer.Enabled := True;
	FR := TForceRus.Create;
end;

destructor TToughDBGrid.Destroy;
begin
//  DestroySearch;
	FindDialog.CloseDialog;
	Self.PopupMenu := nil;
	if Assigned( FColumnsForm) then FColumnsForm.Free;
	FColumnsMI.Free;
	FPopup.Free;
	FTimer.Free;
	FR.Free;
	inherited;
end;

function TToughDBGrid.InSearch: boolean;
begin
	result := Assigned( FPanel) and FPanel.Visible = True;
end;

procedure TToughDBGrid.SaveToRegistry( AReg: TRegistry);
var
	i: integer;
begin
	AReg.OpenKey( Self.Name, True);
	for i := 0 to Self.Columns.Count - 1 do
	begin
		AReg.WriteInteger( Self.Columns[ i].FieldName + 'Width', Self.Columns[ i].Width);
		AReg.WriteInteger( Self.Columns[ i].FieldName + 'Index', i);
		AReg.WriteBool( Self.Columns[ i].FieldName + 'Visible', Self.Columns[ i].Visible);
		AReg.WriteInteger( Self.Columns[ i].FieldName + 'SortMarker', Integer(Self.Columns[ i].Title.SortMarker));
		AReg.WriteInteger( Self.Columns[ i].FieldName + 'SortIndex', Self.Columns[ i].Title.SortIndex);
	end;
end;

procedure TToughDBGrid.LoadFromRegistry( AReg: TRegistry);
var
	i, j: integer;
	Cols: array of string;
	AutoFit: boolean;
begin
	if not AReg.OpenKey( Self.Name, False) then exit;
	AutoFit := Self.AutoFitColWidths;
	Self.AutoFitColWidths := False;
	Self.Enabled := False;

(*Алексей:
	Мои исправления обозначаются <atu></atu>.
*)
	try
		for i := 0 to Self.Columns.Count - 1 do
    begin
			try
				Self.Columns[ i].Visible := AReg.ReadBool( Self.Columns[ i].FieldName + 'Visible');
			except
      end;
			try
  			Self.Columns[ i].Width := AReg.ReadInteger( Self.Columns[ i].FieldName + 'Width');
			except
      end;
			try
  			Self.Columns[ i].Title.SortMarker := TSortMarkerEh( AReg.ReadInteger( Self.Columns[ i].FieldName + 'SortMarker') );
			except
      end;
    end;

		for i := Self.Columns.Count - 1 downto 0 do
		begin
      try
				Self.Columns[ i].Index := AReg.ReadInteger( Self.Columns[ i].FieldName + 'Index');
      except
      end;
      try
				Self.Columns[ i].Title.SortIndex := AReg.ReadInteger( Self.Columns[ i].FieldName + 'SortIndex');
      except
      end;
    end;

{
		SetLength( Cols, Self.Columns.Count);
		for i := 0 to Self.Columns.Count - 1 do Cols[ i] := Self.Columns[ i].FieldName;

		for i := Self.Columns.Count - 1 downto 0 do
		begin
			for j := Self.Columns.Count - 1 downto 0 do
			begin
				if Cols[ i] = Self.Columns[ j].FieldName then
        begin
					//<atu>
					try
          //</atu>
					Self.Columns[ j].Index := AReg.ReadInteger( Cols[ i] + 'Index');
					//<atu>
					except
					end;
          //</atu>
					break;
				end;
			end;
		end;
}    

	finally
		Self.Enabled := True;
		Self.AutoFitColWidths := AutoFit;
	end;
end;

procedure TToughDBGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
	inherited;

	if ( Shift = []) and ( Key = VK_DELETE) then
	begin
		if ( Self.DataSource.DataSet.FindField( FInputField) <> nil) and
			( MessageBox( Application.Handle, 'Удалить значение?', 'Вопрос',
			MB_ICONQUESTION or MB_OKCANCEL) = IDOK) then SetInputValue( 0);
	end;

	if ( Shift = [ ssCtrl]) and ( Key = Ord( 'F')) then
	begin
		HideSearch;
		ShowFind;
	end;

	if ( Key = VK_UP) or
		( Key = VK_DOWN) or
		( Key = VK_LEFT) or
		( Key = VK_RIGHT) or
		( Key = VK_RETURN) or
		( Key = VK_ESCAPE) or
		( Key = VK_F3) or
		( Key = VK_F6) or
		( Key = VK_F8) then HideSearch;
end;

procedure TToughDBGrid.KeyPress( var Key: Char);
var
	AddKey: boolean;
	tmp: string;

	procedure Locate_;
	begin
		if Self.DataSource.DataSet.Locate( FSearchField, FAutoSearch + AnsiUpperCase( Key),
			[loPartialKey, loCaseInsensitive]) then FAutoSearch := FAutoSearch + AnsiUpperCase( Key)
		else
		begin
			if not Self.DataSource.DataSet.Locate( FSearchField, FAutoSearch + AnsiLowerCase( Key),
				[loPartialKey, loCaseInsensitive]) then
			begin
				FEdit.Text := Copy( FEdit.Text, 1, Length( FEdit.Text) - 1);
				MessageBeep( MB_ICONEXCLAMATION);
			end;
		end;
	end;

begin
	if ( Ord( Key) < 32) and ( Ord( Key) <> 8) then exit;

	if FForceRus then
	begin
		tmp := Key;
		tmp := FR.DoIt( tmp);
		Key := tmp[ 1];
	end;

	if InSearch then
	begin
		if Ord( Key) = 8 then
		begin
			FAutoSearch := Copy( FAutoSearch, 1, Length( FAutoSearch) - 1);
			FEdit.Text := Copy( FEdit.Text, 1, Length( FEdit.Text) - 1);
			AddKey := False;
		end
		else
		begin
			FEdit.Text := FEdit.Text + Key;
			AddKey := True;
		end;
		if not Assigned( FPanel) then ShowSearch
			else if FPanel.Visible = False then ShowSearch;
		FLastAuto := Now;

		if AddKey then Locate_
			else Self.DataSource.DataSet.Locate( FSearchField, FAutoSearch, [loPartialKey, loCaseInsensitive])
	end
	else
	begin
		if Ord( Key) = 32 then exit;
		if Ord( Key) = 8 then
		begin
			SetInputValue( GetInputValue div 10);
			exit;
		end;
		if Ord( Key) = 13 then
		begin
			SoftPost;
			exit;
		end;
		if Ord( Key) = 27 then
		begin
			SoftCancel;
			exit;
		end;

		if ( Key = '0') or ( Key = '1') or ( Key = '2') or ( Key = '3') or ( Key = '4') or
			( Key = '5') or ( Key = '6') or ( Key = '7') or ( Key = '8') or ( Key = '9') then
		begin
			if Self.DataSource.DataSet.FindField( FInputField) <> nil then
			begin
				if (Self.DataSource.DataSet.Bookmark = LastMark)
           and (not FCheckLastInput or (FCheckLastInput and (MilliSecondsBetween(Now, LastInputTime) < FInputInterval)))
        then begin
          if GetInputValue < MaxInputValue then
					  SetInputValue( 10 * GetInputValue + StrToInt( Key))
        end
				else begin
					SetInputValue( StrToInt( Key));
        end;
			end
			else
			if Self.DataSource.DataSet.FindField( FSearchField) <> nil then
			begin
				if not Assigned( FPanel) then ShowSearch
					else if FPanel.Visible = False then ShowSearch;
				FEdit.Text := Key;
				FLastAuto := Now;
				Locate_;
			end;
		end
		else
		if Self.DataSource.DataSet.FindField( FSearchField) <> nil then
		begin
			if not Assigned( FPanel) then ShowSearch
				else if FPanel.Visible = False then ShowSearch;
			FEdit.Text := Key;
			FLastAuto := Now;
			Locate_;
		end;
	end;
	inherited;
end;

procedure TToughDBGrid.ToughDBGridSortMarkingChanged( Sender: TObject);
var
	i: integer;
begin
	FSQLOrderBy := '';
	if Self.SortMarkedColumns.Count = 0 then exit;
	for i := 0 to Self.SortMarkedColumns.Count - 1 do
	begin
		if i > 0 then FSQLOrderBy := FSQLOrderBy + ', ';
		if Self.SortMarkedColumns.Items[ i].Title.SortMarker = smUpEh then
			FSQLOrderBy := FSQLOrderBy + Self.SortMarkedColumns.Items[ i].FieldName + ' DESC'
		else
			FSQLOrderBy := FSQLOrderBy + Self.SortMarkedColumns.Items[ i].FieldName + ' ASC';
	end;
	if Assigned( FOnSortChange) then FOnSortChange( Sender, FSQLOrderBy);
end;

procedure TToughDBGrid.FindOnFind(Sender: TObject);
var
	TextFound, Down: boolean;
	Options: TStringSearchOptions;
	Mark: string;
	Str: string;
begin
	Down := frDown in FindDialog.Options;
	Options := [soDown];
	if frMatchCase in FindDialog.Options then Options := Options + [soMatchCase];
	if frWholeWord in FindDialog.Options then Options := Options + [soWholeWord];
	Mark := Self.DataSource.DataSet.Bookmark;
	TextFound := False;
	Self.DataSource.DataSet.DisableControls;
	try
		Screen.Cursor := crHourglass;
		repeat
			if Down then Self.DataSource.DataSet.Next else
				Self.DataSource.DataSet.Prior;
			Str := ColumnByFieldName( FSearchField).Field.AsString;
			if SearchBuf_( PChar( Str), Length(Str), 0, 0,
				FindDialog.FindText, Options) <> nil then
			begin
				TextFound := True;
				break;
			end;
		until ( Down and Self.DataSource.DataSet.Eof) or
			( not Down and Self.DataSource.DataSet.Bof);
		if not TextFound then Self.DataSource.DataSet.Bookmark := Mark;
	finally
		Self.DataSource.DataSet.EnableControls;
		Screen.Cursor := crDefault;
	end;
	if not TextFound then Application.MessageBox( 'Поиск в документе завершен.',
		PChar( Application.Title), MB_ICONWARNING or MB_OK);
end;

procedure TToughDBGrid.OnTimer(Sender: TObject);
begin
	if InSearch and ( SecondSpan( FLastAuto, Now) > ( FFindInterval / 1000))
		then HideSearch;
end;

procedure TToughDBGrid.WMKillFocus( var Message: TWMSetFocus);
begin
	inherited;
	HideSearch;
end;

procedure TToughDBGrid.WMSetFocus(var Message: TMessage);
begin
	inherited;
	FindDialog.OnFind := FindOnFind;
end;

procedure TToughDBGrid.SetupSearch;
begin
	FPanel := TPanel.Create( Self);
	FEdit := TEdit.Create( FPanel);
	FPanel.Parent := Self;
	FPanel.OnEnter := PanelEnter;
	FPanel.Name := 'Panel';
	FPanel.Caption := '';
	FPanel.Visible := False;
	FPanel.BevelOuter := bvNone;
	FEdit.Name := 'Edit';
	FEdit.Text := '';
	FEdit.ReadOnly := True;
	FEdit.Parent := FPanel;
end;

procedure TToughDBGrid.ShowSearch;
const
	Indent = 0;
var
	P: TPoint;
	Column: TColumnEh;
begin
	Column := ColumnByFieldName( FSearchField);
	if Column = nil then exit;
	if FPanel = nil then SetupSearch;
	P.X := Left + 6;
	case FSearchPosition of
		spTop: P.Y := Top + DefaultRowHeight + Indent - 10;
		spBottom: P.Y := Top + Height - FEdit.Height + 2 * Indent - 10;
	end;
	P := Parent.ClientToScreen( P);
	FPanel.Parent := GetParentForm( Self);
	P := FPanel.Parent.ScreenToClient( P);
	FPanel.SetBounds( P.X + Indent, P.Y, min( Column.Width, Self.Width), FEdit.Height + 2 * Indent);
	FEdit.SetBounds( Indent, Indent, FPanel.Width - 2 * Indent, FEdit.Height);
	FPanel.Show;
  FPanel.BringToFront;
end;

procedure TToughDBGrid.HideSearch;
begin
	if Assigned( FPanel) then FPanel.Visible := False;
	FAutoSearch := '';
end;

{
procedure TToughDBGrid.DestroySearch;
begin
	if Assigned( FEdit) then FEdit.Free;
	if Assigned( FPanel) then FPanel.Free;
end;
}

procedure TToughDBGrid.ShowFind;
var
	Column: TColumnEh;
	P, pos: TPoint;
	Parent: TForm;
begin
	Column := ColumnByFieldName( FSearchField);
	if Column = nil then exit;
	Parent := GetParentForm( Self);
	if Parent <> nil then
	begin
		P.X := Parent.Left;
		P.Y := Parent.Top;
		P := Parent.ClientToScreen( P);
		pos.X := Parent.Left + P.X + ( Parent.Width - 350) div 2;
		pos.Y := Parent.Top + P.Y + ( Parent.Height - 330) div 2;
		FindDialog.Position := pos;
	end;
	FindDialog.Execute;
end;

function TToughDBGrid.ColumnByFieldName( FieldName: string): TColumnEh;
var
	i: integer;
begin
	result := nil;
	FieldName := AnsiUpperCase( Trim( FieldName));
	for i := 0 to Columns.Count - 1 do
	if AnsiUpperCase( Columns[ i].FieldName) = FieldName then
	begin
		result := Columns[ i];
		break;
	end;
end;

function TToughDBGrid.GetParentForm( Control: TControl): TForm;
begin
	if Control.Parent = nil then result := nil
		else if Control.Parent is TForm then result := TForm( Control.Parent)
			else result := GetParentForm( Control.Parent);
end;

procedure TToughDBGrid.SetSearchPosition( Value: TSearchPosition);
begin
	if FSearchPosition <> Value then FSearchPosition := Value;
end;

procedure TToughDBGrid.ColumnsMIClick( Sender: TObject);
begin
	if not Assigned( FColumnsForm) then
	begin
		FColumnsForm := TfrmColumns.Create( GetParentForm( Self));
		TfrmColumns( FColumnsForm).OwnerDBGrid := Self;
	end;
	FColumnsForm.ShowModal;
end;

function TToughDBGrid.GetInputValue: Integer;
begin
	result := 0;
	try
		if Self.DataSource.DataSet.FindField( FInputField) <> nil then
			result := Self.DataSource.DataSet.FindField( FInputField).AsInteger;
	except
	end;
end;

procedure TToughDBGrid.SetInputValue( Value: Integer);
var
	CanInput: Boolean;
begin
	HideSearch;
	CanInput := True;
	if Assigned( FOnCanInput) then FOnCanInput( Self, Value, CanInput);
	if CanInput then
	begin
		if Self.DataSource.DataSet.FindField( FInputField) <> nil then
		begin
			SoftEdit;
                        Self.DataSource.DataSet.FindField( FInputField).AsInteger := Value;
			SoftPost;
			LastMark := Self.DataSource.DataSet.Bookmark;
      LastInputTime := Now;
		end;
	end;
end;

procedure TToughDBGrid.SoftEdit;
begin
	if not( Self.DataSource.DataSet.State in [ dsEdit, dsInsert]) then
		Self.DataSource.DataSet.Edit;
end;

procedure TToughDBGrid.SoftPost;
begin
	if Self.DataSource.DataSet.Active and
		( DataSource.DataSet.State in [ dsEdit, dsInsert]) then
		Self.DataSource.DataSet.Post;
end;


procedure TToughDBGrid.SoftCancel;
begin
	if Self.DataSource.DataSet.Active and
		( Self.DataSource.DataSet.State in [ dsEdit, dsInsert]) then
		Self.DataSource.DataSet.Cancel;
end;

procedure TToughDBGrid.PanelEnter(Sender: TObject);
begin
	TPanel( Sender).Parent.SetFocus;
end;

{ копия системной функции SearchBuf из-за англоязычных WordDelimiters }
function SearchBuf_(Buf: PChar; BufLen: Integer; SelStart, SelLength: Integer;
	SearchString: String; Options: TStringSearchOptions): PChar;
const
	WordDelimiters=[#0..#255]-['a'..'z','A'..'Z','1'..'9','0','Ё','ё','А'..'Я','а'..'я'];
var
	SearchCount, I: Integer;
	C: Char;
	Direction: Shortint;
	ShadowMap: array[0..256] of Char;
	CharMap: array [Char] of Char absolute ShadowMap;

  function FindNextWordStart(var BufPtr: PChar): Boolean;
  begin                   { (True XOR N) is equivalent to (not N) }
                          { (False XOR N) is equivalent to (N)    }
     { When Direction is forward (1), skip non delimiters, then skip delimiters. }
     { When Direction is backward (-1), skip delims, then skip non delims }
    while (SearchCount > 0) and
          ((Direction = 1) xor (BufPtr^ in WordDelimiters)) do
    begin
      Inc(BufPtr, Direction);
      Dec(SearchCount);
    end;
    while (SearchCount > 0) and
          ((Direction = -1) xor (BufPtr^ in WordDelimiters)) do
    begin
      Inc(BufPtr, Direction);
      Dec(SearchCount);
    end;
    Result := SearchCount > 0;
    if Direction = -1 then
    begin   { back up one char, to leave ptr on first non delim }
      Dec(BufPtr, Direction);
      Inc(SearchCount);
    end;
  end;
begin
  Result := nil;
  if BufLen <= 0 then Exit;
  if soDown in Options then
  begin
    Direction := 1;
    Inc(SelStart, SelLength);  { start search past end of selection }
    SearchCount := BufLen - SelStart - Length(SearchString) + 1;
    if SearchCount < 0 then Exit;
    if Longint(SelStart) + SearchCount > BufLen then Exit;
  end
  else
  begin
    Direction := -1;
    Dec(SelStart, Length(SearchString));
    SearchCount := SelStart + 1;
  end;
  if (SelStart < 0) or (SelStart > BufLen) then Exit;
  Result := @Buf[SelStart];

  { Using a Char map array is faster than calling AnsiUpper on every character }
  for C := Low(CharMap) to High(CharMap) do
    CharMap[C] := C;
  { Since CharMap is overlayed onto the ShadowMap and ShadowMap is 1 byte longer,
    we can use that extra byte as a guard NULL }
  ShadowMap[256] := #0;

  if not (soMatchCase in Options) then
  begin
{$IFDEF MSWINDOWS}
    AnsiUpperBuff(PChar(@CharMap), sizeof(CharMap));
    AnsiUpperBuff(@SearchString[1], Length(SearchString));
{$ENDIF}
{$IFDEF LINUX}
    AnsiStrUpper(@CharMap[#1]);
    SearchString := AnsiUpperCase(SearchString);
{$ENDIF}
  end;

  while SearchCount > 0 do
  begin
    if (soWholeWord in Options) and (Result <> @Buf[SelStart]) then
      if not FindNextWordStart(Result) then Break;
    I := 0;
    while (CharMap[Result[I]] = SearchString[I+1]) do
    begin
      Inc(I);
      if I >= Length(SearchString) then
      begin
        if (not (soWholeWord in Options)) or
           (SearchCount = 0) or
           (Result[I] in WordDelimiters) then
          Exit;
        Break;
      end;
    end;
    Inc(Result, Direction);
    Dec(SearchCount);
  end;
  Result := nil;
end;

procedure TToughDBGrid.SetFindInterval(const Value: Integer);
begin
  if Value <> FFindInterval then begin
    FFindInterval := Value;
    FTimer.Enabled := False;
    FTimer.Interval := FFindInterval;
    FTimer.Enabled := True;
  end;
end;

initialization
	FindDialog := TFindDialog.Create( nil);
finalization
	FindDialog.Free;
end.
