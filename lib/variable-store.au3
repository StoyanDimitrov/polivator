#include-once

#include <AutoItConstants.au3>


Func get($namespace, $name)
  Local Const $variable = '__VS_' & $namespace & '_' & $name

  If Not IsDeclared($variable) = $DECLARED_GLOBAL Then
    Return Null
  EndIf

  Return Eval($variable)
EndFunc


Func set($namespace, $name, $value)
  Local Const $variable = '__VS_' & $namespace & '_' & $name
  Assign($variable, $value, $ASSIGN_FORCEGLOBAL)
EndFunc