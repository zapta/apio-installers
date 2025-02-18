#!/bin/bash

# Exit on any error
set -e

rm -rf _package _dist	_work
mkdir -p _package/apio

rm -f MyAppComponent.pkg
rm -f MyAppInstaller.pkg

pushd _package/apio
unzip ../../../pyinstaller/packages/pyinstaller-apio-darwin-arm64-0.9.6-package.zip
popd

rm _package/apio/activate
rm _package/apio/README.txt

echo
# See 'man pkgbuild' for details.
pkgbuild \
  --root "_package"\
  --install-location "/Applications" \
  --identifier "io.github.fpgawars.apio" \
  --version "0.9.6" \
  --scripts Scripts \
  --ownership recommended \
  "MyAppComponent.pkg"

echo

productbuild \
  --resources ./resources \
  --distribution distribution.xml \
  --package-path MyAppComponent.pkg \
  MyAppInstaller.pkg

echo
echo "Completed OK".
