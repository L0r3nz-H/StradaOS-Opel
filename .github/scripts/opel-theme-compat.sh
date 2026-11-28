#!/usr/bin/env bash
# Exercise actual UI, stored settings and restart behavior through existing debug hooks.
set -euo pipefail
OUT=${1:?Missing output directory}
PKG=com.stradaos.launcher.debug
ACT=$PKG/com.stradaos.launcher.Main
mkdir -p "$OUT"
adb logcat -c
go() {
  adb shell am start -W -n "$ACT" --es prueba "$1" > "$OUT/opel-theme-last-start.txt"
  sleep 3
  adb shell pidof "$PKG" >/dev/null
}
dump() {
  # A live clock/map never becomes accessibility-idle. Snapshot real visible
  # app views on the UI thread through the package-restricted debug hook.
  adb shell run-as "$PKG" rm -f files/test-view-tree.xml
  go ui-snapshot
  adb shell run-as "$PKG" cat files/test-view-tree.xml > "$OUT/$1.xml"
  python3 - "$OUT/$1.xml" <<'PYXML'
import sys,xml.etree.ElementTree as ET
root=ET.parse(sys.argv[1]).getroot()
assert root.tag=='hierarchy' and root.find('node') is not None, 'Missing UI snapshot'
PYXML
  adb exec-out screencap -p > "$OUT/$1.png"
}
read_prefs() {
  adb shell run-as "$PKG" cat shared_prefs/launcher.xml | tr -d '\r' > "$OUT/opel-theme-prefs.xml"
}
assert_stored_theme() {
  read_prefs
  python3 - "$OUT/opel-theme-prefs.xml" "$theme" <<'PY'
import sys,xml.etree.ElementTree as ET
prefs={e.get('name'):e.text for e in ET.parse(sys.argv[1]).getroot()}
assert prefs.get('premium_theme')==sys.argv[2], 'Stored standard theme lost'
assert prefs.get('opel_projection')=='aa', 'Opel projection setting lost'
assert prefs.get('opel_theme')=='light', 'Opel theme setting lost'
PY
}
for theme in aurora cobalto carbono cards; do
  go idioma:en
  go pref:home_layout=standard
  go pref:design=stradaos
  go pref:opel_projection=aa
  go pref:opel_theme=light
  if [ "$theme" = cards ]; then
    go pref:show_player=true
    go pref:cards_player_open=true
  fi
  go "tema-premium:$theme"
  go inicio
  dump "theme-$theme-standard"
  if [ "$theme" = carbono ]; then
    grep -Fq 'class="com.stradaos.launcher.Carbono$Car"' "$OUT/theme-$theme-standard.xml"
  fi
  if [ "$theme" = cards ]; then
    grep -Fq 'class="com.stradaos.launcher.Cards$Speaker"' "$OUT/theme-$theme-standard.xml"
  fi
  go pref:home_layout=compact_7
  go pref:design=opel_navi_900_modern
  go inicio
  dump "theme-$theme-opel"
  grep -q 'OPEL · STRADAOS' "$OUT/theme-$theme-opel.xml"
  grep -q 'Android Auto' "$OUT/theme-$theme-opel.xml"
  assert_stored_theme
  # Personalization remains available in Opel so users can choose another design.
  # Merely opening it must not change the saved standard theme.
  go vista-temas:h
  dump "theme-$theme-opel-settings"
  grep -q 'class="com.stradaos.launcher.OpelThumb"' "$OUT/theme-$theme-opel-settings.xml"
  grep -q 'text="FREE THEMES"' "$OUT/theme-$theme-opel-settings.xml"
  assert_stored_theme
  adb shell am force-stop "$PKG"
  go inicio
  dump "theme-$theme-opel-restart"
  grep -q 'OPEL · STRADAOS' "$OUT/theme-$theme-opel-restart.xml"
  assert_stored_theme
  go pref:home_layout=standard
  go pref:design=stradaos
  go inicio
  dump "theme-$theme-standard-restored"
  if [ "$theme" = carbono ]; then
    grep -Fq 'class="com.stradaos.launcher.Carbono$Car"' "$OUT/theme-$theme-standard-restored.xml"
  fi
  if [ "$theme" = cards ]; then
    grep -Fq 'class="com.stradaos.launcher.Cards$Speaker"' "$OUT/theme-$theme-standard-restored.xml"
  fi
  if grep -q 'OPEL · STRADAOS' "$OUT/theme-$theme-standard-restored.xml"; then
    echo '::error::Opel layout persisted after returning to standard'; exit 1
  fi
  assert_stored_theme
done
# Brightness changes must follow opel_theme even when the standard mode is fixed Light.
go tema-premium:
go sim:0
go pref:home_layout=compact_7
go pref:design=opel_navi_900_modern
go pref:theme=light
adb shell settings put system screen_brightness_mode 0
adb shell settings put system screen_brightness 230
go pref:auto_bright=true
go pref:opel_theme=auto
go inicio
dump opel-brightness-light
adb shell settings put system screen_brightness 20
sleep 3
dump opel-brightness-dark
adb shell settings put system screen_brightness 230
sleep 3
dump opel-brightness-light-restored
python3 - "$OUT" <<'PYBRIGHT'
from pathlib import Path
import sys,xml.etree.ElementTree as ET
p=Path(sys.argv[1])
for name,color in [('opel-brightness-light','ffe9edf1'),('opel-brightness-dark','ff17191d'),('opel-brightness-light-restored','ffe9edf1')]:
 root=ET.parse(p/(name+'.xml')).getroot()
 assert root.find('node').get('background-color')==color, name+': brightness observer did not update the Opel view'
PYBRIGHT
read_prefs
python3 - "$OUT/opel-theme-prefs.xml" <<'PYPREFS'
import sys,xml.etree.ElementTree as ET
prefs={e.get('name'):e.text for e in ET.parse(sys.argv[1]).getroot()}
assert prefs.get('theme')=='light' and prefs.get('opel_theme')=='auto', 'Per-style theme modes changed'
PYPREFS
go pref:auto_bright=false
# FYT light events must follow the active Opel mode while standard stays Light.
go pref:hw=fyt
adb shell settings put system car_mode 0
go pref:opel_theme=system
go inicio
dump opel-fyt-light
adb shell settings put system car_mode 1
sleep 2
dump opel-fyt-dark
# The optional delay holds the previous color, then applies the requested color.
go pref:theme_delay_dark=5
go pref:theme_delay_light=5
go pref:theme_delay_on=true
adb shell settings put system car_mode 0
dump opel-fyt-delay-held
sleep 3
dump opel-fyt-delay-settled
python3 - "$OUT" <<'PYFYT'
from pathlib import Path
import sys,xml.etree.ElementTree as ET
p=Path(sys.argv[1])
for name,color in [('opel-fyt-light','ffe9edf1'),('opel-fyt-dark','ff17191d'),('opel-fyt-delay-held','ff17191d'),('opel-fyt-delay-settled','ffe9edf1')]:
 root=ET.parse(p/(name+'.xml')).getroot()
 assert root.find('node').get('background-color')==color, name+': FYT light/delay did not update the Opel view'
PYFYT
read_prefs
python3 - "$OUT/opel-theme-prefs.xml" <<'PYFYT_PREFS'
import sys,xml.etree.ElementTree as ET
prefs={e.get('name'):e.get('value', e.text) for e in ET.parse(sys.argv[1]).getroot()}
assert prefs.get('theme')=='light' and prefs.get('opel_theme')=='system', 'FYT changed per-style theme modes'
assert prefs.get('opel_theme_last_dark')=='false', 'Settled Opel color was not saved independently'
PYFYT_PREFS
go pref:theme_delay_on=false
go pref:hw=generic
adb shell settings delete system car_mode
go pref:opel_theme=light
go pref:home_layout=standard
go pref:design=stradaos
adb logcat -b crash -d > "$OUT/opel-theme-crashes.txt"
if grep -q "$PKG" "$OUT/opel-theme-crashes.txt"; then
  echo '::error::Opel/standard theme transition crashed'; exit 1
fi
printf 'Aurora/Cobalto/Carbono: Opel layout, projection, theme settings, restart preservation, brightness isolation and FYT light/delay checks passed.\n' > "$OUT/opel-theme-result.txt"
