#include-once


Func lightboxInit($referenseArea)
  set('lightbox', 'area', $referenseArea)
  set('lightbox', 'off', getLightboxChecksum())
EndFunc


Func isLightboxOn()
  Return get('lightbox', 'off') <> getLightboxChecksum()
EndFunc


Func isLightboxOff()
  Return get('lightbox', 'off') = getLightboxChecksum()
EndFunc


Func waitLightboxOn()
  wait('isLightboxOn', 15)
EndFunc


Func waitLightboxOff()
  wait('isLightboxOff', 15)
EndFunc


Func getLightboxChecksum()
  Local Const $area = get('lightbox', 'area')

  Return PixelChecksum($area[0], $area[1], $area[2], $area[3], 1, '[ACTIVE]', 1)
EndFunc