unit Recalc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Variants, ExtCtrls, ComCtrls, ADODB, ADOInt, DB;

type
  TRecalcForm = class(TForm)
    ProgressBar: TProgressBar;
    Timer: TTimer;
    adsPrices: TADODataSet;
    adcUpdate: TADOCommand;
    adsForms: TADODataSet;
    adtPrices: TADOTable;
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure adtPricesAfterOpen(DataSet: TDataSet);
  private
    Mode: Integer;
    DoStop: Boolean;
    RecNumber, RecCount: Integer;
    ExceptionMessage: string;
    procedure RecalcPrices;
    procedure FillForms;
  public
    { Public declarations }
  end;

procedure DoRecalc(AMode: Integer);

implementation

uses AProc, DModule, DBProc;

{$R *.DFM}

//пересчет необходимых данных для программы:
//0 - все
//1 - пересчет минимальных цен
//2 - добавление форм выпуска в справочник товаров в качестве заголовков групп
procedure DoRecalc(AMode: Integer);
begin
  with TRecalcForm.Create(Application) do try
    Mode:=AMode;
    Timer.Enabled:=True;
    ShowModal;
    if ExceptionMessage<>'' then raise Exception.Create(ExceptionMessage);
  finally
    Free;
  end;
end;

procedure TRecalcForm.TimerTimer(Sender: TObject);
begin
  Timer.Enabled:=False;
  Screen.Cursor:=crHourGlass;
  try
    try
      if Mode in [0,1] then RecalcPrices;
      if Mode in [0,2] then FillForms;
    except
      on E: Exception do ExceptionMessage:=E.Message;
    end;
  finally
    Close;
    Screen.Cursor:=crDefault;
  end;
end;

//пересчитывает цены с наценкой, минимальные цены и лидеров
procedure TRecalcForm.RecalcPrices;
var
  FormId, LeaderId, FormLength, I: Integer;
  PriceFor, PriceMin: Double;
begin
  Caption:='Пересчет цен';
  //вычисляем цены с учетом наценки/скидки поставщика
  with DM.adcUpdate do begin
    CommandText:='EXECUTE PricesSetPriceFor';
    //Execute;
  end;
  //вычисляем минимальные цены и лидера по форме выпуска
  with adtPrices do begin
    FormId:=0; PriceMin:=0; FormLength:=0; LeaderId:=0;
    Open;
    while not Eof do begin
      ProgressBar.Position:=Round(RecNo/RecordCount*100);
      Application.ProcessMessages;
      if DoStop then Break;
      adcUpdate.Parameters.ParamByName('APriceMin').Value:=0;
      adcUpdate.Parameters.ParamByName('ALeaderId').Value:=0;
      adcUpdate.Parameters.ParamByName('ClientId').Value:=FieldByName('ClientsId').Value;
      adcUpdate.Parameters.ParamByName('WareId').Value:=FieldByName('WaresId').Value;
      adcUpdate.Execute;
      Next;
      Continue;
      //если сменилась форма
      if FormId<>FieldByName('FormsId').AsInteger then begin
        //если это не первая группа
        if FormId>0 then begin
          MoveBy(-FormLength);
          for I:=1 to FormLength do begin
            Edit;
            {FieldByName('S1').Value:=DM.hdsS1.LookUp('ID',
              hdsWares.FieldByName('S1_ID').Value,'NAME');
            if Trim(hdsWares.FieldByName('S1').AsString)='' then
              hdsWares.FieldByName('S1').AsString:=
                VarToStr(DM.hdsNames.LookUp('ID',hdsWares.FieldByName('NAMES_ID').Value,'NAME'))+' '+
                VarToStr(DM.hdsForms.LookUp('ID',hdsWares.FieldByName('FORMS_ID').Value,'NAME'));
            PriceNew:=FieldByName('PRICE').AsFloat*
              (1+VarToFloat(DM.hdsFirms.Lookup('ID',FieldByName('FIRMS_ID').Value,'FORCOUNT'))/100);
            hdsWares.FieldByName('PRICE_FOR').AsFloat:=PriceNew;}
            FieldByName('PriceMin').AsFloat:=PriceMin;
            FieldByName('LeaderId').AsInteger:=LeaderId;
            Post;
            Next;
          end;
        end;
        FormId:=FieldByName('FormsId').AsInteger;
        FormLength:=0;
        PriceMin:=0; LeaderId:=0;
      end;
      Inc(FormLength);
      PriceFor:=FieldByName('PriceFor').AsFloat;
      if (PriceMin>PriceFor)and(PriceFor>0) then begin
        PriceMin:=PriceFor;
        LeaderId:=FieldByName('FirmsId').AsInteger;
      end;
      Next;
    end;
    Close;
  end;
end;

//пишет в WARES формы выпуска из FORMS в качестве заголовков
procedure TRecalcForm.FillForms;
var
  AFound: Boolean;
  FormId: Integer;
begin
  Caption:='Заполнение форм выпуска';
  {RecNumber:=0;
  with DM.hdsForms do begin
    Open;
    RecCount:=RecordCount;
    DM.hdsWares.Open;
    try
      while not Eof do begin
        Inc(RecNumber);
        ProgressBar.Position:=Round(RecNumber/RecCount*100);
        Application.ProcessMessages;
        if DoStop then Break;
        if DM.hdsWares.Find(FieldByName('ID').AsString,True,True) then begin
          AFound:=False;
          FormId:=FieldByName('ID').AsInteger;
          while (not DM.hdsWares.Eof)and(DM.hdsWares.FieldByName('FORMS_ID').AsInteger=FormId) do begin
            if DM.hdsWares.FieldByName('FIRMS_ID').AsInteger=0 then begin
              AFound:=True;
              Break;
            end;
            DM.hdsWares.Next;
          end;
          if not AFound then begin
            DM.hdsWares.Append;
            DM.hdsWares.FieldByName('NAMES_ID').AsInteger:=FieldByName('NAMES_ID').AsInteger;
            DM.hdsWares.FieldByName('FORMS_ID').AsInteger:=FieldByName('ID').AsInteger;
            DM.hdsWares.FieldByName('S1').AsString:=FieldByName('NAME').AsString;
            DM.hdsWares.Post;
          end;
        end;
        Next;
      end;
    finally
      Close;
      DM.hdsWares.Close;
    end;
  end;}
end;

procedure TRecalcForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift=[ssCtrl])and(Key=Ord('C')) then DoStop:=True;
end;

procedure TRecalcForm.adtPricesAfterOpen(DataSet: TDataSet);
begin
  adtPrices.Properties['Update Criteria'].Value:=adCriteriaKey;
end;

end.
