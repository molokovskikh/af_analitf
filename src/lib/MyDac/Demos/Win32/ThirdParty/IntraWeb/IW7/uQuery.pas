unit uQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uBase, IWCompLabel, IWControl, IWCompRectangle, IWHTMLControls,
  IWGrids, IWDBGrids, IWCompMemo, IWDBStdCtrls, IWCompButton, DB, MyAccess,
  MemDS, DBAccess, IWTemplateProcessorHTML,
  IWContainer, IWRegion, IWLayoutMgrHTML, IWCompCheckbox, ExtCtrls,
  IWExtCtrls, IWHTMLTag, IWVCLBaseContainer, IWHTMLContainer, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl;

type
  TfmQuery = class(TfmBase)
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    IWDBNavigator: TIWDBNavigator;
    lbResult: TIWLabel;
    btOpen: TIWButton;
    Query: TMyQuery;
    DataSource: TDataSource;
    IWRegion1: TIWRegion;
    IWRegion2: TIWRegion;
    IWDBGrid: TIWDBGrid;
    IWRectangle1: TIWRectangle;
    IWRectangle2: TIWRectangle;
    IWRegion3: TIWRegion;
    meSQL: TIWMemo;
    IWRegion4: TIWRegion;
    IWRectangle3: TIWRectangle;
    btClose: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure btOpenClick(Sender: TObject);
    procedure IWAppFormRender(Sender: TObject);
    procedure IWDBNavigatorRefresh(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
  protected
    procedure ReadFromControls; override;
  end;

var
  fmQuery: TfmQuery;

implementation

{$R *.dfm}

uses
  ServerController, IWForm;

procedure TfmQuery.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  Query.Connection := DM.Connection;
end;

procedure TfmQuery.btOpenClick(Sender: TObject);
begin
  ReadFromControls;
  Query.SQL.Text := UserSession.QuerySQL;
  IWDBGrid.Columns.Clear;
  UserSession.isGoodQuery := False;
  try
    Query.Execute;
    UserSession.isGoodQuery := True;
    if Query.Active then
      UserSession.QueryResult := 'Result'
    else
      if Query.RowsAffected >= 0 then
        UserSession.QueryResult := IntToStr(Query.RowsAffected) + ' rows affected'
      else
        UserSession.QueryResult := 'Executed';
  except
    on E:Exception do
      UserSession.QueryResult := 'Error: '+ E.Message;
  end;
end;

procedure TfmQuery.btCloseClick(Sender: TObject);
begin
  ReadFromControls;
  UserSession.isGoodQuery := False;
  try
    IWDBGrid.Columns.Clear;
    Query.Close;
    UserSession.isGoodQuery := True;
    UserSession.QueryResult := ''
  except
    on E:Exception do
      UserSession.QueryResult := 'Error: '+ E.Message;
  end;
end;

procedure TfmQuery.IWAppFormRender(Sender: TObject);
begin
  inherited;
  meSQL.Lines.Text := UserSession.QuerySQL;
  IWDBGrid.Visible := UserSession.isGoodQuery and Query.Active;
  IWDBNavigator.Enabled := IWDBGrid.Visible;
  lbResult.Font.Color := ResultColors[UserSession.IsGoodQuery];
  lbResult.Caption := UserSession.QueryResult;
end;

procedure TfmQuery.ReadFromControls;
begin
  inherited;
  UserSession.QuerySQL := meSQL.Lines.Text;
end;

procedure TfmQuery.IWDBNavigatorRefresh(Sender: TObject);
begin
  ReadFromControls;
end;

end.
