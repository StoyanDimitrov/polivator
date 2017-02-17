Opt('MustDeclareVars', 1)
Opt('MouseCoordMode', 2)
Opt('PixelCoordMode', 2)

#pragma compile(Out, Polivator.exe)
#pragma compile(Icon, icon.ico)

#include <AutoItConstants.au3>
#include 'lib\has-color-in-area.au3'
#include 'lib\wait.au3'
#include 'lib\social-bar.au3'

#include <Misc.au3>
If _Singleton('foe-polivator', 1) = 0 Then
  Exit
EndIf


#cs
TODO
  generate the config
  use [colors] from the config
  use [positions] from the config
#ce


HotKeySet('{ESC}', exitApp)


main()


Func main()
  Local Const $size = getGeometry()
  Local Const $world = pickWorld()
  Local Const $players = IniReadSection(ini(), $world & '.players')
  Local Const $playersPerPage = 5
  Local Const $pagesByTab = [ _
    Ceiling($players[1][1] / $playersPerPage), _
    Ceiling($players[2][1] / $playersPerPage), _
    Ceiling($players[3][1] / $playersPerPage) _
  ]

  Local $playersNumberAll = 0
  For $x = 0 To UBound($pagesByTab) - 1
    $playersNumberAll += ($pagesByTab[$x] * $playersPerPage)
  Next
  Local $playersNumberProcessed = 0

  socialBarOpen()
  ProgressOn('Social stuff in progress', 'Aiding in progress', '0/' & $playersNumberAll, 150, $size[1] - 250)
  For $tabId = 0 To UBound($pagesByTab) - 1
    socialBarTabChange($tabId)
    socialBarTabProcess($tabId, $pagesByTab[$tabId], $playersNumberAll, $playersNumberProcessed)
  Next
  ProgressOff()

  MsgBox(0, 'Polivation Finished', 'Polivations:' & @TAB & aids('get') & @LF & 'Tavern visits:' & @TAB & tavernVisits('get') & @LF & 'Blueprints:' & @TAB & blueprints('get'))

  ; save stats
  Local Const $stats = IniReadSection(ini(), $world & '.stats')
  Local $statsUpdated[][2] = [ _
    [3, ''], _
    ['aids', $stats[1][1] + aids('get')], _
    ['blueprints', $stats[2][1] + blueprints('get')], _
    ['tavernVisits', $stats[3][1] + tavernVisits('get')] _
  ]
  IniWriteSection(ini(), $world & '.stats', $statsUpdated)
  Exit
EndFunc


Func ini()
  Return 'config.ini'
EndFunc


Func getGeometry()
  Const $browser = WinWaitActive('Forge of Empires')

  Return WinGetClientSize($browser)
EndFunc


Func pickWorld()
  If Not FileExists(ini()) Then
    MsgBox(0, 'Error', 'Config file not found')
  EndIf

  Const $worlds = IniReadSection(ini(), 'worlds')

  If @error Then
    MsgBox(0, 'Error', 'Config file not found')
  EndIf

  Local $worldLegend = ''
  For $i = 1 To UBound($worlds) - 1
    $worldLegend &= ($i & ' -> ' & $worlds[$i][1] & @LF)
  Next

  Const $world = InputBox('World Selection', 'Choose desired world' & @LF & @LF & $worldLegend, 1)

  If $world > UBound($worlds) - 1 Then
    pickWorld()
  EndIf

  Return $worlds[$world][0]
EndFunc


Func blueprints($action)
  Local Static $count = 0

  Switch $action
    Case 'set'
      $count += 1

    Case 'get'
      Return $count
  EndSwitch
EndFunc


Func aids($action)
  Local Static $count = 0

  Switch $action
    Case 'set'
      $count += 1

    Case 'get'
      Return $count
  EndSwitch
EndFunc


Func tavernVisits($action)
  Local Static $count = 0

  Switch $action
    Case 'set'
      $count += 1

    Case 'get'
      Return $count
  EndSwitch
EndFunc


Func click($x, $y)
  MouseMove($x, $y, 25)
  MouseClick($MOUSE_CLICK_PRIMARY)
EndFunc


Func exitApp()
  Exit
EndFunc


While True
  Sleep(1)
WEnd
