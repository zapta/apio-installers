#!/bin/bash

# Builds a pyinstaller package for the current platform.
#
# Requirements:
#   1. Apio installed using 'pip install -e .'
#   2. Pyinstaller installed using 'pip install pyinstaller'. 

cd pyinstaller

python3 build-packge.py

