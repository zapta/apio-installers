#!/bin/bash

# Make an empty 'work' subdirectory.
rm -rf work
mkdir work

# Unzip to work directory
unzip -q apio-darwin-arm64-0.9.6.zip  -d work

# Show the content.
ls -al work

# Build
vpk pack -e apio --packId apio --packVersion 0.0.1 --packDir work


