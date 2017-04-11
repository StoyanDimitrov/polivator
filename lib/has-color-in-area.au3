#include-once

Func hasColorInArea($area, $color, $shades = 3)
  PixelSearch($area[0], $area[1], $area[2], $area[3], $color, $shades)

  If Not @error Then
    Return True
  EndIf

  Return False
EndFunc
