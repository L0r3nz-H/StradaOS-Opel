#!/usr/bin/env bash
# Hosted API 30: real demo-engine samples through the Opel home view.
set -euo pipefail
OUT=${1:?Missing output directory}
PKG=com.stradaos.launcher.debug
ACT=$PKG/com.stradaos.launcher.Main
mkdir -p "$OUT"
go() {
  adb shell am start -W -n "$ACT" --es prueba "$1" > "$OUT/last-start.txt"
  sleep 2
  adb shell pidof "$PKG" >/dev/null
}
snapshot() {
  adb shell run-as "$PKG" rm -f files/test-view-tree.xml
  go ui-snapshot
  adb shell run-as "$PKG" cat files/test-view-tree.xml > "$OUT/$1.xml"
  adb exec-out screencap -p > "$OUT/$1.png"
}
go idioma:en
go pref:home_layout=compact_7
go pref:design=opel_navi_900_modern
go pref:compact_show_speed=true
go pref:obd_speed=true
go obd-demo
sleep 40
go obd-vel-demo:1
go inicio
snapshot obd-speed
go pref:obd_speed=false
snapshot gps-selected
go pref:obd_speed=true
snapshot obd-restored
go obd-off
go obd-vel-demo:0
snapshot scanner-stopped
python3 - "$OUT" <<'PY'
from pathlib import Path
import re,sys,xml.etree.ElementTree as ET
out=Path(sys.argv[1])
for name,obd in [('obd-speed',True),('gps-selected',False),('obd-restored',True),('scanner-stopped',False)]:
    nodes=list(ET.parse(out/(name+'.xml')).getroot().iter('node'))
    assert any(n.get('text')=='OPEL · STRADAOS' for n in nodes), name+': Opel layout lost'
    speed=[n for n in nodes if re.match(r'^OBD: \d+ (km/h|mph)$', n.get('content-desc',''))]
    assert bool(speed)==obd, name+': wrong speed source'
    if obd:
        assert any(re.match(r'^\d+ OBD$', n.get('text','')) for n in speed), name+': missing visible OBD label'
    else:
        assert any(n.get('content-desc','').startswith('GPS speed: ') for n in nodes), name+': GPS fallback lost'
print('Opel OBD speed selection, visible source, opt-out and scanner-stop fallback passed.')
PY
adb logcat -b crash -d > "$OUT/crashes.txt"
if grep -q "$PKG" "$OUT/crashes.txt"; then
  echo '::error::Opel OBD speed check crashed'; exit 1
fi
