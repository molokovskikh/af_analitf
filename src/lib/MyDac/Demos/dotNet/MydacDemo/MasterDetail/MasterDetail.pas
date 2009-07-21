{$I DacDemo.inc}

unit MasterDetail;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, Buttons, MyDacVcl,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, QButtons, MyDacClx,
{$ENDIF}
{$IFNDEF VER130} { Delphi 6 or higher }
  Variants,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DAScript, DBAccess, MyAccess, DB, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  DemoFrame, MyScript;

type
  TMasterDetailFrame = class(TDemoFrame)
    quMaster: TMyQuery;
    DBGrid: TDBGrid;
    ToolBar: TPanel;
    Splitter1: TSplitter;
    ToolBar1: TPanel;
    DBGrid1: TDBGrid;
    quDetail: TMyQuery;
    dsDetail: TDataSource;
    dsMaster: TDataSource;
    Panel1: TPanel;
    DBNavigator: TDBNavigator;
    btClose: TSpeedButton;
    btOpen: TSpeedButton;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    Panel4: TPanel;
    cbLocalMasterDetail: TCheckBox;
    Panel3: TPanel;
    Panel5: TPanel;
    rbSQL: TRadioButton;
    rbSimpleFields: TRadioButton;
    rbCalcFields: TRadioButton;
    quMasterDEPTNO: TIntegerField;
    quMasterDNAME: TStringField;
    quMasterLOC: TStringField;
    Panel6: TPanel;
    Panel7: TPanel;
    cbCacheCalcFields: TCheckBox;
    quMasterDEPTNO_CALCULATE: TIntegerField;
    quDetailEMPNO: TIntegerField;
    quDetailENAME: TStringField;
    quDetailJOB: TStringField;
    quDetailMGR: TIntegerField;
    quDetailHIREDATE: TDateTimeField;
    quDetailSAL: TFloatField;
    quDetailCOMM: TFloatField;
    quDetailDEPTNO: TIntegerField;
    quDetailDEPTNO_CALCULATED: TIntegerField;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure cbLocalMasterDetailClick(Sender: TObject);
    procedure rbClick(Sender: TObject);
    procedure cbCacheCalcFieldsClick(Sender: TObject);
    procedure quCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    // Demo management
    procedure Initialize; override;
    procedure SetDebug(Value: boolean); override;
  end;

implementation

{$IFNDEF FPC}
{$IFDEF CLR}
{$R *.nfm}
{$ENDIF}
{$IFDEF WIN32}
{$R *.dfm}
{$ENDIF}
{$IFDEF LINUX}
{$R *.xfm}
{$ENDIF}
{$ENDIF}

procedure TMasterDetailFrame.btOpenClick(Sender: TObject);
begin
  quMaster.Open;
  quDetail.Open;
end;

procedure TMasterDetailFrame.btCloseClick(Sender: TObject);
begin
  quDetail.Close;
  quMaster.Close;
end;

procedure TMasterDetailFrame.cbLocalMasterDetailClick(Sender: TObject);
var
  OldActive: boolean;
begin
  OldActive := quDetail.Active;
  quDetail.Close;
  try
    quDetail.Options.LocalMasterDetail := cbLocalMasterDetail.Checked;
    if OldActive then
      quDetail.Open;
  except
    cbLocalMasterDetail.Checked := quDetail.Options.LocalMasterDetail;
    raise;
  end;
end;

procedure TMasterDetailFrame.rbClick(Sender: TObject);
var
  OldActive: boolean;
begin
  OldActive := dsMaster.DataSet.Active;
  if OldActive then
    btCloseClick(nil);
  cbCacheCalcFields.Enabled := Sender = rbCalcFields;

  if rbSQL.Checked then begin
    quDetail.SQL.Text := 'SELECT * FROM EMP WHERE DEPTNO = :DEPTNO';
    quDetail.DetailFields := '';
    quDetail.MasterFields := '';
    quMaster.FieldByName('DEPTNO_CALCULATED').Visible := False;
    quDetail.FieldByName('DEPTNO_CALCULATED').Visible := False;
    cbLocalMasterDetail.Checked := False;
    cbLocalMasterDetail.Enabled := False;
    cbCacheCalcFields.Enabled := False;
  end
  else
    if rbSimpleFields.Checked then begin
      quDetail.SQL.Text := 'SELECT * FROM EMP';
      quDetail.DetailFields := 'DEPTNO';
      quDetail.MasterFields := 'DEPTNO';
      quMaster.FieldByName('DEPTNO_CALCULATED').Visible := False;
      quDetail.FieldByName('DEPTNO_CALCULATED').Visible := False;
      cbLocalMasterDetail.Enabled := True;
      cbCacheCalcFields.Enabled := False;
    end
    else
      if rbCalcFields.Checked then begin
        quDetail.SQL.Text := 'SELECT * FROM EMP';
        quDetail.DetailFields := 'DEPTNO_CALCULATED';
        quDetail.MasterFields := 'DEPTNO_CALCULATED';
        quMaster.FieldByName('DEPTNO_CALCULATED').Visible := True;
        quDetail.FieldByName('DEPTNO_CALCULATED').Visible := True;
        cbLocalMasterDetail.Enabled := True;
        cbLocalMasterDetail.Checked := True;
        cbCacheCalcFields.Enabled := True;
      end;
  cbCacheCalcFieldsClick(nil);
  if OldActive then
    btOpenClick(nil);
end;

procedure TMasterDetailFrame.cbCacheCalcFieldsClick(Sender: TObject);
var
  OldActive: boolean;
begin
  OldActive := dsMaster.DataSet.Active;
  if OldActive then
    btCloseClick(nil);
  quMaster.Options.CacheCalcFields := cbCacheCalcFields.Checked and cbCacheCalcFields.Enabled;
  quDetail.Options.CacheCalcFields := quMaster.Options.CacheCalcFields;
  if OldActive then
    btOpenClick(nil);
end;

procedure TMasterDetailFrame.quCalcFields(DataSet: TDataSet);
var
  Dst, Src: TField;
begin
  Src := DataSet.FieldByName('DEPTNO');
  Dst := DataSet.FieldByName('DEPTNO_CALCULATED');
  if Src.IsNull then
    Dst.Value := Null
  else
    Dst.AsInteger := Src.AsInteger * 2;
end;

// Demo management
procedure TMasterDetailFrame.Initialize;
begin
  quMaster.Connection:= Connection as TCustomMyConnection;
  quDetail.Connection:= Connection as TCustomMyConnection;
  rbClick(nil);
end;

procedure TMasterDetailFrame.SetDebug(Value: boolean);
begin
  quMaster.Debug:= Value;
  quDetail.Debug:= Value;
end;

{$IFDEF FPC}
initialization
  {$i MasterDetail.lrs}
{$ENDIF}

end.

