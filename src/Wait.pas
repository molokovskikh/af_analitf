unit Wait;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls;

const
	LABEL_TEXT = '����� ��������� �� ���������� %s' + #10 + #13 +
		'����������� ����������� ������ � ���� ������.' + #10 + #13 +
		'��������� ����� ������� ����� %d ������.';

	WAIT_COUNT	= 30;	// ����� �������� � ��������

type
  TWaitForm = class(TForm)
    Timer: TTimer;
    Label1: TLabel;
    Animate1: TAnimate;
    btnExit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
	ComputerName: string;
	Counter: integer;
  public
    { Public declarations }
  end;

procedure ShowWait;

implementation

uses Main, DModule, AProc;

{$R *.dfm}

procedure ShowWait;
var
	WaitForm: TWaitForm;
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

	WaitForm := TWaitForm.Create( MainForm);
	if not SysUtils.FileExists( ExePath + 'Progress.avi') then
		WaitForm.Animate1.Visible := False
	else
	begin
		WaitForm.Animate1.FileName := ExePath + 'Progress.avi';
		WaitForm.Animate1.Active := True;
	end;
	WaitForm.Show;
end;

procedure TWaitForm.FormCreate(Sender: TObject);
begin
	MainForm.Timer.Enabled := False;
	MainForm.actSendOrders.OnUpdate := nil;
	MainForm.actReceive.Enabled := False;
	MainForm.actReceiveAll.Enabled := False;
	MainForm.actSendOrders.Enabled := False;
	MainForm.actCompact.Enabled := False;
	MainForm.itmSystem.Enabled := False;

	MainForm.CS.Enter;
	ComputerName := Copy( DM.adtFlags.FieldByName( 'ComputerName').AsString, 1, 9);
	MainForm.CS.Leave;
	Counter := WAIT_COUNT;
	Label1.Caption := Format( LABEL_TEXT, [ ComputerName, Counter]);
end;

procedure TWaitForm.btnExitClick(Sender: TObject);
begin
	Application.Terminate;
end;

procedure TWaitForm.TimerTimer(Sender: TObject);
begin
	Timer.Enabled := False;
	if DM.MainConnection.Connected then
	begin
		MainForm.CS.Enter;
		DM.adtFlags.Requery;
		if DM.adtFlags.FieldByName( 'ExclusiveID').AsString = '' then
		begin
			MainForm.CS.Leave;
			MainForm.actSendOrders.OnUpdate := MainForm.actSendOrdersUpdate;
			MainForm.actReceive.Enabled := True;
			MainForm.actReceiveAll.Enabled := True;
			MainForm.actSendOrders.Enabled := True;
			MainForm.actCompact.Enabled := True;
			MainForm.itmSystem.Enabled := True;
			MainForm.Timer.Enabled := True;
			Close;
			exit;
		end
		else MainForm.CS.Leave;
	end;

	MainForm.actReceive.Enabled := False;
	MainForm.actReceiveAll.Enabled := False;
	MainForm.actSendOrders.Enabled := False;
	MainForm.actCompact.Enabled := False;
	MainForm.itmSystem.Enabled := False;

	dec( Counter);
	if Counter = 0 then Application.Terminate;
	Label1.Caption := Format( LABEL_TEXT, [ ComputerName, Counter]);
	Timer.Enabled := True;
end;

end.
