#!/bin/bash

rm -rf output/apio-*-osx-installer.app
rm -rf output/apio-*-osx-installer.dmg

builder="/Applications/InstallBuilder Professional 24.11.1/bin/builder"

"$builder" build apio-project.xml osx

rm -rf output/apio-*-osx-installer.app

ls -al output
