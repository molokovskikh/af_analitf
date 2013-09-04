unit U_frameRejectedPosition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, ExtCtrls, DB, MemDS, DBAccess, MyAccess,
  DModule;

type
  TframeRejectedPosition = class(TFrame)
    pMain: TPanel;
    dbtLetterDate: TDBText;
    dbtSeries: TDBText;
    dbtLetterNumber: TDBText;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    dbmReason: TDBMemo;
    Label1: TLabel;
    dsDefectives: TDataSource;
    adsDefectives: TMyQuery;
    Label5: TLabel;
    dbtName: TDBText;
    Label6: TLabel;
    dbtProducer: TDBText;
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
    // На ком будет рисоваться панель
    FSingleParent: TWinControl;
    //Какой контрол будет в фокусе
    FFocusedControl: TWinControl;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    class function AddFrame(
      Owner: TComponent;
      SingleParent: TWinControl;
      FocusedControl: TWinControl) : TframeRejectedPosition;
    procedure HideReject();
    procedure ShowReject(rejectId : Int64);
  end;

implementation

{$R *.dfm}

{ TframeRejectedPosition }

class function TframeRejectedPosition.AddFrame(Owner: TComponent;
  SingleParent, FocusedControl: TWinControl): TframeRejectedPosition;
begin
  Result := TframeRejectedPosition.Create(Owner);
  Result.Visible := False;
  Result.Name := 'frameRejectedPosition';
  Result.FSingleParent := SingleParent;
  Result.FFocusedControl := FocusedControl;
  Result.Parent := Result.FSingleParent;
  Result.adsDefectives.Connection := DM.MainConnection;
end;

constructor TframeRejectedPosition.Create(AOwner: TComponent);
begin
  inherited;

  pMain.ControlStyle := pMain.ControlStyle - [csParentBackground] + [csOpaque];
  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

procedure TframeRejectedPosition.HideReject;
begin
  Hide();
end;

procedure TframeRejectedPosition.Label1Click(Sender: TObject);
begin
  if not FFocusedControl.Focused and FFocusedControl.CanFocus() then
    try FFocusedControl.SetFocus() except end;
  Hide();
end;

procedure TframeRejectedPosition.ShowReject(rejectId: Int64);
begin
  if adsDefectives.Active then
    adsDefectives.Close;
  adsDefectives.ParamByName('RejectId').Value := rejectId;
  adsDefectives.Open;  
  Self.Visible := True;
  //Центрируем по горизонтали
  Self.Left := (FSingleParent.ClientWidth - Self.Width) div 2;

  //По умолчанию центрируем по вертикали
  Self.Top := (FSingleParent.ClientHeight - Self.Height) div 2;
  
  Self.BringToFront;
end;

end.
