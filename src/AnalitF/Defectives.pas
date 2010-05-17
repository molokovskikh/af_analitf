unit Defectives;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DModule, DB, Grids, DBGrids, RXDBCtrl,
  Placemnt, StdCtrls, DBCtrls, ComCtrls, ActnList, FR_Class, FR_DSet,
  FR_DBSet, DateUtils, DBGridEh, ToughDBGrid, ExtCtrls,
  DBProc, GridsEh, MemDS,
  DBAccess, MyAccess;

const
	DefectSql	= 'SELECT * FROM Defectives WHERE LetterDate BETWEEN :DateFrom And :DateTo ORDER BY ';

type
  //типы сортировки информации
  TSortType = (stNone, stByArticleName, stByLetterDate, stBySerialName, stByProducer);

  TDefectivesForm = class(TChildForm)
    dsDefectives: TDataSource;
    dbtCountry: TDBText;
    dbtSeries: TDBText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    dbtLetterNumber: TDBText;
    dbtLetterDate: TDBText;
    Label4: TLabel;
    dbtLaboratory: TDBText;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    ActionList: TActionList;
    btnCheck: TButton;
    btnUnCheckAll: TButton;
    actCheck: TAction;
    dbgDefectives: TToughDBGrid;
    Panel1: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Panel2: TPanel;
    Bevel1: TBevel;
    dbmReason: TDBMemo;
    adsPrint: TMyQuery;
    adsDefectives: TMyQuery;
    procedure FormCreate(Sender: TObject);
    procedure btnUnCheckAllClick(Sender: TObject);
    procedure actCheckExecute(Sender: TObject);
    procedure dbgDefectivesGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure dtpDateCloseUp(Sender: TObject);
    procedure dbgDefectivesSortMarkingChanged(Sender: TObject);
  private
    FOrderField: string;
    PrintQuery: string;
    procedure SetDateInterval;
    procedure SetOrderField(Value: string);
  public
    //печать препаратов изъ€тых из обращени€
    procedure Print( APreview: boolean = False); override;
    property OrderField: string read FOrderField write SetOrderField;
  end;

implementation

{$R *.dfm}

uses
  Main, Constant, DBGridHelper;

procedure TDefectivesForm.FormCreate(Sender: TObject);
var
	Year, Month, Day: Word;
begin
	inherited;
  PrintEnabled := (DM.SaveGridMask and PrintDefectives) > 0;
	Year := YearOf( Date);
	Month := MonthOf( Date);
	Day := DayOf( Date);
	IncAMonth( Year, Month, Day, -3);
	dtpDateFrom.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
	dtpDateTo.Date:=Date;
	PrintQuery := adsPrint.SQL.Text;
	OrderField:='LetterDate';
  TDBGridHelper.RestoreColumnsLayout(dbgDefectives, Self.ClassName);
	ShowForm;
end;

procedure TDefectivesForm.FormDestroy(Sender: TObject);
begin
  TDBGridHelper.SaveColumnsLayout(dbgDefectives, Self.ClassName);
end;

procedure TDefectivesForm.SetDateInterval;
begin
  with adsDefectives do begin
    ParamByName('DateFrom').AsDate:=dtpDateFrom.Date;
    ParamByName('DateTo').AsDate:=dtpDateTo.Date;
    Screen.Cursor:=crHourglass;
    try
      if Active then
      begin
        Close;
        Open;
      end
      else
        Open;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TDefectivesForm.SetOrderField(Value: string);
begin
  with adsDefectives do begin
    Close;
    adsDefectives.IndexFieldNames := Value;
    SetDateInterval;
  end;
  FOrderField:=AnsiUpperCase(Trim(Value));
end;

procedure TDefectivesForm.btnUnCheckAllClick(Sender: TObject);
var
  Mark: string;
begin
  Screen.Cursor:=crHourglass;
  try
    DM.adcUpdate.SQL.Text := 'UPDATE Defectives SET CheckPrint=0 WHERE CheckPrint=1';
    DM.adcUpdate.Execute;
    with adsDefectives do begin
      Mark:=Bookmark;
      if Active then begin
        Refresh;
      end;
      Bookmark:=Mark;
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
  dbgDefectives.SetFocus;
end;

procedure TDefectivesForm.actCheckExecute(Sender: TObject);
begin
  with adsDefectives do
    if Active and ( adsDefectives.FieldByName( 'Name').AsString <> '') then begin
      Edit;
      FieldByName('CheckPrint').AsBoolean:=not FieldByName('CheckPrint').AsBoolean;
      Post;
    end;
  dbgDefectives.SetFocus;
end;

//печать препаратов изъ€тых из обращени€
procedure TDefectivesForm.Print( APreview: boolean = False);
var
  ShowAll: Boolean;
  CheckPrintCount : Integer;
begin
  //если нет ни одной пометки - печатаем все
  CheckPrintCount := DM.QueryValue('SELECT Count(*) FROM Defectives WHERE CheckPrint = 1', [], []);
  ShowAll := CheckPrintCount = 0;
  with adsPrint do begin
    SQL.Text:=PrintQuery+' ORDER BY '+OrderField;
    //ParamByName('DateFrom').DataType:=ftDate;
    //ParamByName('DateTo').DataType:=ftDate;
    //ParamByName('ShowAll').DataType:=ftBoolean;
    ParamByName('DateFrom').AsDate := adsDefectives.ParamByName('DateFrom').AsDate;
    ParamByName('DateTo').AsDate:=adsDefectives.ParamByName('DateTo').AsDate;
    ParamByName('ShowAll').Value:=ShowAll;
    Open;
    try
      DM.ShowFastReport('Defectives.frf', adsPrint, APreview);
    finally
      Close;
    end;
  end;
end;

procedure TDefectivesForm.dbgDefectivesGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if adsDefectives.FieldByName( 'CheckPrint').AsBoolean then Background := clSilver;
end;

procedure TDefectivesForm.dtpDateCloseUp(Sender: TObject);
begin
	SetDateInterval;
	dbgDefectives.SetFocus;
end;

procedure TDefectivesForm.dbgDefectivesSortMarkingChanged(Sender: TObject);
begin
  MyDacDataSetSortMarkingChanged( TToughDBGrid(Sender) );
end;

end.
