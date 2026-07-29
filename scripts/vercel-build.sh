#!/usr/bin/env bash
set -Eeuo pipefail

export CI=true
export FLUTTER_SUPPRESS_ANALYTICS=true

FLUTTER_VERSION="${FLUTTER_VERSION:-3.44.7}"

if command -v flutter >/dev/null 2>&1; then
  FLUTTER_BIN="$(command -v flutter)"
  echo "Using existing Flutter: $FLUTTER_BIN"
else
  FLUTTER_ROOT="${HOME}/.cache/flutter-${FLUTTER_VERSION}"

  if [[ ! -x "${FLUTTER_ROOT}/bin/flutter" ]]; then
    echo "Installing Flutter ${FLUTTER_VERSION} for Vercel build..."
    rm -rf "$FLUTTER_ROOT"

    git clone \
      --depth 1 \
      --branch "$FLUTTER_VERSION" \
      https://github.com/flutter/flutter.git \
      "$FLUTTER_ROOT"
  fi

  export PATH="${FLUTTER_ROOT}/bin:${PATH}"
  FLUTTER_BIN="${FLUTTER_ROOT}/bin/flutter"
fi

"$FLUTTER_BIN" --version
"$FLUTTER_BIN" config --enable-web
"$FLUTTER_BIN" precache --web
"$FLUTTER_BIN" pub get --enforce-lockfile

build_args=(
  build
  web
  --release
  --no-wasm-dry-run
)

if [[ -n "${APP_API_BASE_URL:-}" ]]; then
  echo "Building with explicit APP_API_BASE_URL."
  build_args+=(
    "--dart-define=APP_API_BASE_URL=${APP_API_BASE_URL}"
  )
else
  echo "APP_API_BASE_URL is not set; using same-origin API fallback."
fi

"$FLUTTER_BIN" "${build_args[@]}"

test -f build/web/index.html
test -f build/web/flutter_bootstrap.js
test -f build/web/main.dart.js

echo "Flutter web release build completed."
