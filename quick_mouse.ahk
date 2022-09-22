#InstallKeybdHook

; quick_mouse
;
; Reinhardt
; 2022.922.0

global INSERT_MODE := False
global NORMAL_MODE := False
global FAST_MODE := False

global FORCE := 1.8
global RESISTANCE := 0.982

global VELOCITY_X := 0
global VELOCITY_Y := 0

SwitchMode(True)

Accelerate(velocity, pos, neg) {
    If (pos == 0 && neg == 0) {
        Return 0
    }
    ; Smooth declaration
    Else If (pos + neg == 0) {
        Return velocity * 0.666
    }
    ; Apply physics /(ㄒoㄒ)/~~
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

    If (NORMAL_MODE == False) {
        VELOCITY_X := 0
        VELOCITY_Y := 0
        SetTimer,, Off
    }

    VELOCITY_X := Accelerate(VELOCITY_X, LEFT, RIGHT)
    VELOCITY_Y := Accelerate(VELOCITY_Y, UP, DOWN)

    RestoreDPI:=DllCall("SetThreadDpiAwarenessContext","ptr",-3,"ptr") ; Enable per-monitor DPI awareness

    MouseMove, %VELOCITY_X%, %VELOCITY_Y%, 0, R
}

SwitchMode(init=False, normal=False) {
    If (init == True) {
        NORMAL_MODE := True
        INSERT_MODE := False

        SetTimer, MoveCursor, 16
    } Else {
        If (normal == True) {
            NORMAL_MODE := True
            INSERT_MODE := False

            SetTimer, MoveCursor, 16
        }

        If (normal == False) {
            NORMAL_MODE := False
            INSERT_MODE := True

            Return
        }
    }

}

EnableFast(fast=False) {
    If (fast == True) {
        FAST_MODE := True
        FORCE := 3.6
        RESISTANCE := 0.96
    } Else {
        FAST_MODE := False
        FORCE := 1.8
        RESISTANCE := 0.982
    }

    Return
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

+!k:: SwitchMode(False, True)
+!l:: SwitchMode(False, False)
+!o:: EnableFast(True)
+!p:: EnableFast(False)

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
n:: Drag()
m:: RightDrag()
i:: ScrollUp()
j:: ScrollLeft()
k:: ScrollDown()
l:: ScrollRight()
End:: Click, Up
