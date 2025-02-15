#!/bin/bash -x

VER="0.9.6"

# Exit on any error.
set -e

builder="/Applications/InstallBuilder Professional 24.11.1/bin/builder"

function build_platform() {
  platform_id=$1
  os=$2

  echo
  echo "***** Building ${platform_id} / ${VER} (${os})"
  echo
  sleep 1.0

  "$builder" build apio-project.xml ${os} \
      --verbose \
      --setvars project.version=${VER} VER=${VER} PLATFORM=${platform_id}
}


rm -rf packages
rm -rf _build

mkdir packages
mkdir _build

for f in ../pyinstaller/packages/apio-*${VER}*.zip; do
    echo "Unzipping: $f"
    dir_name=$(basename $f .zip)
    unzip $f -d _build/$dir_name
done

build_platform "darwin-arm64" "osx"
build_platform "windows-amd64" "windows-x64"
build_platform "linux-x86-64" "linux-x64"

cp _build/apio-${VER}-osx-installer.dmg          packages/apio-darwin-arm64-${VER}-installer.dmg
cp _build/apio-${VER}-windows-x64-installer.exe  packages/apio-windows-amd64-${VER}-installer.exe
cp _build/apio-${VER}-linux-x64-installer.run    packages/apio-linux-x86-64-${VER}-installer.run

echo
ls -l packages
