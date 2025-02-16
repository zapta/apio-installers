# Apio Installers (Experimental)

This repo contains experimental installers for the apio tool (https://github.com/FPGAwars/apio) project. It was created 
by one of apio's contributers but at this stage is experimental and non official.

The license terms of apio applies also to this repository.

Building the installers:

1. Build and check in the pyinstall installer. This must be done on each of the paltforms
with the apio repository installed as the apio packages (run 'pip install -e .' at the apio 
repo roo). To run the installer run 'python build.py' in the pyinstaller directory.

2. Build the InstallBuilder installers by running 'build.sh' in the install-builder directory.
This build uses the pyinstaller files from pyinstaller/packages.

