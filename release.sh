#!/usr/bin/env bash
# RezTink release helper - run from Git Bash inside your local clone of the public RezTink repo.
# (publish.sh in RezTink-Source runs it for you after building; it keeps this copy up to date.)
#
#   ./release.sh 0.0.24 "/c/path/to/RezTink-0.0.24.dll" "What changed in this build"
#
# The release asset is named after the build (RezTink-0.0.24.dll), and players' copies install it
# under that name.
# Build ids: RezTink-0.0.24, RezTink-0.0.25, ... (the updater compares the version numerically and
# never downgrades).
#
# What it does:
#   1. computes the SHA-256 of the DLL
#   2. creates the GitHub release (tag = build id) with the DLL attached
#   3. rewrites the manifest latest.txt
#   4. commits and pushes the manifest to main
#
# One-time setup (see README): install GitHub CLI (winget install GitHub.cli), run `gh auth login`,
# and `git clone https://github.com/ResistanceLab/RezTink.git`.

set -euo pipefail

NUM="${1:-}"; DLL="${2:-}"; NOTES="${3:-}"
REPO="ResistanceLab/RezTink"

usage() { echo "usage: $0 <version e.g. 0.0.24> <path-to-dll> [notes]"; exit 1; }
[[ -z "$NUM" || -z "$DLL" ]] && usage
[[ "$NUM" =~ ^[0-9]+(\.[0-9]+)*$ ]] || usage
[[ -f "$DLL" ]] || { echo "DLL not found: $DLL"; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Run this from inside your RezTink git clone."; exit 1; }
command -v gh >/dev/null || { echo "GitHub CLI (gh) not found. Install: winget install GitHub.cli, then: gh auth login"; exit 1; }

BUILD="RezTink-$NUM"; MANIFEST="latest.txt"; TITLE="RezTink $NUM"
[[ -z "$NOTES" ]] && NOTES="$TITLE"

# Sanity: the DLL must have been built with this version (AssemblyInformationalVersion is stored as UTF-8).
if ! LC_ALL=C grep -aqF "$NUM" "$DLL"; then
  echo "'$NUM' not found inside $DLL - was it built with that version?"; exit 1
fi
[[ "$(head -c2 "$DLL")" == "MZ" ]] || { echo "$DLL isn't a DLL."; exit 1; }

if gh release view "$BUILD" --repo "$REPO" >/dev/null 2>&1; then
  echo "Release $BUILD already exists. Bump the version and build again."; exit 1
fi

SHA=$(sha256sum "$DLL" | cut -d' ' -f1)
ASSET="$BUILD.dll"
URL="https://github.com/$REPO/releases/download/$BUILD/$ASSET"

echo "== Build:    $BUILD"
echo "== Manifest: $MANIFEST"
echo "== SHA-256:  $SHA"
echo "== Notes:"
printf '%s\n' "$NOTES" | sed 's/^/     /'

# Publish under the exact asset name the manifest points at.
TMPDIR_=$(mktemp -d); cp "$DLL" "$TMPDIR_/$ASSET"

git checkout -q main
git pull -q --ff-only

echo "== Creating GitHub release $BUILD ..."
gh release create "$BUILD" "$TMPDIR_/$ASSET" --repo "$REPO" --title "$TITLE" --notes "$NOTES"
rm -rf "$TMPDIR_"

echo "== Updating $MANIFEST ..."
{
  printf '%s\r\n%s\r\n%s\r\n' "$BUILD" "$URL" "$SHA"
  printf '%s\n' "$NOTES" | head -6 | sed 's/$/\r/'
} > "$MANIFEST"
git add "$MANIFEST"
git commit -q -m "$BUILD: update $MANIFEST"
git push -q origin main

echo
echo "Done. $BUILD is live."
echo "Manifest: https://raw.githubusercontent.com/$REPO/main/$MANIFEST  (raw cache may lag ~1-2 min)"
