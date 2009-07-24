@echo off
rem **********************************************************************
rem *
rem * Mydac for Delphi 7
rem *
rem **********************************************************************

set IdeDir="C:\Program Files\Borland\Delphi7
call ..\Make.bat Delphi 7

rem Удаление ненужных файлов
rem del *.dcu
rem del *.dcp
rem del *.bpl
rem del ..\..\CRGrid\Source\Delphi7\*.dcu
rem del ..\..\CRGrid\Source\Delphi7\*.dcp
rem del ..\..\CRGrid\Source\Delphi7\*.bpl