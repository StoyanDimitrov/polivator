#include-once


Func wait($callback, $delay, $arguments = Null)
  __wait_prepareArgs($arguments)

  While Not Call($callback, $arguments) = True
consolewrite($callback & @lf)
    Sleep($delay)
  WEnd
EndFunc


Func __wait_prepareArgs(ByRef $arguments)
  If isArray($arguments) Then
    Local $params[UBound($arguments) + 1]

    $params[0] = 'CallArgArray'

    For $i = 0 To UBound($arguments) - 1
      $params[($i + 1)] = $arguments[$i]
    Next

    ReDim $arguments[UBound($params)]
    $arguments = $params
  EndIf
EndFunc