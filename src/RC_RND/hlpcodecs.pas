unit hlpcodecs;

interface

uses sysutils;

function rc_Decode(sCoded: string): string;
function rc_Encode(sString: string): string;

function in_Decode(sCoded: string): string;
function in_Encode(sString: string): string;


implementation

function rc_Decode(sCoded: string): string;
var
  i,j,c: integer;
  sRes: string;
begin
  sRes:= '';
  i:= 1;
  j:= length(sCoded);
  while i<= j do
    begin
      if ((sCoded[i]= '%') and ((j-i)>1)) then
         try
           c:= strtoint('$'+copy(sCoded,i+1,2));
           sRes:= sRes+ chr(c);
           i:= i+ 2;
         except
           sRes:= sRes+ sCoded[i];
         end
      else
        sRes:= sRes+ sCoded[i];
      inc(i);
    end;
  result:= sRes;
end;

function rc_Encode(sString: string): string;
var
  i,j: integer;
  sRes: string;
begin
  sRes:= '';
  j:= length(sString);
  for i:= 1 to j do
    if (Ord(sString[i]) <= 32) or (sString[i] = '%') then
      sRes:= sRes+ format('%%%.2X',[ord(sString[i])])
    else
      sRes:= sRes+ sString[i];
{
    if ((sString[i]= '*') or (sString[i]= '-') or (sString[i]= '.') or (sString[i]= '_') or (sString[i]= '@')
          or ((sString[i]>= 'A') and (sString[i]<= 'Z')) or ((sString[i]>= 'a') and (sString[i]<= 'z'))
          or ((sString[i]>= '0') and (sString[i]<= '9'))) then
      sRes:= sRes+ sString[i]
    else
      sRes:= sRes+ format('%%%.2X',[ord(sString[i])]);
}
  result:= sRes;
end;

function in_Decode(sCoded: string): string;
var
  i,j,c: integer;
  sRes: string;
begin
  sRes:= '';
  i:= 1;
  j:= length(sCoded);
  while i<= j do
  begin
    c:= strtoint('$' + copy(sCoded, i, 2) );
    sRes:= sRes+ chr(c);
    i:= i+ 2;
  end;
  result:= sRes;
end;

function in_Encode(sString: string): string;
var
  i,j: integer;
  sRes: string;
begin
  sRes:= '';
  j:= length(sString);
  for i:= 1 to j do
      sRes:= sRes+ format('%.2X',[ord(sString[i])]);
  result:= sRes;
end;

end.
