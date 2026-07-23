#!/usr/bin/env bash

set -euo pipefail

if ! command -v scoop >/dev/null; then
    echo "Scoop is required."
    exit 1
fi

if ! command -v gh >/dev/null; then
    scoop install gh
fi

if ! command -v 7z >/dev/null; then
    scoop install 7zip
fi

if ! command -v pipx >/dev/null; then
    scoop install pipx
    pipx ensurepath
fi

# Authenticate if you haven't already:
#   gh auth login

scoop install mpv

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Downloading latest mpv-dev build..."

ASSET_NAME="$(
    gh release view \
        --repo shinchiro/mpv-winbuild-cmake \
        --json assets \
        --jq '
    .assets[]
    | select(
        (.name | startswith("mpv-dev-x86_64-"))
        and (.name | endswith(".7z"))
        and (.name | contains("-v3-") | not)
      )
    | .name
  '
)"

echo "$ASSET_NAME"

gh release download \
    --repo shinchiro/mpv-winbuild-cmake \
    --pattern "$ASSET_NAME" \
    --dir "$TMP_DIR" \
    --clobber

MPV_DIR="$USERPROFILE/scoop/apps/mpv/current"

7z e "$TMP_DIR/$ASSET_NAME" \
    -o"$MPV_DIR" \
    libmpv-2.dll \
    -y >/dev/null

echo
echo "✓ Installed libmpv-2.dll"
echo "Location: $MPV_DIR/libmpv-2.dll"

pipx install ytm-player
