#include-once

#include <AutoItConstants.au3>

Func click($x, $y, $delay = 0)
  MouseClick($MOUSE_CLICK_PRIMARY, $x, $y, 1, 0)

  If $delay > 0 Then
    Sleep($delay)
  EndIf
EndFunc


Func moveAndClick($x, $y)
  MouseMove($x, $y, 5)
  MouseClick($MOUSE_CLICK_PRIMARY)
EndFunc