#!/bin/bash

# Exit on any error
set -e

for d in dist work release; do
  rm -rf _$d
  mkdir _$d
done

pyinstaller --distpath _dist --workpath _work app_bundle.spec

# Build the installer.
#vpk pack \
#  -e app \
#  --packTitle "app" \
#  --outputDir _release \
#  --packId app \
#  --packVersion 0.0.1 \
#  --packDir _dist/main

create-dmg \
  --volname "MyApp Installer" \
  --window-pos 200 120 \
  --window-size 500 300 \
  --icon-size 100 \
  --icon "MyApp.app" 125 150 \
  --hide-extension "MyApp.app" \
  --app-drop-link 375 150 \
  "_release/my-app.dmg" "_dist/app.app/"
