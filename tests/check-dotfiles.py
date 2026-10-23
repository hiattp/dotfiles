#!/usr/bin/env python3
"""Exercise launcher and copy safety without creating any Git worktrees."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
REAL_GIT = shutil.which('git')


def run(command, *, env=None, ok=True):
    result = subprocess.run(command, env=env, text=True, capture_output=True)
    if ok and result.returncode:
        raise AssertionError(f'{command}: {result.stdout}\n{result.stderr}')
    return result


with tempfile.TemporaryDirectory(prefix='dotfiles-check-') as temp:
    base = Path(temp)
    env = dict(os.environ, XDG_CACHE_HOME=str(base/'cache'))
    mockbin = base/'bin'
    mockbin.mkdir()
    codex = mockbin/'codex'
    codex.write_text('#!/usr/bin/env python3\nimport json,resource,sys\nprint(json.dumps({"args":sys.argv[1:],"soft":resource.getrlimit(resource.RLIMIT_NOFILE)[0]}))\n')
    codex.chmod(0o755)
    env['PATH'] = str(mockbin)+os.pathsep+os.environ['PATH']
    launcher = str(ROOT/'bin/codex-isolated')
    result = run([launcher, 'resume', '--last', 'a prompt with spaces'], env=env)
    got = json.loads(result.stdout)
    assert got['args'] == ['--no-daemon', 'resume', '--last', 'a prompt with spaces']
    assert got['soft'] >= 1024
    env['CODEX_ISOLATED_NOFILE_LIMIT'] = 'invalid'
    assert run([launcher], env=env, ok=False).returncode == 2
    del env['CODEX_ISOLATED_NOFILE_LIMIT']
    got = json.loads(run(['zsh', '-fc', 'ulimit -S -n 2048; exec "$1"', 'test', launcher], env=env).stdout)
    assert got['soft'] >= 2048
    # Test without the optional monitor installed alongside the launcher.
    standalone = base/'codex-isolated'
    shutil.copy2(launcher, standalone)
    run([str(standalone), '--help'], env=env)
    print('PASS: isolated launcher arguments, validation, limits, and monitor independence')

    src = base/'source'
    dst = base/'destination'
    src.mkdir(); dst.mkdir()
    run([REAL_GIT, 'init', '-q', str(src)], env=env)
    (src/'.gitignore').write_text('cache/\n')
    (src/'cache').mkdir()
    (src/'cache/file').write_text('source')
    helper = str(ROOT/'zsh/functions/git_worktree_add_copy_on_write')

    def cow(force=False, ok=True):
        return run(['zsh', '-fc', 'source "$1"; shift; worktree_cow_ignored "$@"', 'test', helper, *(['-f'] if force else []), str(dst), str(src)], env=env, ok=ok)

    cow()
    assert (dst/'cache/file').read_text() == 'source'
    (dst/'cache/file').write_text('keep')
    cow()
    assert (dst/'cache/file').read_text() == 'keep'
    cow(force=True)
    assert (dst/'cache/file').read_text() == 'source'
    (src/'.cow-include').write_text('../outside\n')
    assert cow(ok=False).returncode == 2
    (src/'.cow-include').write_text('.git/config\n')
    assert cow(ok=False).returncode == 2
    (src/'.cow-include').write_text('extra\n')
    (src/'extra').write_text('extra')
    cow()
    assert (dst/'extra').read_text() == 'extra'
    outside = base/'outside'
    outside.mkdir()
    shutil.rmtree(dst/'cache')
    (dst/'cache').symlink_to(outside, target_is_directory=True)
    cow(force=True)
    assert not (outside/'file').exists()
    assert (dst/'cache').is_symlink()
    print('PASS: ignored and explicit copies, overwrite protection, traversal and symlink protection')

    # Stub only worktree creation: no linked worktree is created by this test.
    mockgit = mockbin/'git'
    mockgit.write_text('#!/bin/sh\nif [ "$1" = worktree ] && [ "$2" = add ]; then\n  printf "%s\\n" "$@" > "$MOCK_LOG"\n  exit "$MOCK_STATUS"\nfi\nexec "$REAL_GIT" "$@"\n')
    mockgit.chmod(0o755)
    env.update(REAL_GIT=REAL_GIT, MOCK_LOG=str(base/'git-args'), MOCK_STATUS='7')
    before = (dst/'extra').read_text()
    cmd = ['zsh', '-fc', 'source "$1"; shift; git_worktree_add_copy_on_write "$@"', 'test', helper, '--cow', '-b', 'feature', str(dst)]
    assert run(cmd, env=env, ok=False).returncode == 7
    assert (dst/'extra').read_text() == before
    env['MOCK_STATUS'] = '0'
    run(['zsh', '-fc', 'source "$1"; shift; git_worktree_add_copy_on_write "$@"', 'test', helper, '-b', 'feature', str(dst)], env=env)
    assert (base/'git-args').read_text().splitlines() == ['worktree', 'add', '-b', 'feature', str(dst)]
    cow_dest = base/'branch-destination'
    cow_dest.mkdir()
    run(['zsh', '-fc', 'source "$1"; cd "$2"; shift 2; git_worktree_add_copy_on_write "$@"', 'test', helper, str(src), '--cow', '-b', 'feature', str(cow_dest)], env=env)
    assert (cow_dest/'extra').read_text() == 'extra'
    assert (base/'git-args').read_text().splitlines() == ['worktree', 'add', '-b', 'feature', str(cow_dest)]
    print('PASS: branch/path parsing, Git argument forwarding, explicit COW, and failure propagation')

run(['zsh', str(ROOT/'bin/codex-resource-monitor'), '--self-test'])
print('PASS: monitor threshold self-test')
