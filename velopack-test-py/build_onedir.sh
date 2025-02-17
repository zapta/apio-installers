#!/bin/bash

# Exit on any error
set -e

for d in dist work release; do
  rm -rf _$d
  mkdir _$d
done

pyinstaller --distpath _dist --workpath _work app_onedir.spec

# Build the installer.
vpk pack \
  -e app \
  --packTitle "app" \
  --outputDir _release \
  --packId app \
  --packVersion 0.0.1 \
  --packDir _dist/main
