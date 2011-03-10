unit MyEmbConnectionEx;

interface

uses
  SysUtils,
  MyEmbConnection;

type
  TMyEmbConnectionEx = class(TMyEmbConnection)
   protected 
    procedure DoDisconnect; override;
  end;

implementation

{ TMyEmbConnectionEx }

procedure TMyEmbConnectionEx.DoDisconnect;
begin
  inherited;
  //ќжидаем некоторое врем€, чтобы специализированна€ сборка отпустила все хендлы и отпустила папку Data/analitf
  Sleep(1500);
end;

end.
