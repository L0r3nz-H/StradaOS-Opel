# Opel Navi 900 Modern / Opel Style

## Current design selection

Opel Style is the first card in **Settings → Personalization → Landscape**.
It is not offered in the Portrait gallery. Personalization stays available while
Opel Style is active; choosing a standard or premium card returns to a regular
StradaOS layout. Appearance no longer contains a home-design selector.

Opel Style is the 7-inch compact view described in
[COMPACT_7_INCH_PLAN.md](COMPACT_7_INCH_PLAN.md). There is no separate layout
selector. The fixed red Opel accent remains part of the design; its custom
accent controls are hidden in both Appearance and the setup wizard.

`setDesign()` saves `design` and `home_layout` together. On startup, an old
installation using either Opel or compact layout is migrated to the combined
Opel Style selection. Preference identifiers remain unchanged for compatibility:
`design=opel_navi_900_modern` and `home_layout=compact_7`. Standard StradaOS uses
`design=stradaos` and `home_layout=standard`.

Both styles retain Dark, Light, Automatic, and System modes. Opel stores its mode
in `opel_theme` (default `dark`), independently of StradaOS `theme`. Automatic
uses configurable start/end times or GPS-derived sunrise/sunset since 2.22.0; System follows Android's night mode.
Changing styles preserves the standard accent, app assignments, and map settings.

## Layout architecture

`Main.java` builds the UI programmatically on a scalable 1024 × 600 canvas.
`applyTheme()` sets the shared palette, `applyAccent()` applies the active accent,
and `build()` creates the views. GPS, media observers, and existing app actions
update or operate those views. Settings are stored in `SharedPreferences("launcher")`.
`OpelDesign.java` supplies the Opel identifier, palettes, and panel styling;
`CompactLayout.java` supplies compact geometry and action identifiers.

The compact view uses two large panels, an Opel header, and optionally four
large bottom actions: Radio, CarPlay, Phone, All apps. The vehicle name appears
above the transparent car image. Optional GPS speed is centered below it.
Without speed, the name/image group is vertically centered. The clock stays
centered in the header; unavailable temperature is hidden. The settings gear
remains reachable regardless of dock assignments.

Map, GPS, radio, Bluetooth, media, and app launch actions reuse existing code.
There are no new services, permissions, dependencies, firmware modifications,
root requirements, MCU/CAN commands, or screen-resolution changes. The map
remains a GPS map; external navigation apps are not embedded in the dashboard.

## Original design plan — 2026-11-09

The first Opel implementation was a separate design, independent of `theme`
and `accent`. Missing or unknown design values selected StradaOS. It used a
624 × 380 navigation panel on the left, a 356 × 380 media panel on the right,
and seven bottom app buttons. Extra display width enlarged navigation and the
dock. Its shared action/view architecture became the basis for the compact view.

The initial plan was to add `OpelDesign.java`, conditionally build those panels,
reuse existing functions, retain access to settings, then verify build, lint,
and hardware behavior. The separate design/layout menu documented in earlier
screenshots has now been replaced by the combined Opel Style choice.

## Device/emulator checks

- At 1024 × 600, switch between StradaOS and Opel Style. Check panels, clock,
  media controls, settings, and all four compact shortcuts.
- Restart the app. The selected style must persist. Switch back and confirm
  the original standard mode, accent, and app assignments are restored.
- Test all four theme modes, persistence, scheduled transitions, and independent
  per-style mode storage.
- Check map behavior with missing permission, GPS off, and a valid fix; tapping
  the status must open the existing help/diagnostics.
- Test radio and Bluetooth metadata and previous/play-pause/next using supported
  sources. The UI does not add unsupported FM tuning commands.
- Long-press app buttons to assign apps. Check assignments after restart.
  Standard navigation assignments and app access remain available.
- Switch repeatedly while music is playing, including from open settings.
- Verify Android 4.1/API 16, Android 4.2/API 17, and a wider display. Existing
  Android APIs and Java conventions are retained; build success alone does not
  establish runtime compatibility.

Debug hooks are available only in the debug package:

```sh
adb shell am start -n com.stradaos.launcher.debug/com.stradaos.launcher.Main --es prueba design:opel_navi_900_modern
adb shell am start -n com.stradaos.launcher.debug/com.stradaos.launcher.Main --es prueba design:stradaos
```

## Historical local validation

### 2026-11-09 — initial implementation

- JDK 17, Gradle 8.11.1, Android SDK 35, Build Tools 34. Tools were temporarily
  installed under `/tmp`; repository build configuration was unchanged.
- `assembleDebug` succeeded, producing
  `app/build/outputs/apk/debug/StradaOS-2.13.0-prueba.apk`.
- `lintDebug` ran with `abortOnError false`: 60 errors, 1 fatal issue, and
  58 warnings in existing code/configuration, including API gates and target
  SDK 28. None were on the added/changed Java lines or in `OpelDesign.java`.
- APK metadata: `com.stradaos.launcher.debug`, minSdk 16, targetSdk 28.
  Signature verification at minSdk 16 passed for v1/v2. `git diff --check` passed.
- ADB reported no connected devices/emulators. Runtime, visual, GPS, Bluetooth,
  and radio checks were therefore still outstanding at that point.

### 2026-11-10 — light mode

- `assembleDebug lintDebug` succeeded. Lint: 60 errors, 1 fatal issue, and
  59 warnings; no finding on the Java lines changed for light mode.
- Android 11 emulator, 1024 × 600, 160 dpi: enabled Light through Appearance;
  inspected compact and original Opel views. Opel Light persisted after restart.
  Switching to StradaOS restored its stored Dark mode; Opel restored Light.
- Checked the red header/white gear, red play button/white icon, and dark text
  on light surfaces. No crash entry.
- Actual captures: [compact/light](screenshots/compact/04-opel-light-1024x600.png)
  and [original Opel/light](screenshots/compact/05-opel-standard-light-1024x600.png).
- Automatic time transitions and API 17 runtime were not separately tested.

For the current APK and validation history, see [OPEL_APK.md](OPEL_APK.md).
