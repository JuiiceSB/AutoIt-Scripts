#NoTrayIcon
#include <Array.au3>
#include <Date.au3> ; needed to read system time
#include <Misc.au3> ; needed for _Singleton
#include <Timers.au3> ; needed to read system idle time
#include <Misc.au3>

$S_running = "IdleUserCloseProgram"; Same name as script
If WinExists($S_running) Then Exit
AutoItWinSetTitle($S_running)

Opt("WinTitleMatchMode", 2) ;1 = Start of String, 2 = Match any substring in the title, 3 = Exact title match, 4 = Search Advanced Mode on Gooogle.
Opt("TrayIconDebug", 1)

$TimerInterval = 1 * 60 * 1000 ; 1 minute

$SecondsInactiveWindowIsIdle = 60 ; 1 minute

;Close process between these times regardless of activity.
;$StartTime = "0300"
;$EndTime = "0310"

; Array list of all possible windows. Using the option to match on start of string above
; keeps this list shorter than a complete list of all windows.
Global $WinList[1]
$WinList[0] = "Google" ; example
;$WinList[1] = "Settings" ; example
;...

$Seconds = 0

;Loop:
While 1
    ; Don't run if program is not already running.

    ; If Program is running between the times listed above, close it.
    ;$CurrentTime = @HOUR & @MIN
    ;If $CurrentTime <= $EndTime and $CurrentTime >= $StartTime Then
    ;    ProcessClose("Program.exe")
    ;   ContinueLoop
    ;EndIf

    $ActiveWindowFound = 0 ; Used to determine whether or not we found an active window.
    For $i = 0 To 40 ; Loop through the window list to see if the window is active.
        $State = WinGetState($WinList[$i])

        If $State = 15 Or $State = 47 Then ; 15 = Window is active, 47 = Window is active and maximized.
            $ActiveWindowFound = 1
            $Seconds = 0
            If _Timer_GetIdleTime() >= $TimerInterval And ProcessExists("Program.exe")  Then ; Check to see if system idle time is greater than threshold defined above. If it is, show the message.
                Do
                    ;SplashTextOn("Program Timeout Reached", "Program has been idle for longer than 1 minute." _
                    ;              & @CRLF & @CRLF & "Program will be shut down in the next minute.", 500, 250, -1, -1, -1, "", 20, 900)

                    ;$SecondCounter = 0
                    ;Do ; This loop checks for the idle time to reset. If it resets, exit to the parent loop and start over.
                    ;    If _Timer_GetIdleTime() < $TimerInterval Then
                    ;        SplashOff()
                    ;        ContinueLoop 2 ; Exits to the For loop to start looking through the windows again.
                    ;    EndIf

                    ;    $SecondCounter += 1
                    ;    Sleep(1000)
                    ;Until $SecondCounter > 60 ; Continues checking for idle time for one minutes before shutting down program.

                    ;SplashOff()
                    ProcessClose("Program.exe")
					$Seconds = 0 ;After close process reset count to avoid bugs.
                    ;Sleep(10 * 1000) ; Give ten seconds to close before hitting the end of the loop. This insures that the splash text stays off.

                Until _Timer_GetIdleTime() < $TimerInterval or Not ProcessExists("Program.exe")
            EndIf
        EndIf

        If $ActiveWindowFound = 1 Then ; If we found an active window, stop looking at windows.
            ExitLoop
        EndIf
    Next

		 If $Seconds >= $SecondsInactiveWindowIsIdle And ProcessExists("Program.exe") Then ; Check to see if the number of seconds program has not been active is greater than threshold defined above.
			;Do
            ;        SplashTextOn("Program Timeout Reached", "Program has been idle for longer than 1 minute." _
            ;                      & @CRLF & @CRLF & "Program will be shut down in the next minute.", 500, 250, -1, -1, -1, "", 20, 900)

            ;$SecondCounter = 0
            Do
                For $i = 0 To 40 ; Loop through the window list to see if a window has become active. If one has become active, reset seconds inactive counter.
                    $State = WinGetState($WinList[$i])
                        If $State = 15 Or $State = 47 Then
                            $Seconds = 0
                        EndIf
                Next

                ;If $Seconds < $SecondsInactiveWindowIsIdle Then
                ;    SplashOff()
                ;    ContinueLoop 2
				;	 EndIf

                ;$SecondCounter += 1
                ;Sleep(1000)
            ;Until $SecondCounter > 120

            ;SplashOff()
            ProcessClose("Program.exe")
			$Seconds = 0 ;After close process reset count to avoid bugs.
            ;Sleep(10 * 1000) ; Give Chameleon ten seconds to close before hitting the end of the loop. This insures that the splash text stays off.

        Until $Seconds < $SecondsInactiveWindowIsIdle or Not ProcessExists("Program.exe")
    EndIf
    ;This if is setup to avoid bug where scripts keep counting when process is closed and if you try to open program again and count > $SecondsInactiveWindowIsIdle keeps closing process forever.
    if ProcessExists("Program.exe") Then $Seconds += 1

    ;ToolTip("count = " & $Seconds, 0, 0, "state = " & $state) ; Used for troubleshooting. Leave commented out for normal execution.
    Sleep(1000) ; reloop in 1 sec
WEnd