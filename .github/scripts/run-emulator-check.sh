#!/usr/bin/env bash
set -euo pipefail
: "${TEST_API:?Missing Android API}"
: "${TEST_MODE:?Missing test mode}"
shopt -s nullglob
APKS=(emulator-apk/*.apk)
[[ ${#APKS[@]} -eq 1 ]] || { echo 'Expected exactly one APK'; exit 1; }
OUT="capturas/api$TEST_API"
mkdir -p "$OUT"
case "$TEST_MODE" in
  debug)
    bash .github/scripts/smoke.sh "$TEST_API" "${APKS[0]}" "$OUT"
    if [ "$TEST_API" = 30 ]; then
      bash .github/scripts/opel-theme-compat.sh "$OUT"
      python3 .github/scripts/opel-controls-check.py "$OUT/controls"
      python3 .github/scripts/opel-gallery-check.py "$OUT/gallery"
    fi
    ;;
  opel) bash .github/scripts/opel-smoke.sh "$TEST_API" "${APKS[0]}" "$OUT" ;;
  *) echo "Unknown test mode: $TEST_MODE"; exit 1 ;;
esac
