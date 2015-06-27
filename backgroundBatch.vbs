' Running batch file in background script
Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")

' Select directory location of batch script file
WinScriptHost.Run Chr(34) & "C:\Scripts\chMacAddress.bat" & Chr(34), 0
Set WinScriptHost = Nothing

' Now you can make this a scheduled task!
