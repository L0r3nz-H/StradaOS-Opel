# Contributing

Thank you for helping improve StradaOS!

## Reporting problems

Use the [issue templates](https://github.com/L0r3nz-H/StradaOS-Opel/issues/new/choose). Include:

- The StradaOS version and the head unit's **actual Android version**, available in *Settings → About*.
- Photos of the display.
- Diagnostics from *Settings → System → Export diagnostics*.

## Translating StradaOS

You do not need programming experience to translate the app:

1. Copy `app/src/main/assets/i18n/en.txt` to `xx.txt`, using the ISO language code, for example `tr.txt` for Turkish or `fr.txt` for French.
2. Each line is `spanish<TAB>translation`. **Translate only the text after the tab.** Keep the Spanish key exactly unchanged.
3. Preserve placeholders: `{}` for a value such as a number or name, `{z}/{x}/{y}`, `%s`, `%d`, and `\n` for a line break. Lines starting with `#` are comments.
4. Open a pull request containing that file. Optionally add `app/src/main/res/values-xx/strings.xml` based on `values-en`, and register the language in `I18n.java`: `CODES`, `NAMES`, the locale in `set()`, and the date format in `datePattern()`. Otherwise a maintainer can complete that wiring.

Missing strings fall back to Spanish, so partial translations are useful. New release strings are appended to `en.txt`; translate those new lines as needed.

Repository documentation (`*.md`) is maintained in English. This does not change the app's multilingual translation tables or its Spanish source keys.

## Building

Requirements: JDK 17 and the Android SDK.

```bash
./gradlew assembleDebug
# APK output: app/build/outputs/apk/debug/
```

For the separate Opel edition, see [OPEL_APK.md](docs/OPEL_APK.md). `assembleOpel` produces an unsigned intermediate APK that must be aligned and signed before installation.

## Code rules

- **Keep Android 4.1 / API 16 compatibility.** Guard newer APIs with `if (Build.VERSION.SDK_INT >= …)`.
- Use Java 8 **without lambdas**, `java.util.Objects`, or `StandardCharsets`, which are unavailable on API 16–18.
- Do not depend on Google Play Services; the project should remain suitable for F-Droid.
- The UI is built programmatically on a scaled 1024 × 600 reference canvas; see `Main.place()`.

## Structure

```text
app/src/main/java/com/stradaos/launcher/
  Main.java          Home screen, settings, dialogs
  LiveMapView.java   Live map: OSM tiles, caching, dark mode
  NowPlaying.java    Track information on Android 4.x, player and Bluetooth broadcasts
  MediaWatcher.java Android 5+ MediaSession track information
  BtBridge.java      Factory Bluetooth app integration: Autochips/Clinkway
  NotifArt.java      Android Auto artwork from Open Headunit notifications
  Weather.java       Open-Meteo weather
  Updates.java       GitHub release notifications
  CarPhoto.java      Vehicle-photo sizing and optional background removal
  Net.java           TLS 1.2 and current root certificates for Android 4.x
app/src/hiddenapi/   Android 4.x hidden-API compilation stubs; not packaged
app/src/legacy/      RcDisplay, the hidden-API subclass loaded through reflection
```

## Publishing an upstream release

1. Increment `versionCode` and `versionName` in `app/build.gradle`.
2. Add `changelogs/X.Y.Z.md` and `fastlane/metadata/android/*/changelogs/<versionCode>.txt`.
3. Commit and push to `main`, or push a `vX.Y.Z` tag.
4. GitHub Actions builds and signs the APK, creates the release, and updates `update.json`, which the standard app uses to notify users.

The Opel edition has its own package and signing key. Do not distribute the standard upstream APK as an Opel update.
