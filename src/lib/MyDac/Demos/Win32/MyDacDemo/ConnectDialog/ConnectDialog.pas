{$I DacDemo.inc}

unit ConnectDialog;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, Messages,
{$ENDIF}
{$IFNDEF KYLIX}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MyDacVcl,
  Buttons,
{$ELSE}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, MyDacClx, QButtons,
{$ENDIF}
{$IFDEF FPC}
  LResources,
{$ENDIF}
  DBAccess, MyAccess, InheritedConnectForm, MyConnectForm, DemoFrame, DB, 
  {$IFDEF FPC}MemDataSet{$ELSE}MemDS{$ENDIF};

type

  { TConnectDialogFrame }

  TConnectDialogFrame = class(TDemoFrame)
    DataSource: TDataSource;
    MyQuery: TMyQuery;
    DBGrid: TDBGrid;
    ToolBar: TPanel;
    Panel1: TPanel;
    btOpen: TSpeedButton;
    btClose: TSpeedButton;
    DBNavigator: TDBNavigator;
    Panel3: TPanel;
    rbInherited: TRadioButton;
    rbMy: TRadioButton;
    rbDefault: TRadioButton;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure rbDefaultClick(Sender: TObject);
    procedure rbMyClick(Sender: TObject);
    procedure rbInheritedClick(Sender: TObject);
  private
    { Private declarations }
  public
    destructor Destroy; override;
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

destructor TConnectDialogFrame.Destroy;
begin
  MyQuery.Connection.ConnectDialog.DialogClass := '';
  inherited;
end;


procedure TConnectDialogFrame.btOpenClick(Sender: TObject);
begin
  MyQuery.Open;
end;

procedure TConnectDialogFrame.btCloseClick(Sender: TObject);
begin
  MyQuery.Close;
end;

procedure TConnectDialogFrame.rbDefaultClick(Sender: TObject);
begin
  MyQuery.Connection.ConnectDialog.DialogClass := '';
end;

procedure TConnectDialogFrame.rbMyClick(Sender: TObject);
begin                                                         
  MyQuery.Connection.ConnectDialog.DialogClass := 'TfmCustomConnect';
end;

procedure TConnectDialogFrame.rbInheritedClick(Sender: TObject);
begin
  MyQuery.Connection.ConnectDialog.DialogClass := 'TfmInheritedConnect';
end;

// Demo management
procedure TConnectDialogFrame.Initialize;
begin
  inherited;
  MyQuery.Connection := Connection as TMyConnection;
end;

procedure TConnectDialogFrame.SetDebug(Value: boolean);
begin
  MyQuery.Debug:= Value;
end;

{$IFDEF FPC}
initialization
  {$i ConnectDialog.lrs}
{$ENDIF}

end.

