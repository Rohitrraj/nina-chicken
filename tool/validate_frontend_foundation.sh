#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "=========================================="
echo "NINA CHICKEN — FRONTEND FOUNDATION CHECK"
echo "=========================================="

echo ""
echo "===== 1. BRANCH ====="
git branch --show-current

echo ""
echo "===== 2. GIT STATUS ====="
git status --short --branch

echo ""
echo "===== 3. FORMAT CHECK ====="
dart format \
  --output=none \
  --set-exit-if-changed \
  lib/core/design_system \
  lib/core/theme.dart \
  lib/core/widgets/layout \
  lib/core/widgets/buttons \
  lib/core/widgets/forms \
  lib/core/widgets/card/app_card.dart \
  lib/core/widgets/card/app_info_card.dart \
  lib/core/widgets/card/cards.dart \
  lib/core/widgets/feedback \
  lib/core/widgets/snackbarr/custom_snackbar.dart \
  lib/features/user/presentation/widgets \
  lib/features/user/presentation/pages/dashboard.dart \
  lib/features/user/presentation/pages/catalog.dart \
  lib/features/user/presentation/pages/about_us.dart \
  lib/features/user/presentation/pages/contact_us.dart \
  test/core \
  test/features/user/presentation/widgets

echo ""
echo "===== 4. ANALYZE ====="
flutter analyze --no-fatal-infos

echo ""
echo "===== 5. TEST ====="
flutter test

echo ""
echo "===== 6. RELEASE BUILD ====="
flutter build web --release

echo ""
echo "===== 7. DIFF CHECK ====="
git diff --check

echo ""
echo "===== 8. BACKEND FREEZE CHECK ====="
BACKEND_CHANGES="$(
  {
    git diff --name-only 0b525cc...HEAD
    git diff --name-only
    git diff --cached --name-only
  } |
    sort -u |
    grep -E \
      '^(api/|server/|firestore\.rules$|firebase\.json$|lib/dependency_injection/|lib/features/.+/(data|domain)/)' \
    || true
)"

if [[ -n "$BACKEND_CHANGES" ]]; then
  echo "FAIL: ditemukan perubahan pada backend freeze scope:"
  echo "$BACKEND_CHANGES"
  exit 1
fi

echo "PASS: backend freeze tetap terjaga"

echo ""
echo "===== 9. FINAL STATUS ====="
git status --short --branch

echo ""
echo "PASS: frontend foundation validation completed"
