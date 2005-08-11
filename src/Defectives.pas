unit Defectives;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Child, DModule, DB, ADODB, Grids, DBGrids, RXDBCtrl,
  Placemnt, StdCtrls, DBCtrls, ComCtrls, ActnList, FR_Class, FR_DSet,
  FR_DBSet, DateUtils, AdoInt, DBGridEh, ToughDBGrid, Registry, ExtCtrls,
  FIBDataSet, pFIBDataSet, FIBQuery, pFIBQuery;

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
    dbtReason: TDBText;
    dtpDateFrom: TDateTimePicker;
    dtpDateTo: TDateTimePicker;
    ActionList: TActionList;
    btnCheck: TButton;
    btnUnCheckAll: TButton;
    adcUncheckAll2: TADOCommand;
    actCheck: TAction;
    frdsPrint: TfrDBDataSet;
    adsPrint2: TADODataSet;
    adsDefectives2: TADODataSet;
    dbgDefectives: TToughDBGrid;
    Panel1: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Panel2: TPanel;
    Bevel1: TBevel;
    adsDefectives: TpFIBDataSet;
    adsPrint: TpFIBDataSet;
    adcUncheckAll: TpFIBQuery;
    procedure FormCreate(Sender: TObject);
    procedure btnUnCheckAllClick(Sender: TObject);
    procedure actCheckExecute(Sender: TObject);
    procedure adsDefectives2AfterOpen(DataSet: TDataSet);
    procedure dbgDefectivesGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormDestroy(Sender: TObject);
    procedure dbgDefectivesSortChange(Sender: TObject; SQLOrderBy: String);
    procedure dtpDateCloseUp(Sender: TObject);
  private
    FOrderField: string;
    BaseQuery, PrintQuery: string;
    procedure SetDateInterval;
    procedure SetOrderField(Value: string);
  public
    //печать препаратов изъ€тых из обращени€
    procedure Print( APreview: boolean = False); override;
    property OrderField: string read FOrderField write SetOrderField;
  end;

var
  DefectivesForm: TDefectivesForm;

implementation

{$R *.dfm}

uses
  Main;

procedure TDefectivesForm.FormCreate(Sender: TObject);
var
	Reg: TRegistry;
	Year, Month, Day: Word;
begin
	inherited;
	PrintEnabled:=True;
	Year := YearOf( Date);
	Month := MonthOf( Date);
	Day := DayOf( Date);
	IncAMonth( Year, Month, Day, -3);
	dtpDateFrom.Date := StartOfTheMonth( EncodeDate( Year, Month, Day));
	dtpDateTo.Date:=Date;
	BaseQuery:=adsDefectives.SelectSQL.Text;
	PrintQuery:=adsPrint.SelectSQL.Text;
	OrderField:='LetterDate';
	Reg := TRegistry.Create;
	if Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, False) then dbgDefectives.LoadFromRegistry( Reg);
	Reg.Free;
//	txtTablesUpdates.Caption:=DM.GetTablesUpdatesInfo('DefectiveArticles');
	ShowForm;
end;

procedure TDefectivesForm.FormDestroy(Sender: TObject);
var
	Reg: TRegistry;
begin
	Reg := TRegistry.Create;
	Reg.OpenKey( 'Software\Inforoom\AnalitF\' + IntToHex( GetCopyID, 8) + '\'
		+ Self.ClassName, True);
	dbgDefectives.SaveToRegistry( Reg);
	Reg.Free;
end;

procedure TDefectivesForm.SetDateInterval;
begin
  with adsDefectives do begin
    ParamByName('DateFrom').AsDate:=dtpDateFrom.Date;
    ParamByName('DateTo').AsDate:=dtpDateTo.Date;
    Screen.Cursor:=crHourglass;
    try
      if Active then CloseOpen(True) else Open;
    finally
      Screen.Cursor:=crDefault;
    end;
  end;
end;

procedure TDefectivesForm.SetOrderField(Value: string);
begin
  with adsDefectives do begin
    Close;
    SelectSQL.Text:=BaseQuery+' ORDER BY '+Value;
    //ParamByName('DateFrom').DataType:=ftDate;
    //ParamByName('DateTo').DataType:=ftDate;
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
    adcUncheckAll.ExecQuery;
    with adsDefectives do begin
      Mark:=Bookmark;
      if Active then CloseOpen(True);
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
begin
  //если нет ни одной пометки - печатаем все
  with DM.adsSelect do begin
    SelectSQL.Text:='SELECT Count(*) FROM Defectives WHERE CheckPrint = 1';
    Open;
    try
      ShowAll:=Fields[0].AsInteger=0;
    finally
      Close;
    end;
  end;
  with adsPrint do begin
    SelectSQL.Text:=PrintQuery+' ORDER BY '+OrderField;
    //ParamByName('DateFrom').DataType:=ftDate;
    //ParamByName('DateTo').DataType:=ftDate;
    //ParamByName('ShowAll').DataType:=ftBoolean;
    ParamByName('DateFrom').AsDate := adsDefectives.ParamByName('DateFrom').AsDate;
    ParamByName('DateTo').AsDate:=adsDefectives.ParamByName('DateTo').AsDate;
    ParamByName('ShowAll').Value:=ShowAll;
    Open;
    try
      DM.ShowFastReport('Defectives.frf', nil, APreview);
    finally
      Close;
    end;
  end;
end;

procedure TDefectivesForm.adsDefectives2AfterOpen(DataSet: TDataSet);
begin
//	adsDefectives.Properties['Update Criteria'].Value:=adCriteriaKey;
end;

procedure TDefectivesForm.dbgDefectivesGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if adsDefectives.FieldByName( 'CheckPrint').AsBoolean then Background := clSilver;
end;

procedure TDefectivesForm.dbgDefectivesSortChange(Sender: TObject;
  SQLOrderBy: String);
begin
	adsDefectives.DisableControls;
	Screen.Cursor := crHourglass;
	try
		adsDefectives.Close;
		adsDefectives.SelectSQL.Text := DefectSql + SQLOrderBy;
		OrderField := SQLOrderBy;
//		adsDefectives.ParamByName( 'DateFrom').DataType := ftDate;
//		adsDefectives.ParamByName( 'DateTo').DataType := ftDate;
    adsDefectives.ParamByName( 'DateFrom').AsDate := dtpDateFrom.Date;
		adsDefectives.ParamByName( 'DateTo').AsDate := dtpDateTo.Date;
		adsDefectives.Open;
	finally
		adsDefectives.EnableControls;
		Screen.Cursor := crDefault;
	end;
end;

procedure TDefectivesForm.dtpDateCloseUp(Sender: TObject);
begin
	SetDateInterval;
	dbgDefectives.SetFocus;
end;

end.
