## Upstream 2.23.0 sync — published preview

Upstream release `v2.23.0`, commit `42ecf12c4a42b7d43024f8adfc9e720f99322d20`,
adds optional built-in navigation, disabled by default. The Opel port was integrated
into main at `5b9159be770f8bfaa23ce319857860bcdef808f9` after GitHub-hosted build,
lint regression, signature/certificate and signed Android 11 startup checks passed.
[Opel 2.23.0 Preview](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/opel-2.23.0-preview.1)
contains the signed APK and checksum. Stable Latest remains 2.22.0.
Lint remains unclean (72 errors, 1 fatal finding, 91 warnings), with no additional
Error/Fatal findings versus the baseline (82 warnings). API 17, settings interactions
and head-unit hardware remain outside this startup test's coverage.
The previous release and validation records below remain historical.

# StradaOS project status

Updated: 2026-11-16. Current Opel source: **2.22.0-opel**, versionCode **55**.
The historical roadmap below records the earlier upstream snapshot; the sync update below supersedes items shipped or reviewed afterward.

Published Opel releases are now available:
[2.16.0](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/v2.16.0) and
[2.22.0 (Latest)](https://github.com/L0r3nz-H/StradaOS-Opel/releases/tag/v2.22.0),
with signed APKs and checksums. See [installation](OPEL_APK.md).

## Current Opel edition

This fork ports the Opel work onto upstream
`0a7736f` (StradaOS 2.22.0).
The previous `feature/opel-navi900-theme` branch is retained.

- Application **StradaOS Opel**, package `com.stradaos.launcher.opel`, with a
  separate signing key and installation alongside standard StradaOS.
- Appearance offers **StradaOS** or **Opel Style**. Opel Style selects the
  7-inch compact layout directly, replacing independent design/layout selectors.
- Fixed red Opel accent; custom accent controls are hidden in Appearance/setup.
  Dark, Light, Auto, and System modes remain available with separate per-style
  settings. Switching back restores standard colors, modes, and assignments.
- Two large panels: vehicle or map, plus media. Transparent Astra J image,
  name above the image, optional centered GPS speed, centered header clock.
  Without speed, name and image are centered together. User photos take priority.
- Optional four-action dock: Radio, CarPlay, Phone, All apps. The existing
  configurable dock remains available. Compact mode has no direct navigation
  shortcut; navigation apps remain reachable through All apps.
- Only valid, fresh weather temperature is displayed, labeled as weather.
  Missing readings are hidden. Vehicle outside-temperature support is pending
  a confirmed readable interface on the target head unit.
- Existing maintenance, backup, standard portrait layout, offline maps, radio,
  Bluetooth, and navigation actions are reused. No firmware/resolution changes;
  minSdk 16 and targetSdk 28 remain unchanged.
- All Markdown documentation is in English. Multilingual UI strings, Spanish
  source keys, preference identifiers, and historical screenshot languages remain.

The earlier 2.21.2 local installation artifact is
`app/build/outputs/install/StradaOS-Opel-2.21.2.apk`, with a SHA-256 file.
It uses the existing Opel key and verified v1/v2/v3 signatures. Standard upstream
APKs/update notices are not Opel updates. Current published downloads are linked above.

For the earlier 2.21.2 port, builds succeeded. Android 11/API 30 at 1024 × 600 covered design switching,
accent visibility, restart persistence, six startup migration/fallback cases,
and both switch directions, retaining settings. Crash log was empty. Full lint:
72 errors, 1 fatal issue, 81 warnings; none on Java lines changed for the menu.
API 17 runtime and proprietary hardware functions still require target testing.

See [README](../README.md), [APK installation/validation](OPEL_APK.md),
[compact architecture](COMPACT_7_INCH_PLAN.md),
[design history](OPEL_NAVI_900_MODERN.md), and
[screenshots](screenshots/compact/README.md).

## Upstream sync — 2026-11-16

Upstream 2.22.0 is merged while retaining Opel Style and its stored preferences.
Idle display, app sorting, sunrise/sunset themes, Chinese, near-square portrait
handling, and AA disconnect fixes are included. Standard orientation preferences
do not switch Opel's landscape compact layout into portrait. GPS updates feed
both compact speed and the new idle display without requiring a standard speed
widget. Existing API 17/device limitations still apply.

Upstream's Nov 16 status marks blocks 10 and 12 paused by its maintainer.
PR #35 by nothanks91 replaces #31 and remains under review, not merged here.
The review branch compiled and passed upstream emulator workflows; blockers
include sun-coordinate String/float preference mismatch, unconditional player
volume controls, always-on trip/parking tracking, speed-camera defaults,
expanded scope, 2.22 conflicts, and incomplete translations. Review evidence
for that proposal is not validation of this fork or authorization to merge it.

## Upstream publication and testing history

Since v2.8.0, upstream releases use the upstream publishing key from GitHub
secrets, compatible with earlier manual installs. `release.yml` updates
`update.json`; standard apps use it for release notices. `pages.yml` publishes
`site/` at https://lordnordic-debug.github.io/StradaOS/; downloads use the latest
GitHub release, excluding prereleases. Ko-fi is `ko-fi.com/stradaos`.
GitHub Sponsors awaited billing-name correction, support ticket #4952223.

Historically Claude drafted replies and Andrés posted them manually; previously
published generated attribution was retained. These historical notes do not
authorize sending messages or publishing a release from the fork.

[PRUEBAS.md](PRUEBAS.md) explains tests without a car. Upstream `pruebas.yml`
and `smoke.sh` cover API 16/19/21/24/28/30/34 at 1024 × 600, with API 23 in
additional installer checks. Captures/logs go to `pruebas`. The `.debug` package,
StradaOS Prueba, uses a prerelease tag excluded from latest-release checks.
`android.yml` publishes test APKs after compilation, before emulator completion.
These workflows are not test evidence for an unexecuted fork revision.

Debug-only `--es prueba` hooks include `saltar`, `inicio`, `ajustes:N`,
`boton:N`, `elegir:N`, `cajon`, `musica`, `asistente`, and `demo-barra`.
API 16 blank screencap requires emulator screenshot support; API 19–21 CI uses
`/data/local/tmp` if SD is read-only. Changing a release/test tag was an upstream
publishing practice, not a requirement for local verification.

## Completed upstream roadmap

The November roadmap combined Messenger/Reddit feedback and issues #2–#18,
PRs #8/#16. New options were intended to preserve existing behavior by default.
Detailed English version history is in [the changelog](../CHANGELOG.md) and
[release notes](../changelogs/).

| Block / version | Implemented changes and historical evidence |
| --- | --- |
| 1 / 2.14.0, Nov 9 | Active-player tracking, preferred music launch on Android 5+, bigger controls/swipes, cached tiles across providers, drawer uninstall, Malay PR #4 (`d6c9fb0`), removal of incremental compilation metadata. Tested in Picanto; `003d8c6` after test `a90dd7a`. |
| 2 / 2.15.0, Nov 9 | Player side, hidden car card, collapsible AA/CarPlay, normal/compact/side docks. `24e3503`/`7156bc4`; `1c2f9cc` moved oil into header and introduced settings/drawer `uiS`; `32e9f5e` added tall player after Picanto testing. Android 4.1–14 checks passed; minor API 30 source-label clipping was absent on hardware. |
| 3 / 2.16.0, Nov 10 | Offline mapsforge maps, light/dark rendering, interpolated ~30 fps movement, resumable downloads. Android 4.1/11, S23/Picanto checks; Picanto measured 69 ms/tile. Settings scroll restored during onLayout, avoiding post() flicker. |
| 5 / 2.17.0, Nov 12 | Scheduled/System themes, Wi-Fi/BT status controls, translated map diagnostics, larger player text/art, unavailable header speed marker, dock labels/rail side, Arabic PR #16 by MartinDean07, Malay website PR #8 by 9M2PJU. Picanto/S23 and emulator checks; Picanto did not expose headlight theme changes. |
| 6 / 2.18.0, Nov 12 | Connection-button choices, weather details, optional speed/player/oil UI, navigation-button size/side, optional photo background removal and manual EXIF rotation. Picanto/S23 checks; photo fix `2a0777e`. |
| 7 / 2.19.0, Nov 13 | 4–10 dock buttons, real app icons/icon packs, hidden dock, font sizes. Picanto checks; XL row spacing fixed. Arcticons worked API 30/34, could not install API 16 due to its own minimum SDK. Horizontal rail labels remained unimplemented. |
| 8 / 2.20.0, Nov 13 | Analog/mixed gauges, map gauge, custom maintenance/templates/icons, ten reorganized settings categories. Two Picanto rounds; `6b850c1`/`d9ec1c7`. Android 4.x double DatePicker callback guarded. |
| 2.20.1, Nov 13 | Larger centered dial without shrinking photo, maintenance strip, days/weeks/months, Turkish PR #23 (mryusufcan), Arabic PR #21 (MartinDean07), eight languages. |
| 9 / 2.21.0, Nov 14 | Portrait layout, typed JSON/photo backups to storage/USB, themed dialogs/pickers, translated diagnostics, French, optional startup app. `5dd601d`; Android 4.1/6/11/14 checks, backup round trips on 6/11/14; CI 4.1 SD unavailable. Picanto USB/startup tests were pending. |
| 2.21.1, Nov 14 | Navbar hiding and displayed-speed correction from PR #26 by wsx79, manually credited and tested on S23. Esri satellite imagery declined over licensing; upstream reply/closure pending in the snapshot. |
| 2.21.2, Nov 15 | Cable-only AA metadata and no repeated Clinkway binding when absent. `8a9e989`/`d9bf857`; Picanto tested with cable-only phone and S23 BT+AA. #30 reporter diegort55 confirmed zero attempts in 60 seconds. |

### Architecture details retained for maintenance

Automatic themes use `dark_start`/`dark_end` in minutes (1080/360 default);
System uses `uiMode` NIGHT and `onConfigurationChanged`. `status_icons` is on
by default; connected toggles ask for confirmation, long-press opens settings.
Android 10+ avoids hidden settings apps after TS10 reports. Clinkway's separate
BT module uses `BtBridge.a2dp()` and opens its own app. Added Wi-Fi/BT control
permissions were BLUETOOTH_ADMIN and ACCESS/CHANGE_WIFI_STATE.

`conn_buttons=both/aa/cp/none` leaves room for weather. `Weather.parseDetail`
adds optional feels-like, humidity, wind, 12 hours, and five days without breaking
the basic summary on failure. `nav_btn_size=0/1/2/3` means 52/68/84/hidden;
`nav_btn_side=auto/left/right`. `CarPhoto.scaled` caps the long side at 900;
opaque photos use rounded crop, transparent PNGs fit proportionally. Background
removal is optional (levels 1–4), with an original-photo action. Manual EXIF
reading avoids API 24 InputStream ExifInterface. Missing AA buttons no longer
stop connection-panel updates.

Dock count is 4–10, with Apps last; seven preserves original positions.
`dock_icon_size` factors are 0.82/1/1.2, clamped in the rail. `IconPack` reads
ADW/Nova/Apex/GO/Teslacoil appfilter.xml from resources/assets. Font factors are
0.9/1/1.12/1.25. `dock_mode=none` extends cards to the bottom and adds Apps at
the header. Settings categories are vehicle=1, maintenance=2, home=3, dock=4,
appearance=5, connections=6, map=7, music=8, system=9, about=10.

`Gauge` uses an open-bottom dial, ticks every 10, labels every 20 (40 when small),
200 km/h/120 mph range, opaque SweepGradient, and exponential TAU 0.42-second
animation through API 16 postInvalidateOnAnimation. Map gauge sizes are
108/132/160, clamped to 45% height/42% width and avoiding navigation controls.
Maintenance JSON `maint` stores template/name, km/month interval, last odometer/
date, snooze, and icon. Fourteen templates/24 icons cover filters, brakes,
fluids, belts, tires, battery, SOAT/inspection, air conditioning, washing.
`nearestMaint()` competes with oil service; snooze adds 100 km or seven days.
`dd`/`tu=d/w` add day/week intervals beside `mo` months; washing defaults to two
weeks. Odometer runs when oil or distance-based tasks need it.

Portrait uses `H >= W*1.2` and a 720-wide variable-height canvas; absent player
allows the car to float over the map with `insL/insR` clearance. Backups include
typed preferences/base64 photo but exclude `Backup.SKIP` device keys. Automatic
backup waits eight seconds after changes or 30 minutes for odometer-only changes.
`boot_app` runs during the first four minutes after boot or waking after five
minutes off, returning after 3.5 seconds unless the user opened another app.

Offline maps use an LGPL-3.0 mapsforge-derived reader. `MapDownload` saves under
Download/StradaOS on Android ≤9 and app storage on 10+. Desktop harness:
`.github/tools/mapa`; workflows `mapa.yml`, `mapa-emulador.yml`; hooks include
`mapa-archivo:PATH`, `mapa-zoom:N`, `mapa-buscar`, `mapa-diag`, `mapa-mover`,
`mapa-lista`, `mapa-descargar:PATH`, `mapa-pausar`, and `mapa-continuar`.
Settings scroll uses onLayout/`settingsPendingY`; `ajustes-emulador.yml` recorded
the fix. Block 5–9 workflows retain captures in their corresponding branches.

## Open upstream proposals — historical, not shipped

- Block 11 / proposed 2.22: opt-in idle black display with configurable
  time/date/speed and touch dismissal (#28 XNA6393, #27 AL3MDHz), app sorting,
  forced portrait selection. Jorge Morales's Tesla Q91-A4-CPL/API 27 leaves
  768 × 850–880 usable after OEM climate controls; current heuristic fails.
  Proposed `layout_mode=auto/horizontal/vertical` and usable dimensions in
  Compatibility. Fix AA disconnect artwork as described below.
- Chinese PR #32 by gugezhushou789-dotcom (897 lines, one missing key,
  `values-zh`, Locale.SIMPLIFIED_CHINESE), awaiting emulator review. GPS/offline
  sunrise/sunset theme (#33 BoFawziQ8) alongside fixed schedules; Obtainium
  badge (#20 breversa, apps.obtainium.imranr.dev#2011).
- Block 12: diagnose ILL/headlight changes in Settings System/Global/Secure,
  brightness/vendor broadcasts before adding brand-specific lights themes.
  Picanto exposes no signal. For Android 14 units forcing OEM home (ink221),
  collect model/Home behavior before opt-in accessibility window-state support;
  current NotifArt only reads Open Headunit notifications.
- Hardware-dependent block 10: HCN/Hengchen sourceinfo (#5 zer0bytz), A2DP
  fallback for ZLink/CarPlay (#5/#12), blocked notification access on Android 9
  (pasuva #2), Moodmax, and Picanto radio. Later: ELM327 OBD, map-update alerts,
  visualizer, trip logs, panel proportions, tilted map after performance checks.
- Factory radio still needs playing-state diagnostics/APK/services; station
  metadata and previous/next tuning are not implemented for Picanto. HCN's
  proposed transaction 4/file path/MediaMetadataRetriever needs confirmed
  ISourceService methods; ZIPs arrived later. Moodmax needs player diagnostics.
- Widget hosting (#33) is different from embedding full Waze. Modified APKs
  shared by BoFawziQ8/nothanks91 are not official upstream builds. PiP/DPI
  embedding and hiding Lynk & Co OEM controls (#14) were not viable as asked.
  A launcher cannot move the system volume bar (#25 SrBurner).
- Historical roadmap: https://claude.ai/artifact/ECWx1vJdbstZtuMHj2hC1m

### Integrated navigation PR #31 — nothanks91, under review

Not merged in the recorded snapshot. Nav.java (1,662 lines) proposed Photon→
Nominatim, OSRM demo→FOSSGIS, optional TomTom key/TTS, recent/saved places,
recalculation after three readings >65 m away and 12 seconds' wait. Offline A*
added 688 lines, capped at 65 km/3.5 seconds/75,000 nodes with no turn restrictions.
Map route/traffic refresh added 150 lines, Main 577, English 120 keys, plus TLS
changes. Review branch `revision-pr31` (`eff9214`) built and passed emulator
API 16/19/21/23/24/28/30/34. Integration conditions: opt-in/off by default,
restore existing external navigation behavior, remove unrelated TLS changes,
translate all nine languages, test portrait/rail/compact and a real Picanto
route, label offline routes approximate, configurable routing server instead of
production dependence on OSRM demo. The review requested a scope freeze.

## Hardware reports and distribution history

Issue #9 (MIGSGx) involved Android 11 factory-mode startup repeatedly returning
to StradaOS, even from uninstall UI, without kiosk/pinning. 2.14.0 (`9a06017`)
added another-HOME launch, disable Main/FakeHome/BootReceiver using DONT_KILL_APP
only if another HOME exists, or uninstall. `salida.yml` passed API 30/19. Help
no longer recommends Android 10+ factory mode. If install windows also disappear,
ADB/vendor recovery may be necessary; firmware changes are outside launcher scope.

Oil issue #7 (zer0bytz) saved last change in miles because automatic units follow
system locale: 132,107−4,000=128,107 km=79,602 mi. 2.13.0 (`b30a1ef`, test
`241696b`) added correction/unit confirmation and >100 km-above-odometer warning.
Issue #6 added hidden apps with searchable restoration while retaining assignment
choices. `field()` light contrast fixed in `7dbefbe`; #6/#7 closed.

HiveOS AC8227L parsing error: actual Android 6, kernel 3.18.22,
`android-trunk-m0.AC8227L-V1.0`, HMI `HiveOS.TSKJ.D.M.F.3.01`, MCU `HiveOS.YX807`.
Full 505.72 KB 2.11.1 APK failed through OEM file manager even with Play Protect
off. `instalador.yml` (`96832da`) installed 2.11.1/2.12.0/test on API 23; API 22
reproduced the error for an unreadable file. Likely path access/ROM restriction.
Pending comparisons: other APKs, browser notification, alternate file manager/
USB, separate test package. Incremental compilation metadata was harmless and
signed since 2.8.0, later removed in block 1.

Héctor Vázquez's Hyundai ix35, marketed Android 11 but API 28, needed GPS/map
checks and the TLS fix below; emulator validation passed, field confirmation
pending. Lionel Durazo's 12.3-inch 1920 × 720 margins (~345 px each side) were
addressed by 2.11.0's expanded cards/map/dock.

TS10 black-screen report (David Felipe Cepeda): UIS7862S, Android 14, 4+64 GB,
2000 × 1200, TS10S_20260709, `com.tw.car`. Opening hidden Android settings from
2.9.5 made apps/reverse camera black until reboot despite no home/accessibility
setup. TLink5/radio/BT were detected; camera/BT display unknown. 2.9.8 opens
visible OEM settings or asks for an app; 2.9.7 added Guard/sizeStorm. Retests need
a crash-log photo. Lucas Cacciola's BT-on-Home report and Giancarlo Maya's
internal radio/BT activity request need model/API/playing diagnostics, BT APK/
odex, and factory-launcher comparison. Lucas's icon request was implemented.
Oscar Pizarro's Sonic 2015/Musicolet report motivated preferred-music launching;
Moodmax still needs MediaSession evidence. BT does not require USB; Back can
stop its app where Home does not. Slow units should test without live maps.

IzzyOnDroid #832 was declined by FatalGlow on 2026-11-05 under its AI policy,
while APK 2.9.5 scan/metadata passed. No resubmission during AI development was
planned. F-Droid MR !55924 was closed by Licaon_Kter on 2026-11-06 under quality
point 6 (less than three months' development; repo created Nov 4), not AI or
technical failure. Reproducibility suggestions added Binaries and
AllowedAPKSigningKeys. Historical retry target: 2027-02-04 or user-base evidence,
after Gradle 8.11.1/JDK 17 reproducibility checks. Template:
`docs/fdroid/com.stradaos.launcher.yml`; `d38fe99` updated 2.10 metadata/LF and
tag regex excluding test releases. These are historical plans, not acceptance.

## Technical notes

- Update security: dygerydoo's private report led to `907fac8` in 2.12.0;
  credit permission remained pending. safeVersion accepts digits/dots, links
  constructs known URLs, downloads require APK_PREFIX, verifyApk checks package/
  signature. HTTP jsDelivr fallback follows HTTPS-source failure; donation uses
  HTTPS/known hosts; legacy weather/city fallback rounds location to one decimal.
  API 16–34 own/other APK checks passed. Opel disables standard upstream updates.
- Android 9 TLS: enabling TLS_FALLBACK_SCSV/all ciphers caused TLS 1.2 handshake
  rejection by TLS 1.3 servers. `4d77094` uses system TLS plus bundled roots on
  API 21+, filters SCSV/anon/NULL/EXPORT/RC4/DES/MD5 below 21, retries system
  configuration. API 28 fetched OSM Germany/API 16 France afterward. GitHub/raw
  old TLS and jsDelivr caching motivated highest-version checks and cache purge.
- HOME: resolve HOME/MATCH_DEFAULT_ONLY; Android 10+ RoleManager via
  Modern.requestHomeRole/REQ_HOME 77; Android 4–9 temporarily enables FakeHome.
  Tested 4.1/7/11/14; autoChecks once per opening/setup, home_never suppresses.
  BootReceiver/boot_open remain subject to Android 10+ background restrictions.
  showCompat should reflect new features; map_live=false creates no LiveMapView.
- Clinkway: 2.9.3 initializes wasPlaying=null with 60 seconds' grace to avoid
  first-poll false starts. Transaction 4 does not reliably report phone Play
  while radio owns audio; togglePlay transaction 1 routes reliably. External
  setBTMusicMode transaction 16 proved unreliable despite an earlier observation.
  isAudioTmpLose cannot filter radio ownership. Since 2.9.1, BIND_AUTO_CREATE and
  two-second polling detect pause→play, briefly open BT then restore the old
  task if needed. btRouted resets for another source/service loss; three restarts
  in 90 seconds suspend keepalive 15 minutes. Reverse-camera guards remain.
  Future android.mode.AppManager reflection requires diagnostics.
- AA: title-less Clinkway events update only time/state while AA owns a track;
  ignore clear/polled state, wait five seconds for AA metadata after a new BT
  title. Since 2.9.6, check USB VID 0x18D1/PID 0x2D00–0x2D05, or notification
  <15 seconds if USB never seen. checkAaGone runs 1.5 seconds after detach and
  every two seconds, selects BT/clears art/optionally opens BT (aa_off_bt=true).
  Picanto confirmed 2.9.5 stability/2.9.6 disconnect/reconnect on Nov 5. Residual
  2.21.2 issue: a final notification's same-track applyAaNotif path can restore
  AA art after disconnect; add aaRunning guard there. A previous BT title may
  briefly appear in logs when notification precedes it, without visible impact.
- Dock keys store app:package/Activity or fn:id, optional dock_N_name; missing
  values use defaults/function assignments. music_app/nav_app fall back to
  installed candidates. Spanish-tab-translation keys and I18n/TB patterns remain;
  2.21.0 has nine languages, superseding old es/en/pt-only notes. Site strings use
  data-i18n, language tables, I18N.T, browser/localStorage defaults, ?lang=en.
- Historical artwork lookup failed in-car on Nov 11 and was fully reverted;
  it was not to return without an upstream request. Website claims were removed.
  Historical marketing used HTML/Playwright, generic icons/example cities, never
  Andrés's location. In-app browsers provide Chrome/copy-link guidance; ?iab=1
  tests it. A 30-second ES/EN promo exists in 9:16/4:5/16:9 in Andrés's
  `D:\StradaOS - Promo Video\Render`, project `stradaos-trailer-30s`.
