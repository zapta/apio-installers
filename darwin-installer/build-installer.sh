#!/bin/bash

VER=0.9.6

installer_file="release/apio-darwin-arm64-${VER}-installer.pkg"
component_file="_work/apio-component.pkg"

# Exit on any error
set -e

rm -rf _package _dist	_work
mkdir -p _package/Apio
mkdir _work

rm -f ${installer_file}

pushd _package/Apio
unzip ../../../pyinstaller/release/pyinstaller-apio-darwin-arm64-0.9.6-package.zip
popd

rm _package/Apio/activate
rm _package/Apio/README.txt

echo
# See 'man pkgbuild' for details.
pkgbuild \
  --root "_package"\
  --install-location "/Applications" \
  --identifier "io.github.fpgawars.apio" \
  --version "0.9.6" \
  --scripts Scripts \
  --ownership recommended \
  "${component_file}"

echo

productbuild \
  --resources ./resources \
  --distribution distribution.xml \
  --package-path _work \
  "${installer_file}"

echo
echo "Generated ${installer_file}"
echo "Completed OK".
