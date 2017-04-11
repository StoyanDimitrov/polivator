#include-once


Func getClientPoint($x, $y)
  Local $point = [ _
    $x, _
    $y + 8 _
  ]

  If $x < 0 Or $y < 0 Then
    Local $client = WinGetClientSize('[ACTIVE]')

    If $x < 0 Then
      $point[0] = $client[0] + $x + 1
    EndIf

    If $y < 0 Then
      $point[1] = $client[1] + $y + 1
    EndIf
  EndIf

  Return $point
EndFunc


Func getClientArea($x, $y, $width, $height)
  Local $point = getClientPoint($x, $y)

  Local $area = [ _
    $point[0], _
    $point[1], _
    $point[0] + $width, _
    $point[1] + $height _
  ]

  Return $area
EndFunc
