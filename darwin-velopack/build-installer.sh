#!/bin/bash -x

# Build velopak installers from the pyinstaller packages.
#
# Requiremnts
#   * velopak 'vpk' command installed (via dotnet)

# Exit on any error.
set -e

VER="0.9.6"
PLATFORM="darwin-arm64"

# Make empty '_bundle' and '_build' subdirectories.
for d in _bundle _build; do
  rm -rf ./$d
  mkdir ./$d
done

TARGET="release/apio-${PLATFORM}-${VER}-velopack-installer.pkg"

# Unzip to _bundle/Apio.app directory
mkdir _bundle/Apio.app
unzip -q ../pyinstaller/release/apio-${PLATFORM}-${VER}-pyinstaller-bundle.zip  -d _bundle/Apio.app

# Show the content.
ls -al _bundle/Apio.app

# Build
vpk pack \
  -e apio \
  --packTitle "Apio ${VER}" \
  --outputDir _build \
  --packId Apio \
  --packVersion ${VER} \
  --packDir _bundle/Apio.app

cp _build/Apio-osx-Setup.pkg ${TARGET}
echo
echo "Generated ${TARGET}"

