unit LU_LeakWatcher;

interface

uses
 contnrs,
 windows,
 syncobjs,
 LU_TSGEvent;

const
 LWEventNameStart = 'ru.sterling.d110.LeakWatcherEvent.start';
 LWEventNameStop  = 'ru.sterling.d110.LeakWatcherEvent.stop';

type
 TLeakWatcher = class
  private
   CS   : TCriticalSection;
   list : TObjectList;
  public
   constructor Create;
   procedure   RegisterReference   ( event : TSGEvent );
   procedure   UnRegisterReference ( event : TSGEvent );
   function    Dump : string;
 end;

var
 LW : TLeakWatcher;

implementation

uses
 sysutils,
 LU_Tracer,
 classes;      

{ TLeakWatcher }

constructor TLeakWatcher.Create;
begin
 list := TObjectList.Create ( False );
 CS   := TCriticalSection.Create;
end;

function TLeakWatcher.Dump: string;
const
 color1 = '#ffffcc';
 color2 = '#ccff99';
var
 i   : integer;
 sl  : TStringList;
 c   : string;

begin
 CS.Enter;                      
 try
  sl := TStringList.Create;
  sl.Add ( '<HTML><HEAD><TITLE>TLeakWatcher.Dump</TITLE></HEAD><BODY>' );
  sl.Add ( '<p>Созданные, но не разрушенные объекты - '+
           'наследники от TSGEvent</p>' );
  sl.Add ( '<TABLE border=1><TR><TH>Имя класса</TH>'+
           '<TH>Время создания</TH><TH>Размер экземпляра</TH>'+
           '<TH>Дамп объекта</TH></TR>' );
  try
    c := color1;
    for i := 0 to list.Count - 1 do
     begin
      sl.Add (
        '<TR bgcolor=' + c + '><TD valign=top>'   +
        list.Items[i].ClassName +
        '</TD><TD valign=top>'  +
        FormatDateTime ( 'yyyy.mm.dd"&nbsp;"hh.nn.ss.zzz' ,
         TSGEvent ( list.items[i] ).getEventCreationDate ) +
        '</TD><TD valign=top>' +
        IntToStr ( list.Items[i].InstanceSize ) +
        '</TD><TD valign=top align=left><PRE>'  +
        TSGEvent ( list.items[i] ).Dump +
        '</PRE></TD></TR>' );
       if c = color1 then c := color2 else c := color1;
     end;
    sl.Add ( '</TABLE></HTML>' );  
    Result := sl.Text;
   finally
    sl.Free;
  end;
 finally
  CS.Leave;
 end;
end;

procedure TLeakWatcher.RegisterReference(event: TSGEvent);
begin
 CS.Enter;
 try
   list.add ( event );
  finally
   CS.Leave;
 end;
end;

procedure TLeakWatcher.UnRegisterReference(event: TSGEvent);
var
 s : string;
begin
 CS.Enter;
 try
   if list.Remove ( event ) < 0 then
    begin
      try s := event.ClassName except s := '???' end;
      Tracer.TR ( 'LeakWatcher' ,
       'команда на удаление элемента, который не добавлялся. Класс: ' + s );
    end;
  finally
   CS.Leave;
 end;
end;

initialization
 LW  := TLeakWatcher.Create;
 //TLeakWatcherThread.Create ( False );
end.
