#!/usr/bin/env python3
"""API 30 debug-emulator regression: dialogs, artwork and revoked location access.

Run after smoke.sh / opel-theme-compat.sh:
    python3 .github/scripts/opel-controls-check.py OUTPUT_DIRECTORY
"""
import sys
from pathlib import Path
import subprocess,time,xml.etree.ElementTree as E,re
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=True)
pkg='com.stradaos.launcher.debug';act=pkg+'/com.stradaos.launcher.Main'
def adb(*a):return subprocess.check_output(['adb',*map(str,a)],text=True,stderr=subprocess.STDOUT,timeout=40)
def hook(v):
 adb('shell','am','start','-W','-n',act,'--es','prueba',v);time.sleep(2.2)
def tree(name):
 adb('shell','uiautomator','dump','/data/local/tmp/fixed-controls.xml')
 s=adb('shell','cat','/data/local/tmp/fixed-controls.xml');(out/(name+'.xml')).write_text(s);return E.fromstring(s)
def tap(node):
 x1,y1,x2,y2=map(int,re.findall(r'\d+',node.get('bounds')))
 adb('shell','input','tap',(x1+x2)//2,(y1+y2)//2);time.sleep(.8)
def prefs():
 return E.fromstring(adb('shell','run-as',pkg,'cat','shared_prefs/launcher.xml'))
adb('logcat','-b','crash','-c');adb('shell','am','force-stop',pkg)
hook('idioma:en');hook('pref:home_layout=standard');hook('pref:design=stradaos');hook('pref:dark_start=1080');hook('hora')
r=tree('stepper-before');up=[n for n in r.iter('node') if n.get('content-desc')=='Increase']
assert len(up)==2 and all(n.get('clickable')=='true' for n in up),E.tostring(r)
tap(up[0]);r=tree('stepper-after');save=next(n for n in r.iter('node') if n.get('text','').lower()=='save');tap(save)
value=next(n.get('value') for n in prefs() if n.get('name')=='dark_start');assert value=='1140',value
print('PASS accessible steppers, single tap increments hour exactly once and saves correct value',flush=True)
hook('tiempo-mant');r=tree('maintenance-before')
radios=[n for n in r.iter('node') if '/interval_' in n.get('resource-id','')]
assert len(radios)==3 and len({n.get('resource-id') for n in radios})==3
assert next(n for n in radios if n.get('resource-id').endswith('interval_weeks')).get('checked')=='true'
tap(next(n for n in radios if n.get('resource-id').endswith('interval_days')))
r=tree('maintenance-after');assert next(n for n in r.iter('node') if n.get('resource-id','').endswith('interval_days')).get('checked')=='true'
adb('shell','input','keyevent','4')
print('PASS maintenance unit IDs are unique, weeks default is selected and days selection works',flush=True)
hook('ajustes:11');hook('ui-snapshot');s=adb('shell','run-as',pkg,'cat','files/test-view-tree.xml');(out/'theme-gallery.xml').write_text(s)
assert 'Aurora$Thumb' in s and 'Cobalto$Thumb' in s
with (out/'theme-gallery.png').open('wb') as f:subprocess.run(['adb','exec-out','screencap','-p'],stdout=f,check=True)
hook('inicio');hook('pref:dark_start=1080')
print('PASS standard theme gallery with Aurora and Cobalto previews remains available',flush=True)
hook('pista-demo');hook('vel:60')
for theme in ['aurora','cobalto','']:
 hook('tema-premium:'+theme)
 with (out/('art-'+(theme or 'standard')+'.png')).open('wb') as f:subprocess.run(['adb','exec-out','screencap','-p'],stdout=f,check=True)
 assert adb('shell','pidof',pkg).strip()
crashes=adb('logcat','-b','crash','-d');assert pkg not in crashes,crashes
print('PASS demo artwork and speed render in standard, Aurora and Cobalto without crashes',flush=True)
adb('logcat','-b','crash','-c')
adb('shell','am','force-stop',pkg)
for perm in ['ACCESS_FINE_LOCATION','ACCESS_COARSE_LOCATION']:
 adb('shell','pm','revoke',pkg,'android.permission.'+perm)
start=adb('shell','am','start','-W','-n',act);(out/'denied-location-start.txt').write_text(start)
time.sleep(3);assert 'Status: ok' in start and adb('shell','pidof',pkg).strip()
crashes=adb('logcat','-b','crash','-d');(out/'denied-location-crashes.txt').write_text(crashes);assert pkg not in crashes,crashes
for perm in ['ACCESS_COARSE_LOCATION','ACCESS_FINE_LOCATION']:
 adb('shell','pm','grant',pkg,'android.permission.'+perm)
adb('shell','am','force-stop',pkg);hook('inicio')
print('PASS startup without location permission does not crash; permissions restored',flush=True)
