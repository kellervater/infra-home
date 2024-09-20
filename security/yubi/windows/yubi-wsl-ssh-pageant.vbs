Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run "C:\wsl-ssh-pageant\wsl-ssh-pageant-amd64.exe --winssh ssh-pageant --systray --wsl C:\wsl-ssh-pageant\ssh-agent.sock --force" , 0
Set WinScriptHost = Nothing
