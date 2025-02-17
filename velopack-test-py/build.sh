#!/bin/bash

# Exit on any error
set -e

rm -rf _dist
mkdir _dist

rm -rf _work
mkdir _work

pyinstaller --distpath _dist --workpath _work app.spec

# Build the installer.
vpk pack \
  -e app \
  --packTitle "app" \
  --outputDir _release \
  --packId app \
  --packVersion 0.0.1 \
  --packDir _dist/main
