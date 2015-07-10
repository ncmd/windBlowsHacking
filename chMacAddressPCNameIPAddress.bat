
@Echo Off
Setlocal EnableDelayedExpansion
Set _RNDLength=3
Set _Alphanumeric1=00e03d4300000075aa17190000080bbd50c91007e0391000000d1b51e22b3fa990800024a0dcb800ed375117fc3a60000398
Set _Alphanumeric2=2f2190da47824ad1408bb4d621192a70ab87dcffc467cb471211407b76483f5090f39ef55ea65fec7e5eb3904600ee55a17a
Set _Alphanumeric3=62b0636f0352370432ff81b7459229bcaa5f10ee869048b5c9359c12e23bcce88d8ae7d3064cdb9a52f4141450c18e211242
Set _Alphanumeric4=d33b6d699cf62f6df15aaa3a83285f1b1ba3765a649ee4ddff7691c43c3874a7d821d4399ac97e0230ca2b0c05f4e1c844a3
Set _Str=%_Alphanumeric1%9876543210
Set _Str=%_Alphanumeric2%9876543210
Set _Str=%_Alphanumeric3%9876543210
Set _Str=%_Alphanumeric4%9876543210

:_LenLoop
IF NOT "%_Str:~18%"=="" SET _Str=%_Str:~9%& SET /A _Len+=9& GOTO :_LenLoop
SET _tmp=%_Str:~9,1%
SET /A _Len=_Len+_tmp
Set _count=0
SET _RndAlphaNum=
:_loop
Set /a _count+=1
SET _RND=%Random%
Set /A _RND=_RND%%%_Len%
SET _RndAlphaNum1=!_RndAlphaNum1!!_Alphanumeric1:~%_RND%,1!
SET _RndAlphaNum2=!_RndAlphaNum2!!_Alphanumeric2:~%_RND%,1!
SET _RndAlphaNum3=!_RndAlphaNum3!!_Alphanumeric3:~%_RND%,1!
SET _RndAlphaNum4=!_RndAlphaNum4!!_Alphanumeric4:~%_RND%,1!

If !_count! lss %_RNDLength% goto _loop
:: Batch registry command to edit registry
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0007 /v NetworkAddress /T REG_SZ /d "!_RndAlphaNum1!!_RndAlphaNum2!!_RndAlphaNum3!!_RndAlphaNum4!" /f
@echo off

@echo off
setlocal EnableDelayedExpansion
set "INPUT_FILE=C:\Users\PK\Desktop\LISTPC.txt"

:: # Count the number of lines in the text file and generate a random number
for /f "usebackq" %%a in (`find /V /C "" ^< %INPUT_FILE%`) do set lines=%%a
set /a randnum=%RANDOM% * lines / 32768 + 1, skiplines=randnum-1

:: # Extract the line from the file
set skip=
if %skiplines% gtr 0 set skip=skip=%skiplines%
for /f "usebackq %skip% delims=" %%a in (%INPUT_FILE%) do set "newPCNAME=%%a" & goto continue
:continue

::echo Line #%randnum% is:
::echo/!newPCNAME!

REG ADD HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName /v ComputerName /t REG_SZ /d !newPCNAME! /f
@echo off
timeout /t 3
netsh int ip set address "local area connection" dhcp
netsh int ip set address "local area connection" static %staticIP% %subnetmask%
netsh int ip set address "local area connection" dhcp
ipconfig/release
ipconfig/renew
:: Directory= HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0007
:: Network Adapter Interface = 0007 (Look at DriverDesc key to identify the interface. Ex. Intel(R) 82579LM Gigabit Network Connection)
:: Key to Edit=  NetworkAddress
:: Type of Key = REG_SZ
:: Modified Value = "%RND2%%RND3%%RND4%%RND1%"

:: Restart interface to make changes
@echo off
:: Waiting 3 seconds before disabling interface
timeout /t 3
netsh interface set interface "Local Area Connection" DISABLED
:: Waiting 3 seconds before enabling interface
timeout /t 3
netsh interface set interface "Local Area Connection" ENABLED

netsh int ip set address "local area connection" static %staticIP% %subnetmask%
