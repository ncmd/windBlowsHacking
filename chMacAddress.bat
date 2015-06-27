:: In order to make this program in background use backgroundBatch.vbs

:: Randomly genereate 3 numbers 4 times to make up a MAC Address
set /A RND1=%RANDOM% %% 999 + 111
set /A RND2=%RANDOM% %% 999 + 111
set /A RND3=%RANDOM% %% 999 + 111
set /A RND4=%RANDOM% %% 999 + 111

:: Batch registry command to edit registry
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\0007 /v NetworkAddress /T REG_SZ /d "%RND2%%RND3%%RND4%%RND1%" /f

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
