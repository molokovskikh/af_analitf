{*************************************************}
{                                                 }
{             FIBPlus Script, version 1.9         }
{                                                 }
{     Copyright by Nikolay Trifonov, 2003-2007    }
{                                                 }
{           E-mail: t_nick@mail.ru                }
{                                                 }
{*************************************************}

This FibScript Component Set provide maximum compatibility for behaviour with similar 
module from IBX, but at the same time in the scripts will be work commands
as "execute procedure", "create or alter", "describe" and so on.

This FibPlus Script destination for execute scripts, example:

==========
DECLARE EXTERNAL FUNCTION TIMETOSECONDS 
    TIME
    RETURNS INTEGER BY VALUE
    ENTRY_POINT 'TimeToSeconds' MODULE_NAME 'nntudf';

ALTER PROCEDURE SP_GET_ROUNDMINUTES (
    DURATION TIME)
RETURNS (
    DURATION_ROUNDMINUTES INTEGER)
AS
declare variable duration_hour integer;
declare variable duration_minute integer;
declare variable duration_second integer;
declare variable dontusefirstseconds integer;
BEGIN
  select Z(extract(hour from :duration)), Z(extract(minute from :duration)), Z(extract(second from :duration))
  from rdb$database
  into :duration_hour, :duration_minute, :duration_second;

  SUSPEND;
END ;
=========

Put module on form and fill property DataBase and Transaction.

For right work module on FIBPlus version lower that 5.0 you have to
move in FIBDatabase.pas procedure RemoveDatabase from section 
"protected" in section "public" and recompile FibPlus.


Example of use:

===
FIBScript1.Script.Assign(ListSQL);
FIBScript1.AutoDDL := False;
if FIBScript1.ValidateScript then FIBScript1.ExecuteScript;
if FIBScript1.Transaction.InTransaction then FIBScript1.Transaction.Commit;
===

Nikolay Trifonov
E-mail: t_nick@mail.ru
http://www.atstariff.com/fibscript/en/