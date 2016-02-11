@ECHO OFF
cls
echo A.D.A.P.T.
echo --------------------
echo (A)dvanced
echo (D)eveloper
echo (A)sync
echo (P)rogramming
echo (T)oolkit
echo.
echo Copyright (C) 2014-2016, Simon J Stuart, All Rights Reserved
echo Formerly known as LaKraven Studios Standard Library [LKSL]
echo.
echo Setting Environment Variables for ADAPT Paths

echo Registering ADAPT_HOME
setx ADAPT_HOME %~dp0
echo registering ADAPT_PASCAL
setx ADAPT_PASCAL %~dp0Source\Pascal\Lib
echo ADAPT Paths added...
echo -------------------
echo The following Environment Variables have been registered:
echo ADAPT_HOME		Points to the ADAPT Root Directory
echo ADAPT_PASCAL		Points to $(ADAPT_LIB)\Pascal

pause