unit ExchangeDModule;

interface

uses
  SysUtils, Classes;

type
  TExchangeDM = class(TDataModule)
  private
    { Private declarations }
  public
    procedure BeforeExchange;
    procedure Connect;
    procedure SendData;
    procedure Disconnect;
    procedure AfterExchange;
    procedure Stop;
  end;

var
  ExchangeDM: TExchangeDM;

implementation

uses Exchange;

{$R *.dfm}

procedure TExchangeDM.BeforeExchange;
begin
end;

procedure TExchangeDM.Connect;
begin
end;

procedure TExchangeDM.SendData;
begin
end;

procedure TExchangeDM.Disconnect;
begin
end;

procedure TExchangeDM.AfterExchange;
begin
end;

procedure TExchangeDM.Stop;
begin
end;

end.
