#!/bin/bash

# Exit on any error
set -e

for d in _package; do
  rm -rf ./$d
  mkdir ./$d
done

mkdir _package/apio
pushd _package/apio
unzip ../../../pyinstaller/packages/pyinstaller-apio-darwin-arm64-0.9.6-package.zip
popd

pkgbuild \
  --root "_package"\
  --install-location "/Applications" \
  --identifier "com.example.myapp" \
  --version "0.9.6" \
  --scripts scripts \
  --ownership recommended \
  "packages/installer-apio-darwin-arm64-0.9.6.pkg"
