unit NotFound;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, U_VistaCorrectForm;

type
  TNotFoundForm = class(TVistaCorrectForm)
    btnClose: TButton;
    Memo: TMemo;
    Button1: TButton;
    SaveDialog: TSaveDialog;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowNotFound(Strings: TStrings);

procedure ShowNotSended(ALog: String);

procedure ShowNotFoundCertificates(ALog: String);

procedure ShowReallocationResult(Strings: TStrings);

implementation

{$R *.dfm}

procedure ShowNotSended(ALog: String);
var
  Interval : Integer;
begin
  with TNotFoundForm.Create(Application) do try
    Caption := 'Неотправленные заказы';
    Label1.Caption := 'Данные заказы НЕ ОТПРАВЛЕНЫ, т.к. Поставщик отказал в приеме заказа:';//;
    Label2.Caption := 'Сумма заказа меньше минимально допустимой Поставщиком';
    Label2.Visible := True;
    Interval := Label2.Top - Label1.Top;
    Memo.Top := Memo.Top + Interval;
    Memo.Height := Memo.Height - Interval;
    Memo.Lines.Text := ALog;
    ShowModal;
  finally
    Free;
  end;
end;

procedure ShowNotFound(Strings: TStrings);
begin
  with TNotFoundForm.Create(Application) do try
    Caption := 'Ненайденные позиции';
    Label1.Caption := 'Предложения по данным позициям из заказа отсутствуют :';
    Memo.Lines.Assign(Strings);
    ShowModal;
  finally
    Free;
  end;
end;

procedure ShowNotFoundCertificates(ALog: String);
begin
  with TNotFoundForm.Create(Application) do try
    Caption := 'Ненайденные сертификаты';
    Label1.Caption := 'Не были получены сертификаты для следующих позиций :';
    Memo.Lines.Text := ALog;
    ShowModal;
  finally
    Free;
  end;
end;

procedure ShowReallocationResult(Strings: TStrings);
begin
  with TNotFoundForm.Create(Application) do try
    Caption := 'Найденные/ненайденные позиции';
    Label1.Caption := 'Результат перераспределения заказа :';
    Memo.Lines.Assign(Strings);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TNotFoundForm.Button1Click(Sender: TObject);
begin
  if SaveDialog.Execute then Memo.Lines.SaveToFile(SaveDialog.FileName);
end;

end.
