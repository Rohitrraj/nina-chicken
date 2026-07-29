#!/usr/bin/env bash
set -Eeuo pipefail

BASE_URL="${1:-}"

if [[ -z "$BASE_URL" ]]; then
  echo "Usage:"
  echo "  bash scripts/validate-production.sh https://project.vercel.app"
  exit 1
fi

BASE_URL="${BASE_URL%/}"

request_code() {
  local method="$1"
  local path="$2"

  curl \
    --silent \
    --show-error \
    --location \
    --request "$method" \
    --output /dev/null \
    --write-out '%{http_code}' \
    "${BASE_URL}${path}"
}

expect_code() {
  local method="$1"
  local path="$2"
  shift 2

  local actual
  actual="$(request_code "$method" "$path")"

  for expected in "$@"; do
    if [[ "$actual" == "$expected" ]]; then
      printf 'PASS: %-5s %-34s HTTP %s\n' \
        "$method" "$path" "$actual"
      return 0
    fi
  done

  printf 'FAIL: %-5s %-34s HTTP %s, expected %s\n' \
    "$method" "$path" "$actual" "$*"
  return 1
}

echo "Validating: $BASE_URL"

public_routes=(
  /
  /home
  /catalog
  /about
  /contact_us
  /login
  /admin/dashboard
  /admin/catalog
  /admin/catalog/mutation
  /admin/orders
  /admin/analytics
)

for route in "${public_routes[@]}"; do
  expect_code GET "$route" 200
done

expect_code GET /flutter_bootstrap.js 200
expect_code GET /main.dart.js 200

expect_code GET /api/cloudinary-signature 405
expect_code GET /api/cloudinary-delete 405

expect_code POST /api/cloudinary-signature 401 403
expect_code POST /api/cloudinary-delete 401 403

echo
echo "Automated production HTTP validation passed."
echo "Continue with browser smoke testing for Firebase Auth,"
echo "Firestore CRUD, Cloudinary upload/delete, console errors,"
echo "responsive layouts, and route refresh behavior."
