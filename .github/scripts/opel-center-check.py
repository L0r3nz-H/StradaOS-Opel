#!/usr/bin/env python3
"""API30 hosted regression: standard video playback and Opel style transitions."""
from pathlib import Path
import subprocess
import sys
import time
import xml.etree.ElementTree as ET

out = Path(sys.argv[1])
out.mkdir(parents=True, exist_ok=True)
pkg = 'com.stradaos.launcher.debug'
activity = pkg + '/com.stradaos.launcher.Main'


def adb(*args):
    return subprocess.check_output(['adb', *args], text=True,
                                   stderr=subprocess.STDOUT, timeout=40)


def go(value):
    adb('shell', 'am', 'start', '-W', '-n', activity, '--es', 'prueba', value)
    time.sleep(2.2)


def snapshot(name):
    go('ui-snapshot')
    xml = adb('shell', 'run-as', pkg, 'cat', 'files/test-view-tree.xml')
    (out / (name + '.xml')).write_text(xml)
    with (out / (name + '.png')).open('wb') as stream:
        subprocess.run(['adb', 'exec-out', 'screencap', '-p'], stdout=stream, check=True)
    return ET.fromstring(xml)


def preferences():
    xml = adb('shell', 'run-as', pkg, 'cat', 'shared_prefs/launcher.xml')
    return {n.get('name'): n.text if n.tag == 'string' else n.get('value')
            for n in ET.fromstring(xml)}


def has_video(root):
    return any(n.get('class') == 'com.stradaos.launcher.VideoCard'
               for n in root.iter('node'))


adb('logcat', '-c')
adb('shell', 'mkdir', '-p', '/sdcard/Movies/OpelCheck')
adb('push', '.github/scripts/prueba-video.mp4', '/sdcard/Movies/OpelCheck/sample.mp4')
adb('shell', 'pm', 'grant', pkg, 'android.permission.READ_EXTERNAL_STORAGE')
go('idioma:en')
go('pref:idle_on=false')
go('pref:home_layout=standard')
go('pref:design=stradaos')
go('tema-premium:')
go('pref:video_dir=/sdcard/Movies/OpelCheck')
go('video-vel:0')
go('centro:video')
go('inicio')
time.sleep(12)
assert has_video(snapshot('01-standard-video'))
log = adb('logcat', '-d', '-s', 'StradaVideo:I', '*:S')
(out / 'video-playback.txt').write_text(log)
assert 'First frame' in log, 'Sample video never rendered its first frame'
print('PASS standard carousel renders the sample video', flush=True)

go('pref:opel_projection=aa')
go('pref:compact_main_panel=map')
go('design:opel_navi_900_modern')
go('inicio')
root = snapshot('02-opel-map')
assert not has_video(root)
assert any(n.get('text') == 'OPEL · STRADAOS' for n in root.iter('node'))
assert any(n.get('text') == 'Android Auto' for n in root.iter('node'))
assert preferences().get('center_card') == 'both'
go('ajustes:7')
root = snapshot('03-opel-map-settings')
assert not any(n.get('text') in ('In the center card', 'Map and video', 'Choose video',
                                'Video diagnostics') for n in root.iter('node'))
adb('shell', 'am', 'force-stop', pkg)
go('inicio')
assert not has_video(snapshot('04-opel-restart'))
assert preferences().get('center_card') == 'both'
print('PASS Opel map keeps its own controls and preserves the standard video choice across restart', flush=True)

go('design:stradaos')
go('inicio')
assert has_video(snapshot('05-standard-restored'))
assert preferences().get('center_card') == 'both'
crashes = adb('logcat', '-b', 'crash', '-d')
(out / 'crashes.txt').write_text(crashes)
assert pkg not in crashes, crashes
go('centro:solo')
go('video-vel:x')
print('PASS returning to standard restores the carousel without crashes', flush=True)
