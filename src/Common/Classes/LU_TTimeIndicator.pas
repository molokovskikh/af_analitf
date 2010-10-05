{
 Change List :
  2002.04.15 - ��� ������ ������ startTime - ���� ��������� � �����
               ������ ��� ���������� �� ����� ���������� ������ ���
               ��� ���� �����, � ������ ����� �������� �����. ������
               � application log, ��������� ����� ��������������� �
               ���������� ������.
  2002.07.16 - ������� ��, ��� ����� �� ������� � ������������ � ������������
               TimeIndicator'�.
}

unit LU_TTimeIndicator;

interface

uses
  Windows, SysUtils, Classes, U_SXConversions, Contnrs, LU_TSGHashTable,
  LU_TSGEvent;

const
  MeasureMsgHeader      = 'LU_TTimeIndicator:TMeasureInformation.%s - %s';
  IndicatorMsgHeader    = 'LU_TTimeIndicator:TTimeIndicator.%s - %s';
  IndicatorIsRunning    = '��������� "%s" ��� ��������.';
  IndicatorIsNotRunning = '��������� "%s" �� ��������.';
  UnknownIndicator      = '���������� "%s" �� ����������.';

  //����������� ��������� ������� ������� ������� �� ������� ������
  WorkCoef = 1;

type
  //���� ����� �������� ���������� � ����������
  TMeasureInformation = class(TSGEvent)
   private
    Working : Boolean;
    FFailureCount,
    FMaxWork,
    FMeasureCount,
    FWorkTime,
    FLastWorkTime,
    FLastStartTick,
    FLastEndTick,
    FStartTick,
    FEndTick : DWORD;
    FMeasureID : String;
    //������������� �������
    procedure   Init;
   public
    function    Dump : string;override;
    constructor Create(AOwner : TComponent); override;
    constructor Summon(AMeasureID : String);
    //��������� ������� ����� ����� ������ ��� ����������� �� ����,
    //��� ������� ����� �������������
    class function Difference(AStartTime, AEndTime : DWORD) : DWORD;
    //������ ��������� �������
    procedure Start;
    //��������� ���������
    function  Stop : DWORD;
    //���������� ����� �� ���������� ������
    function  CanStart : Boolean;
    //������ ���������� � �������� ������
    function  GetAsText : String;
    //�������� ���������� ���������� ����
    property  LastStartTick : DWORD read FLastStartTick;
    //�������� ���������� ��������� ����
    property  LastEndTick : DWORD read FLastEndTick;
    //���������� ������������� �������
    property  MeasureCount : DWORD read FMeasureCount;
    //����� ���������� �������������� �������
    property  WorkTime : DWORD read FWorkTime;
    //���������� ������������� ����������
    property  MeasureID : String read FMeasureID;
    //������������ ����� ������ ���������
    property  MaxWork : DWORD read FMaxWork;
    //���������� �������, ���������� � ��� ������ CanStart
    property  FailureCount : DWORD read FFailureCount;
    //��������� ����� ������
    property  LastWorkTime : DWORD read FLastWorkTime;
  end;

  //������ ��������� � ����������� �� ����������
  TTimeIndicator = class
   private
    FMeasures     : TObjectList; //������ �����������
    FHT           : TSGHashTable;//��� ������� ������� � ���������  
    FStartWork    : TDateTime;   //����� ������ ������
    FSaveFileName : String;
    //��������� ������ � ���� TStringList
    function    GetAsStringList : TStringList;
    //��������� �������, ������� ��������� ����������
    fuNction    Add(MeasureID : String) : TMeasureInformation;
   public
    constructor Create;
    destructor  Destroy; override;
    //������ ���������
    procedure   StartTime(MeasureID : String);
    //��������� ���������
    function    StopTime(MeasureID : String) : DWORD;
    //������� � ���, ����� �� ���������� ������
    function    CanStart(MeasureID : String) : Boolean;
    //����� ������� ��������
    function    Find(MeasureID : String) : TMeasureInformation;
    //��������� ���������� � ���� ������
    function    GetAsText : String;
    //��������� ���������� � ���� XML ���������
    function    GetAsXML : String;
    //��������� ������ �� ����������� � ����
    procedure   SaveToFile;
    //����� ������ ������
    property    StartWork : TDateTime read FStartWork;
  end;

var
  TimeIndicator : TTimeIndicator;

implementation

uses
 LU_SystemLogReport;

{ TMeasureInformation }

function TMeasureInformation.CanStart: Boolean;
var
  CurTick : DWORD;
begin
  CurTick := GetTickCount;
  //����� ���� �� ��� �� ���� �� �����������
  Result := (FLastEndTick = 0) and (FLastStartTick = 0);

  if not Result then
    if (FLastWorkTime <> 0) then
      Result := (Difference(FLastEndTick, CurTick)/FLastWorkTime >= WorkCoef)
    else
      Result := (Difference(FLastEndTick, CurTick) > 0);

  if Result and not Working then
    Start
  else
    Inc(FFailureCount);
end;

constructor TMeasureInformation.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Init;
end;

class function TMeasureInformation.Difference(AStartTime,
  AEndTime: DWORD): DWORD;
begin
  if AEndTime >= AStartTime then
    Result := AEndTime - AStartTime
  else
    Result := AEndTime + (High(DWORD) - AStartTime);
end;

function TMeasureInformation.Dump: string;
begin
 Result := 'ID:' + FMeasureID;
end;

function TMeasureInformation.GetAsText: String;
var
  DT : TDateTime;
begin
  DT := Now;
  Result :=
   '����������                 : ' + FMeasureID + #13#10 +
   '����� ����� ������         : ' +
                        DateTimeDiffToString(DT, DT + FWorkTime/MSecsPerDay) +
                                #13#10 +
   '���������� ���������       : ' + IntToStr(FMeasureCount) + #13#10 +
   '������������ ����� ������  : ' + IntToStr(FMaxWork) + ' MSecs'#13#10 +
   '��������� ����� ������(���): ' + IntToStr(FLastWorkTime) + ' MSecs'#13#10 +
   '��������� ����� ������     : ' + IntToStr(FLastEndTick - FLastStartTick) +
                                ' MSecs'#13#10;
  if FMeasureCount > 0 then
     Result := Result +
     '������� ����� ������       : ' +
        IntToStr(FWorkTime div FMeasureCount ) + #13#10 +
     '���������� �������         : ' + IntToStr(FFailureCount) + #13#10;
  if Working then
     Result := Result +
       '���������                  : ��������'#13#10 +
       '��������� ���              : ' + IntToStr(FStartTick) + ' MSecs'#13#10 +
       '������� ���                : ' + IntToStr(GetTickCount) + ' MSecs'#13#10
  else
     Result := Result +
       '���������                  : �� ��������'#13#10;
end;

procedure TMeasureInformation.Init;
begin
  Working := False;
  FMeasureCount := 0;
  FStartTick    := 0;
  FEndTick      := 0;
  FWorkTime     := 0;
  FMaxWork      := 0;
  FLastWorkTime := 0;
  FLastStartTick:= 0;
  FLastEndTick  := 0;
  FFailureCount := 0;
  FMeasureID    := '';
end;

procedure TMeasureInformation.Start;
begin
//2002.04.15 - ��������� ��������� �����.
//2002.07.16 - ������� ��, ��� ����� �� �������
  if Working then begin
    WriteInSystemLog ( letError ,
     Format (MeasureMsgHeader, ['Start',
       Format(IndicatorIsRunning, [FMeasureID])]) , NIL );
    Stop;
  end;
  Working := True;
  FStartTick := GetTickCount;
end;

function TMeasureInformation.Stop : DWORD;
begin
  if Working then begin
    FEndTick := GetTickCount;
    Working := False;
    Inc(FMeasureCount);

    //�������, �� ������������ �� � ��� GetTickCount(����� 47 ����)
    FLastWorkTime := Difference(FStartTick, FEndTick);

    Result  := FLastWorkTime;
    FLastStartTick:= FStartTick;
    FLastEndTick  := FEndTick;
    Inc(FWorkTime, Result);
    if Result > FMaxWork then
      FMaxWork := Result;
  end
  else
    raise Exception.CreateFmt(MeasureMsgHeader, ['Stop',
                                  Format(IndicatorIsNotRunning, [FMeasureID])]);
end;

constructor TMeasureInformation.Summon(AMeasureID: String);
begin
  inherited Create(nil);
  Init;
  FMeasureID := AMeasureID;
end;

{ TTimeIndicator }

function TTimeIndicator.Add(MeasureID: String): TMeasureInformation;
begin
  Result := TMeasureInformation.Summon(MeasureID);
  FMeasures.Add(Result);
  FHT.AddItem(MeasureID, Result);
end;

function TTimeIndicator.CanStart(MeasureID: String): Boolean;
var
  MI : TMeasureInformation;
begin
  MI := Find(MeasureID);
  if not Assigned(MI) then begin
    MI := Add(MeasureID);
    MI.Start;
    Result := True;
  end
  else
    Result := MI.CanStart;
end;

constructor TTimeIndicator.Create;
begin
  FSaveFileName := ParamStr(0) + '.timing';
  if FileExists(FSaveFileName) then
    RenameFile(FSaveFileName, FSaveFileName + '.old');
  FStartWork    := Now;
  FMeasures     := TObjectList.Create(True);
  FHT           := TSGHashTable.Create(8000);
end;

destructor TTimeIndicator.Destroy;
begin
  FHT.Free;
  FMeasures.Free;
  inherited;
end;

function TTimeIndicator.Find(MeasureID: String): TMeasureInformation;
begin
  Result := TMeasureInformation(FHT.FindItem(MeasureID));
end;

function TTimeIndicator.GetAsStringList: TStringList;
const
  TimeIndicatorDelimiter = '**************************************************';
  TIDateTimeTemplate = '  yyyy.mm.dd hh.nn.ss.zzz';
var
  I : Integer;
  CurrentTime : TDateTime;
begin
  Result := TStringList.Create;
  for I := 0 to FMeasures.Count-1 do begin
    Result.Add(TimeIndicatorDelimiter);
    Result.Add(TMeasureInformation(FMeasures.Items[i]).GetAsText);
  end;
  try
    CurrentTime := Now;
    Result.Insert(0,
      '����� ������ ��� ����������� : '
        + DateTimeDiffToString(FStartWork, CurrentTime) + '   '
        + FormatDateTime(TIDateTimeTemplate, FStartWork)
        + FormatDateTime(TIDateTimeTemplate, CurrentTime));
  except
    on E : Exception do
      Result.Insert(0, E.Message);
  end;
end;

function TTimeIndicator.GetAsText: String;
var
  SL : TStringList;
begin
  SL := GetAsStringList;
  try
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function TTimeIndicator.GetAsXML: String;
const
  TIDateTimeTemplate = '  yyyy.mm.dd hh.nn.ss.zzz';
var
  i  : Integer;
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Add (
       '<?xml version = "1.0" encoding = "windows-1251" standalone = "yes" ?>' );
    sl.Add ( '<TI startup="' +
       FormatDateTime(TIDateTimeTemplate, FStartWork) +
       '" uptime="' +
       IntToStr ( Round ( ( Now - FStartWork ) * MSecsPerDay ) ) +
       '">' );

    for I := 0 to FMeasures.Count-1 do
    begin
      sl.Add ( '<Indicator name="' +
                TMeasureInformation(FMeasures.Items[i]).FMeasureID +
                '" TotalTime="' +
                IntToStr (
                 Round (
                 TMeasureInformation(FMeasures.Items[i]).FWorkTime ) ) +
                '" Count="' +
                IntToStr (
                 TMeasureInformation(FMeasures.Items[i]).FMeasureCount ) +
                '" Max="' +
                IntToStr (
                 TMeasureInformation(FMeasures.Items[i]).FMaxWork ) +
                '" Last="' +
                IntToStr (
                 TMeasureInformation(FMeasures.Items[i]).FLastWorkTime ) + '"'
              );

      if TMeasureInformation(FMeasures.Items[i]).Working then
         sl.Add ( ' working="1"' )
       else
         sl.Add ( ' working="0"' );       
      sl.Add (  '>'    );
      sl.Add ( '</Indicator>' );
    end;
    sl.Add ( '</TI>' );
    Result := sl.Text;    
   finally
    sl.Free;
  end;
end;

procedure TTimeIndicator.SaveToFile;
var
  SL : TStringList;
begin
  try
    SL := GetAsStringList;
    try
      SL.SaveToFile(FSaveFileName);
    finally
      SL.Free;
    end;
   except
  end;
end;

procedure TTimeIndicator.StartTime(MeasureID: String);
var
  MI : TMeasureInformation;
  Step : String;
begin
 try
   Step := '---1';
   MI := Find(MeasureID);
   Step := '---2';
   if not Assigned(MI) then
     MI := Add(MeasureID);
   Step := '---3';
   MI.Start;
  except
   on E : Exception do
    raise Exception.CreateFmt (IndicatorMsgHeader, ['StartTime',
                                Step + '  ' + E.Message]);
 end;
end;

function TTimeIndicator.StopTime(MeasureID: String) : DWORD;
var
  MI : TMeasureInformation;
begin
 try
    MI := Find(MeasureID);
    if Assigned(MI) then
      Result := MI.Stop
    else
      raise Exception.CreateFmt(UnknownIndicator, [MeasureID]);
  except
   on E : Exception do
    raise Exception.CreateFmt (IndicatorMsgHeader, ['StopTime', E.Message]);
 end;
end;


initialization
  TimeIndicator   := TTimeIndicator.Create;
finalization
  TimeIndicator.Free;
end.
