"""Publish verified main only; never move tags, replace assets, or change Latest."""
import hashlib
import json
from pathlib import Path
import os
import subprocess


def run(*args):
    return subprocess.check_output(args, text=True).strip()


def api(path):
    return json.loads(run('gh', 'api', path))


repo = os.environ['GITHUB_REPOSITORY']
sha = os.environ['GITHUB_SHA']
assert repo == 'L0r3nz-H/StradaOS-Opel'
assert Path('dist/commit.txt').read_text().strip() == sha
assert api(f'repos/{repo}/git/ref/heads/main')['object']['sha'] == sha, 'main moved; revalidate latest commit'
m = json.loads(Path('.github/upstream-sync.json').read_text())
assert m['repo'] == 'lordnordic-debug/StradaOS'
up = api(f"repos/{m['repo']}/releases/{m['release_id']}")
assert not up['draft'] and not up['prerelease'] and up['tag_name'] == m['tag']
assert run('git', 'rev-parse', f"{m['upstream_commit']}^{{commit}}") == m['upstream_commit']
subprocess.run(['git', 'merge-base', '--is-ancestor', m['upstream_commit'], sha], check=True)
tag = m['preview_tag']
assert tag.startswith('opel-') and '-preview.' in tag
# Fetch list successfully before deciding absence; API failures must not look like no release.
releases = json.loads(run('gh', 'api', '--paginate', '--slurp', f'repos/{repo}/releases?per_page=100'))
existing = next((r for page in releases for r in page if r['tag_name'] == tag), None)
remote = run('git', 'ls-remote', 'origin', f'refs/tags/{tag}', f'refs/tags/{tag}^{{}}')
if remote:
    refs = dict(line.split()[::-1] for line in remote.splitlines())
    target = refs.get(f'refs/tags/{tag}^{{}}', refs.get(f'refs/tags/{tag}'))
    assert target == sha, 'Existing tag points elsewhere; refusing overwrite'
else:
    assert existing is None
    subprocess.run(['git', 'tag', tag, sha], check=True)
    subprocess.run(['git', 'push', 'origin', f'refs/tags/{tag}'], check=True)

apk = next(Path('dist').glob('*.apk'))
checksum = Path(str(apk) + '.sha256')
assert checksum.read_text().split()[0] == hashlib.sha256(apk.read_bytes()).hexdigest()
assets = [apk, checksum]
if existing:
    assert not existing['draft'] and existing['prerelease']
    assert {a['name'] for a in existing['assets']} == {p.name for p in assets}
    for p in assets:
        a = next(a for a in existing['assets'] if a['name'] == p.name)
        assert a['digest'] == 'sha256:' + hashlib.sha256(p.read_bytes()).hexdigest(), 'Existing asset differs'
    print('Already published:', existing['html_url'])
else:
    report = json.loads(Path('dist/verification.json').read_text())
    notes = (f"Upstream: {up['html_url']}\n\n"
             f"Upstream commit: `{m['upstream_commit']}`\nOpel commit: `{sha}`\n\n"
             'Preserves Opel Style, Astra image fallback, CarPlay/Android Auto selection, '
             'Opel package identity, settings migrations and official-update separation.\n\n'
             'Validated: debug/Opel builds, no additional lint errors/fatal findings against sync baseline, '
             'package/name/version/SDK metadata, increasing versionCode, APK alignment, '
             'v1/v2/v3 signatures at minSdk 16, certificate matches Opel 2.22.0.\n\n'
             f"Lint baseline: {report['baseline_lint']}; current: {report['current_lint']}. "
             'Existing lint findings remain.\n\n'
             f"Test limits: {report['runtime_tests']}\n")
    Path('dist/release-notes.md').write_text(notes)
    subprocess.run(['gh', 'release', 'create', tag, *(str(p) for p in assets),
                    '--repo', repo, '--verify-tag', '--prerelease', '--latest=false',
                    '--title', f"StradaOS Opel {m['tag'].removeprefix('v')} Preview",
                    '--notes-file', 'dist/release-notes.md'], check=True)
