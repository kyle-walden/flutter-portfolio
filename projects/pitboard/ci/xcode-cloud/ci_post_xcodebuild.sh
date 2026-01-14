#!/usr/bin/env bash
set -euo pipefail

# Adapted post-build script for Xcode Cloud (abstracted from original Pitboard)
# Purpose: collect .xcresult bundles, activity logs and other diagnostics into
# a single artifacts folder that can be uploaded or inspected.

ARTIFACT_DIR="./flutter_app/xccloud_artifacts"
mkdir -p "$ARTIFACT_DIR"

echo "Preparing artifacts directory: $ARTIFACT_DIR"

zip_xcresult() {
  local path="$1"
  local name
  name="$(basename "$path")"
  name="${name// /_}"
  local out="$ARTIFACT_DIR/${name}.zip"
  if [ -f "$out" ]; then
    echo "Already archived: $out"
    return 0
  fi
  echo "Archiving $path -> $out"
  /usr/bin/ditto -ck --sequesterRsrc --keepParent "$path" "$out" || true
}

echo "Searching repo workspace for .xcresult bundles..."
find . -maxdepth 6 -type d -name '*.xcresult' -print0 | while IFS= read -r -d '' xc; do
  zip_xcresult "$xc"
done

echo "Searching common temp locations for recent .xcresult bundles (last 1 day)..."
for base in /var/folders /private/var/folders /tmp /private/tmp; do
  if [ -d "$base" ]; then
    find "$base" -maxdepth 6 -type d -name '*.xcresult' -mtime -1 -print0 2>/dev/null | while IFS= read -r -d '' xc; do
      zip_xcresult "$xc"
    done
  fi
done

echo "Copying recent activity logs from DerivedData and workspace..."
for dd in "$HOME/Library/Developer/Xcode/DerivedData" "/Users/local/Library/Developer/Xcode/DerivedData" "/Volumes/workspace/DerivedData"; do
  if [ -d "$dd" ]; then
    find "$dd" -type f -name '*.xcactivitylog' -mtime -1 -print0 2>/dev/null | while IFS= read -r -d '' lf; do
      echo "Copying activity log: $lf"
      cp -p "$lf" "$ARTIFACT_DIR/" || true
    done
  fi
done

find . -maxdepth 8 -type f \( -name '*.xcactivitylog' -o -name '*.log' -o -name '*.txt' \) -mtime -1 -print0 | while IFS= read -r -d '' lf; do
  echo "Copying: $lf"
  cp -p "$lf" "$ARTIFACT_DIR/" || true
done

if [ -d "Pods" ]; then
  echo "Recording pods_g_matches.txt"
  grep -R --line-number -n -E '(^|[^A-Za-z0-9_-])-G([[:space:]]+[A-Za-z_][A-Za-z0-9_]*|[A-Za-z_][A-Za-z0-9_]*)' Pods || true > "$ARTIFACT_DIR/pods_g_matches.txt"
fi

echo "Artifacts prepared in $ARTIFACT_DIR"
ls -la "$ARTIFACT_DIR" || true
