unit Data;

interface

uses
  Windows, Messages, SysUtils, Classes, ComServ, ComObj, VCLCom, DataBkr,
  DBClient, Server_TLB, StdVcl, Db, MemDS,   Provider,
  DBTables, DBAccess, MyAccess, Dialogs, MyDacVcl;

type
  TDatas = class(TRemoteDataModule, IDatas)
    MyConnection: TMyConnection;
    Query: TMyQuery;
    DataSetProvider: TDataSetProvider;
    MyConnectDialog: TMyConnectDialog;
    MyDataSetProvider: TDataSetProvider;
    procedure DatasCreate(Sender: TObject);
    procedure DatasDestroy(Sender: TObject);
    procedure ConnectionChange(Sender: TObject);
  private
    { Private declarations }
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
  public
    { Public declarations }
  end;

var
  Datas: TDatas;

implementation

uses ServerForm;

var
  CountConnection: integer;

{$R *.DFM}

class procedure TDatas.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
begin
  if Register then
  begin
    inherited UpdateRegistry(Register, ClassID, ProgID);
    EnableSocketTransport(ClassID);
    EnableWebTransport(ClassID);
  end else
  begin
    DisableSocketTransport(ClassID);
    DisableWebTransport(ClassID);
    inherited UpdateRegistry(Register, ClassID, ProgID);
  end;
end;

procedure TDatas.DatasCreate(Sender: TObject);
var
  St: string;
begin
  if not Assigned(Datas) then begin
    Datas := TDatas(Sender);
    St := Query.SQL.Text;

    fmServer.meSQL.Lines.Text := St;
    fmServer.cbDebug.Checked := Query.Debug;
    fmServer.DataSource.DataSet := Query;
    fmServer.rbDSResolve.Checked := MyDataSetProvider.ResolveToDataset;
    fmServer.rbSQLResolve.Checked := not MyDataSetProvider.ResolveToDataset;
  end;

  Inc(CountConnection);
  fmServer.StatusBar.Panels[0].Text := 'Connections count  ' + IntToStr(CountConnection);
end;

procedure TDatas.DatasDestroy(Sender: TObject);
begin
  if Datas = TDatas(Sender) then begin
    if Assigned(fmServer) and Assigned(fmServer.DataSource) then
      fmServer.DataSource.DataSet := nil;
    Datas := nil;
  end;

  Dec(CountConnection);
  if Assigned(fmServer) and Assigned(fmServer.StatusBar) then
    fmServer.StatusBar.Panels[0].Text := 'Connections count ' + IntToStr(CountConnection);
end;

procedure TDatas.ConnectionChange(Sender: TObject);
begin
  if (Sender as TCustomDAConnection).Connected then
    Inc(CountConnection)
  else
    Dec(CountConnection);
  if Assigned(fmServer) then
    fmServer.StatusBar.Panels[0].Text := 'Connections count ' + IntToStr(CountConnection);
end;

initialization
  TComponentFactory.Create(ComServer, TDatas,
    Class_Datas, ciMultiInstance{, tmApartment});
end.

