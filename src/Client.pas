unit Client;

interface

uses
  Windows, Classes, Forms, Controls, DBCtrls, StdCtrls, Mask, ExtCtrls,
  Grids, DBGridEh, ToughDBGrid, Menus;

type
  TClientForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label5: TLabel;
    dbeForcount: TDBEdit;
    Bevel1: TBevel;
    ToughDBGrid1: TToughDBGrid;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
  public
    { Public declarations }
  end;

function ShowClient: Boolean;

implementation

uses DModule, AProc;

{$R *.DFM}

function ShowClient: Boolean;
begin
  with TClientForm.Create(Application) do try
    Result:=ShowModal=mrOk;
    if Result then begin
      DM.adsRetailMargins.ApplyUpdates;
      DM.LoadRetailMargins;
    end
    else
      DM.adsRetailMargins.CancelUpdates;
  finally
    Free;
  end;
end;

procedure TClientForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Res : Boolean;
  PrevRight : Currency;
begin
  if ModalResult = mrOK then begin
    DM.adsRetailMargins.DoSort(['LEFTLIMIT'], [True]);
    if DM.adsRetailMargins.RecordCount > 0 then begin
      DM.adsRetailMargins.First;
      Res := DM.adsRetailMarginsLEFTLIMIT.AsCurrency <= DM.adsRetailMarginsRIGHTLIMIT.AsCurrency;
      PrevRight := DM.adsRetailMarginsRIGHTLIMIT.AsCurrency;
      DM.adsRetailMargins.Next;
      while not DM.adsRetailMargins.Eof and Res do begin
        Res := PrevRight <= DM.adsRetailMarginsLEFTLIMIT.AsCurrency;
        if Res then
          Res := DM.adsRetailMarginsLEFTLIMIT.AsCurrency <= DM.adsRetailMarginsRIGHTLIMIT.AsCurrency;
        DM.adsRetailMargins.Next;
      end;
      if not Res then begin
        CanClose := False;
        MessageBox('Некорректно введены границы цен.', MB_ICONWARNING);
      end;
    end;
  end;
end;

end.
