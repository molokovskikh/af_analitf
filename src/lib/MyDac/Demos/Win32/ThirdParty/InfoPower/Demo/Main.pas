unit Main;

interface

uses
{$IFDEF LINUX}
  SysUtils, Types, Classes, QGraphics, QControls, QForms, QDialogs, QStdCtrls,
  QDBCtrls, QComCtrls, QExtCtrls, QGrids, QDBGrids, MyDacClx,
{$ELSE}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBCtrls, ExtCtrls, Grids, DBGrids, StdCtrls, ToolWin, ComCtrls, MyDacVcl,
{$ENDIF}
  MemDS, DBAccess, DB, MyAccess, MyIP, Wwdatsrc, wwSpeedButton,
  wwDBNavigator, wwclearpanel, Buttons, Wwdbigrd, Wwdbgrid;


type
  TfmMain = class(TForm)
    wwDBGrid1: TwwDBGrid;
    MyConnection1: TMyConnection;
    wwDataSource1: TwwDataSource;
    wwMyQuery: TwwMyQuery;
    wwDBGrid1IButton: TwwIButton;
    wwMyQueryDEPTNO: TIntegerField;
    wwMyQueryDNAME: TStringField;
    wwMyQueryLOC: TStringField;
    ToolBar: TPanel;
    btOpen: TButton;
    btClose: TButton;
    wwDBNavigator1: TwwDBNavigator;
    wwDBNavigator1First: TwwNavButton;
    wwDBNavigator1PriorPage: TwwNavButton;
    wwDBNavigator1Prior: TwwNavButton;
    wwDBNavigator1Next: TwwNavButton;
    wwDBNavigator1NextPage: TwwNavButton;
    wwDBNavigator1Last: TwwNavButton;
    wwDBNavigator1Insert: TwwNavButton;
    wwDBNavigator1Delete: TwwNavButton;
    wwDBNavigator1Edit: TwwNavButton;
    wwDBNavigator1Post: TwwNavButton;
    wwDBNavigator1Cancel: TwwNavButton;
    wwDBNavigator1Refresh: TwwNavButton;
    wwDBNavigator1SaveBookmark: TwwNavButton;
    wwDBNavigator1RestoreBookmark: TwwNavButton;
    procedure btOpenClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.DFM}

procedure TfmMain.btOpenClick(Sender: TObject);
begin
  wwMyQuery.Open;  
end;

procedure TfmMain.btCloseClick(Sender: TObject);
begin
  wwMyQuery.Close;
end;

end.
