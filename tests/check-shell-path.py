#!/usr/bin/env python3
"""Check tool resolution in real login and interactive shell startup."""
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]

with tempfile.TemporaryDirectory(prefix='shell-path-check-') as temp:
    base = Path(temp)
    home = base/'home'
    native = home/'.local/bin/claude'
    native.parent.mkdir(parents=True)
    native.write_text('#!/bin/sh\necho native-claude\n')
    native.chmod(0o755)
    (home/'.config').mkdir()
    (home/'.config/hiattp').symlink_to(ROOT/'config/hiattp')
    (home/'.zprofile').symlink_to(ROOT/'zprofile')
    (home/'.zshrc').write_text('source "'+str(ROOT/'zshrc.local')+'"\n')
    for data in [home/'.asdf', base/'custom-asdf']:
        shims = data/'shims'
        shims.mkdir(parents=True)
        for name, body in [('claude', 'echo stale-claude-shim >&2; exit 126'),
                           ('node', 'echo project-node'),
                           ('dotnet', 'echo project-dotnet')]:
            command = shims/name
            command.write_text('#!/bin/sh\n'+body+'\n')
            command.chmod(0o755)
        env = dict(os.environ, HOME=str(home), ZDOTDIR=str(home), PATH=str(shims)+':/usr/bin:/bin:/usr/sbin:/sbin')
        env.pop('ASDF_DIR', None)
        env.pop('ASDF_DATA_DIR', None)
        if data != home/'.asdf':
            env['ASDF_DATA_DIR'] = str(data)
        for version in ['20.10.0', '24.11.1']:
            project = base/('project-'+version)
            project.mkdir(exist_ok=True)
            (project/'.tool-versions').write_text('nodejs '+version+'\n')
            result = subprocess.run(
                ['zsh', '-fc', 'source "$1"; command -v claude; claude --version; command -v node',
                 'test', str(ROOT/'zshrc.local')],
                env=env, cwd=project, text=True, capture_output=True)
            assert result.returncode == 0, (result.stdout, result.stderr)
            assert result.stdout.splitlines() == [str(native), 'native-claude', str(shims/'node')], result.stdout
            for flags in ['-lc', '-lic']:
                result = subprocess.run(
                    ['zsh', flags,
                     'command -v claude; command -v node; command -v dotnet; '
                     'source "$HOME/.config/hiattp/shell-path.zsh"; '
                     'source "$HOME/.config/hiattp/shell-path.zsh"; print -l -- $path'],
                    env=env, cwd=project, text=True, capture_output=True)
                assert result.returncode == 0, (result.stdout, result.stderr)
                lines = result.stdout.splitlines()
                assert lines[:3] == [str(native), str(shims/'node'), str(shims/'dotnet')], result.stdout
                assert len(lines[3:]) == len(set(lines[3:])), result.stdout

print('PASS: login and interactive shells prefer native Claude and asdf runtimes; custom ASDF_DATA_DIR and PATH deduplication work')
