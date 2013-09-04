unit U_frameRejectedPosition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, ExtCtrls;

type
  TframeRejectedPosition = class(TFrame)
    Panel2: TPanel;
    dbtLetterDate: TDBText;
    dbtSeries: TDBText;
    dbtLetterNumber: TDBText;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    dbmReason: TDBMemo;
  private
    { Private declarations }
    FSingleParent: TWinControl;
    FAdvertisingPanel: TWinControl;
    FFocusedControl: TWinControl;
    FShowUnderFocusedControl : Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    class function AddFrame(
      Owner: TComponent;
      SingleParent: TWinControl;
      AdvertisingPanel: TWinControl;
      FocusedControl: TWinControl;
      ShowUnderFocusedControl : Boolean) : TframeRejectedPosition;
  end;

implementation

{$R *.dfm}

{ TframeRejectedPosition }

class function TframeRejectedPosition.AddFrame(Owner: TComponent;
  SingleParent, AdvertisingPanel, FocusedControl: TWinControl;
  ShowUnderFocusedControl: Boolean): TframeRejectedPosition;
begin
  Result := TframeRejectedPosition.Create(Owner);
  Result.Visible := False;
  Result.Name := 'frameRejectedPosition';
  Result.FSingleParent := SingleParent;
  Result.FAdvertisingPanel := AdvertisingPanel;
  Result.FFocusedControl := FocusedControl;
  Result.Parent := Result.FAdvertisingPanel;
  Result.Align := alClient;
  Result.FShowUnderFocusedControl := ShowUnderFocusedControl;
end;

constructor TframeRejectedPosition.Create(AOwner: TComponent);
begin
  inherited;

  Self.ControlStyle := Self.ControlStyle - [csParentBackground] + [csOpaque];
end;

end.
