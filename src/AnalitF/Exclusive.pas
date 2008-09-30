unit Exclusive;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TExclusiveForm = class(TForm)
    Label1: TLabel;
    Timer: TTimer;
    Animate1: TAnimate;
    Label2: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
	EnableEscape: boolean;
	list: TStringList;
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

	DM.SetExclusive;
	MainForm.Timer.Enabled := False;

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
	finally
		ExclusiveForm.Free;
	end;
end;

procedure TExclusiveForm.FormCreate(Sender: TObject);
var
	Dummy1, Dummy2: string;
begin
	list := DM.DatabaseOpenedList( Dummy1, Dummy2);
	Label2.Caption := Format( 'Копий запущено : %d', [ list.Count]);
end;

procedure TExclusiveForm.FormKeyDown(Sender: TObject; var Key: Word;
	Shift: TShiftState);
begin
	if EnableEscape and ( Key = VK_ESCAPE) then ModalResult := mrCancel;
end;

procedure TExclusiveForm.TimerTimer(Sender: TObject);
var
	Dummy1, Dummy2: string;
begin
	list := DM.DatabaseOpenedList( Dummy1, Dummy2);
	Label2.Caption := Format( 'Копий запущено : %d', [ list.Count]);
	if list.Count < 2 then ModalResult := mrOK;
end;

procedure TExclusiveForm.FormDestroy(Sender: TObject);
begin
	list.Free;
end;

end.
