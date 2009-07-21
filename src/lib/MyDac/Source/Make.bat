@echo off
rem **********************************************************************
rem *
rem * MyDAC
rem *
rem * Tasks:
rem *   1) Compile Dac packages;
rem *   2) Compile CRControls package;
rem *   2) Compile MyDAC packages;
rem *
rem * Command line:
rem *   call ..\_Make.bat IDEName IDEVer CLR
rem *   
rem * Parameters:
rem *   IDEName = (Delphi, CBuilder)
rem *   IDEVer = (5, 6, 7, 8, 9, 10, 11, 12)
rem *   CLR = (CLR, WIN32) WIN32 - default
rem **********************************************************************

rem Prepare ==============================================================
rem ======================================================================
set IDEName=%1
set IDEVer=%2
set CLR=%3
set PrjName=MyDAC
set PrjNameL=mydac

pushd

rem Test IDEName
if %IDEName%A==DelphiA goto IDENameOK
if %IDEName%A==CBuilderA goto IDENameOK
echo Command line must be:
echo    call ..\_Make.bat IDEName IDEVer
echo    IDEName = (Delphi, CBuilder)
goto Err
:IDENameOK

rem Test IDEVer
if %IDEVer%A==5A goto IDEVerOK
if %IDEVer%A==6A goto IDEVerOK
if %IDEVer%A==7A goto IDEVerOK
if %IDEVer%A==8A goto IDEVerOK
if %IDEVer%A==9A goto IDEVerOK
if %IDEVer%A==10A goto IDEVerOK
if %IDEVer%A==11A goto IDEVer11
if %IDEVer%A==12A goto IDEVerOK
echo Command line must be:
echo    call ..\Make.bat IDEName IDEVer CLR
echo    IDEVer = (5, 6, 7, 8, 9, 10, 11, 12)
goto Err

:IDEVer11:
set PkgVer=105
goto PkgVerOK

:IDEVerOK
set PkgVer=%IDEVer%0

:PkgVerOK

rem Test CLR
if %CLR%A==CLRA goto CLROK
set CLR=WIN32
:CLROK

rem Make paths ===========================================================
rem Create common paths
mkdir %PrjName%
mkdir %PrjName%\Lib
mkdir %PrjName%\CRGrid
if %IDEVer%A==10A mkdir %PrjName%\Include
if %IDEVer%A==11A mkdir %PrjName%\Include

rem Create CBuilder specific paths
if %IDEName%A==DelphiA goto SkipCBPaths
mkdir %PrjName%\Include
mkdir %PrjName%\Dcu
:SkipCBPaths 

rem del /Q/S %PrjName%\*.*

if %IDEName%A==CBuilderA goto CBuilder
if %CLR%A==CLRA goto Delphi8

rem Compile ==============================================================
rem Compile DAC packages =================================================
%IdeDir%\Bin\dcc32.exe" -LE. dac%PkgVer%.dpk
@if errorlevel 1 goto Err

if %IDEVer%A==4A goto SkipDVcl
if %IDEVer%A==5A goto SkipDVcl
%IdeDir%\Bin\dcc32.exe" -LE. dacvcl%PkgVer%.dpk
@if errorlevel 1 goto Err

:SkipDVcl
%IdeDir%\Bin\dcc32.exe" -LE. dcldac%PkgVer%.dpk
@if errorlevel 1 goto Err

rem Compile CRControls package ===========================================
cd ..\..\CRGrid\Source\%IDEName%%IDEVer%
%IdeDir%\Bin\dcc32.exe" -LE. CRControls%PkgVer%.dpk -I..\..\..\Source -U..\..\..\Source\%IDEName%%IDEVer%
@if errorlevel 1 goto Err
cd ..\..\..\Source\%IDEName%%IDEVer%

rem Compile MyDAC packages ===========================================
%IdeDir%\Bin\dcc32.exe" -U.. -LE. %PrjNameL%%PkgVer%.dpk
@if errorlevel 1 goto Err

if %IDEVer%A==4A goto SkipD__Vcl
if %IDEVer%A==5A goto SkipD__Vcl

%IdeDir%\Bin\dcc32.exe" -U.. -LE. %PrjNameL%vcl%PkgVer%.dpk
@if errorlevel 1 goto Err

:SkipD__Vcl

%IdeDir%\Bin\dcc32.exe" -U.. -LE. dcl%PrjNameL%%PkgVer%.dpk
@if errorlevel 1 goto Err

%IdeDir%\Bin\dcc32.exe" -U.. -LE. dclmysqlmon%PkgVer%.dpk
@if errorlevel 1 goto Err

rem Copy files ===========================================================
rem ======================================================================

copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\CRControls%PkgVer%.bpl    %PrjName%

copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\CRControls%PkgVer%.dcp    %PrjName%\CRGrid
copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\CRGrid.dcu                 %PrjName%\CRGrid
copy ..\..\CRGrid\Source\CRGrid.res                                   %PrjName%\CRGrid

copy *.bpl               %PrjName%

copy *.bpi               %PrjName%\Lib
copy *.dcu               %PrjName%\Lib
copy *.dcp               %PrjName%\Lib
copy ..\*.res            %PrjName%\Lib
copy *.hpp               %PrjName%\Include
copy ..\*.hpp            %PrjName%\Include

copy ..\..\CRGrid\Source\CRControlsReg.hpp                            %PrjName%\Include
copy ..\..\CRGrid\Source\CRGrid.hpp                                   %PrjName%\Include
 
rem set IdeDir="D:\Progra~1\Borland\BDS\4.0

if not %IDEVer%A==10A goto SkipD10BCCLib
if not %CLR%A==WIN32A goto SkipD10BCCLib

del %PrjName%\Include\*100.hpp
:SkipD10BCCLib

goto end

:Delphi8
rem Compile Delphi8 ======================================================
rem Compile DAC packages =================================================

%IdeDir%\Bin\dccil.exe" -LE. Devart.Dac.dpk
@if errorlevel 1 goto Err

%IdeDir%\Bin\dccil.exe" -LE. Devart.Dac.AdoNet.dpk
@if errorlevel 1 goto Err

%IdeDir%\Bin\dccil.exe" -LE. Devart.Dac.Design.dpk
@if errorlevel 1 goto Err

rem Compile CRControls package ===========================================
cd ..\..\CRGrid\Source\%IDEName%%IDEVer%
%IdeDir%\Bin\dccil.exe" -LE. Devart.Vcl.dpk -I..\..\..\Source -U..\..\..\Source\%IDEName%%IDEVer%;..\ -R..\..\..\Source\;..\
@if errorlevel 1 goto Err
cd ..\..\..\Source\%IDEName%%IDEVer%

rem Compile MyDAC packages ===========================================
%IdeDir%\Bin\dccil.exe" -LE. Devart.MyDac.dpk
@if errorlevel 1 goto Err

%IdeDir%\Bin\dccil.exe" -LE. Devart.MyDac.AdoNet.dpk
@if errorlevel 1 goto Err

%IdeDir%\Bin\dccil.exe" -LE. Devart.MyDac.Design.dpk
@if errorlevel 1 goto Err

rem Copy files ===========================================================
rem ======================================================================

copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\Devart.Vcl.dll            %PrjName%

copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\Devart.Vcl.dcpil          %PrjName%\CRGrid
copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\Devart.Vcl.CRGrid.dcuil   %PrjName%\CRGrid
copy ..\..\CRGrid\Source\CRGrid.res                   %PrjName%\CRGrid

copy *.dll               %PrjName%

copy *.dcuil             %PrjName%\Lib
copy *.dcpil             %PrjName%\Lib
copy ..\*.res            %PrjName%\Lib

goto end

:CBuilder
rem Compile ==============================================================
rem Compile DAC packages =================================================
cd %DacDir%

%IdeDir%\Bin\bpr2mak.exe" -t..\dac.bmk dac%PkgVer%.bpk
@if errorlevel 1 goto Err
%IdeDir%\Bin\make.exe" -f dac%PkgVer%.mak
@if errorlevel 1 goto Err

if %IDEVer%A==4A goto SkipCBVcl
if %IDEVer%A==5A goto SkipCBVcl
%IdeDir%\Bin\bpr2mak.exe" -t..\dac.bmk dacvcl%PkgVer%.bpk
@if errorlevel 1 goto Err
%IdeDir%\Bin\make.exe" -f dacvcl%PkgVer%.mak
@if errorlevel 1 goto Err

:SkipCBVcl

%IdeDir%\Bin\bpr2mak.exe" -t..\dac.bmk dcldac%PkgVer%.bpk
@if errorlevel 1 goto Err
%IdeDir%\Bin\make.exe" -f dcldac%PkgVer%.mak
@if errorlevel 1 goto Err

rem Compile CRControls package ===========================================
cd ..\..\CRGrid\Source\%IDEName%%IDEVer%

%IdeDir%\Bin\bpr2mak.exe" -t..\..\..\Source\dac.bmk CRControls%PkgVer%.bpk
@if errorlevel 1 goto Err
%IdeDir%\Bin\make.exe" -f CRControls%PkgVer%.mak
@if errorlevel 1 goto Err
cd ..\..\..\Source\%IDEName%%IDEVer%

rem Compile MyDAC packages ===========================================
%IdeDir%\Bin\bpr2mak.exe" -t..\dac.bmk %PrjNameL%%PkgVer%.bpk
@if errorlevel 1 goto Err
%IdeDir%\Bin\make.exe" -f %PrjNameL%%PkgVer%.mak
@if errorlevel 1 goto Err

if %IDEVer%A==4A goto SkipCB__Vcl
if %IDEVer%A==5A goto SkipCB__Vcl

%IdeDir%\Bin\bpr2mak.exe" -t..\dac.bmk %PrjNameL%vcl%PkgVer%.bpk
@if errorlevel 1 goto Err
%IdeDir%\Bin\make.exe" -f %PrjNameL%vcl%PkgVer%.mak
@if errorlevel 1 goto Err

:SkipCB__Vcl

%IdeDir%\Bin\bpr2mak.exe" -t..\dac.bmk dcl%PrjNameL%%PkgVer%.bpk
@if errorlevel 1 goto Err
%IdeDir%\Bin\make.exe" -f dcl%PrjNameL%%PkgVer%.mak
@if errorlevel 1 goto Err
%IdeDir%\Bin\bpr2mak.exe" -t..\dac.bmk dclmysqlmon%PkgVer%.bpk
@if errorlevel 1 goto Err
%IdeDir%\Bin\make.exe" -f dclmysqlmon%PkgVer%.mak
@if errorlevel 1 goto Err

rem Copy files ===========================================================
rem ======================================================================

copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\CRControls%PkgVer%.bpl    %PrjName%

copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\CRControls%PkgVer%.bpi    %PrjName%\CRGrid
copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\CRControls%PkgVer%.lib    %PrjName%\CRGrid

copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\CRGrid.obj                 %PrjName%\CRGrid
copy ..\..\CRGrid\Source\%IDEName%%IDEVer%\CRGrid.dcu                 %PrjName%\CRGrid
copy ..\..\CRGrid\Source\CRGrid.hpp                                   %PrjName%\CRGrid
copy ..\..\CRGrid\Source\CRGrid.res                                   %PrjName%\CRGrid

copy *.bpl               %PrjName%

copy *.dcu               %PrjName%\Dcu
copy ..\*.hpp            %PrjName%\Include
copy *.bpi               %PrjName%\Lib
copy *.lib               %PrjName%\Lib
copy *.obj               %PrjName%\Lib
copy ..\*.res            %PrjName%\Lib

goto end
:Err
pause

:end
popd
