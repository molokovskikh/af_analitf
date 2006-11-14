unit U_frmSendLetter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmSendLetter = class(TForm)
    leSubject: TLabeledEdit;
    lBody: TLabel;
    mBody: TMemo;
    cbAddLogs: TCheckBox;
    lbFiles: TListBox;
    btnAddFile: TButton;
    btnDelFile: TButton;
    btnSend: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSendLetter: TfrmSendLetter;

implementation

{$R *.dfm}

end.
