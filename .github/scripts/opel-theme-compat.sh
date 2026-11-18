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
  adb shell uiautomator dump /data/local/tmp/opel-theme.xml > /dev/null
  adb pull /data/local/tmp/opel-theme.xml "$OUT/$1.xml" > /dev/null
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
for theme in aurora cobalto; do
  go idioma:en
  go pref:home_layout=standard
  go pref:design=stradaos
  go pref:opel_projection=aa
  go pref:opel_theme=light
  go "tema-premium:$theme"
  go inicio
  dump "theme-$theme-standard"
  go pref:home_layout=compact_7
  go pref:design=opel_navi_900_modern
  go inicio
  dump "theme-$theme-opel"
  grep -q 'OPEL · STRADAOS' "$OUT/theme-$theme-opel.xml"
  grep -q 'Android Auto' "$OUT/theme-$theme-opel.xml"
  assert_stored_theme
  # Standard-only personalization must be absent from the Opel settings UI.
  go ajustes:11
  dump "theme-$theme-opel-settings"
  if grep -Eq 'text="(Personalization|Free themes|Premium themes)"' "$OUT/theme-$theme-opel-settings.xml"; then
    echo '::error::Standard theme controls exposed in Opel Style'; exit 1
  fi
  # Theme commands cannot replace saved standard choices while Opel Style is active.
  go tema-gratis:1
  go tema-premium:aurora
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
  if grep -q 'OPEL · STRADAOS' "$OUT/theme-$theme-standard-restored.xml"; then
    echo '::error::Opel layout persisted after returning to standard'; exit 1
  fi
  assert_stored_theme
done
adb logcat -b crash -d > "$OUT/opel-theme-crashes.txt"
if grep -q "$PKG" "$OUT/opel-theme-crashes.txt"; then
  echo '::error::Opel/standard theme transition crashed'; exit 1
fi
printf 'Aurora/Cobalto: Opel layout, projection, theme settings and restart preservation passed.\n' > "$OUT/opel-theme-result.txt"
