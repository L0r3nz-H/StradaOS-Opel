"""Check actual lint findings and Opel APK metadata; Gradle ignores lint errors."""
from collections import Counter
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import xml.etree.ElementTree as ET

base = Path(sys.argv[1])

def findings(path):
    result = Counter()
    totals = Counter()
    for issue in ET.parse(path).getroot().findall('issue'):
        severity = issue.get('severity')
        totals[severity] += 1
        if severity in ('Error', 'Fatal'):
            location = issue.find('location')
            filename = location.get('file', '') if location is not None else ''
            filename = filename.replace('\\', '/').split('/app/')[-1]
            result[(issue.get('id'), filename, issue.get('message'))] += 1
    return result, totals

old, old_totals = findings('verification/baseline-lint.xml')
new, new_totals = findings('app/build/reports/lint-results-opel.xml')
regressions = new - old
report = {'baseline_lint': dict(old_totals), 'current_lint': dict(new_totals),
          'new_errors': [{'id': k[0], 'file': k[1], 'message': k[2], 'count': v}
                         for k, v in sorted(regressions.items())],
          'runtime_tests': 'Publication requires upstream debug UI tests and signed Opel install/three cold starts on APIs 16, 19, 21, 23, 24, 28, 30 and 34. API 17, detailed Opel settings interactions and head-unit hardware remain untested.'}
Path('verification/summary.json').write_text(json.dumps(report, indent=2) + '\n')
print(json.dumps(report, indent=2))
if regressions:
    raise SystemExit('New lint errors/fatal findings: release blocked')

build = Path('app/build.gradle').read_text()
version = re.search(r"versionName '([^']+)'", build)[1]
code = int(re.search(r'versionCode (\d+)', build)[1])
old_code = int(re.search(r'versionCode (\d+)', (base / 'app/build.gradle').read_text())[1])
assert code > old_code, 'versionCode must increase over sync baseline'
tools = Path(os.environ['ANDROID_HOME']) / 'build-tools/35.0.0'
apks = list(Path('app/build/outputs/apk/opel').glob('*.apk'))
assert len(apks) == 1, apks
badging = subprocess.check_output([str(tools / 'aapt'), 'dump', 'badging', str(apks[0])], text=True)
assert "name='com.stradaos.launcher.opel'" in badging
assert f"versionName='{version}-opel'" in badging
assert f"versionCode='{code}'" in badging
assert "application-label:'StradaOS Opel'" in badging
assert "sdkVersion:'16'" in badging and "targetSdkVersion:'28'" in badging
assert 'application-debuggable' not in badging
Path('verification/apk-badging.txt').write_text(badging)
print('Opel metadata and increasing versionCode verified')
