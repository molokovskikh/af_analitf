unit LU_Tracer;

interface                                              

uses
 syncobjs,
 classes;

type
 TTracer = class
  private
   //Предельный размер TR файла - по умолчанию - мегабайт.
   MaxTracePosition : integer;
   FSuffix          : string;
   CS : TCriticalSection;
   FT : TFileStream;
   FFTName : String;
   function getFTName : string;
   procedure DoSwitch;
  public
   constructor Create;overload;
   //AMaxSize - максимальный размер файла в байтах. Если AMaxSize <= 0 то
   //не резать.
   //Suffix - Суффикс имени
   //файла трассировки.
   constructor Create ( FTName, Suffix : string; AMaxSize : integer );overload;
   destructor  Destroy;override;
   procedure   TR ( ASubSystem,AMessage : string );
 end;

var
 Tracer : TTracer;

implementation

uses
 SysUtils;

{ TTracer }

constructor TTracer.Create;
begin
 try
   MaxTracePosition := 1024 * 1024;
   FSuffix := 'TR';
   CS := TCriticalSection.Create;
   if FindCmdLineSwitch('extd') or FindCmdLineSwitch('e') or FindCmdLineSwitch('i') or FindCmdLineSwitch('si')
   then begin
     if not FileExists ( getFTName ) then
      begin
       FT := TFileStream.Create ( getFTName , fmCreate );
       FT.Free;
      end;
     FT := TFileStream.Create ( getFTName , fmOpenWrite or fmShareDenyWrite );
     //Здесь надо искать строку -END-
     FT.Seek ( 0 , soFromEnd );
   end
   else
     FT := NIL;

   TR ( 'Tracer' , 'Start' );
  except
   FT := NIL;
 end;
end;

constructor TTracer.Create(FTName, Suffix: string; AMaxSize: integer);
begin
 try
   MaxTracePosition := AMaxSize;
   FFTName := FTName;
   FSuffix := Suffix;
   CS := TCriticalSection.Create;
   if not FileExists ( getFTName ) then
    begin
     FT := TFileStream.Create ( getFTName , fmCreate );
     FT.Free;
    end;
   FT := TFileStream.Create ( getFTName , fmOpenWrite or fmShareDenyWrite );
   FT.Seek ( 0 , soFromEnd );
   TR ( 'Tracer' , 'Start' );
  except
   FT := NIL;
 end;
end;

destructor TTracer.Destroy;
begin
  inherited;
   TR ( 'Tracer' , 'Stop' );
  FT.Free;
  CS.Free;
end;

procedure TTracer.DoSwitch;
begin
 DeleteFile ( ParamStr ( 0 ) + '.old.' + FSuffix );
 FT.Free;
 RenameFile ( getFTName , ParamStr ( 0 ) + '.old.' + FSuffix );
   if not FileExists ( getFTName ) then
    begin
     FT := TFileStream.Create ( getFTName , fmCreate );
     FT.Free;
    end;
   FT := TFileStream.Create ( getFTName , fmOpenWrite or fmShareDenyWrite );
   FT.Seek ( 0 , soFromEnd );
   TR ( 'Tracer' , 'Start' );
end;

function TTracer.getFTName: string;
begin
  if FFTName = '' then
    Result := ParamStr ( 0 ) + '.' + FSuffix
  else
    Result := FFTName + '.' + FSuffix;
end;

procedure TTracer.TR(ASubSystem, AMessage: string);
var
 s  : string;
 sl : TStringList;
 i  : integer;
begin
 try
   if FT = NIL then exit;
   if Length ( AMessage ) = 0 then exit;
   if AMessage = '' then
    AMessage := 'ОШИБКА: Вызов метода Trace.TR с пустым параметром AMessage';
   if ( MaxTracePosition > 0 ) and ( FT.Position > MaxTracePosition ) then
    begin
     DoSwitch;
    end;
   sl := TStringList.Create;
   try
     sl.Text := AMessage;
     sl.Strings[0] :=
        FormatDateTime ( 'yyyy.mm.dd hh.nn.ss.zzz' , Now ) + #9 +
        ASubSystem + #9 + sl.Strings[0];
     for i := 1 to sl.Count - 1 do
      begin
       sl.Strings[i] :=
          '                       '#9 +
          ASubSystem + #9 + sl.Strings[i];
      end;
     s := sl.Text;
    finally
     sl.Free;
   end;

   CS.Enter;
   try
     FT.WriteBuffer ( s[1] , Length ( s ) );
    finally
     CS.Leave;
   end;
  except
 end;
end;

initialization
 Tracer := TTracer.Create;
finalization
 Tracer.Free;
end.
