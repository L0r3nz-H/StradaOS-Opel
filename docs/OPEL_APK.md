# Installable Opel edition

- App name: **StradaOS Opel**
- Package: `com.stradaos.launcher.opel`, installed alongside StradaOS and StradaOS Prueba
- Version: `2.21.2-opel`, versionCode 54
- Android: minSdk 16, targetSdk 28; screen resolution remains unchanged
- Build type: `opel`, based on `release`, not debuggable

On first installation, this edition selects **Opel Style**, the compact vehicle
view, and the name **Astra J**. The setup wizard remains available. Later user
settings are preserved across launches. Dark, Light, Automatic, and System modes
remain selectable, with a separate Opel preference. Opel Style uses a fixed red
accent and hides the custom accent selector, including during setup.

The Opel edition does not offer ordinary StradaOS updates. Compatible updates
must use the same package name and Opel signing key.

## Installation file — 2026-11-16

The locally signed installation file is:

`app/build/outputs/install/StradaOS-Opel-2.21.2.apk`

Its SHA-256 checksum is in `StradaOS-Opel-2.21.2.apk.sha256` beside it. Copy the
APK to the Android head unit and open it with its file manager. Allow installation
from that source if requested. The different package does not replace an existing
standard StradaOS installation or automatically import its settings.

## Build and signing

Branch `feature/opel-latest-2.21.2` is based directly on upstream 2.21.2, commit
`b2f327dcfae5e8341cb7851c525dc893545b3ee2` dated 2026-11-15. The previous Opel
branch is retained. This port preserves the Opel package and update separation
while reusing upstream maintenance, backup, portrait layout, system/scheduled
themes, and speed correction.

```sh
./gradlew assembleDebug assembleOpel lintOpel
```

This produces the **unsigned** intermediate APK at
`app/build/outputs/apk/opel/StradaOS-2.21.2-opel.apk`. Align it with `zipalign`
before signing with `apksigner`. The distributed file has v1, v2, and v3 signatures;
v1 is included for Android 4.2, and verification uses `--min-sdk-version 16`.

The local key is stored outside the repository at
`~/.config/stradaos/opel-signing/stradaos-opel.jks`, alias `stradaos-opel`.
Its password file is in the same protected directory. Keep that directory for
future compatible updates. This key is independent of official StradaOS releases.

## Validation history

### 2.15.0-opel

- `assembleOpel` succeeded. `aapt` confirmed the app name, package, SDK levels,
  and absence of the debuggable flag.
- `apksigner verify --verbose --min-sdk-version 16` passed with v1/v2/v3.
- Installed and launched on an Android 11 emulator: permission prompts showed
  StradaOS Opel, followed by the compact photo view and Astra J. No crash entry.
- Lint reported 60 errors, 1 fatal issue, and 62 warnings. Because
  `abortOnError false` is configured, task success does not mean a clean report.
- API 17 and manufacturer-specific radio, Bluetooth, and CarPlay functions
  still require testing on the target device.

### 2.16.0-opel — 2026-11-11

- `assembleOpel lintOpel` succeeded with JDK 17 and Android SDK 35.
- Metadata: package `com.stradaos.launcher.opel`, version `2.16.0-opel`,
  versionCode 46, minSdk 16, targetSdk 28.
- All 33 Java files also compiled with Java 8 as the target language level.
- The inherited desktop harness rendered a real Monaco mapsforge map in both
  light and dark modes.
- Lint reported 60 errors, 1 fatal issue, and 60 warnings, with no increase in
  severe findings. The build APK was unsigned; no new installation APK or
  emulator/target-device test was produced for that revision.

### 2.21.2-opel — 2026-11-16

- `assembleDebug assembleOpel lintOpel` succeeded with JDK 17, Gradle 8.11.1,
  and Android SDK 35. minSdk 16 and targetSdk 28 remain unchanged.
- The installation APK uses the existing Opel key. Signature verification with
  minimum SDK 16 passed for v1/v2/v3; the certificate matches the distributed
  2.15.0 APK. Metadata: StradaOS Opel, `com.stradaos.launcher.opel`,
  `2.21.2-opel`, versionCode 54.
- The initial port reported 72 lint errors, 1 fatal issue, and 81 warnings.
  Opel Java lines changed relative to upstream had no errors/fatal findings and
  one RTL warning. The full report remains unclean.
- A native ARM64 Android 11/API 30 test environment was subsequently installed
  at 1024 × 600 and 160 dpi. The signed APK installs as an update and launches.
  Appearance was checked in both styles: the single design selector switches
  directly to compact Opel, the accent section is absent there, and switching
  back restores the chosen standard accent and Dark mode. Opel Light persisted
  independently across a restart.
- Six debug-package startup cases passed: old Opel/standard, StradaOS/compact,
  canonical Opel/compact, canonical StradaOS/standard, missing values, and unknown
  values. Both design-switch directions wrote the matching layout while
  preserving accent, per-style modes, car name, and dock assignment.
- No lint finding is on the Java lines changed for this menu refinement. The
  full lint totals remain 72 errors, 1 fatal issue, and 81 warnings. The crash
  log was empty during the emulator checks.
- Device-specific functions and Android 4.2/API 17 runtime compatibility remain
  outside this emulator's coverage.

## Simplified style selection

Appearance now offers **StradaOS** and **Opel Style** through one selector.
Opel Style always activates the 7-inch compact layout. Switching to StradaOS
restores its standard layout, stored accent, and separate light/dark preference.
Legacy installations with either the old Opel design or the compact layout are
normalized to Opel Style. Compact vehicle/map, four-shortcut, and optional GPS
speed settings remain available. See [the compact layout specification](COMPACT_7_INCH_PLAN.md).
