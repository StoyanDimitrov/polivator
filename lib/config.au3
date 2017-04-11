#include-once

Func configSet(ByRef $section, $key, $value)
  Local Const $index = configGetIndexByKey($section, $key)

  $section[$index][1] = $value
EndFunc


Func configGet(ByRef $section, $key)
  Local Const $index = configGetIndexByKey($section, $key)

  Return $section[$index][1]
EndFunc


Func configGetIndexByKey(ByRef $section, $key)
  For $index = 1 To UBound($section) - 1
    If Not $section[$index][0] = $key Then
      ContinueLoop
    EndIf

    Return $index
  Next
EndFunc