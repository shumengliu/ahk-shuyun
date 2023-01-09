; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input") ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir) ; Ensures a consistent starting directory.

; a map that maps app names to paths
apps := Map()
Loop read, "apps.csv"
{
    ; skip empty lines and comments starting with 
    if (StrLen(A_LoopReadLine) = 0)
        continue
    ; skip comments starting with #
    if (Substr(A_LoopReadLine, 1, 1) = "#")
        continue
    ; split the line into two parts
    parts := StrSplit(A_LoopReadLine, ",")
    ; the first part is the app name
    appName := Trim(parts[1])
    ; the second part is the app path
    appPath := Trim(parts[2])
    ; add the app to the map
    apps[appName] := appPath
}

StartApp(appPath)
{
    { ErrorLevel := "ERROR"
        Try ErrorLevel := Run(appPath, , "", &process_id)
    }
}

; Alt + Y for starting any app
!Y::
    {
        ; create an inputbox that specifies which app to start
        IB := InputBox("", "Which app do you want to start?"), appName := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
        ; check if the app exists
        if (not apps.Has(appName))
        {
            MsgBox "App Not Found"
            return
        }
        appPath := apps[appName]
        StartApp(appPath)
        return
    }

; Alt + T for Windows Terminal
!T::
    {
        if WinExist("Windows PowerShell")
        {
            WinActivate()
            #WinActivateForce
        }
        if not WinExist("Windows PowerShell")
        {
            { ErrorLevel := "ERROR"
                Try ErrorLevel := Run("`"C:\Users\Shumeng\AppData\Local\Microsoft\WindowsApps\wt.exe`"", , "", &process_id)
            }
        }
        return

    }