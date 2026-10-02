#!/usr/bin/env bash
#
# Sync the generated privacy policy out of the chore-pg release-profile compiler.
#
# privacy.html in this repo is a BUILD ARTIFACT, not a source file. The source of
# truth is scripts/release-profile.mjs in the app repo, which composes the page
# from the selected release profile's feature flags. Hand-editing privacy.html
# here guarantees drift between the page you publish and the build you ship.
#
# The one transform applied: the generated page references the wordmark as
# "/assets/brand/..." (absolute, correct for the app's own web root). GitHub
# Pages serves this repo from a subpath, where an absolute path resolves to the
# user root and 404s. We rewrite it to a relative path.
#
# Usage:  ./sync-privacy.sh [profile] [path-to-chore-pg]

set -euo pipefail

PROFILE="${1:-standalone-store}"
APP_REPO="${2:-../chore-pg}"
HERE="$(cd "$(dirname "$0")" && pwd)"

SRC="$APP_REPO/release/generated/$PROFILE/privacy.html"

if [[ ! -f "$SRC" ]]; then
  echo "error: $SRC not found." >&2
  echo "       Generate it first, from the app repo:" >&2
  echo "       node scripts/release-profile.mjs apply $PROFILE" >&2
  exit 1
fi

# Absolute -> relative asset path, so the logo resolves under the Pages subpath.
sed 's#src="/assets/brand/#src="assets/brand/#g' "$SRC" > "$HERE/privacy.html"

# Keep the referenced asset in step with the app's brand output.
cp "$APP_REPO/public/assets/brand/chore-pg-wordmark.png" "$HERE/assets/brand/"

echo "Synced privacy.html from profile: $PROFILE"
grep -o 'Effective date:[^<]*' "$HERE/privacy.html" || true

if grep -q 'REPLACE-ME@example.com' "$HERE"/*.html; then
  echo
  echo "WARNING: the support email placeholder is still present in this repo." >&2
  echo "         Replace REPLACE-ME@example.com before enabling GitHub Pages." >&2
fi
