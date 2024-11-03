@REM TPPATH - папка с компилятором tpc.exe для Borland Turbo Pascal 7.0
@REM TASMPATH - папка с ассемблером TASM 3.2 (Borland)
@REM TPUPATH - папка с модулями Turbo Pascal - туда будет скопирован mb2.tpu
@SET TPPATH=C:\SYS\TP\BIN
@SET TPUPATH=C:\SYS\TP\UNITS
@SET TASMPATH=%TPPATH%
@
@CLS
@ECHO yeaR 2o24 coMeZ With the New veRsioN oF MB2 ;)
@ECHO BuiLDiNG McGaBase 2.6 tpu...
@PAUSE
@
%TASMPATH%\tasm mb2.asm
@
%TPPATH%\tpc -$D- -$S- MB2.PAS
@
@del mb2.obj
@
@ECHO copyiNG mb2.tpu...
copy mb2.tpu %TPUPATH%\*.*
@
@ECHO.
@ECHO BuiLDiNG coMpLeteD!
