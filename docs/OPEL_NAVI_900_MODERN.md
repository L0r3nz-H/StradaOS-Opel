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

Opel verwendet eine feste dunkle Palette mit roten Akzenten und silbernen Icons.
Hell-/Dunkelmodus und Akzentfarbe bleiben für den Standard gespeichert. Die
vorhandene Kartenanzeige bleibt eine GPS-Karte; die Navigationstaste öffnet die
zugeordnete Navigations-App. Es wird keine externe App in das Dashboard eingebettet.

## Prüfen auf Gerät oder Emulator

- 1024 × 600: Standard ansehen, anschließend Opel auswählen; Karte, Medien,
  Zeit, Zahnrad und sieben Menütasten müssen sichtbar und bedienbar sein.
- App beenden/neustarten: Opel bleibt ausgewählt. Über das Zahnrad zurück auf
  StradaOS wechseln; ursprünglichen Modus, Akzent und App-Zuordnungen prüfen.
- Mit dunklem, hellem und automatischem Standardmodus wechseln. Opel bleibt
  dunkel, auch beim automatischen Tageszeitwechsel.
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
