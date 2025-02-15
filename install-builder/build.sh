#!/bin/bash

VER="0.9.6"
PLATFORM="darwin-arm64"

rm -rf output/apio-*${VER}-*.app
rm -rf output/apio-*${VER}-*.dmg

builder="/Applications/InstallBuilder Professional 24.11.1/bin/builder"

"$builder" build apio-project.xml osx \
   --verbose \
   --setvars project.version=${VER} VER=${VER} PLATFORM=${PLATFORM}

rm -rf output/apio-*.app

# apio-0.9.6-osx-installer.dmg
mv output/apio-${VER}-*.dmg output/apio-${PLATFORM}-${VER}-installer.dmg

ls -l output
