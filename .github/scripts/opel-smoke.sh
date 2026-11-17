#!/usr/bin/env bash
set -euo pipefail
mkdir -p smoke
PKG=com.stradaos.launcher.opel
adb wait-for-device
adb shell wm size 1024x600
adb shell wm density 160
adb install -r dist/*.apk
adb logcat -c
for attempt in 1 2 3; do
  adb shell am force-stop "$PKG"
  adb shell am start -W -n "$PKG/com.stradaos.launcher.Main" | tee "smoke/start-$attempt.txt"
  grep -q 'Status: ok' "smoke/start-$attempt.txt"
  sleep 8
  adb shell pidof "$PKG"
done
adb exec-out screencap -p > smoke/opel-startup.png
adb logcat -b crash -d > smoke/crash.txt
if grep -q "$PKG" smoke/crash.txt; then
  cat smoke/crash.txt
  exit 1
fi
adb shell dumpsys package "$PKG" > smoke/package.txt
