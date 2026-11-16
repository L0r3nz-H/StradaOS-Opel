# Changelog

Detailed notes are in [`changelogs/`](changelogs) and [upstream releases](https://github.com/lordnordic-debug/StradaOS/releases).

## Upstream sync — 2.22.0-opel

- Merged upstream `0a7736f` / versionCode 55, preserving Opel Style, fixed accent,
  compact shortcuts, photo, and per-style themes.
- Added idle screen, drawer sorting, sunrise/sunset themes, Chinese, standard
  orientation refinements, and AA disconnect fixes. Compact stays landscape.
- See [upstream release notes](changelogs/2.22.0.md) and [Opel sync notes](changelogs/2.22.0-opel.md).

## Opel Style menu refinement

- One home-screen design choice: StradaOS or Opel Style. Opel Style directly activates the 7-inch compact dashboard.
- Fixed Opel red accent; the custom-accent section and setup step are hidden in Opel Style.
- Standard Dark, Light, Auto, and System theme modes remain available.
- Existing Opel/compact configurations migrate without discarding saved standard colors, themes, or shortcut assignments.
- Repository Markdown documentation is maintained in English.

## Previous signed Opel build — 2.21.2-opel

The local signed Opel build uses versionCode 54 and package
`com.stradaos.launcher.opel`, based on upstream `b2f327d` dated 2026-11-15.
It retains the transparent Astra J photo, centered clock/optional speed,
vehicle-or-map panel, and four large shortcuts. Valid weather is explicitly
labeled; missing temperature is hidden. Vehicle-temperature integration remains
pending a confirmed head-unit interface.

See [Opel release notes](changelogs/2.21.2-opel.md) and
[APK installation/validation](docs/OPEL_APK.md). This describes the local build;
it does not assert that an Opel GitHub release has been published.

## Recent upstream history

| Version | Main changes |
| --- | --- |
| [2.21.2](changelogs/2.21.2.md) | Cable-only Android Auto metadata; no repeated Clinkway service binding when absent |
| [2.21.1](changelogs/2.21.1.md) | Hide system navigation bar; displayed-speed correction |
| [2.21.0](changelogs/2.21.0.md) | Portrait layout, backups, themed dialogs, French, startup app |
| [2.20.1](changelogs/2.20.1.md) | Gauge layout refinements, day/week maintenance units, Turkish |
| [2.20.0](changelogs/2.20.0.md) | Analog/mixed gauges, custom maintenance, reorganized settings |
| [2.19.0](changelogs/2.19.0.md) | Configurable dock count/icons, icon packs, text sizes |
| [2.18.0](changelogs/2.18.0.md) | Weather details, panel visibility, photo handling |
| [2.17.0](changelogs/2.17.0.md) | Scheduled/system themes, Wi-Fi/BT status, Arabic |
| [2.16.0](changelogs/2.16.0.md) | Offline maps and in-app downloads |
| [2.15.0](changelogs/2.15.0.md) | Player side, hidden car card, collapsible projection panel, dock layouts |
| [2.14.0](changelogs/2.14.0.md) | Player gestures/source tracking, cached maps, exit controls, Malay |
| [2.13.0](changelogs/2.13.0.md) | Hidden apps, oil-change correction, readable light-mode inputs |
| [2.12.0](changelogs/2.12.0.md) | Oil reminders, heading-up map, Italian/German, verified updates |
| [2.11.1](changelogs/2.11.1.md) | Android 9 TLS/map fix |
| [2.11.0](changelogs/2.11.0.md) | Wide displays, GPS status, speed units |
| [2.10.1](changelogs/2.10.1.md) | Default-home setup, boot launch, optional live map |
| [2.10.0](changelogs/2.10.0.md) | Configurable shortcuts, preferred apps, Spanish/English/Portuguese |

Earlier Opel ports are documented in [2.15.0-opel](changelogs/2.15.0-opel.md)
and [2.16.0-opel](changelogs/2.16.0-opel.md).

## Early upstream history

## 2.9.4 — Ready for F-Droid-style stores

- Store-installed apps receive store updates; GitHub notifications are optional and explained.

## 2.9.3 — Show the dashboard first

- Bluetooth Audio no longer opens automatically at startup.
- Automatic routing is experimental and off by default; dashboard Play routes Bluetooth audio.
- Review detected app assignments in setup and shortcut settings.

## 2.9.2 — Reliable updates and compatibility

- Check all update sources and select the newest result; show individual responses.
- Automatic Bluetooth audio routing can follow radio playback.
- Compatibility information lists Android/manufacturer requirements.

## 2.9.1 — Bluetooth audio fixes

- Play works after pausing with automatic routing enabled.
- Briefly open Bluetooth Audio when routing is needed, then return to the previous app.

## 2.9.0 — Bluetooth routing without manually opening the factory app

- Route phone music through the head unit; automatic Clinkway/Autochips support was revised in subsequent releases.
- Other brands can briefly open their Bluetooth app on connection.
- Dashboard Play activates Bluetooth audio; Bluetooth diagnostics added.

## 2.8.0 — First public release

- GPL-3.0 repository opened on GitHub.
- GitHub update notifications with direct APK or QR download.
- About page: update checks, GitHub star, donations, and issue reporting.

## 2.7

- Settings redesigned with a sidebar and categories.
- Dark, light, and automatic themes.
- Weather units and map brightness.

## 2.1–2.6 — StradaOS

- New name/icon and support for modern Android permissions, APK installation on Android 7+, and music on Android 5+.
- Live maps with multiple sources compatible with Android 4.x and map diagnostics.
- Android Auto/CarPlay buttons and phone connection selection.
- Protection against mirroring apps such as EasyConnection taking over USB.

## 2.0

- Universal edition: setup wizard, vehicle photo/background removal, and accent color.

## 1.0–1.9 — Picanto Launcher prototype

- Dashboard, player with artwork, Autochips Bluetooth and Android Auto track information, and Android 4.1 support.
