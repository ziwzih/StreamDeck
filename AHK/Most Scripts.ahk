#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Menu, Tray, Icon, shell32.dll, 42 ; changes the icon to a (\) thingy


; Disable stand-alone Alt key press: make Alt purely a modifier key.
; The If statement is required to get Alt+Shift work as expected. If it's not
; there, only [Press Alt], [Press Shift], [Release Shift], [Release Alt] would
; trigger the input language change. The other, more common sequence would be
; [Press Alt], [Press Shift], [Release  Alt], [Release Shift], but AutoHotKey
; would block it before it reaches Windows if the "#If" isn't there.

;;;;;;;;;;;;;;;;;;;EXPLORER STREAM DECK MAXTO MOVEMENT

#IfWinActive ahk_exe explorer.exe

F20::
	Send, ^!+{Right}
Return

F21::
	Send, ^!+{Down}
Return

F22::
	Send, ^!+{Left}
Return

F23::
	Send, ^!+{Up}
Return

#IfWinActive 


;;;;;;;;;;;;;;;;;ONE COMMANDER STREAM DECK MAATO MOVEMENT;;;;;;;;;;;;;;;;

#IfWinActive ahk_exe OneCommanderV2.exe

F20::
	Send, ^!+{Right}
Return

F21::
	Send, ^!+{Down}
Return

F22::
	Send, ^!+{Left}
Return

F23::
	Send, ^!+{Up}
Return

#IfWinActive 


;;;;;;;;;;;;;;AHK;;;;;;;;;;;;;;;


#r:: Reload
return

#!c:: Send, {Home};
#+!c:: Send, {Home}{Delete}
return


;;;;;;;;;;TOUCHCURSOR;;;;;;;;;

;turn it off

^F23:: 
	Run, C:\Program Files (x86)\TouchCursor\tcconfig.exe
	Sleep 700
	Send, {Tab}{Space}
	Sleep 20
	Send, {Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Tab}{Space}
return


;;;;;;;;;;;;;;;;;;;; -------- APPLICATION SWITCHING ------------;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;; ------ CONTROLS ---------;;;;;;;;;;;;;;;;

#IfWinActive

^F12::back()

;macro key G17
^Numpad1::switchToExplorer()

!^F10::closeAllExplorers()

;macro key G18
^F9::switchToPremiere()

;No K95 macro key assigned:
^Numpad0::switchToChrome()

^Numpad3::switchToBrave()

; Numpad5:: switchToTCC ()

^Numpad5:: 
	Run, C:\Program Files (x86)\TouchCursor\tcconfig.exe

^Numpad6::switchToPremiere()

return


;macro key G14
+^F7::
windowSaver()
msgbox,,, savedCLASS = %savedCLASS% `nsavedEXE = %savedEXE%, 0.6
Return

;Macro key G14
^F6::
;I had to learn just now to use the parameter to pass "savedCLASS" even though it's already a global variable. Just works better this way... but really IDK what i am doing.
;msgbox,,, switching to `nsavedCLASS = %savedCLASS% `nsavedEXE = %savedEXE%,0.3
switchToSavedApp(savedCLASS) 
return

;;;;;;;;;;;;; ------- SCRIPT --------;;;;;;;;;;;;;;;;;


#IfWinActive


windowSaver()
{
WinGet, lolexe, ProcessName, A
WinGetClass, lolclass, A ; "A" refers to the currently active window
global savedCLASS = "ahk_class "lolclass
global savedEXE = lolexe ;is this the way to do it? IDK.
;msgbox, %savedCLASS%
;msgbox, %savedEXE%
}

;SHIFT + macro key G14


global savedCLASS = "ahk_class Notepad++"
global savedEXE = "notepad++.exe"

switchToSavedApp(savedCLASS)
{
;msgbox,,, savedCLASS is %savedCLASS%,0.5
;msgbox,,, savedexe is %savedEXE%,0.5
if savedCLASS = ahk_class Notepad++
	{
	;msgbox,,, is notepad++,0.5
	if WinActive("ahk_class Notepad++")
		{
		sleep 5
		Send ^{tab}
		}
	}
;msgbox,,,got to here,0.5
windowSwitcher(savedCLASS, savedEXE)
}



back(){
;; if WinActive("ahk_class MozillaWindowClass")
;tooltip, baaaack
if WinActive("ahk_exe firefox.exe")
	Send ^+{tab}
if WinActive("ahk_class Chrome_WidgetWin_1")
	Send ^+{tab}
if WinActive("ahk_class Notepad++")
	Send ^+{tab}
if WinActive("ahk_exe Adobe Premiere Pro.exe")
	Send ^!+b ;ctrl alt shift B  is my shortcut in premiere for "go back"(in bins)(the project panel)
if WinActive("ahk_exe explorer.exe")
	Send !{left} ;alt left is the explorer shortcut to go "back" or "down" one folder level.
if WinActive("ahk_class OpusApp")
	sendinput, {F2} ;"go to previous comment" in Word.
}

;macro key 16 on my logitech G15 keyboard. It will activate firefox,, and if firefox is already activated, it will go to the next window in firefox.

switchToFirefox(){
sendinput, {SC0E8} ;scan code of an unassigned key. Do I NEED this?
IfWinNotExist, ahk_class MozillaWindowClass
	Run, firefox.exe
if WinActive("ahk_exe firefox.exe")
	{
	WinGetClass, class, A
	if (class = "Mozillawindowclass1")
		msgbox, this is a notification
	}
if WinActive("ahk_exe firefox.exe")
	Send ^{tab}
else
	{
	;WinRestore ahk_exe firefox.exe
	WinActivatebottom ahk_exe firefox.exe
	;sometimes winactivate is not enough. the window is brought to the foreground, but not put into FOCUS.
	;the below code should fix that.
	WinGet, hWnd, ID, ahk_class MozillaWindowClass
	DllCall("SetForegroundWindow", UInt, hWnd) 
	}
}


#IfWinActive
;Press SHIFT and macro key 16, and it'll switch between different WINDOWS of firefox.

switchToOtherFirefoxWindow(){
;sendinput, {SC0E8} ;scan code of an unassigned key
Process, Exist, firefox.exe
;msgbox errorLevel `n%errorLevel%
	If errorLevel = 0
		Run, firefox.exe
	else
	{
	GroupAdd, taranfirefoxes, ahk_class MozillaWindowClass
	if WinActive("ahk_class MozillaWindowClass")
		GroupActivate, taranfirefoxes, r
	else
		WinActivate ahk_class MozillaWindowClass
	}
}



; This is a script that will always go to The last explorer window you had open.
; If explorer is already active, it will go to the NEXT last Explorer window you had open.
; CTRL Numpad2 is pressed with a single button stoke from my logitech G15 keyboard -- Macro key 17. 

switchToExplorer(){
IfWinNotExist, ahk_class CabinetWClass
	Run, explorer.exe
GroupAdd, taranexplorers, ahk_class CabinetWClass
if WinActive("ahk_exe explorer.exe")
	GroupActivate, taranexplorers, r
else
	WinActivate ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
}

; ;trying to activate these windows in reverse order from the above. it does not work.
; ^+F2::
; IfWinNotExist, ahk_class CabinetWClass
	; Run, explorer.exe
; GroupAdd, taranexplorers, ahk_class CabinetWClass
; if WinActive("ahk_exe explorer.exe")
	; GroupActivate, taranexplorers ;but NOT most recent.
; else
	; WinActivatebottom ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
; Return

;closes all explorer windows :/
;^!F2 -- for searchability

closeAllExplorers()
{
WinClose,ahk_group taranexplorers
}


switchToPremiere(){
IfWinNotExist, ahk_class Premiere Pro
	{
	;Run, Adobe Premiere Pro.exe
	;Adobe Premiere Pro CC 2017
	; Run, C:\Program Files\Adobe\Adobe Premiere Pro CC 2017\Adobe Premiere Pro.exe ;if you have more than one version instlaled, you'll have to specify exactly which one you want to open.
	Run, Adobe Premiere Pro.exe
	}
if WinActive("ahk_class Premiere Pro")
	{
	IfWinNotExist, ahk_exe notepad++.exe
		{
		Run, notepad++.exe
		sleep 200
		}
	WinActivate ahk_exe notepad++.exe ;so I have this here as a workaround to a bug. Sometimes Premeire becomes unresponsive to keyboard input. (especially after timeline scrolling, especially with a playing video.) Switching to any other application and back will solve this problem. So I just hit the premiere button again, in those cases.g
	sleep 10
	WinActivate ahk_class Premiere Pro
	}
else
	WinActivate ahk_class Premiere Pro
}


switchToWord()
{
Process, Exist, WINWORD.EXE
;msgbox errorLevel `n%errorLevel%
	If errorLevel = 0
		Run, WINWORD.EXE
	else
	{
	IfWinExist, Microsoft Office Word, OK ;checks to see if the annoying "do you want to continue searching from the beginning of the document" dialouge box is present.
		sendinput, {escape}
	else if WinActive("ahk_class OpusApp")
		sendinput, {F3} ;set to "go to next comment" in Word.
	else
		WinActivate ahk_class OpusApp
	}
}


switchWordWindow()
{
; Process, Exist, WINWORD.EXE
; ;msgbox errorLevel `n%errorLevel%
	; If errorLevel = 0
		; Run, WINWORD.EXE
	; else
	; {
	GroupAdd, taranwords, ahk_class OpusApp
	if WinActive("ahk_class OpusApp")
		GroupActivate, taranwords, r
	else
		WinActivate ahk_class OpusApp
	; }
}


switchToChrome()
{
IfWinNotExist, ahk_exe chrome.exe
	Run, chrome.exe

if WinActive("ahk_exe chrome.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe chrome.exe
}


; switchToBrave()
; {
; IfWinNotExist, ahk_exe brave.exe
; 	Run, brave.exe

; if WinActive("ahk_exe brave.exe")
; 	Sendinput ^{tab}
; else
; 	WinActivate ahk_exe brave.exe
; }


switchToBrave()
{
IfWinNotExist, ahk_exe brave.exe
	Run, brave.exe
GroupAdd, jeremyisbrave, ahk_exe brave.exe
if WinActive("ahk_exe brave.exe")
	GroupActivate, jeremyisbrave, r
else
	WinActivate ahk_exe brave.exe ;you have to use WinActivatebottom if you didn't create a window group.
}


switchToTCC()
{
IfWinNotExist, ahk_exe tcconfig.exe
	Run, tcconfig.exe

if WinActive("ahk_exe tcconfig.exe")
	Sendinput ^{tab}
else
	WinActivate ahk_exe tcconfig.exe
}


switchToStreamDeck(){
IfWinNotExist, ahk_exe StreamDeck.exe
	{
	Run, C:\Program Files\Elgato\StreamDeck\StreamDeck.exe
	}
else
	{
	WinActivate ahk_exe StreamDeck.exe
	}
}


#IfWinActive
windowSwitcher(theClass, theEXE)
{
;msgbox,,, switching to `nsavedCLASS = %theClass% `nsavedEXE = %theEXE%, 0.5
IfWinNotExist, %theClass%
	Run, % theEXE
if not WinActive(theClass)
	WinActivate %theClass%
}



;---------------------------------------------------------------------------------
;Run Function - Running specific executable
F_Run(Target,TPath = 0)
{
if TPath = 0 
	Run, %Target%
else
	Run, %TPath% ;Command for running target if conditions are satisfied
}

;---------------------------------------------------------------------------------
;Switch Function - Switching between different instances of the same executable or running it if missing
F_Switch(Target,TClass,TGroup,TPath = 0)
{
IfWinExist, ahk_exe %Target% ;Checking state of existence
	{
	GroupAdd, %TGroup%, %TClass% ;Definition of the group (grouping all instance of this class) (Not the perfect spot as make fo unnecessary reapeats of the command with every cycle, however the only easy option to keep the group up to date with the introduction of new instances)
	ifWinActive %TClass% ;Status check for active window if belong to the same instance of the "Target"
		{
		GroupActivate, %TGroup%, r ;If the condition is met cycle between targets belonging to the group
		}
	else
		WinActivate %TClass% ;you have to use WinActivatebottom if you didn't create a window group.
	}
else
	{
	if TPath = 0 
		Run, %Target%
	else
		Run, %TPath% ;Command for running target if conditions are satisfied
	}
Return
}


;;;;;;;;;;;;;;JP KANA KEY TESTS;;;;;;;;;;;;;


;SC07B:: Send {ShiftDown}
;return

;SC07B:: Send {AltDown}
;Loop
;{
 ;   Sleep, 100
  ;  if !GetKeyState("SC07B", "P") 
   ;     break
;}
;Send {AltUp}
;return


;#InstallKeybdHook


;;;;;;;;;;;;;;;;;;;;MAC KEYBOARD;;;;;;;;;;;;;;;;;


; CapsLock::Ctrl
; return

!F3:: volume_Up
!F2:: volume_Down
return

;Special remap for LWin & Tab to AltTab 
;LWin & Tab::AltTab 
;All other LWin presses will be LAlt 
;LWin::Send {LAlt}
; Makes the Alt key send a Windows key
;LAlt::Send {RWin}
;return

;LWin & Tab::AltTab 
;LWin::Send {LAlt}
;LAlt::Send {RWin}
;return




;;;;;;;;;ARROWS UNDER ALT;;;;;;;;;;;

!e:: Send, {Up}
!d:: Send {Down}
!s:: Send {Left}
!f:: Send {Right}
!+f:: Send +{Right}
!+s:: Send +{Left}
!^s:: Send ^{Left}
!^f:: Send ^{Right}
return 

;;;;;;;;;;;;;;;;;;;;SPACEBAR Alt;;;;;;;;;;;;;;;;;

; $space::
   ; send {LShift down} 
   ; Spacedown := A_TickCount 
   ; Return    
; $+space up::
  ;; The space-down set the shift-key, so the space-up event is now shift+space-up
   ; send {LShift up}   
   ; if (A_TickCount - Spacedown <200) 
    ;;  If short time between space-down and space-up...  
      ; Send {Space}
   ; Return

   
   

; space & e:: Send {Up}
; space & d:: Send {Down}
; space & f:: Send {Right}
; space & s:: Send {Left}  
; return


; space::
	; Send {space}
; return

; space & f::
	; Send, {Right}

	; GetKeyState, state, LShift
	; if state = D
		; Send, +{Right}
	
	; GetKeyState, state, LCtrl
	; if state = D
		; Send, ^{Right}
; return

; space & s::
	; Send, {Left}

	; GetKeyState, state, LShift
	; if state = D
		; Send, +{Left}
	
	; GetKeyState, state, LCtrl
	; if state = D
		; Send, ^{Left}
; return

; space & e::
	; Send, {Up}

	; GetKeyState, state, LShift
	; if state = D
		; Send, +{Up}
	
	; GetKeyState, state, LCtrl
	; if state = D
		; Send, ^{Up}
; return

; space & d::
	; Send, {Down}

	; GetKeyState, state, LShift
	; if state = D
		; Send, +{Down}
	
	; GetKeyState, state, LCtrl
	; if state = D
		; Send, ^{Down}
; return


;;;;;;;;;;WINDOWS SHIORTCUTS;;;;;;;;;;;


^backspace:: Send, {LShift down}^{Left}{LShift up}{Backspace}
return

#+d::
Run, "C:\Users\jerem\Downloads"
return



; Disable stand-alone Alt key press: make Alt purely a modifier key.
; The If statement is required to get Alt+Shift work as expected. If it's not
; there, only [Press Alt], [Press Shift], [Release Shift], [Release Alt] would
; trigger the input language change. The other, more common sequence would be
; [Press Alt], [Press Shift], [Release  Alt], [Release Shift], but AutoHotKey
; would block it before it reaches Windows if the "#If" isn't there.

	;#If not GetKeyState("LShift", "P")
		;~LAlt::
		;KeyWait, LAlt
	;return

; Make Alt+Something still work:
	;~LAlt Up::
    ;Send, {LAlt Up}
;return

;clipboard = %clipboard%
;Send, ^{vk56} ;Ctrl V
;return

#b::
	Run, bthprops.cpl
return

!^0::
	Send, {Numpad0}
return 

#f::
	Run, C:\Program Files\WindowsApps\44576milosp.OneCommander_2.4.5.0_neutral__p0rg76fmnrgsm\Rapidrive\OneCommanderV2.exe
Return



;;;;;;;;;;;;;;;;;;;;;;JP KEYBOARD ASSIGNMENTS;;;;;;;;;;;;;;;;;;;;;;;

#InputLevel 1
	$SC07D::
Send, {BackSpace}

>+Left::
Send, {Home}
return

>+Right::
	Send, {End}
return

SC073::
	Send, {Home}
return

SC136::
	Send, {End}
return

+SC073::
	Send, {Shift Down}{Home}{Shift Up}
return

+SC136::
	Send, +{End}
return




;need to figure out a better way of doing this but it will work
;+^Right:: Send, {End}  
;+^Left:: Send, {Home}
;return




;;;;;;;;;;;;;;;;;PREMIERE PRO;;;;;;;;;;;;;;;

#ifwinactive ahk_exe adobe premiere pro.exe

^1:: Send ^+a^c+3^v+3
return

; +F1:: Send, {Tab}{Tab}{Tab}{Tab}3840{Tab}2160{Enter}
; return

; ^b:: Send t+b
; return

!+^e:: 
	Send {Up}
!+^d:: 
	Send {Down}
return

^2::
	Send, c+3 {Up}m {Down}
return

F12::
	sendinput, ^+!0
	sendinput, ^\
return

Numpad7::
	sendinput, ^+!0
	sendinput, ^\
return

F9::
sendinput, {Enter}{Left}0
return

F16:: 
	Send, !^+v
return

^F24:: ;space + B
	Sendinput, t
	KeyWait 5,
	Send, {BackSpace}
return


F21:: ;space + T
	!+t
return

; +F1::
	; send, ^r40
	; Send, {Enter}
; return

^+b::
	Send, +4
	sleep 20
	Send, ^!+b
return

^b::
	Send, t
	sleep 10
	Send, +b
Return



; ^!o::
; Gui, Add, text, , Enter #:
; Gui, Add, Edit, vNum
; Gui, Add, Button, default, OK
; Gui, Show
; Return

; GuiClose:
; ButtonOK:
; Gui, Submit

; Loop, %Num%
; {
;  msgbox, Hello

; }
; return


; ^!o::
; Gui, Add, text, , Enter #:
; Gui, Add, Edit, vNum
; Gui, Add, Button, default, OK
; Gui, Show
; Return

; GuiClose:
; ButtonOK:
; Gui, Submit

; Loop, %Num%t


; sendinput, t 
; Sleep 500
; sendinput, F8
; Sleep 500
; sendinput, {Enter}
; Sleep 500
; sendinput, +3
; Sleep 300
; sendinput, {Down}
; Sleep 1000


; Gui, Destroy
; Return




; ^!o::
; #SingleInstance, force

; InputBox, loopCount,,Enter a number for loop count

; loop, %loopCount% {
; sendinput, t 
; Sleep 1000
; sendinput, 
; Sleep 1000
; sendinput, {Enter}
; Sleep 1000
; sendinput, +3
; Sleep 1000
; sendinput, {Down}
; Sleep 1000
; }

; msgbox, all done
; return


!^i::
sendinput, t 
Sleep 1000
sendinput, +c
Sleep 1000
sendinput, {Enter}
Sleep 1000
sendinput, +3
Sleep 1000
sendinput, {Down}
Sleep 1000
return


!^o::
InputBox, count, Sequence to Subclip, Enter number of subclips to make.

loop, %count% {
sendinput, t 
sendinput, +c
Sleep 20
sendinput, {Enter}
Sleep 20
sendinput, +3
Sleep 5
sendinput, {Down}
Sleep 5
;   tooltip, Loop #: %A_Index%
;   #Persistent
; SetTimer, RemoveToolTip, -1000
; return

; RemoveToolTip:
; ToolTip
; return
}
; MsgBox, Subclips Made
return

^esc::ExitApp




;;;;;;;;;;FUNCTION FOR DIRECTLY APPLYING A PRESET EFFECT TO A CLIP!;;;;;;;;;;;;
; preset() is my most used, and most useful AHK function! There is no good reason why Premiere doesn't have this functionality.
;keep in mind, I use 150% UI scaling, so your pixel distances for commands like mousemove WILL be different!
;to use this script yourself, carefully go through  testing the script and changing the values, ensuring that the script works, one line at a time. use message boxes to check on variables and see where the cursor is. remove those message boxes later when you have it all working!
#IfWinActive ahk_exe Adobe Premiere Pro.exe
preset(item)
{
Sendinput, ^!+k ;shuttle STOP
;Keyshower(item,"preset") ;YOU DO NOT NEED THIS LINE. -- it simply displays keystrokes on the screen for the sake of tutorials... IF the function "keyshower" has been defined.

if IsFunc("Keyshower") {
	Func := Func("Keyshower")
	RetVal := Func.Call(item,"preset") 
}

ifWinNotActive ahk_exe Adobe Premiere Pro.exe
	goto theEnding ;and this line is here just in case the function is called while not inside premiere.

sleep 10
Send ^!+k ; another shortcut for Shuttle Stop. CTRL ALT SHIFT K. Set this in Premiere's shortcuts panel.
;so if the video is playing, this will stop it. Othewise, it can mess up the script.

sleep 5

;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.

coordmode, pixel, Window
coordmode, mouse, Window
coordmode, Caret, Window


;This (temporarily) blocks the mouse and keyboard from sending any information, which could interfere with the funcitoning of the script.
BlockInput, SendAndMouse
BlockInput, MouseMove
BlockInput, On

SetKeyDelay, 0 ;this ensures that any text AutoHotKey "types in," will input instantly, rather than one letter at a time.

MouseGetPos, xposP, yposP ;---stores the cursor's current coordinates at X%xposP% Y%yposP%
send, {mButton} ;this will MIDDLE CLICK to bring focus to the panel underneath the cursor (the timeline). I forget exactly why, but if you create a nest, and immediately try to apply a preset to it, it doesn't work, because the timeline wasn't in focus...?
;but i just tried that and it still didn't work...
;;DAMN IT, i forgot the { } and it was sending those as letters, I am an idiot. Need better diagnostics tools...

Send ^+!7 ;CTRL SHIFT ALT 7 --- you must set this in premiere's keyboard shortcuts menu to the "effects" panel

sleep 20 ;"sleep" means the script will wait for 20 milliseconds before the next command. This is done to give Premiere some time to load its own things.

Send ^b ;CTRL B -- set in premiere to "select find box"
sleep 20

;Any text in the Effects panel's find box has now been highlighted. There is also a blinking "text insertion point" at the end of that text. This is the vertical blinking line, or "caret." 

MouseMove, %A_CaretX%, %A_CaretY%, 0
sleep 15
MouseMove, %A_CaretX%, %A_CaretY%, 0

;and fortunately, AHK knows the exact X and Y position of this caret. So therefore, we can find the effects panel find box, no matter what monitor it is on, with 100% consistency.

sleep 15
;msgbox, carat X Y is %A_CaretX%, %A_CaretY%

MouseGetPos, , , Window, classNN
WinGetClass, class, ahk_id %Window%
;msgbox, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%
;;;I think ControlGetPos is not affected by coordmode??  Or at least, it gave me the wrong coordinates if premiere is not fullscreened... https://autohotkey.com/docs/commands/ControlGetPos.htm 
ControlGetPos, XX, YY, Width, Height, %classNN%, ahk_class %class%, SubWindow, SubWindow ;-I tried to exclude subwindows but I don't think it works...?
;;my results:  59, 1229, 252, 21,      Edit1,    ahk_class Premiere Pro

;msgbox, classNN = %classNN%
;now we have found a lot of useful informaiton about this find box. Turns out, we don't need most of it...
;we just need the X and Y coordinates of the "upper left" corner...

;comment in the following line to get a message box of your current variable values. The script will not advance until you dismiss the message box.
;MsgBox, xx=%XX% yy=%YY%

MouseMove, XX-15, YY+5, 0 ;-----------------------moves cursor onto the magnifying glass
;msgbox, should be in the center of the magnifying glass now.
sleep 5
;This types in the text you wanted to search for. Like "pop in." We can do this because the entire find box text was already selected by Premiere. Otherwise, we could click the magnifying glass if we wanted to , in order to select that find box.

Send %item%

sleep 30
MouseMove, 28, 48, 0, R ;----------------------relative to the position of the magnifying glass (established earlier,) this moves the cursor down and directly onto the preset's icon. In my case, it is inside the "presets" folder, then inside of another folder, and the written name sohuld be compeltely unique so that it is the first and only item.

;msgbox, The cursor should be directly on top of the preset's icon. `n If not, the script needs modification.


sleep 5

MouseGetPos, iconX, iconY, Window, classNN ;---now we have to figure out the ahk_class of the current panel we are on. It used to be DroverLord - Window Class14, but the number changes anytime you move panels around... so i must always obtain the information anew.

sleep 5

WinGetClass, class, ahk_id %Window% ;----------"ahk_id %Window%" is important for SOME REASON. if you delete it, this doesnt work.
;msgbox, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%

ControlGetPos, xxx, yyy, www, hhh, %classNN%, ahk_class %class%, SubWindow, SubWindow ;-I tried to exclude subwindows but I don't think it works...?

MouseMove, www/4, hhh/2, 0, R ;-----------------clicks in about the CENTER of the Effects panel. This clears the displayed presets from any duplication errors. VERY important. without this, the script fails 20% of the time.

sleep 5

MouseClick, left, , , 1 ;-----------------------the actual click

sleep 10

MouseMove, iconX, iconY, 0 ;--------------------moves cursor BACK onto the effect's icon

sleep 35

MouseClickDrag, Left, , , %xposP%, %yposP%, 0 ;---clicks the left button down, drags this effect to the cursor's pervious coordinates and releases the left mouse button, which should be above a clip, on the TIMELINE panel.

sleep 10


MouseClick, middle, , , 1 ;this returns focus to the panel the cursor is hovering above, WITHOUT selecting anything. great!



blockinput, MouseMoveOff ;returning mouse movement ability
BlockInput, off ;do not comment out or delete this line -- or you won't regain control of the keyboard!! However, CTRL+ALT+DEL will still work if you get stuck!! Cool.


theEnding:
}
;END of preset()

+!F1::preset("warp stabilizer 30%")
Return










;;;;;;;;;;;;; AUDIO TRANSITIONS ;;;;;;;;;;;;;


; preset() is my most used, and most useful AHK function! There is no good reason why Premiere doesn't have this functionality.
;keep in mind, I use 150% UI scaling, so your pixel distances for commands like mousemove WILL be different!
;to use this script yourself, carefully go through  testing the script and changing the values, ensuring that the script works, one line at a time. use message boxes to check on variables and see where the cursor is. remove those message boxes later when you have it all working!
#IfWinActive ahk_exe Adobe Premiere Pro.exe
sfx(item)
{
Sendinput, ^!+k ;shuttle STOP
;Keyshower(item,"preset") ;YOU DO NOT NEED THIS LINE. -- it simply displays keystrokes on the screen for the sake of tutorials... IF the function "keyshower" has been defined.

if IsFunc("Keyshower") {
	Func := Func("Keyshower")
	RetVal := Func.Call(item,"sfx") 
}

ifWinNotActive ahk_exe Adobe Premiere Pro.exe
	goto theEnding2 ;and this line is here just in case the function is called while not inside premiere.

sleep 10
Send ^!+k ; another shortcut for Shuttle Stop. CTRL ALT SHIFT K. Set this in Premiere's shortcuts panel.
;so if the video is playing, this will stop it. Othewise, it can mess up the script.

sleep 5

;Setting the coordinate mode is really important. This ensures that pixel distances are consistant for everything, everywhere.

coordmode, pixel, Window
coordmode, mouse, Window
coordmode, Caret, Window


;This (temporarily) blocks the mouse and keyboard from sending any information, which could interfere with the funcitoning of the script.
BlockInput, SendAndMouse
BlockInput, MouseMove
BlockInput, On

SetKeyDelay, 0 ;this ensures that any text AutoHotKey "types in," will input instantly, rather than one letter at a time.

MouseGetPos, xposP, yposP ;---stores the cursor's current coordinates at X%xposP% Y%yposP%
send, {mButton} ;this will MIDDLE CLICK to bring focus to the panel underneath the cursor (the timeline). I forget exactly why, but if you create a nest, and immediately try to apply a preset to it, it doesn't work, because the timeline wasn't in focus...?
;but i just tried that and it still didn't work...
;;DAMN IT, i forgot the { } and it was sending those as letters, I am an idiot. Need better diagnostics tools...

Send ^+!7 ;CTRL SHIFT ALT 7 --- you must set this in premiere's keyboard shortcuts menu to the "effects" panel

sleep 20 ;"sleep" means the script will wait for 20 milliseconds before the next command. This is done to give Premiere some time to load its own things.

Send ^b ;CTRL B -- set in premiere to "select find box"
sleep 20

;Any text in the Effects panel's find box has now been highlighted. There is also a blinking "text insertion point" at the end of that text. This is the vertical blinking line, or "caret." 

MouseMove, %A_CaretX%, %A_CaretY%, 0
sleep 15
MouseMove, %A_CaretX%, %A_CaretY%, 0

;and fortunately, AHK knows the exact X and Y position of this caret. So therefore, we can find the effects panel find box, no matter what monitor it is on, with 100% consistency.

sleep 15
;msgbox, carat X Y is %A_CaretX%, %A_CaretY%

MouseGetPos, , , Window, classNN
WinGetClass, class, ahk_id %Window%
;msgbox, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%
;;;I think ControlGetPos is not affected by coordmode??  Or at least, it gave me the wrong coordinates if premiere is not fullscreened... https://autohotkey.com/docs/commands/ControlGetPos.htm 
ControlGetPos, XX, YY, Width, Height, %classNN%, ahk_class %class%, SubWindow, SubWindow ;-I tried to exclude subwindows but I don't think it works...?
;;my results:  59, 1229, 252, 21,      Edit1,    ahk_class Premiere Pro

;msgbox, classNN = %classNN%
;now we have found a lot of useful informaiton about this find box. Turns out, we don't need most of it...
;we just need the X and Y coordinates of the "upper left" corner...

;comment in the following line to get a message box of your current variable values. The script will not advance until you dismiss the message box.
;MsgBox, xx=%XX% yy=%YY%

MouseMove, XX-15, YY+5, 0 ;-----------------------moves cursor onto the magnifying glass
;msgbox, should be in the center of the magnifying glass now.
sleep 5
;This types in the text you wanted to search for. Like "pop in." We can do this because the entire find box text was already selected by Premiere. Otherwise, we could click the magnifying glass if we wanted to , in order to select that find box.

Send %item%

sleep 30
MouseMove, 38, 126, 0, R ;----------------------relative to the position of the magnifying glass (established earlier,) this moves the cursor down and directly onto the preset's icon. In my case, it is inside the "presets" folder, then inside of another folder, and the written name sohuld be compeltely unique so that it is the first and only item.

;msgbox, The cursor should be directly on top of the preset's icon. `n If not, the script needs modification.


sleep 5

MouseGetPos, iconX, iconY, Window, classNN ;---now we have to figure out the ahk_class of the current panel we are on. It used to be DroverLord - Window Class14, but the number changes anytime you move panels around... so i must always obtain the information anew.

sleep 5

WinGetClass, class, ahk_id %Window% ;----------"ahk_id %Window%" is important for SOME REASON. if you delete it, this doesnt work.
;msgbox, ahk_class =   %class% `nClassNN =     %classNN% `nTitle= %Window%

ControlGetPos, xxx, yyy, www, hhh, %classNN%, ahk_class %class%, SubWindow, SubWindow ;-I tried to exclude subwindows but I don't think it works...?

MouseMove, www/4, hhh/2, 0, R ;-----------------clicks in about the CENTER of the Effects panel. This clears the displayed presets from any duplication errors. VERY important. without this, the script fails 20% of the time.

sleep 5

MouseClick, left, , , 1 ;-----------------------the actual click

sleep 10

MouseMove, iconX, iconY, 0 ;--------------------moves cursor BACK onto the effect's icon

sleep 35

MouseClickDrag, Left, , , %xposP%, %yposP%, 0 ;---clicks the left button down, drags this effect to the cursor's pervious coordinates and releases the left mouse button, which should be above a clip, on the TIMELINE panel.

sleep 10


MouseClick, middle, , , 1 ;this returns focus to the panel the cursor is hovering above, WITHOUT selecting anything. great!




blockinput, MouseMoveOff ;returning mouse movement ability
BlockInput, off ;do not comment out or delete this line -- or you won't regain control of the keyboard!! However, CTRL+ALT+DEL will still work if you get stuck!! Cool.


theEnding2:
}
;END of preset()

+F3::sfx("exponential fade")
Return












;;;;;;;;STREAM DECK - COLOR FOLDER;;;;;;;;;;;;

F20:: ;CNTRL UP
;for some reason the stream deck wont adjust the param w the arrows. had 2 send to AHK
	Send, ^{Up}
Return

F21:: ;CNTRL DOWN
;for some reason the stream deck wont adjust the param w the arrows. had 2 send to AHK
	Send, ^{Down}
Return

F22:: ;UP
	Send, {Up}
Return

F23:: ;DOWN
	Send, {Down}
Return

^!+F1::  ;Exposure in lumetri
	Send, ^!+9
	Loop 5
	Send, {Tab}
Return

^!+F2:: ;Contrast in lumetri
	Send, ^!+9
	Loop 6
	Send, {Tab}
Return

^!+F3:: ;Saturation in lumetri
	Send, ^!+9
	Loop 13
	Send, {Tab}
Return

^!+F4:: ;Saturation in lumetri
	Send, ^!+9
	Loop 4
	Send, {Tab}
Return





;;;;;;;;;;;;;;; CHANGE DEFAULT TRANSITION ;;;;;;;;;;;;;;;;


+F23:: 
	Send, ^+!O
	Loop 5
	Send, {Tab}
	Send, 3.0 {Enter}
	; tooltip, 3 Second Complete
Return

+F22:: 
	Send, ^+!O
	Loop 5
	Send, {Tab}
	Send, 1.0 {Enter}
Return

+F21:: 
	Send, ^+!O
	Loop 5
	Send, {Tab}
	Send, 0.3 {Enter}
Return

+F20:: 
	Send, ^+!O
	Loop 5
	Send, {Tab}
	Send, 0.1 {Enter}
Return