#!/bin/bash

# Exit on any error
set -e

rm -rf _package _dist	_work
mkdir -p _package/apio

pushd _package/apio
unzip ../../../pyinstaller/packages/pyinstaller-apio-darwin-arm64-0.9.6-package.zip
popd

# See 'man pkgbuild' for details.
pkgbuild \
  --root "_package"\
  --install-location "/Applications" \
  --identifier "io.github.fpgawars.apio" \
  --version "0.9.6" \
  --scripts Scripts \
  --ownership recommended \
  "packages/installer-apio-darwin-arm64-0.9.6.pkg"
