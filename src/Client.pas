unit Client;

interface

uses
  Windows, Classes, Forms, Controls, DBCtrls, StdCtrls, Mask, ExtCtrls;

type
  TClientForm = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    Label5: TLabel;
    dbeForcount: TDBEdit;
    Bevel1: TBevel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

function ShowClient: Boolean;

implementation

uses DModule;

{$R *.DFM}

function ShowClient: Boolean;
begin
  with TClientForm.Create(Application) do try
    DM.adtClients.Edit;
    Result:=ShowModal=mrOk;
  finally
    Free;
  end;
end;

procedure TClientForm.btnOkClick(Sender: TObject);
begin
  DM.adtClients.Post;
  ModalResult:=mrOk;
end;

procedure TClientForm.btnCancelClick(Sender: TObject);
begin
  DM.adtClients.Cancel;
  ModalResult:=mrCancel;
end;

end.
