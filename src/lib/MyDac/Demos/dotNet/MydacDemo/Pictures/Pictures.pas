{$I DacDemo.inc}

unit Pictures;

interface

uses
  SysUtils,
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFDEF KYLIX}
  Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, QButtons,
{$ELSE}
  Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ComCtrls, ExtDlgs, Buttons,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DBAccess, MyAccess, DB, {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF}, 
  DemoFrame, MyScript, DAScript;

type
  TPicturesFrame = class(TDemoFrame)
    DBGrid: TDBGrid;
    ToolBar: TPanel;
    ToolBar1: TPanel;
    Splitter1: TSplitter;
    ScrollBox1: TScrollBox;
    DBImage: TDBImage;
    Panel1: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    DBNavigator: TDBNavigator;
    Panel2: TPanel;
    Panel3: TPanel;
    btClear: TSpeedButton;
    btSave: TSpeedButton;
    btLoad: TSpeedButton;
    dsPictures: TDataSource;
    quPictures: TMyQuery;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btClearClick(Sender: TObject);
    procedure dsPicturesStateChange(Sender: TObject);
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

procedure TPicturesFrame.btOpenClick(Sender: TObject);
begin
  quPictures.Open;
  SetControlsState;
end;

procedure TPicturesFrame.btCloseClick(Sender: TObject);
begin
  quPictures.Close;
end;

procedure TPicturesFrame.SetControlsState;
begin
  btLoad.Enabled := quPictures.Active;
  btSave.Enabled := quPictures.Active;
  btClear.Enabled := quPictures.Active;
end;

procedure TPicturesFrame.btLoadClick(Sender: TObject);
var
  BlobField: TBlobField;
begin
{$IFNDEF LINUX}
  with TOpenPictureDialog.Create(nil) do
{$ELSE}
  with TOpenDialog.Create(nil) do
{$ENDIF}
    try
      InitialDir := '.\Pictures';
      if Execute then begin
        if quPictures.State in [dsBrowse] then
          quPictures.Edit;
        BlobField := quPictures.FieldByName('Picture') as TBlobField;
        BlobField.LoadFromFile(FileName);
      end;
    finally
      Free;
    end;
end;

procedure TPicturesFrame.btSaveClick(Sender: TObject);
begin
{$IFNDEF LINUX}
  with TSavePictureDialog.Create(nil) do
{$ELSE}
  with TSaveDialog.Create(nil) do
{$ENDIF}
    try
      InitialDir := '.';    
      if Execute then begin
    TBlobField(quPictures.FieldByName('Picture')).
          SaveToFile(FileName);
      end;
    finally
      Free;
  end;
end;

procedure TPicturesFrame.btClearClick(Sender: TObject);
begin
  if quPictures.State in [dsBrowse] then
    quPictures.Edit;
  TBlobField(quPictures.FieldByName('Picture')).Clear;
end;

procedure TPicturesFrame.dsPicturesStateChange(Sender: TObject);
begin
  inherited;
  SetControlsState;
end;

// Demo management
procedure TPicturesFrame.SetDebug(Value: boolean);
begin
  quPictures.Debug:= Value;
end;

procedure TPicturesFrame.Initialize;
begin
  quPictures.Connection:= Connection as TCustomMyConnection;
  SetControlsState
end;

{$IFDEF FPC}
initialization
  {$i Pictures.lrs}
{$ENDIF}

end.



