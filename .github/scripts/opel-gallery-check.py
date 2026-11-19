#!/usr/bin/env python3
"""API 30 debug-emulator checks for the Opel entry in Personalization.

Usage: python3 .github/scripts/opel-gallery-check.py OUTPUT_DIRECTORY
Uses a disposable debug install, changes test preferences and leaves the German
landscape gallery open.
"""
from pathlib import Path
import re
import subprocess
import sys
import time
import xml.etree.ElementTree as ET

out = Path(sys.argv[1])
out.mkdir(parents=True, exist_ok=True)
pkg = 'com.stradaos.launcher.debug'
activity = pkg + '/com.stradaos.launcher.Main'


def adb(*args):
    return subprocess.check_output(['adb', *map(str, args)], text=True,
                                   stderr=subprocess.STDOUT, timeout=40)


def go(value):
    adb('shell', 'am', 'start', '-W', '-n', activity, '--es', 'prueba', value)
    time.sleep(2.2)  # Main schedules debug hooks after 1.5 seconds.


def snapshot(name):
    go('ui-snapshot')
    xml = adb('shell', 'run-as', pkg, 'cat', 'files/test-view-tree.xml')
    (out / (name + '.xml')).write_text(xml)
    with (out / (name + '.png')).open('wb') as stream:
        subprocess.run(['adb', 'exec-out', 'screencap', '-p'], stdout=stream, check=True)
    return ET.fromstring(xml)


def tap_text(text):
    # The live dashboard need not become accessibility-idle: use its debug UI-thread snapshot.
    for attempt in range(8):
        go('ui-snapshot')
        root = ET.fromstring(adb('shell', 'run-as', pkg, 'cat', 'files/test-view-tree.xml'))
        viewport = list(map(int, re.findall(r'-?\d+', root.find('node').get('bounds'))))
        for node in root.iter('node'):
            if node.get('text') != text:
                continue
            x1, y1, x2, y2 = map(int, re.findall(r'-?\d+', node.get('bounds')))
            x1, y1 = max(x1, viewport[0]), max(y1, viewport[1])
            x2, y2 = min(x2, viewport[2]), min(y2, viewport[3])
            if x2 <= x1 or y2 <= y1:
                continue
            adb('shell', 'input', 'tap', (x1 + x2) // 2, (y1 + y2) // 2)
            time.sleep(2)
            return
        adb('shell', 'input', 'swipe', 900, 520, 900, 160, 300)
        time.sleep(.5)
    raise AssertionError('Gallery option not found: ' + text)


def prefs():
    root = ET.fromstring(adb('shell', 'run-as', pkg, 'cat', 'shared_prefs/launcher.xml'))
    return {n.get('name'): n.text if n.tag == 'string' else n.get('value') for n in root}


def opel_selected():
    p = prefs()
    assert p.get('design') == 'opel_navi_900_modern' and p.get('home_layout') == 'compact_7', p
    assert p.get('opel_theme') == 'light' and p.get('opel_projection') == 'aa', p
    assert p.get('accent') == '-13730510', 'Saved standard accent was changed'


adb('logcat', '-b', 'crash', '-c')
# Earlier smoke runs leave demo maintenance reminders behind; keep them out of gallery taps.
go('pref:oil_on=false')
go('pref:maint=[]')
go('pref:idle_on=false')
adb('shell', 'input', 'keyevent', '4')
go('idioma:en')
go('sim:0')
go('pref:opel_projection=aa')
go('pref:opel_theme=light')
go('pref:accent=-13730510')
go('tema-premium:cobalto')
go('vista-temas:h')
root = snapshot('01-landscape-gallery')
thumbs = [n.get('class') for n in root.iter('node') if n.get('class', '').endswith('Thumb')]
assert thumbs and thumbs[0] == 'com.stradaos.launcher.OpelThumb', thumbs
assert thumbs.count('com.stradaos.launcher.OpelThumb') == 1, thumbs
print('PASS Opel Style is the first landscape gallery option', flush=True)

tap_text('Opel Style')
opel_selected()
assert prefs().get('premium_theme') == 'cobalto', 'Entering Opel lost saved premium theme'
root = snapshot('02-opel-selected')
assert any(n.get('text') == 'Personalization' for n in root.iter('node'))
go('inicio')
root = snapshot('03-opel-home')
assert any(n.get('text') == 'OPEL · STRADAOS' for n in root.iter('node'))
adb('shell', 'am', 'force-stop', pkg)
go('inicio')
opel_selected()
print('PASS gallery selection activates Opel and preserves its settings across restart', flush=True)

go('ajustes:5')
root = snapshot('04-appearance')
assert not any(n.get('text') in ('Home design', 'Home screen design', 'Opel Style') for n in root.iter('node'))
go('vista-temas:v')
root = snapshot('05-portrait-gallery')
assert not any(n.get('class') == 'com.stradaos.launcher.OpelThumb' for n in root.iter('node'))
opel_selected()
print('PASS Appearance has no design selector; Portrait has no Opel card', flush=True)

go('vista-temas:h')
tap_text('Classic')
p = prefs()
assert p.get('design') == 'stradaos' and p.get('home_layout') == 'standard', p
assert 'premium_theme' not in p and p.get('accent') == '-13730510', p
print('PASS selecting a standard theme exits Opel and restores the standard accent', flush=True)

go('vista-temas:h')
tap_text('Opel Style')
opel_selected()
go('vista-temas:h')
tap_text('Cobalt')
p = prefs()
assert p.get('design') == 'stradaos' and p.get('home_layout') == 'standard', p
assert p.get('premium_theme') == 'cobalto' and p.get('opel_theme') == 'light', p
print('PASS selecting a premium theme exits Opel without changing Opel settings', flush=True)

go('vista-temas:h')
tap_text('Opel Style')
go('idioma:de')
go('vista-temas:h')
snapshot('06-german-opel-gallery')
opel_selected()
crashes = adb('logcat', '-b', 'crash', '-d')
(out / 'crashes.txt').write_text(crashes)
assert pkg not in crashes, crashes
print('PASS no crashes; German Opel gallery left open', flush=True)
