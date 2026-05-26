#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

APT_PACKAGES=(
  build-essential
  ccache
  clang
  curl
  git
  lldb
  nasm
  pkg-config
  python3
  python3-pip
  python3-venv
  valgrind
  wayland-protocols
)

if command -v apt-get >/dev/null 2>&1; then
  if [ "$(id -u)" -eq 0 ]; then
    apt-get update
    apt-get install -y --no-install-recommends "${APT_PACKAGES[@]}"
  elif command -v sudo >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends "${APT_PACKAGES[@]}"
  else
    echo "apt-get found but no root/sudo available; skipping system package install" >&2
  fi
fi

if [ -x "./mach" ]; then
  ./mach --no-interactive bootstrap --application-choice browser
fi

mkdir -p artifacts .cache/ccache .cache/sccache

if [ ! -f ".mozconfig" ]; then
  cat > .mozconfig <<'MOZCONFIG'
ac_add_options --enable-application=browser
ac_add_options --enable-address-sanitizer
ac_add_options --disable-jemalloc
ac_add_options --disable-crashreporter
mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/obj-asan
mk_add_options MOZ_MAKE_FLAGS=-j$(nproc)
MOZCONFIG
fi

cat <<'MSG'
Setup complete.

Build cache directories are now prepared:
  .cache/ccache
  .cache/sccache
  obj-asan

To continue an incremental ASan build across resumed sessions:
  ./run/maintenance_setup.sh
  ./run/repro_build.sh

After build completes, run Firefox on Wayland:
  MOZ_ENABLE_WAYLAND=1 ./mach run
MSG
