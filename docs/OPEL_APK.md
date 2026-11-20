# Installable Opel edition

## Current design selection

Use **Settings → Personalization → Landscape → Opel Style** (the first card).
Select another standard/premium card in the same gallery to leave Opel Style.
Personalization stays available in Opel Style; Appearance no longer offers the
design selector. Earlier selection menus described below are historical.

## Published preview — 2026-11-17

[StradaOS Opel 2.23.0 Preview](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/opel-2.23.0-preview.1)
is a prerelease from commit `5b9159be770f8bfaa23ce319857860bcdef808f9`, based on
upstream `v2.23.0` / `42ecf12c4a42b7d43024f8adfc9e720f99322d20`.
Version `2.23.0-opel`, versionCode 56; stable Latest remains 2.22.0.

- GitHub-hosted `assembleDebug assembleOpel lintOpel` passed. Actual lint XML
  comparison found no additional Error/Fatal findings: baseline 72 errors,
  1 fatal, 82 warnings; preview 72 errors, 1 fatal, 91 warnings.
- Opel package/name/version, minSdk 16, targetSdk 28, non-debuggable flag and
  increasing versionCode were checked. zipalign and v1/v2/v3 signature verification
  with minimum SDK 16 passed. The certificate matches published Opel 2.22.0.
- Signed APK installation and three cold starts passed on Android 11/API 30,
  1024 × 600, with no Opel crash entry. This does not cover API 17, detailed
  settings interactions or vehicle/head-unit hardware.
- Release APK SHA-256:
  `8f10942411516a551360664cdae9bc396d040dc68d66e8d7f69aeb88b48a15ff`.
  Both uploaded asset digests were verified. Re-running publication skipped the
  existing identical release without changing its tag or assets.
- Verification run: [Opel preview 44118771959](https://github.com/L0r3nz-H/StradaOS-Opel/actions/runs/44118771959).
  The same signed artifact was published from the VPS after fast-forwarding main
  to the exact tested commit; no Android build or key export occurred on the VPS.

## Published releases — 2026-11-16

1. [StradaOS Opel 2.16.0](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/v2.16.0)
   was published first, from historical Opel commit `48d2993`, versionCode 46.
2. [StradaOS Opel 2.22.0](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/v2.22.0)
   followed 15 seconds later, from `b7da6ce`, versionCode 55, and is **Latest**.

Each release includes a signed `StradaOS-Opel-<version>.apk` and its `.apk.sha256`
checksum. Both use the existing Opel key, matching previously distributed Opel
APKs. v1/v2/v3 signatures were verified at minimum SDK 16, along with package,
app label, version, SDK levels, APK alignment, and uploaded asset sizes/digests.
2.22.0 installed over the previous Opel version and launched on Android 11/API 30;
no crash entry occurred. No new runtime test was performed for historical 2.16.0.
The earlier build records below remain historical rather than claims about a
new target-device test. API 17 and manufacturer-specific functions still need
hardware validation.

- App name: **StradaOS Opel**
- Package: `com.stradaos.launcher.opel`, installed alongside StradaOS and StradaOS Prueba
- Latest version: `2.22.0-opel`, versionCode 55
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

`app/build/outputs/install/StradaOS-Opel-2.22.0.apk`

Its SHA-256 checksum is in `StradaOS-Opel-2.22.0.apk.sha256` beside it. Copy the
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
`app/build/outputs/apk/opel/StradaOS-2.22.0-opel.apk`. Align it with `zipalign`
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

## Previous simplified style selection

Appearance previously offered **StradaOS** and **Opel Style** through one selector.
Opel Style always activates the 7-inch compact layout. Switching to StradaOS
restores its standard layout, stored accent, and separate light/dark preference.
Legacy installations with either the old Opel design or the compact layout are
normalized to Opel Style. Compact vehicle/map, four-shortcut, and optional GPS
speed settings remain available. See [the compact layout specification](COMPACT_7_INCH_PLAN.md).

## Upstream sync validation — 2.22.0-opel

- `assembleDebug assembleOpel lintOpel` passed after merging upstream `0a7736f`.
- Lint totals: 72 errors, 1 fatal issue, 82 warnings; task success does not mean
  a clean report. minSdk 16 and targetSdk 28 are unchanged.
- Debug APK checked on Android 11/API 30, 1024 × 600: Opel compact home,
  new idle screen with simulated GPS speed 62 km/h, wake touch, style selector,
  sunrise/sunset settings, and Chinese labels. API 17 and hardware tests remain.
- This sync produced unsigned Opel and debug build outputs. The older signed
  2.21.2 installation APK described above remains a separate historical artifact.

## GitHub-hosted verification and prereleases

GitHub Pages is not required by this fork. The inherited `pages.yml` deployment
workflow was intentionally removed; keep it removed during future upstream syncs.
The `site/` source remains in the repository. APK builds, verification, signing
and GitHub Releases operate independently of website hosting.

The VPS performs Git operations only. Android builds, signing and emulator tests
run on GitHub-hosted runners through `Opel preview`. Both upstream debug UI tests
and signed Opel installation/three cold starts cover APIs 16, 19, 21, 23, 24, 28,
30 and 34, matching the original emulator matrix. Screenshots and logs are saved
as per-API workflow artifacts. Emulator failures block publication.
Repository Actions secrets are `OPEL_KEYSTORE_BASE64`, `OPEL_KEYSTORE_PASSWORD`,
`OPEL_KEY_ALIAS` and `OPEL_KEY_PASSWORD`. The existing Opel keystore stays backed
up on the original machine; it is not copied to the VPS.

A sync records its stable upstream release ID, tag, resolved commit, previous Opel
`main` commit and unique preview tag in `.github/upstream-sync.json`.
Pull requests build debug/Opel, compare actual lint XML findings against that
baseline, validate APK metadata and run the full upstream debug UI emulator
matrix without accessing signing secrets.
Dispatch `opel-preview.yml` on a sync branch with `publish=false` to additionally
verify signing against the published Opel 2.22.0 certificate and run the signed
Opel startup matrix in addition to the upstream debug UI tests. Only after these checks pass may the sync be
merged/pushed to `main`. Dispatch on that exact `main` commit with `publish=true`
to repeat verification and publish the APK plus checksum as a prerelease.

Tags use `opel-<upstream-version>-preview.<n>` and never move. Existing identical
releases are skipped; inconsistent tags/assets block publication. A retry after
pushing `main` can dispatch the pending marker again. Stable Latest and official
update metadata are unchanged. The inherited official release and debug-release
publication jobs are restricted to the original upstream repository.

Existing lint findings remain visible; any additional Error/Fatal finding blocks
the workflow. Emulator coverage does not establish API 17, detailed Opel settings
interaction or head-unit hardware compatibility. The separate inherited
`pruebas.yml` uses the same reusable emulator workflow, retains its screenshot
branch, and explicitly depends on both build and emulator results when publishing
that report. The preview release depends on both emulator matrices succeeding.


## Published upstream 2.24.0 preview (historical candidate notes)

The stable upstream tag resolves to `858e2a5c4e958076ee47c489caff9752d8f57af2`.
The candidate uses version `2.24.0-opel`, versionCode 57, and compares against
Opel main `20ccfb869964b82e4f656b339c2d583793faa370`.
Personalization/Aurora/Cobalto apply only in the standard layout. Opel Style keeps
its fixed dashboard, red accent, per-style theme settings, Astra fallback and
projection shortcuts. Standard themes remain stored while Opel Style is active.
The official update metadata and removed Pages workflow remain unchanged.
This candidate is not a published release until the hosted build, signature and
both eight-version emulator matrices succeed and publication completes.


## Published upstream 2.24.1 preview (historical candidate notes)

Stable upstream `v2.24.1` resolves to `0644024d9a73f27dc055170820e6d290915b7977`.
The candidate uses version `2.24.1-opel`, versionCode 58, against Opel main
`5592bd25f826da227a15ffe3fbb86611ff2429a1`. It preserves the Opel layout,
projection controls, update isolation and stored standard themes. The new
brightness observer reads the active style's theme setting, preserving independent
standard and Opel modes. An API 30 check verifies actual Opel background colors
when system brightness changes, with the standard mode fixed to Light.
Both full emulator matrices, lint/signature/metadata gates and this additional
check must pass before integration. The already integrated 2.24.0 publication must
finish before main can advance to this candidate.


## Completed 2.24 publications and pending 2.25.0 sync

[Opel 2.24.0 Preview](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/opel-2.24.0-preview.1)
was published from `5592bd25f826da227a15ffe3fbb86611ff2429a1` by successful
workflow run `44345847474`.
[Opel 2.24.1 Preview](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/opel-2.24.1-preview.1)
was published from `69688ad59854c071c294f635b8ca1dcf95082f6b` by successful
workflow run `44351427891`. Both completed signing and both eight-version
emulator matrices. The historical candidate notes above describe their preparation.
Stable Latest remains 2.22.0; existing release assets/tags are unchanged.

The next stable upstream tag is `v2.25.0`, release ID 451430222, resolved commit
`6d092e6830d19a30c36e2ffe030536a809be727b`. The candidate is `2.25.0-opel`,
versionCode 59, based on Opel main `cdc6b13aa351789c404820d22695a6099137134b`.
It preserves the integrated Opel Personalization gallery, its controls and tests,
strict lint/test gates, certificate-trust fixes, update separation and removed Pages.
The new media/notif hints retain null-safe Opel widget updates and the conditional
Android Auto settings. Existing MediaWatcher resource cleanup is retained alongside
new HCN cleanup. Build/signing/lint and both emulator matrices remain pending.


## Completed 2.25.0 and pending 2.25.2 sync — 2026-11-19

[Opel 2.25.0 Preview](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/opel-2.25.0-preview.1)
was published from `b76afbdcad7de81ec7d59c3364b272fedd9c978a` by successful
[workflow 44571516199](https://github.com/L0r3nz-H/StradaOS-Opel/actions/runs/44571516199).
Builds, unit tests, strict lint, metadata/signature/certificate checks and both
complete eight-API emulator matrices passed. Lint had no Error/Fatal findings
(baseline: one information; preview: 17 warnings and one information).
The signed APK SHA-256 is
`b6ae897e900580fcb2ebace2065962ea5f04b2b1fbad582bc03579704b7cd654`.
Stable Latest remains Opel 2.22.0.

The new candidate merges only published upstream `v2.25.2`, release ID 451869164,
commit `5ed05a3537c575d58da440f0c68a29b034d9b0f2`, against that Opel baseline.
Version `2.25.2-opel`, versionCode 61, includes the released 2.25.1 FYT support
and Hungarian translation. The Opel palette, independent style modes and layout
controls remain; FYT light observation reads the active style, and the delayed
color cache/persisted state is isolated between standard and Opel styles.
API 30 debug checks additionally exercise FYT light changes and delayed colors.
FYT defaults to Generic and needs explicit selection; proprietary hardware data
and API 17 remain untested. Signing, lint and both full emulator matrices must
pass on GitHub runners before main integration/publication. No local Android
builds or signing are used. Pages and official release/update guards remain.


## Completed 2.25.2 and pending 2.26.0 sync — 2026-11-20

[Opel 2.25.2 Preview](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/opel-2.25.2-preview.1)
was published from `4aee951932ec761f2badae31b94e22f1e270b427` after successful
hosted workflow `44636762941`, including signing and both full emulator matrices.

The new candidate merges only stable upstream `v2.26.0`, release ID 452770406,
commit `1d21e7eaef74bd3bde4a767de4a81809f7ad1593`, against that Opel main baseline.
Version `2.26.0-opel`, versionCode 62, adds the upstream opt-in OBD-II scanner,
vehicle overlay, fault-code information and offline guide. Opel palette setup
still runs before building the home view; the new overlay attaches afterward.
Settings retain Opel category labels and defensive bounds checks, alongside OBD
subpages and listener cleanup. Backup excludes both per-style delayed theme state
and the optional AI key. The Opel gallery, Astra fallback, projection controls,
migrations, package identity, official-update isolation and Pages removal remain.

Hosted build/unit/lint/signature checks and both complete eight-API emulator
matrices are required before integration and publication. No Android tools run
on the VPS. API 17 and vehicle hardware, including real OBD-II adapters, remain
untested; normal startup coverage does not establish full OBD or vehicle UI behavior.


### 2.26.0 Bluetooth permission correction

Hosted lint initially blocked the candidate on 16 missing Bluetooth scan/connect
permission findings in the upstream OBD code. The candidate now declares nearby
device permissions, checks them before Bluetooth connection/discovery on API 31+,
and requests them only for Bluetooth actions (Wi-Fi/demo remain independent).
The engine refuses a Bluetooth connection if permission is absent. Legacy Bluetooth
permissions and minSdk 16 / targetSdk 28 remain, and all strict lint gates remain
active. Real adapter pairing/connection still requires vehicle hardware validation.
