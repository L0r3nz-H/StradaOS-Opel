# Opel Navi 900 Modern

## Analyse und Plan

`Main.java` erzeugt die Oberfläche programmatisch mit einer skalierbaren Basis von
1024 × 600. `applyTheme()` setzt die gemeinsame Palette, `applyAccent()` die
Akzentfarbe. `build()` erstellt die Views; GPS, Medienbeobachter und App-Aktionen
aktualisieren bzw. bedienen diese Views. Darstellungseinstellungen liegen in den
`SharedPreferences` namens `launcher`.

Die zusätzliche Variante wird deshalb unabhängig von `theme` und `accent` unter
`design` gespeichert. Ohne Auswahl (auch bei bestehenden Installationen) bleibt
StradaOS aktiv. Unbekannte Designwerte fallen auf StradaOS zurück.

Umsetzung:

1. Eigene Designkennung, Grundpalette und Kartenbreite in `OpelDesign.java`.
2. Bedingte Layout-Erzeugung: Navigation links (624 × 380), Medien rechts
   (356 × 380), sieben App-Tasten unten. Breitere Displays geben den zusätzlichen
   Platz an Navigation und Menüleiste weiter.
3. Bestehende Karten-, GPS-, Radio-, Bluetooth-, Medien- und App-Aktionen verwenden.
   Keine zusätzlichen Dienste, Berechtigungen oder Abhängigkeiten.
4. Auswahl in Einstellungen → Darstellung → Design; jederzeit dort zurück auf
   StradaOS. Das Zahnrad oben rechts bleibt unabhängig von frei belegten Tasten
   erreichbar. Standardmodus, Akzent, App-Zuordnungen und Karteneinstellungen
   werden durch den Designwechsel nicht überschrieben.
5. Debug-Build und Lint prüfen; abschließend Gerätetest durchführen.

Opel unterstützt eine helle und eine dunkle Palette mit festen roten Akzenten.
Unter Einstellungen → Darstellung → Modus kann zwischen Dunkel, Hell und
Automatisch gewählt werden. Automatisch ist wie bei StradaOS von 6 bis 18 Uhr
hell. Die Auswahl liegt separat in `opel_theme`, Vorgabe ist `dark`; die
StradaOS-Einstellung `theme` und dessen Akzentfarbe bleiben erhalten. Das gilt
für das bisherige Opel-Layout und den optionalen Kompaktmodus. Die
vorhandene Kartenanzeige bleibt eine GPS-Karte; die Navigationstaste öffnet die
zugeordnete Navigations-App. Es wird keine externe App in das Dashboard eingebettet.

## Prüfen auf Gerät oder Emulator

- 1024 × 600: Standard ansehen, anschließend Opel auswählen; Karte, Medien,
  Zeit, Zahnrad und sieben Menütasten müssen sichtbar und bedienbar sein.
- App beenden/neustarten: Opel bleibt ausgewählt. Über das Zahnrad zurück auf
  StradaOS wechseln; ursprünglichen Modus, Akzent und App-Zuordnungen prüfen.
- Dunkel, Hell und Automatisch im Opel-Design prüfen; Auswahl bleibt nach
  Neustart erhalten. Tageszeitwechsel beachten. Zwischen StradaOS und Opel
  wechseln und die jeweils separat gespeicherte Modusauswahl kontrollieren.
- Ohne GPS-Berechtigung, bei ausgeschaltetem GPS und mit Fix den Kartenstatus
  prüfen; Status antippen öffnet die bestehende Abhilfe/Diagnose.
- Radio und Bluetooth über Menüleiste öffnen; Medieninformationen und
  Vorher/Play-Pause/Nächster mit den bereits unterstützten Quellen prüfen.
- Navigation antippen; langes Drücken wählt die Navigations-App. App-Tasten
  weiterhin lang drücken, frei belegen und nach Neustart prüfen.
- Mehrfach bei laufender Musik wechseln, auch aus geöffneten Einstellungen.
- Android 4.1/API 16 und ein breiteres Display prüfen. Es wurden ausschließlich
  bereits verwendete APIs und Java-Konventionen eingesetzt; minSdk bleibt 16.

Debug-Hook (wie die bestehenden `prueba`-Hooks nur im Debug-Paket):

```sh
adb shell am start -n com.stradaos.launcher.debug/com.stradaos.launcher.Main --es prueba design:opel_navi_900_modern
adb shell am start -n com.stradaos.launcher.debug/com.stradaos.launcher.Main --es prueba design:stradaos
```

Keine Firmware-, Root-, MCU- oder CAN-Bus-Änderungen.

## Hellmodus – lokale Validierung (2026-11-10)

- `assembleDebug` und `lintDebug` erfolgreich. Lint enthält weiterhin
  60 Errors, 1 Fatal und 59 Warnings; keine Befunde auf den für den Hellmodus
  geänderten Java-Zeilen. `abortOnError false` bleibt zu berücksichtigen.
- Android-11-Emulator, 1024 × 600, 160 dpi: Hell über die Darstellungseinstellungen
  aktiviert; Kompaktansicht und bisheriges Opel-Layout visuell kontrolliert.
  Opel-Hell bleibt nach App-Neustart erhalten. Wechsel zu StradaOS stellt dessen
  gespeicherten Dunkelmodus wieder her; zurück zu Opel erscheint erneut Hell.
- Rote Kopfleiste mit weißem Zahnrad, rote Play-Taste mit weißem Icon und
  dunkle Schrift/Icons auf hellen Flächen kontrolliert. Kein Crash-Eintrag.
- Echte Aufnahmen: [Kompakt/Hell](screenshots/compact/04-opel-light-1024x600.png)
  und [bisheriges Opel-Layout/Hell](screenshots/compact/05-opel-standard-light-1024x600.png).
- Automatischer Tageszeitwechsel und Laufzeit auf API 17 wurden für diese
  Änderung nicht separat getestet. `minSdk 16` bleibt unverändert.

## Lokale Validierung (2026-11-09)

- JDK 17, Gradle 8.11.1, Android SDK 35; Build-Tools 34 gemäß AGP-Vorgabe.
  Build-Werkzeuge wurden temporär unter `/tmp` eingerichtet; die
  Build-Konfiguration des Repositories wurde nicht verändert.
- `assembleDebug`: erfolgreich. Ausgabe:
  `app/build/outputs/apk/debug/StradaOS-2.13.0-prueba.apk`.
- `lintDebug`: ausgeführt. Das Repository setzt `abortOnError false`; der Bericht
  enthält 60 Errors, 1 Fatal und 58 Warnings in bestehendem Code bzw. bestehender
  Konfiguration (u. a. API-Gates und bewusstes targetSdk 28). Keine Fundstelle
  liegt in den hinzugefügten/geänderten Java-Zeilen oder in `OpelDesign.java`.
  Der erfolgreiche Task ist daher kein fehlerfreier Lint-Befund.
- APK-Metadaten: `com.stradaos.launcher.debug`, minSdk 16, targetSdk 28.
  APK-Signatur für minSdk 16 geprüft: v1 und v2 gültig.
- `git diff --check`: erfolgreich.
- ADB meldet keine verbundenen Geräte/Emulatoren. Die oben aufgeführten
  Laufzeit-, visuellen und Hardwareprüfungen wurden lokal nicht durchgeführt;
  insbesondere GPS-/Bluetooth-/Radio-Verhalten auf echter Hardware ist noch
  zu prüfen.
