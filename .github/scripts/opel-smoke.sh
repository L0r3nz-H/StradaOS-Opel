#!/usr/bin/env bash
set -euo pipefail
API=${1:?Missing Android API}
APK=${2:?Missing signed APK}
OUT=${3:?Missing output directory}
mkdir -p "$OUT"
PKG=com.stradaos.launcher.opel
adb wait-for-device
if [ "$API" -ge 18 ]; then
  adb shell wm size 1024x600
  adb shell wm density 160
else
  adb shell am display-size 1024x600
  adb shell am display-density 160
fi
adb shell input keyevent 82 || true
adb install -r "$APK" | tee "$OUT/install.txt"
grep -q Success "$OUT/install.txt"
adb logcat -c
# Save diagnostics even if installation/launch checks fail.
collect_logs() {
  adb logcat -d > "$OUT/logcat.txt" 2>&1 || true
  adb shell dumpsys package "$PKG" > "$OUT/package.txt" 2>&1 || true
}
trap collect_logs EXIT
for attempt in 1 2 3; do
  adb shell am force-stop "$PKG"
  adb shell am start -W -n "$PKG/com.stradaos.launcher.Main" | tee "$OUT/start-$attempt.txt"
  grep -q 'Status: ok' "$OUT/start-$attempt.txt"
  sleep 8
  # Android 4.x does not provide pidof. ps works across the original API matrix.
  adb shell ps | tr -d '\r' | awk -v pkg="$PKG" '$NF == pkg { found=1 } END { exit !found }'
done
adb shell screencap -p /data/local/tmp/opel-startup.png
adb pull /data/local/tmp/opel-startup.png "$OUT/opel-startup.png"
collect_logs
adb logcat -d -s AndroidRuntime:E > "$OUT/runtime-errors.txt"
if grep -q 'FATAL EXCEPTION' "$OUT/runtime-errors.txt" || grep -q "ANR in $PKG" "$OUT/logcat.txt"; then
  echo "::error::Signed Opel APK crashed or stopped responding on API $API"
  exit 1
fi
printf 'Signed Opel install and three cold starts passed on API %s\n' "$API"
