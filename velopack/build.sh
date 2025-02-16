#!/bin/bash

# Exit on any error.
set -e

VER="0.9.6"
PLATFORM="darwin-arm64"

# Make empty '_work' and '_build' subdirectories.
for d in _work _build; do
  rm -rf $d
  mkdir $d
done

TARGET="packages/vpk-apio-${PLATFORM}-${VER}-installer.pkg"

# Unzip to _work directory
unzip -q ../pyinstaller/packages/apio-${PLATFORM}-${VER}.zip  -d _work

# Show the content.
ls -al _work

# Build
vpk pack \
  -e apio \
  --packTitle "Apio ${VER}" \
  --outputDir _build \
  --packId apio \
  --packVersion ${VER} \
  --packDir _work

cp _build/apio-osx-Setup.pkg ${TARGET}
echo
echo "Generated ${TARGET}"

