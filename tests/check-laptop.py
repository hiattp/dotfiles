#!/usr/bin/env python3
"""Run laptop.local against command stubs; install nothing on the host."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
STUB = r'''
import json,os,pathlib,sys
name=pathlib.Path(sys.argv[0]).name
args=sys.argv[1:]
with open(os.environ['DOTFILES_TEST_LOG'],'a') as f:
    f.write(json.dumps([name,*args])+'\n')
if name=='brew' and args[:1]==['bundle']:
    pathlib.Path(os.environ['DOTFILES_TEST_MANIFEST']).write_text(sys.stdin.read())
elif name=='asdf' and args[:1]==['latest']:
    print(os.environ.get('DOTFILES_TEST_RUBY','4.0.3') if args[1]=='ruby' else '1.17.0')
elif name=='curl':
    url=next((a for a in args if a.startswith('https://')),'')
    if 'claude.ai' in url:
        if os.environ.get('DOTFILES_TEST_FAIL')=='claude': sys.exit(22)
        print('exit 0')
    elif 'nodejs.org' in url:
        if os.environ.get('DOTFILES_TEST_FAIL')=='node': sys.exit(22)
        print(json.dumps([{'version':'v99.0.0','lts':False},{'version':'v24.11.1','lts':'Krypton'},{'version':'v22.20.0','lts':'Jod'}]))
    elif '-o' in args:
        pathlib.Path(args[args.index('-o')+1]).write_text('{}\n')
elif name=='git' and args!=['lfs','install']:
    raise SystemExit('Unexpected Git clone/update: '+str(args))
'''


def scenario(changes=None):
    with tempfile.TemporaryDirectory(prefix='laptop-check-') as temp:
        base = Path(temp)
        home = base/'home'
        home.mkdir()
        (home/'.hiattp-dotfiles').symlink_to(ROOT)
        (home/'.thoughtbot-dotfiles/.git').mkdir(parents=True)
        fakebin = base/'bin'
        fakebin.mkdir()
        for name in ['brew','asdf','curl','git','go','pipx','rcup','npm']:
            stub = fakebin/name
            stub.write_text('#!'+sys.executable+'\n'+STUB)
            stub.chmod(0o755)
        env = dict(os.environ,HOME=str(home),PATH=str(fakebin)+os.pathsep+os.environ['PATH'],
                   DOTFILES_TEST_LOG=str(base/'commands.jsonl'),DOTFILES_TEST_MANIFEST=str(base/'Brewfile'))
        env.pop('ASDF_DATA_DIR',None)
        env.update(changes or {})
        harness = 'fancy_echo() { printf "$1\\n" "${@:2}"; }; add_or_update_asdf_plugin() { asdf plugin add "$@"; }; source "$1"'
        result = subprocess.run(['bash','-c',harness,'test',str(ROOT/'laptop.local')],env=env,text=True,capture_output=True)
        calls = [json.loads(line) for line in (base/'commands.jsonl').read_text().splitlines()]
        manifest = (base/'Brewfile').read_text()
        return result,calls,manifest


result,calls,manifest = scenario()
assert result.returncode==0,(result.stdout,result.stderr)
assert ['asdf','install','nodejs','24.11.1'] in calls
assert ['asdf','set','--home','nodejs','24.11.1'] in calls
assert ['asdf','install','ruby','4.0.3'] in calls
assert ['asdf','install','terraform','1.17.0'] in calls
playwright_install = ['npm','install','--global','@playwright/cli@latest']
assert calls.index(['asdf','set','--home','nodejs','24.11.1']) < calls.index(playwright_install)
assert calls.index(playwright_install) < calls.index(['asdf','reshim','nodejs'])
assert ['rcup','-K'] in calls
assert not any(c[0]=='git' and c[1:]!=['lfs','install'] for c in calls)
assert not any(c==['asdf','install'] for c in calls)
assert 'cask "zap"' not in manifest
for entry in ['cask "1password-cli"','cask "azure-cli"','brew "sdl2-compat"','cask "codex"','brew "dotnet"']:
    assert entry in manifest,entry
for entry in ['tap "azure/functions"','brew "azure/functions/azure-functions-core-tools@4"',
              'cask "tailscale-app"','cask "balenaetcher"','cask "dropbox"',
              'cask "avast-security"','cask "obsidian"']:
    assert entry not in manifest,entry
assert 'trusted: true' in manifest
print('PASS: supported package entries, scoped trust, stable/LTS defaults, no checkout pulls or legacy pin installation')

for failure in ['claude','node']:
    result,calls,_ = scenario({'DOTFILES_TEST_FAIL':failure})
    assert result.returncode==22,(failure,result.returncode,result.stderr)
    assert not any(c[:3]==['asdf','install','nodejs'] for c in calls)
print('PASS: failed installer/index downloads stop setup, including piped commands')

result,calls,_ = scenario({'DOTFILES_TEST_RUBY':'not-a-version'})
assert result.returncode!=0
assert not any(c[:2]==['asdf','install'] for c in calls)
print('PASS: invalid release metadata is rejected before runtime installation')
