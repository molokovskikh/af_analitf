unit U_frmOldOrdersDelete;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms;

type
  TfrmOldOrdersDelete = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Image1: TImage;
    lblError: TLabel;
  end;

var
  frmOldOrdersDelete: TfrmOldOrdersDelete;

implementation

{$R *.DFM}

end.
