#!/usr/bin/env bash
set -euo pipefail
mkdir -p verification
BASE=$(python3 -c 'import json; print(json.load(open(".github/upstream-sync.json"))["baseline_commit"])')
[[ "$BASE" =~ ^[0-9a-f]{40}$ ]]
git merge-base --is-ancestor "$BASE" HEAD
BASE_DIR=$(mktemp -d "$RUNNER_TEMP/opel-baseline.XXXXXX")
trap 'rm -rf "$BASE_DIR"' EXIT
git archive "$BASE" | tar -x -C "$BASE_DIR"
(cd "$BASE_DIR" && bash ./gradlew --no-daemon --max-workers=2 lintOpel)
cp "$BASE_DIR/app/build/reports/lint-results-opel.xml" verification/baseline-lint.xml
bash ./gradlew --no-daemon --max-workers=2 assembleDebug assembleOpel test lintDebug lintOpel lintRelease
python3 .github/scripts/opel-verify.py "$BASE_DIR"
