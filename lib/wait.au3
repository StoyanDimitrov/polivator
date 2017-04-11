#include-once


Func wait($callback, $delay, $arguments = Null)
  __wait(False, $callback, $delay, $arguments)
EndFunc


Func waitNot($callback, $delay, $arguments = Null)
  __wait(True, $callback, $delay, $arguments)
EndFunc


Func __wait($predicate, $callback, $delay, $arguments = Null)
  __wait_prepareArgs($arguments)

  While Call($callback, $arguments) = $predicate
    Sleep($delay)
  WEnd
EndFunc


Func __wait_prepareArgs(ByRef $arguments)
  If Not isArray($arguments) Then
    Return
  EndIf

  Local $params[UBound($arguments) + 1]

  $params[0] = 'CallArgArray'

  For $i = 0 To UBound($arguments) - 1
    $params[($i + 1)] = $arguments[$i]
  Next

  ReDim $arguments[UBound($params)]
  $arguments = $params
EndFunc
