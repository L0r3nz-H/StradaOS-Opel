# Optional 7-inch compact mode — architecture and implementation plan

Updated: 2026-11-16. Target: Android head units with a 1024 × 600 display,
especially Android 4.2/API 17. The initial compact mode was implemented on
2026-11-10 and subsequently ported to upstream 2.21.2 (`b2f327d`) on branch
`feature/opel-latest-2.21.2`.

Appearance now offers **StradaOS** and **Opel Style**. Opel Style activates the
compact layout directly. This replaces the original independent design/layout
selectors. Standard StradaOS and its existing layout options remain available.
Newer upstream maintenance, backup, dialogs, portrait layout, scheduled/system
themes, and GPS speed correction are reused.

## Implemented behavior

- Two large panels, readable text, large media controls, and an optional four-item
  dock: **Radio · CarPlay · Phone · All apps**. This requested order takes
  precedence over labels in the supplied reference image.
- Opel Style uses a fixed red header/accent. The accent selector is hidden in
  Appearance and skipped in setup. The standard accent remains stored.
- Vehicle or map as the main panel, plus a choice between four large shortcuts
  and the existing configurable dock. The compact app drawer uses four columns.
- The car name is above the image. There is no additional Vehicle caption or
  direct navigation link. User car photos take priority over the bundled image.
- With speed disabled, the name and photo form one vertically centered group;
  no empty speed row is reserved. Default car name: **Astra J**.
- Optional GPS speed (`compact_show_speed=false` by default): centered below
  the car image, or horizontally centered at the bottom of the map panel.
  It reuses existing GPS updates, km/h/mph/automatic units, and speed correction.
  Missing speed or GPS data older than six seconds shows an em dash. Tapping
  opens the existing GPS help/permission flow.
- Dark, Light, Automatic, and System modes remain available. Opel stores its
  mode separately in `opel_theme`; StradaOS keeps `theme` and its own accent.
- The header clock remains centered. Only valid weather temperature no more
  than one hour old is currently displayed, explicitly labeled as weather.
  Missing/stale data or disabled weather leaves the temperature area empty.
  **A vehicle-temperature reader is not yet implemented:** the target head
  unit's actual exposed interface must first be identified.

## Supplied reference images

The original files remain in the repository independently of chat attachments.
Bottom actions follow the requested order above rather than this image's labels.

![Dashboard reference with two large panels and four bottom actions](design/compact-7/dashboard-reference.png)

![Original Opel Astra J reference photograph](design/compact-7/opel-astra-j-reference.jpg)

The original JPEG is retained for reference. The app loads
`app/src/main/assets/opel_astra_j.png`, a cutout with a real alpha channel so
that the panel background remains visible around the car. It is decoded with
`inSampleSize=2` to reduce memory usage on older devices. Display the entire car
proportionally with `FIT_CENTER`, without cropping or distortion.
`CarPhoto.load()` continues to prefer user photos, including transparent ones.
Other designs do not receive a new default vehicle image.

## Repository architecture

- `Main.java` contains the Activity, programmatic views, settings, and app actions.
  There are no XML dashboard layouts. The original `build()` uses `buildTop()`,
  `buildCarCard()`, `buildAaCard()`, `buildAudioCard()`, and `buildDock()`.
- Scaling originally uses `s = min(width / 1024, height / 600)` and distributes
  extra width through `ex`. `place()` and `tv()` use scaled virtual pixels,
  rather than dp/sp layout resources. Adding `layout-sw600dp` alone would not
  change this architecture. Newer upstream portrait/dock metrics remain intact.
- At initial investigation, standard panels were vehicle 300 × 380,
  map/projection 420 × 380, and audio 248 × 380, with seven configurable dock
  actions. Many secondary labels were only 11–15 virtual pixels.
- The first `opel_navi_900_modern` design enlarged the map to 624 × 380 and
  audio to 356 × 380, hid the vehicle card, and retained seven actions. It did
  not match the supplied compact reference. `OpelDesign.java` supplies its
  palettes and panel style; `CompactLayout.java` now supplies compact geometry.
- Preferences live in `SharedPreferences("launcher")`: `design`, `home_layout`,
  `theme`, `opel_theme`, `accent`, `dock_N`, `car_name`, `car_tag`, `nav_app`,
  `carplay`, `bt`, and `map_live`, among others. `setDesign()`/`rebuild()` rebuild
  views without restarting the Activity and its media connections.
- `openDrawer()` retains its adapter, search/filter, hidden apps, and launch
  actions. Compact mode changes density to four columns instead of the original
  six. `showSettings()` and `cat…()` build settings; Appearance is `C_LOOK=5`.
- `map_live=false` uses a decorative map instead of live tiles. Compact vehicle
  mode creates neither `LiveMapView` nor decorative `MapView`.
- `app/build.gradle`: minSdk 16, targetSdk 28, Java 8, no external UI library.
  API 17 is within the declared range but still needs a runtime test.
- `I18n` loads `assets/i18n/*.txt` using Spanish source keys. Translating
  documentation does not rename these identifiers or force the app language.
- `Weather.java` obtains online weather temperature. The inspected code has no
  vehicle outside-temperature integration or confirmed target-radio interface.

## Current preference model

| Preference | Values / default | Effect |
| --- | --- | --- |
| `design` + `home_layout` | `stradaos` + `standard`, or `opel_navi_900_modern` + `compact_7` | One user-facing style selection saves both values |
| `opel_theme` | `dark` / `light` / `auto` / `system`; default `dark` | Independent Opel theme mode |
| `compact_main_panel` | `vehicle` / `map`; default `vehicle` | Main compact panel |
| `compact_four_shortcuts` | boolean; default `true` | Four fixed functions or existing configurable dock |
| `compact_show_speed` | boolean; default `false` | Optional centered GPS speed |

The original plan selected density and design independently. Since 2026-11-16,
`setDesign()` writes the canonical pair atomically. On startup, old selections
using either Opel or compact layout are normalized to Opel Style. Neither
standard accent nor per-style theme mode, map settings, photos, or app assignments
are reset. Missing/unknown identifiers fall back to standard unless the other
identifier explicitly selects Opel/compact. Fresh Opel-edition installations
apply their existing one-time Opel defaults.

There is no automatic activation based on resolution: pixel count does not
reliably identify physical screen size. Compact-specific options only affect
the compact view. The internal old identifiers remain valid for stored settings
and debug tooling; the normal menu has no separate layout selector.

## Geometry at 1024 × 600

All dimensions are virtual base pixels and continue to scale with `s`.

| Area | Position and size | Content |
| --- | --- | --- |
| Header | x=16, y=16, 992 × 64 | Brand/design name, centered clock, valid labeled temperature, settings |
| Left panel | x=16, y=96, 488 × 340 | Name over car image/icon, or map; optional centered speed below |
| Right panel | x=520, y=96, 488 × 340 | Source, title/received station, optional secondary line, large media controls |
| Four-action dock | y=452, height=132 | Full touch tiles, each 236 wide, x=16/268/520/772 |

Primary text is approximately 30–40 px, important secondary text/action labels
22–24 px, and icons 32–48 px. Avoid enlarging every `tv()` call globally, which
would overflow standard layouts. Compact controls target at least 64 × 64
virtual pixels; verify a real minimum of 48 dp at the target device's density.
The entire bottom tile is clickable.

No extra vehicle/oil/projection card is added beside these two panels. Existing
vehicle/maintenance settings remain reachable; reduced UI does not disable GPS
or odometer processing. Navigation apps remain accessible through All apps and
the standard navigation assignment. The compact audio panel omits large album
art/progress rings and ellipsizes long text.

Never invent a frequency such as 98.5: show received metadata only, otherwise
the translated empty state with an audio-app action. Additional width enlarges
both main panels and the dock. Four actions are the recommended compact default;
the existing configurable dock remains optional.

## Vehicle temperature before weather — remaining implementation

The intended source is the car's **outside temperature** when the head unit
exposes a readable interface. Cabin, CPU, and battery temperatures are not substitutes.

1. Identify the radio model and actual manufacturer service, documented
   broadcast, SDK, or readable provider through diagnostics. Implement service
   names, actions, extras, units, and permissions only after confirming them.
   Do not guess MCU/CAN commands or actively query the vehicle bus.
2. Add an isolated, optional read-only `VehicleTemperatureSource` supplying a
   value, unit, source, reception time, and availability status. It must start
   safely on API 17 without new hardware libraries and report unavailable if
   services or access rights are missing. Release receivers/connections on exit.
3. Prefer valid, fresh vehicle readings. Fall back to fresh online weather only
   when enabled. Hide temperature when neither exists; do not keep stale car
   readings indefinitely. Define freshness, sentinels, and valid ranges against
   the confirmed interface. Zero and negative Celsius readings are valid.
4. Label car values as outside temperature and fallback values as weather.
   Reuse °C/°F settings, validate source units before conversion, and show source,
   age, and unavailability reasons in diagnostics.

Vehicle readings should work offline and independently of the online-weather
switch. Initially limit this change to the compact header to preserve standard
layouts. If access requires firmware changes, root, or unavailable system
permissions, leave the adapter unavailable; those changes are outside scope.

## Reuse existing actions

| Compact action | Existing implementation |
| --- | --- |
| Radio | `runFn("radio")` → `openSlot(0)` |
| CarPlay | `runFn("carplay")` → `openCarPlay()`; assignment through `pickFor("carplay", …)` |
| Phone | `runFn("bt")` → `openSlot(1)`; existing Bluetooth/phone assignment |
| All apps | `runFn("apps")` → `openDrawer()` |
| Navigation outside compact dashboard | `openNavApp()` and `nav_app` |
| Previous / play-pause / next | `mediaClick(…)`, existing sources and `BtBridge` |
| Vehicle | `CarPhoto.load()`, `car_name`, existing photo/vehicle settings |
| Settings | `openSettings()` through the always-visible gear |

The four functional positions neither read nor overwrite `dock_0…dock_6`.
Their order/labels remain fixed while the underlying radio, CarPlay, and phone
apps remain assignable. Existing missing-app pickers/help still apply. CarPlay
requires compatible hardware/an adapter and its Android app.

## Implementation sequence and callback safeguards

The initial seven-step plan was implemented except for the unconfirmed vehicle
interface; the combined style selector supersedes its independent-selector step.

1. Encapsulate safe defaults, expose style/panel/four-action choices, and preserve
   existing colors, themes, map preferences, and dock assignments.
2. Branch to compact or existing builders after shared metrics. Include dock
   backgrounds and Opel trim so obsolete elements do not show through. Reuse
   platform views/drawables without a broad service or UI rewrite.
3. Clear old view references when rebuilding and guard optional widgets:
   `updateClock()` cannot require `dateTv`/`greetTv`; `renderTrack()` cannot
   assume `playerArt`, `timePosTv`, `artistTv`, or `sourceTv` exist whenever
   `trackTv` exists. `updateProgress()` must work without artwork, and
   `refreshStates()` must not skip all compact updates when the AA subtitle is
   absent. Check `setGps()`, `updateMapTag()`, and pending weather/media callbacks.
4. Create vehicle or map as requested, load the bundled fallback image, wire
   audio/dock actions, and avoid updates to removed maps. Preserve `map_live`.
5. Adapt app-drawer density and touch targets while retaining search, hidden
   apps, assignments, and launch behavior. Add UI strings to existing languages.
6. Investigate and implement the read-only temperature adapter only for a
   verified exposed interface. Keep the rest of compact mode independent of it.
7. Build, inspect lint, run smoke checks, and document actual runtime evidence.

## Historical validation

The original planning phase introduced no builds/device tests. Later checks:

- Initial compact `assembleDebug lintDebug` succeeded. Lint: 60 errors,
  1 fatal issue, 60 warnings; no errors/fatal findings on changed Java lines,
  two RTL `Gravity.RIGHT` warnings. `abortOnError false` means an unclean report
  can still produce a successful task.
- Android 11/API 30, 1024 × 600, 160 dpi: checked vehicle/map, return to original
  Opel layout, settings, and four-column drawer. These are historical captures:
  [compact](screenshots/compact/01-opel-compact-1024x600.png),
  [app drawer](screenshots/compact/02-apps-1024x600.png).
- Simulated GPS: 72 km/h (38.8769 knots), automatic US units rounded to 45 mph,
  stationary speed, and unavailable marker after disabling location. Vehicle
  and map views remained usable.
  [Simulated 72 km/h](screenshots/compact/03-gps-speed-simulated-1024x600.png).
- Debug hooks: `--es prueba layout:compact_7`, `layout:standard`,
  `compact-panel:vehicle`, and `compact-panel:map`. These low-level layout hooks
  are retained for diagnostics; ordinary selection uses Opel Style.
- Current build/signing and emulator information: [OPEL_APK.md](OPEL_APK.md).

## Acceptance and remaining limits

- Verify style persistence and return to standard with original theme/accent,
  assignments, and map preferences. Use archived Opel images for historical
  comparisons; the old independent combinations are no longer normal choices.
- Explicitly test 1024 × 600 on API 17, plus API 16 and a modern Android version.
  Existing emulator evidence does not constitute an API 17 runtime result.
- Check vehicle/map, four-action/configurable dock, both palettes, scheduled and
  system modes, unknown stored values, wider displays, large system fonts,
  long German strings, and real touch-target sizes at different densities.
- All four requested actions must be visible in order. Settings and the larger
  app drawer must remain reachable.
- Switching during music playback, Bluetooth reconnects, missing apps/GPS/network,
  and delayed callbacks must not crash or update stale views. Vehicle mode must
  not create an unseen map.
- Verify radio, phone/Bluetooth, and CarPlay on the actual head unit. Emulator
  results do not validate proprietary apps or add unsupported station tuning.
- Show the whole vehicle; prefer user photos. The bundled photo is only an Opel
  compact fallback. Missing speed must leave balanced vertical image spacing.
- For a future car-temperature reader, test offline values, zero/negative
  Celsius, conversion, invalid/delayed data, service loss, and reconnects.
  Clearly label weather fallback and hide all unavailable temperatures.
- Run `assembleDebug`, `lintDebug`, and `git diff --check`, and inspect findings.
  No new firmware, root, MCU/CAN, resolution, minimum-SDK, permission, or UI-library
  changes are part of this work.
