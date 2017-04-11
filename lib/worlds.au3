Func getWorldId()
  Local $settings = get('config', 'settings')

  Return $settings[1][1]
EndFunc


Func setWorldId($id)
  Local $settings = get('config', 'settings')

  $settings[1][1] = $id

  set('config', 'settings', $settings)
  set('config', 'world_settings', IniReadSection('config.ini', $id & '.settings'))

  ; TODO - save config on exit
  IniWriteSection('config.ini', 'settings', $settings)
EndFunc


Func getWorldNameById($id)
  Local Const $worldsList = get('config', 'worlds')

  For $i = 1 To UBound($worldsList) -1
    If $worldsList[$i][0] <> $id Then
      ContinueLoop
    EndIf

    Return $worldsList[$i][1]
  Next

  Return '[unknown]'
EndFunc


Func getWorldNameSignature()
  Local Const $worldId = getWorldId()

  Return StringUpper(StringLeft($worldId, 2)) & ' ' & getWorldNameById($worldId)
EndFunc


Func getWorldSettingsSignature()
  Local Const $settings = get('config', 'world_settings')
  Local $signature

  For $i = 1 To UBound($settings) - 1
    If $settings[$i][1] = 0 Then
      ContinueLoop
    EndIf

    $signature &= StringUpper(StringLeft($settings[$i][0], 1))
  Next

  Return $signature
EndFunc


Func setWorldSettings(ByRef $settings)
  Local Const $worldId = getWorldId()

  set('config', 'world_settings', $settings)

  ; TODO - save config on exit
  IniWriteSection('config.ini', $worldId & '.settings', $settings)
EndFunc
