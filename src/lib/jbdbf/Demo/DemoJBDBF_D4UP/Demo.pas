unit Demo;
{$I jb.inc}

// by Andrea Russo - Italy - [mailto:andrusso@yahoo.com]
interface

{$IfNDef LINUX}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  jbDbf, StdCtrls, Grids, Buttons, Menus, ExtCtrls, ComCtrls;
{$Else}
uses
  SysUtils, Classes, QForms, QGraphics, Types, QMenus, QTypes, QControls
  , QComCtrls, QStdCtrls, QButtons, QExtCtrls, QGrids, jbDbf;
{$EndIf}

const
  cProjectName : string = 'Demo JBDBF';

const
   COL_ID = 0;
   COL_NUMERIC_FIELD = 1;
   COL_TEXT_FIELD = 2;

   COUNT_DATA = 3;

type aRowData = array[0..COUNT_DATA-1] of string;

type TypePosition = record
  sCurrentRow : string;
  iLeftCol : integer;
end;

type
  TFDemo = class(TForm)
    StringGrid: TStringGrid;
    DBF: TjbDBF;
    PanelTop: TPanel;
    btnUndo: TBitBtn;
    btnExit: TBitBtn;
    btnSave: TBitBtn;
    btnDelete: TBitBtn;
    btnInsert: TBitBtn;
    btnEdit: TBitBtn;
    PanelText: TPanel;
    lblNumericField: TLabel;
    lblTextField: TLabel;
    Edit_NumericField: TEdit;
    Edit_TextField: TEdit;
    ProgressBar: TProgressBar;
    StatusBar: TStatusBar;
    MainMenu: TMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    mnuEmptyArchive: TMenuItem;
    DBF_New: TjbDBF;
    mnuPackArchive: TMenuItem;
    lblNumRows: TLabel;
    N3: TMenuItem;
    procedure StringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBFFound(Sender: TObject);
    procedure DBFQuery(Sender: TObject; const IdxName, IdxField,
      Key: ShortString; var Accept, Cancel: Boolean);
    procedure DBFProgress(Sender: TObject; const Operace: ShortString;
      Progress: Integer);
    procedure Edit_NumericFieldExit(Sender: TObject);
    procedure Edit_NumericFieldEnter(Sender: TObject);
    procedure Edit_TextFieldEnter(Sender: TObject);
    procedure Edit_TextFieldExit(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuEmptyArchiveClick(Sender: TObject);
    procedure mnuPackArchiveClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Edit_NumericFieldKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    gbFound : boolean;

    nID: Cardinal;

    procedure ClearTextData();
    Procedure LoadTextData(i: Cardinal);
    Procedure EnabledTextData(bEnabled: boolean);
    Procedure ButtonState(b: boolean);
    procedure EnableAll(b: boolean);
    procedure EnableArchiveMenu(b: boolean);
    procedure SaveData();
    Procedure ReadData(T: TStrings);
    Procedure ClearProgressBar();
    procedure RefreshIndexes(DBF: TjbDBF);
    procedure ProgressPosition(i : integer);
    function  InModify(bMsg : boolean = false): boolean;
    procedure RefreshCountLabel;
  public
    { Public declarations }
    sDBFName: string;
    gsExePath : string;

    gsTotNumRows : string;
    gsLoadingArchive : string;
    gsInsert : string;
    gsModify : string;
    gsError : string;
    gsCaptionGridFields : string;

    gMsgArchivePacked : PChar;
    gMsgOperazioneNonRiuscita : PChar;

    gsAttention : PChar;
    gMsgDeleteCurrentRow : PChar;
    gMsgErrorWhenDelete : PChar;
    gMsgDeleteArchive : PChar;
    gMsgPackArchive : PChar;
    gMsgSaveorCancelChanges : PChar;
    gMsgPackingArchive : PChar;
    gsMsgFileDBFNotValid : PChar;

    Procedure OpenArchive();
    procedure CreateArchive(sDBF: string);
  end;

var
  FDemo: TFDemo;

implementation

uses Math, PortingKylix;

Type Operation = (Edit, Insert, Delete, None);
var Op : Operation;

{$R *.dfm}

procedure OnlyNumbers(var Key : Char);
begin
  {$IFDEF VER12UP}
    if not(CharInSet(Key,['0'..'9']+[#8])) then
  {$ELSE}
    if not(Key in ['0'..'9']+[#8]) then
  {$ENDIF}

   begin
      key := #0;
   end;
end;

function ConvertCommaText(const s : string): string;
var
  sResult : string;
begin
  sResult := s;

  if Copy(sResult,1,1) = ',' then
    sResult := '" "' + sResult;

  while pos(',,',sResult)>0 do
    sResult := StringReplace(sResult,',,','," ",',[rfReplaceAll]);

  Result := sResult;
end;

procedure RepositionOnRow(var GenStrGrid: TStringGrid; const sDataRow : string);
var
 bFound : boolean;
 i : integer;
begin
 bFound := false;

 i := 1;

 with GenStrGrid do
 begin
   while (i<RowCount) and not(bFound) do
   begin
     if sDataRow = ConvertCommaText(Rows[i].CommaText) then
       bFound := true
     else
       inc(i);
   end;

   if bFound then
     Row := i;
 end;
end;

procedure ExtractPosition(StringGrid : TStringGrid; var Position : TypePosition);
begin
  Position.sCurrentRow := ConvertCommaText(StringGrid.Rows[StringGrid.Row].CommaText);
  Position.iLeftCol := StringGrid.LeftCol;
end;

procedure SetPosition(StringGrid : TStringGrid; const Position : TypePosition);
begin
  RepositionOnRow(StringGrid,Position.sCurrentRow);
  StringGrid.LeftCol := Position.iLeftCol;
end;

procedure TFDemo.ProgressPosition(i : integer);
begin
  ProgressBar.Position:=i;
  ProgressBar.Refresh;
  ProgressBar.Repaint;
end;

Procedure TFDemo.OpenArchive();
var
  i: Cardinal;
  k: Cardinal;
  nNewID: Cardinal;
  Save_Cursor:TCursor;
  W : smallint;
begin
   Statusbar.Panels.items[0].Text := '';

   ClearTextData;
   EnabledTextData(false);

   DBF.FileName:= sDBFName;
   FDemo.Caption:=cProjectName;
   Save_Cursor := Screen.Cursor;
   try
     Screen.Cursor := crHourGlass;
     Statusbar.Panels.items[0].Text := gsLoadingArchive;

     for i := 0 to StringGrid.ColCount-1 do
       StringGrid.Cols[i].Clear;

     StringGrid.Rows[0].CommaText := gsCaptionGridFields;

     StringGrid.RowCount := 2;

     if DBF.Open then
     begin
        if (DBF.Fields[1].name <> 'ID') or (DBF.Fields[3].name <> 'TEXT') then
        begin
          Application.MessageBox(PChar(Format(gsMsgFileDBFNotValid,[DBF.FileName])), gsAttention, MB_OK);
          DBF.Close;
          exit;
        end;

        // Grid layout
        with StringGrid do
        begin
          W := 6;

          ColWidths[COL_ID]:= 0; //Font.Size*dbf.FieldByName['ID'].len;

          ColWidths[COL_NUMERIC_FIELD]:=
            Font.Size*Max((dbf.FieldByName['NUMERIC'].len), length(Rows[0].strings[COL_NUMERIC_FIELD]));

          ColWidths[COL_TEXT_FIELD]:=
            Font.Size*Max(dbf.FieldByName['TEXT'].len, length(Rows[0].strings[COL_TEXT_FIELD]));

          Edit_NumericField.MaxLength := dbf.FieldByName['NUMERIC'].len;
          Edit_TextField.MaxLength := dbf.FieldByName['TEXT'].len;

          Edit_NumericField.Width := Edit_NumericField.Font.Size*Edit_NumericField.MaxLength;
          Edit_TextField.Width := Edit_TextField.Font.Size*Edit_TextField.MaxLength+W;

          Width := 30;
          for i := 0 to ColCount-1 do
          begin
            Width := Width + ColWidths[i];
            Cols[i].Clear;
          end;
          RowCount := 2;

          width := width - ColWidths[COL_TEXT_FIELD];
        end;
           //Load the grid
        DBF.GotoEnd;

        k:=1;
        for i := 1 to DBF.RecordsCount do
        begin
           nNewID := strtoint(DBF.Load('ID'));
           if nNewID>nID then
             nID := nNewID;

           if not(DBF.CurrentRecDeleted) then
           begin
             ReadData(StringGrid.Rows[k]);
             k:=k+1;
             StringGrid.RowCount := StringGrid.RowCount+1;
           end;
          DBF.GotoPrev;
        end;
        if k>1 then
        begin
          StringGrid.RowCount := StringGrid.RowCount-1;
        end;
     end;
     ButtonState(false);
     LoadTextData(1);
     FDemo.Caption:=cProjectName+' ['+ExtractFileName(sDBFName)+']';
   finally
     Screen.Cursor := Save_Cursor;
     ClearProgressBar;

     if DBF.FileIsOpen then
       begin
         RefreshIndexes(DBF);
         DBF.Close;
         ClearProgressBar;
         EnableArchiveMenu(true);
       end
     else
       begin
         EnableAll(false);
         EnableArchiveMenu(false);
       end;

     RefreshCountLabel;
  end;
  Statusbar.Panels.items[0].Text := '';
  StringGrid.Rows[0].CommaText := gsCaptionGridFields;
  if StringGrid.CanFocus then
    StringGrid.SetFocus;
end;

procedure TFDemo.StringGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
 if ARow>0 then
  LoadTextData(ARow);
end;

procedure TFDemo.FormCreate(Sender: TObject);
begin
  gsCaptionGridFields := '" ","Numeric field","Text field"';

  StringGrid.Rows[0].CommaText := gsCaptionGridFields;

  gsLoadingArchive := 'Loading the archive...';
  gsInsert := 'on insert';
  gsModify := 'on modify';
  gsError := 'Error:';

  gsAttention := 'Attention';
  gMsgDeleteCurrentRow := 'Delete the current row?';
  gMsgErrorWhenDelete := 'Error when trying to delete.';
  gMsgDeleteArchive := 'Delete the archive?';
  gMsgPackArchive := 'Pack the archive?'+#13+#10+#13+#10'This is useful only if cancellations are made.';
  gMsgSaveorCancelChanges := 'Save or cancel changes made.';
  gMsgPackingArchive := 'Packing the archive...';
  gMsgArchivePacked := 'Archive packed.';

  gsMsgFileDBFNotValid := 'Impossible to open the file %s.' +#13+#10+#13+#10 + 'The DBF structure is not valid.';
  gsTotNumRows := 'Num rows: ';
  
  StringGrid.ColCount := COUNT_DATA;

  gsExePath := ExtractFilePath(Application.ExeName);

  Constraints.MinWidth := btnExit.Left + 2*(btnExit.Width);
  Op := None;
  btnSave.Enabled:=false;
  btnUndo.Enabled:=false;
  ClearTextData;
  lblNumRows.Caption := '';
end;

procedure TFDemo.FormShow(Sender: TObject);
begin
  {$IfDef LINUX}
    SetKylixFont(FDemo);
  {$ENDIF}

  sDBFName := gsExePath + 'Test.dbf';

  if Not(FileExists(sDBFName)) then
     CreateArchive(sDBFName);

  OpenArchive;
end;

procedure TFDemo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DBF.FileIsOpen then
     DBF.Close;
end;

procedure TFDemo.EnableArchiveMenu(b: boolean);
begin
  mnuPackArchive.Enabled := b;
  mnuEmptyArchive.Enabled := b;
end;

procedure TFDemo.EnableAll(b: boolean);
begin
 StringGrid.Enabled:=b;

 btnInsert.Enabled := b;
 btnDelete.Enabled := b;
 btnEdit.Enabled := b;

 btnUndo.Enabled := b;
 btnSave.Enabled := b;
end;

Procedure TFDemo.ButtonState(b: boolean);
begin
 StringGrid.Enabled:=not(b);

 btnInsert.Enabled := not(b);

 btnDelete.Enabled := not(b);
 btnEdit.Enabled := not(b);

 if (StringGrid.RowCount<=2) and (StringGrid.Rows[1].Strings[COL_ID]='') then
 begin
   btnDelete.Enabled := false;
   btnEdit.Enabled := false;
 end;

 btnUndo.Enabled := b;
 btnSave.Enabled := b;

 EnabledTextData(b);
end;

procedure TFDemo.btnInsertClick(Sender: TObject);
begin
 Op := Insert;
 ClearTextData;
 ButtonState(true);
 Statusbar.Panels.items[0].Text := gsInsert;

 Edit_NumericField.SetFocus;
end;

procedure TFDemo.btnDeleteClick(Sender: TObject);
var
  i: Integer;
  k: Integer;
  Save_Cursor:TCursor;
  sResult: TStatusWrite;
  b: boolean;
begin

 if Application.MessageBox(gMsgDeleteCurrentRow, gsAttention, MB_YESNO) = IDNO then
    exit;

 Op := Delete;
 b:=false;

 EnableAll(b);
 btnExit.Enabled := b;

 EnabledTextData(b);
 ClearTextData;

 Save_Cursor := Screen.Cursor;
 try
 Screen.Cursor := crHourGlass;
   With DBF Do
   begin
     If Open Then
     begin
       gbFound := false;
       Find('TEST.IDX','ID');
       ClearProgressBar;
       if gbFound then
        begin
         sResult := Delete(DBF.CurrRec);
         if not(sResult in [dbfOk]) then
           begin
             Application.MessageBox(gMsgErrorWhenDelete, gsAttention, MB_OK);
           end
         else
           begin
             ClearProgressBar;
             RefreshIndexes(DBF);
             ClearProgressBar;
             k:= StringGrid.RowCount-StringGrid.Row;

             for i := StringGrid.Row to StringGrid.RowCount do
             begin
               StringGrid.Rows[i] := StringGrid.Rows[i+1];
               if k>0 then
                 ProgressBar.Position := ((100*(i-StringGrid.Row+1)) div k);
             end;
             if StringGrid.RowCount>2 then
               StringGrid.RowCount := StringGrid.RowCount-1;
             if StringGrid.Rows[StringGrid.Row].Strings[COL_ID]<>'' then
               LoadTextData(StringGrid.Row);
          end;
        end
       else
         Application.MessageBox(gMsgErrorWhenDelete, gsAttention, MB_OK);
       Close;
       ClearProgressBar;
     end;
   end;
 finally
  Screen.Cursor := Save_Cursor;
  if DBF.FileIsOpen then
    DBF.Close;

  btnExit.Enabled := true;
  ButtonState(false);

  if StringGrid.CanFocus then
    StringGrid.SetFocus;

  RefreshCountLabel;
 end;
end;

procedure TFDemo.ClearProgressBar();
begin
  ProgressPosition(0);
  Statusbar.Panels.items[0].Text :='';
end;

procedure TFDemo.btnUndoClick(Sender: TObject);
begin
 Op := None;

 if StringGrid.Row>0 then
   LoadTextData(StringGrid.Row)
 else
   ClearTextData;

 ButtonState(false);

 Statusbar.Panels.items[0].Text := '';
 StringGrid.SetFocus;
end;

procedure TFDemo.btnEditClick(Sender: TObject);
begin
 Op := Edit;
 ButtonState(true);
 Edit_NumericField.SetFocus;
 Statusbar.Panels.items[0].Text := gsModify;
end;

procedure TFDemo.btnExitClick(Sender: TObject);
begin
 Close;
end;

Procedure TFDemo.ClearTextData();
begin
  Edit_NumericField.Text := '';
  Edit_TextField.Text := '';
end;

Procedure TFDemo.LoadTextData(i: Cardinal);
begin
  with StringGrid.Rows[i] do
  begin
    Edit_NumericField.Text := trim(Strings[COL_NUMERIC_FIELD]);
    Edit_TextField.Text := trim(Strings[COL_TEXT_FIELD]);
  end;
end;

Procedure TFDemo.EnabledTextData(bEnabled: boolean);
var
 cColor : TColor;
begin
   Edit_NumericField.ReadOnly := not(bEnabled);
   Edit_TextField.ReadOnly := not(bEnabled);

   if bEnabled then
     cColor := clWindow
   else
     cColor := $02E1FFFF;

   Edit_NumericField.Color := cColor;
   Edit_TextField.Color := cColor;

   Edit_NumericField.TabStop := bEnabled;
   Edit_TextField.TabStop := bEnabled;

   Edit_NumericField.Enabled := true;
   Edit_TextField.Enabled := true;
end;

procedure TFDemo.btnSaveClick(Sender: TObject);
var
  Save_Cursor:TCursor;
  i: Cardinal;
  k: smallint;
  j: smallint;
  iPos: integer;
begin

 DBF.StoreByIndex:=true;
 Save_Cursor := Screen.Cursor;
 try
 Screen.Cursor := crHourGlass;
 case Op of
   Edit:
     begin
        With DBF Do
        begin
          If Open Then
          begin
            gbFound := false;
            Find('TEST.IDX','ID');
            ClearProgressBar;
            if gbFound then
            begin
              SaveData;

              Write(DBF.CurrRec);
              ClearProgressBar;
              ReadData(StringGrid.Rows[StringGrid.Row]);
              RefreshIndexes(DBF);
            end;
            Close;
          end;
        end;
     end;
   Insert:
    begin
       with DBF do
       begin
          If Open Then
          Begin
            nID := nID+1;

            Store('ID',ShortString(inttostr(nID)));
            ClearProgressBar;
            SaveData;

            ClearProgressBar;
            NewRecord;
            ClearProgressBar;
            if (StringGrid.RowCount>1) AND (StringGrid.Rows[1].Strings[COL_ID]<>'') then
             begin
              StringGrid.RowCount := StringGrid.RowCount+1;
              k:= StringGrid.RowCount-2;
              for i := StringGrid.RowCount downto 2 do
              begin
                 StringGrid.Rows[i] := StringGrid.Rows[i-1];
                 j:=i;
                 if k>0 then
                 begin
                   iPos:=((100*(StringGrid.RowCount-j+1)) div k);
                   if iPos>ProgressBar.Position then
                     ProgressPosition(iPos);
                 end;
              end;
              ClearProgressBar;
              ReadData(StringGrid.Rows[1]);
              RefreshIndexes(DBF);
              Close;
             end
            else
             begin
              Close;
              OpenArchive;
             end;

            StringGrid.Row := 1;
            ClearProgressBar;
            StringGrid.Enabled:=true;
        end;
       end;
    end;
   end;

   ButtonState(false);
   Op := None;
   Statusbar.Panels.items[0].Text := '';
 finally
  Screen.Cursor := Save_Cursor;
  if DBF.FileIsOpen then
    DBF.Close;
  ClearProgressBar;

  if StringGrid.CanFocus then
    StringGrid.SetFocus;

  RefreshCountLabel;
 end;
end;

procedure TFDemo.SaveData();
begin
 with DBF do
 begin
   Store('NUMERIC',ShortString(trim(Edit_NumericField.Text)));
   Store('TEXT',ShortString(Edit_TextField.Text));
 end;
end;

Procedure TFDemo.ReadData(T: TStrings);

  function LoadData(const sField : ShortString): string;
    var s : string;
  begin
    s := Trim(DBF.Load(sField));

    if s='' then
     s := ' ';

    result := s;
  end;
begin
     With T do
     begin
        Clear;
        Add(LoadData('ID'));
        Add(LoadData('NUMERIC'));
        Add(LoadData('TEXT'));
     end;
end;

procedure TFDemo.DBFFound(Sender: TObject);
begin
  if not(DBF.CurrentRecDeleted) then
    gbFound := true;
end;

procedure TFDemo.DBFQuery(Sender: TObject; const IdxName, IdxField,
  Key: ShortString; var Accept, Cancel: Boolean);
begin
  Accept := false;
  if (IdxField='ID') and (key = ShortString(StringGrid.Rows[StringGrid.Row].Strings[COL_ID])) then
    Accept:=true;
end;

procedure TFDemo.DBFProgress(Sender: TObject;
  const Operace: ShortString; Progress: Integer);
begin
  ProgressPosition(Progress);
  Statusbar.Panels.items[0].Text := String(Operace);
  Application.ProcessMessages
end;

procedure TFDemo.Edit_NumericFieldExit(Sender: TObject);
begin
   Edit_NumericField.Enabled:=true;
end;

procedure TFDemo.Edit_NumericFieldEnter(Sender: TObject);
begin
  if not(InModify) then
   Edit_NumericField.Enabled:=false;
end;

procedure TFDemo.Edit_TextFieldEnter(Sender: TObject);
begin
 if not(InModify) then
   Edit_TextField.Enabled:=false;
end;

procedure TFDemo.Edit_TextFieldExit(Sender: TObject);
begin
 Edit_TextField.Enabled := true;
end;

procedure TFDemo.mnuExitClick(Sender: TObject);
begin
 Close;
end;

procedure TFDemo.mnuEmptyArchiveClick(Sender: TObject);
begin
  if InModify(true) then
    exit;

 if Application.MessageBox(gMsgDeleteArchive, gsAttention, MB_OKCANCEL)=IDOK then
 begin
   CreateArchive(sDBFName);
   OpenArchive;
 end;
end;

procedure TFDemo.CreateArchive(sDBF: string);
Var
 sIndex : ShortString;
begin
  SysUtils.DeleteFile(sDBF);
  sIndex:='';

  with DBF_New do
  begin
    sIndex:='TEST.idx';
    SysUtils.DeleteFile(gsExePath + String(sIndex));

    MakeField(1,'ID','n',6,0,sIndex,dbfUnique,dbfDescending);
    MakeField(2,'NUMERIC','n',10,0,'',dbfDuplicates,dbfDescending);
    MakeField(3,'TEXT','c',76,0,'',dbfDuplicates,dbfDescending);

    CreateDB(sDBF,6+10+76,3);
  end;
end;

procedure TFDemo.RefreshIndexes(DBF: TjbDBF);
var
 sPath:string;
begin
  sPath:=ExtractFilePath(DBF.FileName);
  DBF.MakeIndex(sPath+'TEST.IDX','ID');
end;

procedure TFDemo.mnuPackArchiveClick(Sender: TObject);
var
  Save_Cursor:TCursor;
  sMsg : PChar;
begin
  if InModify(true) then
    exit;

 if Application.MessageBox(gMsgPackArchive, gsAttention, MB_OKCANCEL)=IDOK then
 begin
   Save_Cursor := Screen.Cursor;
   Screen.Cursor:=crHourglass;
   try
     if DBF.PackDBF then
       sMsg := gMsgArchivePacked
     else
       sMsg := gMsgOperazioneNonRiuscita;

     Application.MessageBox(sMsg,gMsgPackingArchive,MB_OK);
   finally
     Screen.Cursor := Save_Cursor;
   end;
 end;
end;

procedure TFDemo.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if InModify(true) then
    CanClose := false;
end;

function TFDemo.InModify(bMsg : boolean = false): boolean;
var bState : boolean;
begin
  bState := (Op in [Edit, Insert]);

  if bState and bMsg then
    Application.MessageBox(gMsgSaveorCancelChanges, gsAttention, MB_OK);

  result := bState;
end;

procedure TFDemo.RefreshCountLabel;
begin
  if (StringGrid.RowCount > 2) or ((StringGrid.RowCount = 2) and (StringGrid.Rows[1].Strings[COL_ID]<>'')) then
    lblNumRows.Caption := gsTotNumRows + ' ' + inttostr(StringGrid.RowCount-1)
  else
    lblNumRows.Caption := '';

  lblNumRows.Left := PanelText.Width - (lblNumRows.Width + 5);
end;

procedure TFDemo.Edit_NumericFieldKeyPress(Sender: TObject;
  var Key: Char);
begin
  OnlyNumbers(Key);
end;

end.
