#!/bin/bash

# Exit on any error
set -e

# Make an empty _package directory.
rm -rf _package
mkdir _package

# Make an empty _release directory.
rm -rf _release
mkdir _release

# Build the app,
clang app.c -o _package/app.bin

# Build the installer.
vpk pack \
  -e app.bin \
  --packTitle "cli" \
  --outputDir _release \
  --packId cli \
  --packVersion 0.0.1 \
  --packDir _package

