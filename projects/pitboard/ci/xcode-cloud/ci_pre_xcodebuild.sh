#!/usr/bin/env bash
set -euo pipefail

# Adapted pre-build script for Xcode Cloud (abstracted from original Pitboard)
# Purpose: prepare the environment, install Flutter and CocoaPods, and run
# flutter pub get. This script is safe for inclusion in the showcase repo —
# secrets, certificates, and provisioning are intentionally NOT included.

VERBOSE_LOGS="${VERBOSE_LOGS:-0}"
if [ "$VERBOSE_LOGS" -ne 0 ]; then
  echo "Verbose logging enabled"
  set -x
  FLUTTER_VERBOSITY="-v"
  POD_VERBOSITY="--verbose"
else
  FLUTTER_VERBOSITY=""
  POD_VERBOSITY=""
fi

FLUTTER_VERSION_TAG="stable"

# Determine workspace root
if [ -z "${XCODE_CLOUD_SOURCE_DIR:-}" ]; then
  if git_root=$(git rev-parse --show-toplevel 2>/dev/null); then
    XCODE_CLOUD_SOURCE_DIR="$git_root"
  else
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
    XCODE_CLOUD_SOURCE_DIR="$script_dir"
  fi
fi
cd "$XCODE_CLOUD_SOURCE_DIR" || exit 1

# Install or reuse Flutter in $HOME/flutter
FLUTTER_ROOT="$HOME/flutter"
if [ ! -d "$FLUTTER_ROOT" ]; then
  git clone --depth 1 -b $FLUTTER_VERSION_TAG https://github.com/flutter/flutter.git "$FLUTTER_ROOT"
fi
export PATH="$FLUTTER_ROOT/bin:$PATH"

# Ensure correct flutter version
cd "$FLUTTER_ROOT" || true
git fetch --depth=1 origin "refs/heads/stable:refs/remotes/origin/stable" || true
git checkout "$FLUTTER_VERSION_TAG" || true
cd - || true

# Basic info
flutter --version || true

# Prepare the Flutter project
cd "$XCODE_CLOUD_SOURCE_DIR/flutter_app"
flutter pub get

# Ensure CocoaPods (install if missing)
cd ios || true
if ! command -v pod >/dev/null 2>&1; then
  echo "cocoapods not found; attempting to install via gem (user install)"
  gem install --user-install cocoapods || true
fi

# Run pod install with retries
attempts=0
max_attempts=3
until [ $attempts -ge $max_attempts ]
 do
  if pod install ${POD_VERBOSITY} --repo-update; then
    break
  fi
  attempts=$((attempts+1))
  echo "pod install failed; attempt $attempts/$max_attempts"
  sleep 3
 done

cd "$XCODE_CLOUD_SOURCE_DIR"

echo "Pre-build setup complete"
