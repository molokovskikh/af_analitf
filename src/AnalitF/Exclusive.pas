unit Exclusive;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, U_VistaCorrectForm;

type
  TExclusiveForm = class(TVistaCorrectForm)
    Label1: TLabel;
    Timer: TTimer;
    Animate1: TAnimate;
    Label2: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    EnableEscape: boolean;
  public
    { Public declarations }
  end;

function ShowExclusive( EnableEscape: boolean = True; ChildThread: TThread = nil): boolean;

implementation

uses Main, AProc, DModule, UniqueID, SysNames, Exchange;

{$R *.dfm}

function ShowExclusive( EnableEscape: boolean = True; ChildThread: TThread = nil): boolean;
var
  ExclusiveForm: TExclusiveForm;
  ProgressAVI: TResourceStream;
begin
  if not SysUtils.FileExists( ExePath + 'Progress.avi') then
  begin
    ProgressAVI := TResourceStream.Create( hInstance, 'PROGRESS', RT_RCDATA);
    try
      ProgressAVI.SaveToFile( ExePath + 'Progress.avi');
    except
      ProgressAVI.Free;
    end;
  end;

  MainForm.tmrOnExclusive.Enabled := False;
  DM.GlobalExclusiveParams.SetExclusive;

  ExclusiveForm := TExclusiveForm.Create( MainForm);
  ExclusiveForm.EnableEscape := EnableEscape;
  try
    if not SysUtils.FileExists( ExePath + 'Progress.avi') then
      ExclusiveForm.Animate1.Visible := False
    else
    begin
      ExclusiveForm.Animate1.FileName := ExePath + 'Progress.avi';
      ExclusiveForm.Animate1.Active := True;
    end;
    result := ExclusiveForm.ShowModal = mrOK;
    if not Result then
      DM.GlobalExclusiveParams.ResetExclusive;
  finally
    MainForm.tmrOnExclusive.Enabled := True;
    ExclusiveForm.Free;
  end;
end;

procedure TExclusiveForm.FormCreate(Sender: TObject);
var
  countOfProcess : Integer;
begin
  countOfProcess := DM.GlobalExclusiveParams.CountOfProcess();
  Label2.Caption := Format( 'Копий запущено : %d', [ countOfProcess]);
end;

procedure TExclusiveForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if EnableEscape and ( Key = VK_ESCAPE) then ModalResult := mrCancel;
end;

procedure TExclusiveForm.TimerTimer(Sender: TObject);
var
  countOfProcess : Integer;
begin
  countOfProcess := DM.GlobalExclusiveParams.CountOfProcess();
  Label2.Caption := Format( 'Копий запущено : %d', [ countOfProcess]);
  if countOfProcess < 2 then ModalResult := mrOK;
end;

end.
