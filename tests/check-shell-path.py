#!/usr/bin/env python3
"""Check native Claude wins over a stale asdf shim across project directories."""
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
    for data in [home/'.asdf', base/'custom-asdf']:
        shims = data/'shims'
        shims.mkdir(parents=True)
        for name, body in [('claude', 'echo stale-claude-shim >&2; exit 126'),
                           ('node', 'echo project-node')]:
            command = shims/name
            command.write_text('#!/bin/sh\n'+body+'\n')
            command.chmod(0o755)
        env = dict(os.environ, HOME=str(home), PATH=str(shims)+':/usr/bin:/bin:/usr/sbin:/sbin')
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

print('PASS: native Claude overrides stale asdf shims across projects and custom ASDF_DATA_DIR; Node still resolves through asdf')
