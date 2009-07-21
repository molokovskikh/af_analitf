{$I DacDemo.inc}

unit Text;

interface

uses
  Classes, SysUtils, DB,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFDEF KYLIX}
  Types, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, MyDacClx, QButtons,
{$ELSE}
  Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MyDacVcl, Buttons,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DBAccess, MyAccess, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  DemoFrame, MyScript, DAScript;

type
  TTextFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    DataSource: TDataSource;
    ToolBar: TPanel;
    meComments: TDBMemo;
    Query: TMyQuery;
    Splitter1: TSplitter;
    ToolBar1: TPanel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel8: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    DBNavigator: TDBNavigator;
    btLoad: TSpeedButton;
    btSave: TSpeedButton;
    btClear: TSpeedButton;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure DataSourceStateChange(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetControlsState;

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

procedure TTextFrame.SetControlsState;
begin
  btLoad.Enabled := Query.Active;
  btSave.Enabled := Query.Active;
  btClear.Enabled := Query.Active;
end;

procedure TTextFrame.btOpenClick(Sender: TObject);
begin
  Query.Open;
end;

procedure TTextFrame.btCloseClick(Sender: TObject);
begin
  Query.Close;
end;

procedure TTextFrame.btLoadClick(Sender: TObject);
begin
  if Query.Active and OpenDialog.Execute then begin
    if Query.State = dsBrowse then
      Query.Edit;

    TBlobField(Query.FieldByName('TextField')).LoadFromFile(OpenDialog.FileName);
  end;
end;

procedure TTextFrame.btSaveClick(Sender: TObject);
begin
  if not Query.EOF and SaveDialog.Execute then
    TBlobField(Query.FieldByName('TextField')).SaveToFile(SaveDialog.FileName);
end;

procedure TTextFrame.btClearClick(Sender: TObject);
begin
  if Query.Active then begin
    if Query.State = dsBrowse then
      Query.Edit;
    Query.FieldByName('TextField').Clear;
  end;
end;

procedure TTextFrame.DataSourceStateChange(Sender: TObject);
begin
  inherited;
  SetControlsState;
end;

// Demo management
procedure TTextFrame.Initialize;
begin
  Query.Connection := Connection as TCustomMyConnection;
  SetControlsState
end;

procedure TTextFrame.SetDebug(Value: boolean);
begin
  Query.Debug := Value;
end;

{$IFDEF FPC}
initialization
  {$i Text.lrs}
{$ENDIF}

end.
