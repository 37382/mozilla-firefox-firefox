#!/usr/bin/env bash
set -euo pipefail

if [ -x "./mach" ]; then
  ./mach --no-interactive bootstrap --application-choice browser
fi

mkdir -p artifacts .cache/ccache .cache/sccache obj-asan

export CCACHE_DIR="${CCACHE_DIR:-$PWD/.cache/ccache}"
export SCCACHE_DIR="${SCCACHE_DIR:-$PWD/.cache/sccache}"

if command -v ccache >/dev/null 2>&1; then
  ccache -M 20G >/dev/null 2>&1 || true
fi

cat <<'MSG'
Maintenance setup complete.

Incremental build state is preserved in obj-asan and .cache.
Continue the ASan build with:
  ./run/repro_build.sh
MSG
