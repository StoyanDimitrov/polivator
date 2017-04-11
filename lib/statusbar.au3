#include-once

Func statusbarInit($container, $texts)
  Local Const $statusbar = _GUICtrlStatusBar_Create($container)

  Local $partsWidth = [ _
    130, _
    180, _
    -1 _
  ]
  _GUICtrlStatusBar_SetParts($statusbar, $partsWidth)
  set('gui', 'statusbar', $statusbar)

  For $index = 0 To UBound($texts) - 1
    setStatusText($texts[$index], $index)
  Next
EndFunc


Func setStatusText($text, $statusId)
  Local Const $statusbar = get('gui', 'statusbar')

  _GUICtrlStatusBar_SetText($statusbar, $text, $statusId)
EndFunc
