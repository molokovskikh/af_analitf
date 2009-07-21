echo off
rem Path to DCC32.exe
SET DCCPATH=D:\Program Files\CodeGear\RAD Studio\6.0\bin\
rem Path to project Dir
rem SET PROJECTPATH=D:\Program Files\Devart\MyDac for RAD Studio 2009\Demos\Win32\ThirdParty\FastReport\FR4\Delphi12\
SET PROJECTPATH=D:\Projects\Delphi\MyDac\Demos\Win32\ThirdParty\FastReport\FR4\Delphi12\
rem FastReport 4 LibD12 Path
SET FRLIBDLLPATH=D:\Program Files\FastReports\FastReport 4\LibD12


echo on
rem -----------------------BEGIN------------------------------------------
echo off
cd "%PROJECTPATH%"

rem FastReport
"%DCCPATH%DCC32.EXE" -LE. -B -JL frxDAC12.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac120;fs12;fsDB12"
"%DCCPATH%DCC32.EXE" -LE. -B -JL frxMyDAC12.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac120;fs12;fsDB12"
"%DCCPATH%DCC32.EXE" -LE. -B -JL dclfrxMyDAC12.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac120;fs12;fsDB12"
rem FastScript
"%DCCPATH%DCC32.EXE" -LE. -B -JL fsDAC12.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac120;fs12;fsDB12"
"%DCCPATH%DCC32.EXE" -LE. -B -JL fsMyDAC12.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac120;fs12;fsDB12"
"%DCCPATH%DCC32.EXE" -LE. -B -JL dclfsMyDAC12.dpk -N0. -NO. -NH. -NB. -U"..\;%FRLIBDLLPATH%" -I"..\;%FRLIBDLLPATH%" -LU"dac120;fs12;fsDB12"