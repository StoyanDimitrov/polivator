#include-once


Func socialBarInit()
  socialBarOpen()
EndFunc


Func socialBarOpen()
  Local Const $buttonClosed = getClientArea(268, -26, 20, 20)
  Local Const $buttonOpened = getClientArea(268, -153, 20, 20)

  ; set('gui', 'socialbar_open', 0)
  ; check if the social bar is open
  If Not hasColorInArea($buttonClosed, 0x535d76) Then
    ; set('gui', 'socialbar_open', 1)

    Return
  EndIf

  ; open the social bar
  moveAndClick(Floor(($buttonClosed[0] + $buttonClosed[2]) / 2), Floor(($buttonClosed[1] + $buttonClosed[3]) / 2))

  ; wait social bar to be fully opened
  Local Const $hasPx = [ _
    $buttonOpened, _
    0x535d76 _
  ]
  wait('hasColorInArea', 25, $hasPx)
EndFunc


Func socialBarTabChange($tabId)
  ; pixel color sniffing areas for the three social bar tabs
  Local Const $neighbors = getClientArea(727, -156, 28, 23)
  Local Const $guildies = getClientArea(793, -156, 28, 23)
  Local Const $friends = getClientArea(857, -156, 28, 23)
  #forceref $neighbors, $guildies, $friends

  If IsDeclared($tabId) <> $DECLARED_LOCAL Then
    Return
  EndIf

  Local $area = Eval($tabId)

  ; if tabId is not the active tab
  If Not hasColorInArea($area, 0x535d76) Then
    ; click in the middle of the sniffing area
    moveAndClick(Floor(($area[2] + $area[0]) / 2), Floor(($area[3] + $area[1]) / 2))

    Sleep(750)
    wait('socialBarPageHasLoaded', 25)
  EndIf

  wait('isSocialbarFirstPage', 250)
  wait('socialBarPageHasLoaded', 25)
EndFunc


Func socialBarTabProcess($tabId)
  Do
    socialBarPageProcess($tabId)
  Until Not socialBarPageHasNext()
EndFunc


Func socialBarPageProcess($tabId)
  Local Const $size = getBrowserSize()

  Local Const $aid1 = getClientArea(264, -20, 97, 14)
  Local Const $aid2 = getClientArea(371, -20, 97, 14)
  Local Const $aid3 = getClientArea(478, -20, 97, 14)
  Local Const $aid4 = getClientArea(585, -20, 97, 14)
  Local Const $aid5 = getClientArea(692, -20, 97, 14)
  Local Const $aids = [ _
    $aid1, _
    $aid2, _
    $aid3, _
    $aid4, _
    $aid5 _
  ]
  Local Const $tavern1 = getClientArea(354, -42, 3, 3)
  Local Const $tavern2 = getClientArea(461, -42, 3, 3)
  Local Const $tavern3 = getClientArea(568, -42, 3, 3)
  Local Const $tavern4 = getClientArea(675, -42, 3, 3)
  Local Const $tavern5 = getClientArea(782, -42, 3, 3)
  Local Const $taverns = [ _
    $tavern1, _
    $tavern2, _
    $tavern3, _
    $tavern4, _
    $tavern5 _
  ]

  Local Const $blueprintCloseButton = getClientArea(Floor($size[0] / 2) + 8, Floor(($size[1] - 8) / 2) + 232, 167, 18)
  Local Const $tavernCloseButton = getClientArea(Floor($size[0] / 2) - 83, Floor(($size[1] - 8) / 2) + 297, 167, 18)

  Local $stats = get('config', 'world_stats')
  Local Const $continueAfterPolivationData = [ _
    $blueprintCloseButton, _
    0x792419 _
  ]
  Local Const $closeTavern = [ _
    $tavernCloseButton, _
    0x792419 _
  ]

  For $i = 0 To UBound($aids) - 1
    Local $area = $aids[$i]
consolewrite('Aid button ' & $i & @lf)
    waitLightboxOff()

    ; aid button
    If hasColorInArea($area, 0x8e4c1e) Then
      moveAndClick(Floor(($area[2] + $area[0]) / 2), Floor(($area[3] + $area[1]) / 2))
      configSet($stats, 'aids', configGet($stats, 'aids') + 1)

      waitLightboxOn()

      ; wait for lightbox to disappear or blueprintCloseButton to appear
      wait('continueAfterPolivation', 125, $continueAfterPolivationData)

      waitLightboxOff()

      #cs
      ; blueprint close button
      If hasColorInArea($blueprintCloseButton, 0x792419) Then
        moveAndClick(Floor(($blueprintCloseButton[2] + $blueprintCloseButton[0]) / 2), Floor(($blueprintCloseButton[3] + $blueprintCloseButton[1]) / 2))
        configSet($stats, 'blueprints', configGet($stats, 'blueprints') + 1)
        ; wait button to disappear
        waitNot('hasColorInArea', 25, $continueAfterPolivationData)
      EndIf
      #ce
    EndIf


    ; checking for taverns
    If $tabId = 'friends' Then
      waitLightboxOff()

      ; tavern is free icon
      Local $tavernIcon = $taverns[$i]
      If hasColorInArea($tavernIcon, 0x94845d) Then
        moveAndClick($tavernIcon[0] - 5, $tavernIcon[1] + 5)
        configSet($stats, 'tavernVisits', configGet($stats, 'tavernVisits') + 1)

        waitLightboxOn()
        wait('hasColorInArea', 25, $closeTavern)

        ; simple click closes the tavern window
        MouseClick($MOUSE_CLICK_PRIMARY)

        ; wait button to disappera
        waitNot('hasColorInArea', 25, $closeTavern)
      EndIf
    EndIf
  Next
EndFunc


Func isSocialbarFirstPage()
  Local Const $area = getClientArea(264, -109, 20, 9)
  Local Const $point = getClientPoint(245, -32)

  Return Not socialBarPageIsDifferent($area, $point)
EndFunc


Func socialBarPageHasNext()
  Local Const $area = getClientArea(692, -109, 20, 9)
  Local Const $point = getClientPoint(913, -65)

  Return socialBarPageIsDifferent($area, $point)
EndFunc


Func continueAfterPolivation(ByRef $area, $color)
  If isLightboxOff() Then
consolewrite('Lightbox Off' & @lf)
    Return True
  EndIf

  If Not hasColorInArea($area, $color) Then
consolewrite('Blueprint button Missing' & @lf)
    Return False
  EndIf

consolewrite('Blueprint button Found' & @lf)
  moveAndClick(Floor(($area[2] + $area[0]) / 2), Floor(($area[3] + $area[1]) / 2))
consolewrite('Blueprint button Clicked' & @lf)

  ; TODO
  ; configSet($stats, 'blueprints', configGet($stats, 'blueprints') + 1)

  Local Const $continueAfterPolivationData = [ _
    $area, _
    $color _
  ]
  waitNot('hasColorInArea', 125, $continueAfterPolivationData)
consolewrite('Blueprint button Disappeared' & @lf)
  ; waitLightboxOff()
  Return True
EndFunc


Func socialBarPageHasLoaded()
  Local Const $aid1 = getClientArea(264, -20, 97, 14)
  Local Const $aid2 = getClientArea(371, -20, 97, 14)

  Return hasColorInArea($aid1, 0xecd7a1) _
      Or hasColorInArea($aid1, 0xffcc68) _
      Or hasColorInArea($aid2, 0xecd7a1) _
      Or hasColorInArea($aid2, 0xffcc68)
EndFunc


Func socialBarPageIsDifferent($area, $point)
  Local Const $reference = PixelChecksum($area[0], $area[1], $area[2], $area[3], 1, '[ACTIVE]', 1)
  Local $before, $after

  moveAndClick($point[0], $point[1])
  ; wait animation to kick in
  Sleep(750)

  Do
    $before = PixelChecksum($area[0], $area[1], $area[2], $area[3], 1, '[ACTIVE]', 1)
    ; must be long enough to properly detect animation frame change
    Sleep(250)
    $after = PixelChecksum($area[0], $area[1], $area[2], $area[3], 1, '[ACTIVE]', 1)
  Until $before = $after

  Return $reference <> $after
EndFunc
