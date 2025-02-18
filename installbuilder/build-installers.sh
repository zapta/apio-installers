#!/bin/bash -x

# Build installers for the pyinstaller's packages.
#
# Usage:
#   cd install-builder
#   ./build-installers.sh
  
VER="0.9.6"

# Exit on any error.
set -e

builder="/Applications/InstallBuilder Professional 24.11.1/bin/builder"

function build_platform() {
  platform_id=$1
  os=$2
  ext=$3

  echo
  echo "***** Building ${platform_id} / ${VER} (${os})"
  echo
  sleep 1.0

  rm -rf _package _build
  mkdir _package
  mkdir _build

  

  unzip ../pyinstaller/release/apio-${platform_id}-${VER}-pyinstaller-package.zip -d _package

  rm -f _package/README.txt
  rm -f package/activate

  "$builder" build apio-project.xml ${os} \
      --verbose \
      --setvars project.version=${VER} 

  cp _build/apio-${VER}-${os}-installer.${ext} release/apio-${platform_id}-${VER}-installbuilder-installer.${ext}

}

rm -rf release
mkdir release


build_platform "darwin-arm64" "osx" "dmg"
build_platform "windows-amd64" "windows-x64" "exe"
build_platform "linux-x86-64" "linux-x64" "run"

echo
ls -l release
