unit Normatives;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, DBCtrls, ComCtrls, Child,
  Normative, RXDBCtrl, ADBGrid;

type
  EDocumentNotFound = class(Exception);

  TNormativesForm = class(TChildForm)
    dbgNormatives: TADBGrid;
    dsNormatives: TDataSource;
    dbreTitle: TDBRichEdit;
    adsNormatives: TADODataSet;
    cbPartitions: TComboBox;
    Label1: TLabel;
    adsNormativesId: TIntegerField;
    adsNormativesPartition: TWideStringField;
    adsNormativesName: TWideStringField;
    adsNormativesUpdated: TBooleanField;
    adsNormativesFileName: TWideStringField;
    adsNormativesTitle: TMemoField;
    adsNormativesDate: TDateTimeField;
    Label2: TLabel;
    lblRecordCount: TLabel;
    txtTablesUpdates: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure cbPartitionsClick(Sender: TObject);
    procedure dbgNormativesCanFocusNext(Sender: TObject; Next: Boolean;
      var CanFocus: Boolean);
  private
    { Private declarations }
  public
  end;

var
  NormativesForm: TNormativesForm;

implementation

uses
  Main, AProc, DModule;

{$R *.dfm}

procedure TNormativesForm.FormCreate(Sender: TObject);
begin
  inherited;
  //формируем список разделов
  with DM.adsSelect do begin
    CommandText:='SELECT DISTINCT Partition FROM Normatives ORDER BY 1';
    Open;
    try
      while not Eof do begin
        if Fields[0].AsString='' then
          cbPartitions.Items.Add(' ') //проблема спустой строкой
        else
          cbPartitions.Items.Add(Fields[0].AsString);
        Next;
      end;
    finally
      Close;
    end;
  end;
  NormativeForm:=TNormativeForm.Create(Application);
  cbPartitionsClick(nil);
  txtTablesUpdates.Caption:=DM.GetTablesUpdatesInfo('Normatives');
  ShowForm;
end;

procedure TNormativesForm.cbPartitionsClick(Sender: TObject);
begin
  with adsNormatives do begin
    Parameters.ParamByName('ShowAll').Value:=cbPartitions.ItemIndex=0;
    Parameters.ParamByName('APartition').Value:=Trim(cbPartitions.Text);
    Screen.Cursor:=crHourglass;
    try
      if Active then Requery else Open;
    finally
      Screen.Cursor:=crDefault;
    end;
    lblRecordCount.Caption:=Format('Документов: %d',[RecordCount]);
  end;
  if dbgNormatives.CanFocus then dbgNormatives.SetFocus;
end;

procedure TNormativesForm.dbgNormativesCanFocusNext(Sender: TObject;
  Next: Boolean; var CanFocus: Boolean);
begin
  if Next then NormativeForm.ShowForm(adsNormativesFileName.AsString);
end;

end.
