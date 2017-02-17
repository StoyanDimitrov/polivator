#include-once


Func socialBarOpen()
  Local Const $size = getGeometry()
  Local Const $buttonClosed = [269, $size[1] - 25, 286, $size[1] - 7]
  Local Const $buttonOpened = [269, $size[1] - 152, 286, $size[1] - 134]

  ; check if the social bar is open
  If hasColorInArea($buttonClosed, 0x535d76) Then
    click(Floor(($buttonClosed[0] + $buttonClosed[2]) / 2), Floor(($buttonClosed[1] + $buttonClosed[3]) / 2))

    ; wait social bar to be fully opened
    Local Const $hasPx[] = [ _
      $buttonOpened, _
      0x535d76 _
    ]
    wait('hasColorInArea', 25, $hasPx)
  EndIf
EndFunc


Func socialBarTabChange($tabId)
  Local Const $size = getGeometry()

  ; pixel color sniffing areas for the three social bar tabs
  Local Const $neighbors = [727, $size[1] - 156, 756, $size[1] - 133]
  Local Const $guildies = [790, $size[1] - 156, 820, $size[1] - 133]
  Local Const $friends = [855, $size[1] - 156, 884, $size[1] - 133]
  Local $tabs = [$neighbors, $guildies, $friends]

  ; multi-dimentional arrays can not be docomposed
  Local $area = $tabs[$tabId]

  If Not hasColorInArea($area, 0x535d76) Then
    ; click in the middle of the sniffing area
    click(Floor(($area[2] + $area[0]) / 2), Floor(($area[3] + $area[1]) / 2))

    Sleep(500)
  EndIf

  ; click on the "first page" button
  click(245, $size[1] - 32)

  Sleep(1000)
EndFunc


Func socialBarTabProcess($tabId, $pages, $playersAll, ByRef $playersProcessed)
  For $i = 1 To $pages
    socialBarPageProcess($tabId, $playersAll, $playersProcessed)
    If $i < $pages Then
      socialBarPageNext()
    EndIf
  Next
EndFunc


Func socialBarPageProcess($tabId, $playersAll, ByRef $playersProcessed)
  Local Const $size = getGeometry()

  Local Const $aid1 = [263, $size[1] - 21, 361, $size[1] - 5]
  Local Const $aid2 = [370, $size[1] - 21, 468, $size[1] - 5]
  Local Const $aid3 = [477, $size[1] - 21, 575, $size[1] - 5]
  Local Const $aid4 = [584, $size[1] - 21, 682, $size[1] - 5]
  Local Const $aid5 = [691, $size[1] - 21, 789, $size[1] - 5]
  Local Const $aids = [ _
    $aid1, _
    $aid2, _
    $aid3, _
    $aid4, _
    $aid5 _
  ]
  Local Const $tavern1 = [355, $size[1] - 43, 358, $size[1] - 40]
  Local Const $tavern2 = [462, $size[1] - 43, 465, $size[1] - 40]
  Local Const $tavern3 = [569, $size[1] - 43, 572, $size[1] - 40]
  Local Const $tavern4 = [676, $size[1] - 43, 679, $size[1] - 40]
  Local Const $tavern5 = [783, $size[1] - 43, 786, $size[1] - 40]
  Local Const $taverns = [ _
    $tavern1, _
    $tavern2, _
    $tavern3, _
    $tavern4, _
    $tavern5 _
  ]

  Local Const $blueprintCloseButton = [ _
    ($size[0] / 2) + 8, _
    ($size[1] / 2) + 232, _
    ($size[0] / 2) + 175, _
    ($size[1] / 2) + 251 _
  ]


  For $i = 0 To UBound($aids) - 1
    Local $area = $aids[$i]

    ; aid button
    If hasColorInArea($area, 0x8e4c1e) Then
      click(Floor(($area[2] + $area[0]) / 2), Floor(($area[3] + $area[1]) / 2))
      aids('set')

      Sleep(1500)

      ; blueprint close button
      If hasColorInArea($blueprintCloseButton, 0x792419) Then
        click(Floor(($blueprintCloseButton[2] + $blueprintCloseButton[0]) / 2), Floor(($blueprintCloseButton[3] + $blueprintCloseButton[1]) / 2))
        blueprints('set')

        Sleep(750)
      EndIf
    EndIf


    ; checking for taverns
    If $tabId = 2 Then
      ; tavern free icon
      Local $tavernIcon = $taverns[$i]
      If hasColorInArea($tavernIcon, 0x94845d) Then
        click($tavernIcon[0] - 5, $tavernIcon[1] + 5)
        tavernVisits('set')

        Sleep(2000)

        ; simple click closes the tavern window
        MouseClick($MOUSE_CLICK_PRIMARY)
        Sleep(500)
      EndIf
    EndIf

    $playersProcessed += 1
    ProgressSet(($playersProcessed / $playersAll) * 100, $playersProcessed & '/' & $playersAll)
  Next
EndFunc


Func socialBarPageNext()
  Local Const $size = getGeometry()

  click(915, $size[1] - 65)

  Sleep(1500)
EndFunc
