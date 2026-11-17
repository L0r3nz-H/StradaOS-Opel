#!/usr/bin/env bash
set -euo pipefail
: "${OPEL_KEYSTORE_BASE64:?Missing Opel keystore}"
: "${OPEL_KEYSTORE_PASSWORD:?Missing store password}"
: "${OPEL_KEY_ALIAS:?Missing alias}"
: "${OPEL_KEY_PASSWORD:?Missing key password}"
KEY_DIR=$(mktemp -d "$RUNNER_TEMP/opel-key.XXXXXX")
trap 'rm -rf "$KEY_DIR"' EXIT
umask 077
printf '%s' "$OPEL_KEYSTORE_BASE64" | base64 --decode > "$KEY_DIR/opel.jks"
TOOLS="$ANDROID_HOME/build-tools/35.0.0"
VERSION=$(python3 -c 'import re; print(re.search(r"versionName '\''([^'\'']+)'\''",open("app/build.gradle").read())[1])')
mkdir -p dist
APK="dist/StradaOS-Opel-$VERSION.apk"
"$TOOLS/zipalign" -p -f 4 "app/build/outputs/apk/opel/StradaOS-$VERSION-opel.apk" "$KEY_DIR/aligned.apk"
"$TOOLS/apksigner" sign --ks "$KEY_DIR/opel.jks" --ks-key-alias "$OPEL_KEY_ALIAS" \
  --ks-pass env:OPEL_KEYSTORE_PASSWORD --key-pass env:OPEL_KEY_PASSWORD \
  --min-sdk-version 16 --v1-signing-enabled true --v2-signing-enabled true \
  --v3-signing-enabled true --out "$APK" "$KEY_DIR/aligned.apk"
"$TOOLS/zipalign" -c -p 4 "$APK"
"$TOOLS/apksigner" verify --verbose --print-certs --min-sdk-version 16 "$APK" > "$KEY_DIR/new-cert.txt"
for v in 1 2 3; do grep -Eq "Verified using v$v scheme.*true" "$KEY_DIR/new-cert.txt"; done
# Fixed existing stable Opel release is the trust anchor, never an upstream APK.
gh release download v2.22.0 --repo "$GITHUB_REPOSITORY" --pattern StradaOS-Opel-2.22.0.apk --dir "$KEY_DIR"
"$TOOLS/apksigner" verify --print-certs --min-sdk-version 16 "$KEY_DIR/StradaOS-Opel-2.22.0.apk" > "$KEY_DIR/old-cert.txt"
grep 'Signer #1 certificate SHA-256 digest:' "$KEY_DIR/new-cert.txt" > "$KEY_DIR/new-digest"
grep 'Signer #1 certificate SHA-256 digest:' "$KEY_DIR/old-cert.txt" > "$KEY_DIR/old-digest"
diff -u "$KEY_DIR/old-digest" "$KEY_DIR/new-digest"
(cd dist && sha256sum "StradaOS-Opel-$VERSION.apk" > "StradaOS-Opel-$VERSION.apk.sha256")
cp verification/summary.json dist/verification.json
printf '%s\n' "$GITHUB_SHA" > dist/commit.txt
printf 'Verified v1/v2/v3 signatures and existing Opel certificate.\n'
