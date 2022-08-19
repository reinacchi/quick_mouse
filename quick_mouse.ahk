#InstallKeybdHook

; quick_mouse
;
; Reinhardt
; 2022.819.9

global INSERT_MODE := false
global NORMAL_MODE := false

global FORCE := 1.8
global RESISTANCE := 0.982

global VELOCITY_X := 0
global VELOCITY_Y := 0

EnterNormalMode()

Accelerate(velocity, pos, neg) {
    If (pos == 0 && neg == 0) {
        Return 0
    }
    ; smooth deceleration :)
    Else If (pos + neg == 0) {
        Return velocity * 0.666
    }
    ; physicszzzzz
    Else {
        Return velocity * RESISTANCE + FORCE * (pos + neg)
    }
}

MoveCursor() {
    LEFT := 0
    DOWN := 0
    UP := 0
    RIGHT := 0

    LEFT := LEFT - GetKeyState("a", "P")
    DOWN := DOWN + GetKeyState("s", "P")
    UP := UP - GetKeyState("w", "P")
    RIGHT := RIGHT + GetKeyState("d", "P")

    If (NORMAL_MODE == false) {
        VELOCITY_X := 0
        VELOCITY_Y := 0
        SetTimer,, Off
    }

    VELOCITY_X := Accelerate(VELOCITY_X, LEFT, RIGHT)
    VELOCITY_Y := Accelerate(VELOCITY_Y, UP, DOWN)

    RestoreDPI:=DllCall("SetThreadDpiAwarenessContext","ptr",-3,"ptr") ; enable per-monitor DPI awareness

    MouseMove, %VELOCITY_X%, %VELOCITY_Y%, 0, R
}

EnterNormalMode(quick:=false) {
    If (NORMAL_MODE) {
        Return
    }
    NORMAL_MODE := true
    INSERT_MODE := false

    SetTimer, MoveCursor, 16
}

EnterInsertMode(quick:=false) {
    If (INSERT_MODE) {
        Return
    }

    INSERT_MODE := true
    NORMAL_MODE := false
}

Drag() {
    Click, Down
}

Yank() {
    wx := 0
    wy := 0
    width := 0
    WinGetPos,wx,wy,width,,A
    center := wx + width - 180
    y := wy + 12
    ;MsgBox, Hello %width% %center%
    MouseMove, center, y
    Drag()
}

RightDrag() {
    Click, Right, Down
}

MouseLeft() {
    Click
}

MouseRight() {
    Click, Right
}

MouseMiddle() {
    Click, Middle
}

JumpMiddle() {
    CoordMode, Mouse, Screen
    MouseMove, (A_ScreenWidth // 2), (A_ScreenHeight // 2)
}

JumpMiddle2() {
    CoordMode, Mouse, Screen
    MouseMove, (A_ScreenWidth + A_ScreenWidth // 2), (A_ScreenHeight // 2)
}

JumpMiddle3() {
    CoordMode, Mouse, Screen
    MouseMove, (A_ScreenWidth * 2 + A_ScreenWidth // 2), (A_ScreenHeight // 2)
}

MouseCtrlClick() {
    Send, {Ctrl Down}{Click}{Ctrl Up}
}

MonitorLeftEdge() {
    mx := 0
    CoordMode, Mouse, Screen
    MouseGetPos, mx
    monitor := (mx // A_ScreenWidth)

    return monitor * A_ScreenWidth
}

JumpLeftEdge() {
    x := MonitorLeftEdge() + 2
    y := 0
    CoordMode, Mouse, Screen
    MouseGetPos,,y
    MouseMove, x,y
}

JumpBottomEdge() {
    x := 0
    CoordMode, Mouse, Screen
    MouseGetPos, x
    MouseMove, x,(A_ScreenHeight - 0)
}

JumpTopEdge() {
    x := 0
    CoordMode, Mouse, Screen
    MouseGetPos, x
    MouseMove, x,0
}

JumpRightEdge() {
    x := MonitorLeftEdge() + A_ScreenWidth - 2
    y := 0
    CoordMode, Mouse, Screen
    MouseGetPos,,y
    MouseMove, x,y
}

MouseBack() {
    Click, X1
}

MouseForward() {
    Click, X2
}

ScrollUp() {
    Click, WheelUp
}

ScrollDown() {
    Click, WheelDown
}

ScrollRight() {
    Click, WheelRight
}

ScrollLeft() {
    Click, WheelLeft
}

ScrollUpMore() {
    Click, WheelUp
    Click, WheelUp
    Click, WheelUp
    Click, WheelUp
    Return
}

ScrollDownMore() {
    Click, WheelDown
    Click, WheelDown
    Click, WheelDown
    Click, WheelDown
    Return
}

Break:: EnterNormalMode()
Insert:: EnterInsertMode()
<#<!n:: EnterNormalMode()
<#<!i:: EnterInsertMode()

+Break:: Send, {Break}
+Insert:: Send, {Insert}
^Capslock:: Send, {Capslock}
^+Capslock:: SetCapsLockState, Off

#If (NORMAL_MODE)
w:: Return
a:: Return
s:: Return
d:: Return
+E:: MouseCtrlClick()
+W:: JumpTopEdge()
+A:: JumpLeftEdge()
+S:: JumpBottomEdge()
+D:: JumpRightEdge()
e:: MouseLeft()
q:: MouseRight()
r:: MouseMiddle()
+Y:: Yank()
*n:: Drag()
*m:: RightDrag()
i:: ScrollUp()
j:: ScrollLeft()
k:: ScrollDown()
l:: ScrollRight()
End:: Click, Up
