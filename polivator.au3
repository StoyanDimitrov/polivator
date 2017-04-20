Opt('MustDeclareVars', True)
Opt('MouseCoordMode', 2)
Opt('PixelCoordMode', 2)

#pragma compile(Out, Polivator.exe)
#pragma compile(Icon, icon.ico)

#include <Misc.au3>
If _Singleton('foe-polivator-gui', 1) = 0 Then
  Exit
EndIf

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>

#include 'lib\click.au3'
#include 'lib\variable-store.au3'
#include 'lib\wait.au3'
#include 'lib\has-color-in-area.au3'
#include 'lib\lightbox.au3'
#include 'lib\area.au3'
#include 'lib\config.au3'
#include 'lib\worlds.au3'
#include 'lib\social-bar.au3'
#include 'lib\statusbar.au3'


Func exitApp()
  Exit
EndFunc

HotKeySet('{ESC}', exitApp)


main()


Func main()

  loadConfiguration()

  Local $worldslist = get('config', 'worlds')
  Local $settings = get('config', 'settings')
  Local $worldSettings = get('config', 'world_settings')

  Local $worldsItems[UBound($worldsList)]
  $worldsItems[0] = UBound($worldsList)

  Local $worldActionsItems[UBound($worldSettings)]
  $worldActionsItems[0] = UBound($worldSettings)

  Local $acceleratorKeys[UBound($worldsList)][2]
  $acceleratorKeys[0][0] = UBound($worldsList)

  Local $automator = GUICreate('Polivator', 351, 141)
  GUISetIcon(@ScriptName, 0)

  Local $worldsMenu = GUICtrlCreateMenu('&World')
  Local $actionsMenu = GUICtrlCreateMenu('&Actions')
  ; $settingsMenu = GUICtrlCreateMenu('&Settings')
  ; GUICtrlSetState(-1, $GUI_DISABLE)
  ; $settingsMenu = GUICtrlCreateMenu('&Help')
  ; GUICtrlSetState(-1, $GUI_DISABLE)

  Local $go = GUICtrlCreateButton('Process world', 8, 8, 85, 25)
  ; Local $taverns = GUICtrlCreateButton('Process taverns', 100, 8, 85, 25)
  ; GUICtrlSetState(-1, $GUI_DISABLE)
  ; TODO disable if $worldActionsItems[4] is 0

  For $worldId = 1 To UBound($worldsList) - 1
    $worldsItems[$worldId] = GUICtrlCreateMenuItem('&' & $worldsList[$worldId][1] & @TAB & 'Shift+F' & $worldId, $worldsMenu, -1, 1)
    If $settings[1][1] = $worldsList[$worldId][0] Then
      GUICtrlSetState(-1, $GUI_CHECKED)
    EndIf

    $acceleratorKeys[$worldId][0] = '+{F' & $worldId & '}'
    $acceleratorKeys[$worldId][1] = $worldsItems[$worldId]
  Next
  GUISetAccelerators($acceleratorKeys)

  $worldActionsItems[1] = GUICtrlCreateMenuItem('Aid &Neighbours', $actionsMenu)
  $worldActionsItems[2] = GUICtrlCreateMenuItem('Aid &Guildies', $actionsMenu)
  $worldActionsItems[3] = GUICtrlCreateMenuItem('Aid &Friends', $actionsMenu)
  $worldActionsItems[4] = GUICtrlCreateMenuItem('Visit Friends &Taverns', $actionsMenu)
  worldSettingsItemsCheck($worldActionsItems)

  Local $statusTexts[] = [ _
    getWorldNameSignature(), _
    getWorldSettingsSignature(), _
    'Ready' _
  ]
  statusbarInit($automator, $statusTexts)

  GUISetState(@SW_SHOW)

  While True
    Local $msg = GUIGetMsg()
    Switch $msg
      Case $GUI_EVENT_CLOSE
        Exit

      Case $go
        process()

      ; Case $taverns
      ;  visitTaverns()

      Case Else
        ; world
        For $worldId = 1 To UBound($worldsItems) - 1
          If $msg <> $worldsItems[$worldId] Then
            ContinueLoop
          EndIf

          setWorldId($worldsList[$worldId][0])

          worldSettingsItemsCheck($worldActionsItems)
          setStatusText(getWorldNameSignature(), 0)
          setStatusText(getWorldSettingsSignature(), 1)
        Next

        ; actions
        For $worldSettingId = 1 To UBound($worldActionsItems) - 1
          If $msg <> $worldActionsItems[$worldSettingId] Then
            ContinueLoop
          EndIf

          $worldSettings[$worldSettingId][1] = BitXOR($worldSettings[$worldSettingId][1], 1)
          setWorldSettings($worldSettings)

          worldSettingsItemsCheck($worldActionsItems)
          setStatusText(getWorldSettingsSignature(), 1)
        Next
    EndSwitch
  WEnd
EndFunc


Func worldSettingsItemsCheck(ByRef $worldActionsItems)
  Local Const $settings = get('config', 'world_settings')

  For $settingId = 1 To UBound($settings) - 1
    Local $state = $GUI_UNCHECKED
    If $settings[$settingId][1] = 1 Then
      $state = $GUI_CHECKED
    EndIf

    GUICtrlSetState($worldActionsItems[$settingId], $state)
  Next
EndFunc


Func process()
  setStatusText('Give focus to the game', 2)
  WinWaitActive('Forge of Empires')
  setStatusText('Game is in focus', 2)

  lightboxInit(getClientArea(0, -88, 5, 6))

  socialBarInit()
  setStatusText('Processing…', 2)

  Local $tabs = getTabsToProcess()
  For $i = 0 To UBound($tabs) - 1
    socialBarTabChange($tabs[$i])
    socialBarTabProcess($tabs[$i])
  Next

  Local Const $worldId = getWorldId()
  IniWriteSection('config.ini', $worldId & '.stats', get('config', 'world_stats'))
  setStatusText('Done!', 2)
EndFunc


Func visitTaverns()
consolewrite(isSocialbarFirstPage() & @lf)
  ; setStatusText('Waiting for the game to appear', 2)

  ; setStatusText('Game in focus', 2)
  lightboxInit(getClientArea(0, -88, 5, 6))

  socialBarInit()
  socialBarTabChange(2)
EndFunc


Func loadConfiguration()
  set('config', 'worlds', IniReadSection('config.ini', 'worlds'))

  set('config', 'settings', IniReadSection('config.ini', 'settings'))

  Local Const $worldId = getWorldId()
  set('config', 'world_settings', IniReadSection('config.ini', $worldId & '.settings'))
  set('config', 'world_stats', IniReadSection('config.ini', $worldId & '.stats'))
EndFunc


Func getBrowserSize()
  Const $browser = WinWaitActive('Forge of Empires')

  Return WinGetClientSize($browser)
EndFunc


Func getTabsToProcess()
  Local Const $worldSettings = get('config', 'world_settings')
  Local $tabs = []
  Local $index = 0

  For $i = 1 To UBound($worldSettings) - 1
    If $worldSettings[$i][1] = 0 Then
      ContinueLoop
    EndIf

    ReDim $tabs[$index + 1]
    $tabs[$index] = $worldSettings[$i][0]

    $index += 1
  Next

  Return $tabs
EndFunc
