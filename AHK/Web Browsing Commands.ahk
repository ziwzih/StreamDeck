#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



^#r:: Reload
return



;#ifWinactive ahk_exe firefox.exe
#ifWinactive ahk_exe brave.exe

;;;;;;;;;;;;;; STREAM DECK BUTTONS ;;;;;;;;;;;;

F20:: ;Maxto right
	Send, #!{Right}
Return

F22:: ;Maxto left
	Send, #!{Left}
Return

F19::
	Send, ^t chrome://settings/
	Send, {Enter}
return

F23::
	Send, ^t chrome://extensions/
	Send, {Enter}
return


;;;;;;;;;;;;;;;;;;; General Chrome Hotkeys ;;;;;;;;;;;;;;;

^+e::
	clipboard =
	Send ^c
	ClipWait
	Send ^t^v {Enter}
return


^,:: 
	Send, ^t chrome://settings/
	Send, {Enter}
return


^+,::
	Send, ^t chrome://extensions/
	Send, {Enter}
return



F14:: 
	Send, !{Left}
return


F15:: 
	Send, !{Right}
return

F16:: ;cookie error bring you to search bar
	Send, ^t chrome://settings/
	Send, {Enter}
	sleep 1200
	Send, content
	sleep 1000
	Send, {Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Space}
	sleep 700
	Send, {Tab}{Tab}{Space}
	sleep 700
	Send, {Tab}{Tab}{Tab}{Tab}{Space}
	sleep 700
	Send, {Tab}
Return

F17:: ;cookie error GOOGLE
	Send, ^t chrome://settings/
	Send, {Enter}
	sleep 1200
	Send, content
	sleep 1000
	Send, {Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Space}
	sleep 700
	Send, {Tab}{Tab}{Space}
	sleep 700
	Send, {Tab}{Tab}{Tab}{Tab}{Space}
	sleep 700
	Send, {Tab}
	sleep 40
	send, www.google.com
	sleep 500
	Send, {Tab}{Tab}{Tab}{Space}
Return


F18::
	Send, ^t chrome://settings/
	Send, {Enter}
	sleep 1200
	Send, content
	sleep 1000
	Send, {Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Space}
	sleep 700
	Send, {Tab}{Tab}{Space}
	sleep 700
	Send, {Tab}{Tab}{Tab}{Tab}{Space}
	sleep 700
	Send, {Tab}
	sleep 40
	send, www.youtube.com
	sleep 500
	Send, {Tab}{Tab}{Tab}{Space}
Return