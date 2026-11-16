# Testing StradaOS without a car

There are three levels of testing, from fastest to closest to real hardware.

## 1. Automated emulator tests

In the upstream repository, each push to `main` that changes `app/` runs **Emulator tests** (`.github/workflows/pruebas.yml`):

- Installs the test build on Android **4.1 / API 16, 4.4 / 19, 5.0 / 21, 7.0 / 24, 9 / 28, 11 / 30, and 14 / 34**, with a **1024 × 600** head-unit display.
- Opens the setup wizard, dashboard, shortcut menu, app list, shortcut/music/map/about settings, music selection, all apps, and modified dock, taking screenshots.
- **Fails if StradaOS crashes or hangs**, recording results in `CIERRES.txt`.
- Saves screenshots, logcat, and crash reports in the upstream [`pruebas` branch](https://github.com/lordnordic-debug/StradaOS/tree/pruebas), grouped by Android version with a README summary.

The script is `.github/scripts/smoke.sh`. The `.debug` package accepts `--es prueba VALUE` to open screens without coordinate-based taps; see `Main.testHook()`.

Fork workflows may need separate configuration. Do not treat historical upstream CI results as tests of a modified Opel build.

## 2. Test build on a phone

Upstream pushes to `main` publish **StradaOS Prueba** in the [`prueba` prerelease](https://github.com/lordnordic-debug/StradaOS/releases/tag/prueba):

- Fixed APK link: https://github.com/lordnordic-debug/StradaOS/releases/download/prueba/StradaOS-prueba.apk
- Installs alongside the regular version as `com.stradaos.launcher.debug`, with the application name “StradaOS Prueba”. It does not replace the regular installation.
- Uses a consistent signing key, so subsequent test APKs update it without uninstalling.
- Does not offer regular-release updates; download the next test APK from the same link.
- Does not appear as the latest official release on the website or in the standard app updater.

Download and install the APK, allowing installation from that source if needed. Open it and rotate the phone to landscape, enabling auto-rotation. If Android asks which home app to use, keep the phone's usual launcher as the default and open StradaOS Prueba using its app icon.

This tests the dock, preferred music/navigation apps, settings, setup, maps, and weather. It does not verify factory radio, reverse camera, head-unit Bluetooth, or Android Auto over USB.

## 3. Tests on the head unit

Radio, reverse camera, factory Bluetooth, and USB projection must be checked on the actual device. The separate test build can coexist with the regular version, or you can wait for an official release.

## Opel Style checks

- Select *Settings → Appearance → Home screen design → Opel Style*. It must activate the compact Opel layout directly, without a second layout selector.
- Check that the accent-color section is absent. Switch back to StradaOS: the regular layout and saved custom accent must return.
- Verify Dark, Light, Auto, and System modes; vehicle/map choice; optional speed; four large shortcuts; restart persistence; and migration from older separate design/layout settings.
- Check Android 4.2 / API 17 on the target head unit. Android-11 screenshots are not a substitute for that test.

## Publishing an official release

After validation, increment the version, add release notes, and push the release changes. Upstream `release.yml` publishes a signed `vX.Y.Z` release and enables in-app update notifications for the standard edition. The Opel edition uses separately signed APKs.
