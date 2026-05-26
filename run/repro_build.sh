#!/usr/bin/env bash
set -euo pipefail

mkdir -p artifacts .cache/ccache .cache/sccache

export CCACHE_DIR="${CCACHE_DIR:-$PWD/.cache/ccache}"
export SCCACHE_DIR="${SCCACHE_DIR:-$PWD/.cache/sccache}"
export MOZ_ENABLE_WAYLAND=1

if [ ! -f ".mozconfig" ]; then
  echo "Missing .mozconfig. Run ./run/setup.sh first." >&2
  exit 1
fi

log="artifacts/mach-build-asan.log"

echo "Starting incremental build. Log: ${log}"
./mach build >>"${log}" 2>&1

echo "Build finished. Binary: obj-asan/dist/bin/firefox"
