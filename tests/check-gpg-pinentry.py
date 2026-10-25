#!/usr/bin/env python3
"""Check portable pinentry setup without accessing real keys or GPG agents."""
import os
from pathlib import Path
import stat
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]

with tempfile.TemporaryDirectory(prefix='gpg-pinentry-check-') as temp:
    base = Path(temp)
    mockbin = base/'commands'
    mockbin.mkdir()
    log = base/'gpgconf.log'
    for name, body in {
        'brew': 'printf "%s\\n" "$TEST_BREW_PREFIX"',
        'gpgconf': 'printf "%s\\n" "$*" >> "$TEST_GPG_LOG"',
    }.items():
        command = mockbin/name
        command.write_text('#!/bin/sh\n'+body+'\n')
        command.chmod(0o755)
    env = dict(os.environ, PATH=str(mockbin)+':/usr/bin:/bin', TEST_GPG_LOG=str(log))
    env.pop('GNUPGHOME', None)

    def setup():
        return subprocess.run([str(ROOT/'bin/setup-gpg-pinentry')], env=env, text=True, capture_output=True)

    for arch in ['apple-silicon', 'intel']:
        prefix = base/arch/'brew'
        pinentry = prefix/'bin/pinentry-mac'
        pinentry.parent.mkdir(parents=True)
        pinentry.write_text('#!/bin/sh\nexit 0\n')
        pinentry.chmod(0o755)
        home = base/arch/'home'
        home.mkdir()
        env.update(HOME=str(home), TEST_BREW_PREFIX=str(prefix))
        config = home/'.gnupg/gpg-agent.conf'
        result = setup()
        assert result.returncode == 0, result.stderr
        assert 'pinentry-program '+str(pinentry)+'\n' in config.read_text()
        assert stat.S_IMODE(config.stat().st_mode) == 0o600
        assert stat.S_IMODE(config.parent.stat().st_mode) == 0o700
        before, calls = config.read_bytes(), log.read_bytes()
        assert setup().returncode == 0
        assert config.read_bytes() == before and log.read_bytes() == calls

    custom_home = base/'custom gpg home'
    custom_home.mkdir()
    config = custom_home/'gpg-agent.conf'
    env['GNUPGHOME'] = str(custom_home)
    config.write_text('default-cache-ttl 600')
    assert setup().returncode == 0
    assert config.read_text().startswith('default-cache-ttl 600\n')
    existing = b'default-cache-ttl 600\n  pinentry-program /existing/pinentry\n'
    config.write_bytes(existing)
    calls = log.read_bytes()
    assert setup().returncode == 0
    assert config.read_bytes() == existing and log.read_bytes() == calls

    env['GNUPGHOME'] = str(base/'missing-helper-home')
    pinentry.unlink()
    assert setup().returncode != 0
    assert not Path(env['GNUPGHOME']).exists()

print('PASS: per-machine Homebrew paths, private new-file permissions, existing configuration preservation, repeat runs, custom GNUPGHOME, and missing-helper handling')
