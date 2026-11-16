# Installierbare Opel-Edition

- App-Name: **StradaOS Opel**
- Paket: `com.stradaos.launcher.opel` (parallel zu StradaOS und StradaOS Prueba)
- Version: `2.21.2-opel`, versionCode 54
- Android: minSdk 16, targetSdk 28; keine Änderung der Bildschirmauflösung
- Build-Typ: `opel`, basiert auf `release`, nicht debuggable

Die erste Installation verwendet Opel Navi 900 Modern, den Kompaktmodus und
den Fahrzeugnamen „Astra J“. Der Einrichtungsassistent bleibt erhalten.
Eigene spätere Einstellungen werden nicht bei jedem Start überschrieben.
Hell, Dunkel und Automatisch bleiben auswählbar. Die eigene Opel-Edition bietet
keine normalen StradaOS-Updates an; Updates benötigen dieselbe Paketkennung
und denselben Signierschlüssel.

## Installationsdatei vom 16.11.2026

Die installierbare, lokal signierte Datei liegt unter:

`app/build/outputs/install/StradaOS-Opel-2.21.2.apk`

Daneben liegt `StradaOS-Opel-2.21.2.apk.sha256` mit der SHA-256-Prüfsumme.
APK auf das Android-Autoradio kopieren und mit dem dortigen Dateimanager öffnen.
Die Installation aus dieser Quelle muss am Radio gegebenenfalls erlaubt werden.
Bestehendes StradaOS wird durch das andere Paket nicht ersetzt; dessen
Einstellungen werden auch nicht automatisch übernommen.

## Build und Signierung

Der neue Branch `feature/opel-latest-2.21.2` basiert auf Upstream 2.21.2, Commit
`b2f327dcfae5e8341cb7851c525dc893545b3ee2` vom 15.11.2026. Darauf sind die
Opel-Anpassungen des bisherigen Branches portiert. Der alte Branch bleibt
erhalten. Opel-Design, Kompaktlayout, Paketkennung und Update-Trennung bleiben
erhalten; neuere Upstream-Funktionen wie Wartungen, Backup, Hochformat,
System-/Zeitplan-Theme und Geschwindigkeitskorrektur werden weiterverwendet.

`./gradlew assembleOpel lintOpel` baut die **unsignierte** Zwischenversion unter
`app/build/outputs/apk/opel/StradaOS-2.21.2-opel.apk`. Diese vor der Installation
mit `zipalign` ausrichten und anschließend mit `apksigner` signieren.
Die ausgelieferte Datei wurde mit v1-, v2- und v3-Signatur erstellt; die
v1-Signatur ist für Android 4.2 vorhanden und mit `--min-sdk-version 16` geprüft.

Der lokale Schlüssel liegt außerhalb des Repositories unter
`~/.config/stradaos/opel-signing/stradaos-opel.jks`, Alias `stradaos-opel`.
Die zugehörige Passwortdatei liegt im selben geschützten Verzeichnis.
Dieses Verzeichnis für zukünftige kompatible Opel-Updates aufbewahren.
Der Schlüssel ist unabhängig von offiziellen StradaOS-Releases.

## Bisherige Validierung der ausgelieferten 2.15.0

- `assembleOpel` erfolgreich; App-Name, Paket, minSdk und targetSdk aus der
  finalen APK mit `aapt` kontrolliert. Nicht als debuggable markiert.
- `apksigner verify --verbose --min-sdk-version 16`: gültig; v1/v2/v3 vorhanden.
- Signierte APK auf Android-11-Emulator installiert und gestartet. Die
  Berechtigungsabfrage zeigt „StradaOS Opel“; dahinter erscheint das Opel-
  Kompaktlayout mit Fahrzeugfoto und „Astra J“. Kein Crash-Eintrag.
- `lintOpel` ausgeführt: bestehende 60 Errors, 1 Fatal, 62 Warnings.
  Wegen `abortOnError false` bedeutet Task-Erfolg keinen fehlerfreien Lint-Befund.
- Laufzeit auf API 17 und herstellerspezifische Radio-/Bluetooth-/CarPlay-
  Funktionen sind weiterhin auf dem echten Zielgerät zu prüfen.

## Validierung 2.16.0-opel (11.11.2026)

- `assembleOpel lintOpel` mit JDK 17 und Android SDK 35 erfolgreich ausgeführt.
- APK-Metadaten mit `aapt` geprüft: `com.stradaos.launcher.opel`,
  `2.16.0-opel`, versionCode 46, minSdk 16, targetSdk 28.
- Alle 33 Java-Quelldateien zusätzlich mit Java-8-Zielversion kompiliert.
- Offline-Renderer über den übernommenen Desktop-Prüfstand mit einer echten
  mapsforge-Karte von Monaco im hellen und dunklen Modus ausgeführt.
- Lint: 60 Errors, 1 Fatal, 60 Warnings. Die Anzahl schwerer Befunde entspricht
  dem vorherigen Stand; `abortOnError false` lässt den Task trotzdem passieren.
- Die neue Build-APK ist unsigniert. Keine neue signierte Installationsdatei
  erstellt und kein Emulator-/Zielgerätetest durchgeführt.

## Validierung 2.21.2-opel (16.11.2026)

- `assembleDebug assembleOpel lintOpel` mit JDK 17, Gradle 8.11.1 und
  Android SDK 35 erfolgreich. minSdk 16 und targetSdk 28 unverändert.
- Installations-APK mit dem bisherigen Opel-Schlüssel signiert und mit
  `apksigner verify --min-sdk-version 16` geprüft; v1/v2/v3 gültig.
  Zertifikat stimmt mit der ausgelieferten 2.15.0 überein. Metadaten:
  `StradaOS Opel`, `com.stradaos.launcher.opel`, `2.21.2-opel`, versionCode 54.
- Lint: 72 Errors, 1 Fatal, 81 Warnings. Auf den gegenüber Upstream
  geänderten Opel-Java-Zeilen keine Errors/Fatals, eine RTL-Warnung.
  Der gesamte Lint-Bericht ist weiterhin nicht fehlerfrei.
- Kein neuer Emulator- oder Gerätetest: Kein Emulator installiert; der
  Zugriff auf die T3-Geräteansicht ist in dieser Umgebung deaktiviert.
  Die bisherigen Screenshots und Laufzeitnachweise oben gehören zu älteren
  Versionen und sind kein Laufzeitnachweis für 2.21.2.
