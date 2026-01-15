#!/usr/bin/env bash
set -euo pipefail

echo "Starting Firebase emulator (functions + firestore)..."
firebase emulators:start --only functions,firestore
