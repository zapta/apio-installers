"""A script to build the apio pyinstaller package for the current platform.

Prerequisites
* Python is available.
* This apio local repo is installed as the pip apio package.
  (run 'pip install -e .' at the root of this repo.)
* The Pyinstaller package is installed ('pip install pyinstaller').

Usage:
  cd pyinstaller
  python ./build-package.py
"""

from pathlib import Path
import shutil
import os
import sys
from subprocess import CompletedProcess, run
from apio.apio_context import ApioContext, ApioContextScope
from apio.utils import util

apio_version = util.get_apio_version()

apio_ctx = ApioContext(scope=ApioContextScope.NO_PROJECT)
platform_id = apio_ctx.platform_id
print(f"\nPlatform id = [{platform_id}]")

NAME = "apio-" + platform_id.replace("_", "-") + "-" + apio_version
print(f"\nPackage name = [{NAME}]")


dist:Path = Path("_dist")
build:Path = Path("_build")
package_file:Path = Path("packages") / ("pyinstaller-" + NAME + ".zip")

if apio_ctx.is_darwin:
  OSX_BUNDLE_NAME = NAME + "-bundle"
  print(f"\nOSX bundle name = [{OSX_BUNDLE_NAME}]")
  osx_bundle_file:Path = Path("packages") / ("pyinstaller-" + OSX_BUNDLE_NAME + ".zip")

# -- Clean old build dirs.
for path in [dist, build]:
    if path.is_dir():
        print(f"Deleting old dir [{path}].")
        shutil.rmtree(path)
    else:
        print(f"Dir [{path}] does not exist.")
    assert not path.exists(), path

if package_file.exists():
    print(f"Deleting {package_file}")
    os.remove(package_file)

if apio_ctx.is_darwin and osx_bundle_file.exists():
    print(f"Deleting {osx_bundle_file}")
    os.remove(osx_bundle_file)

# apio_dir = Path(sys.modules["apio"].__file__).parent
# print(f"{apio_dir=}")

if apio_ctx.is_darwin:
  spec_file = "./apio-osx.spec"
else:
  spec_file = "./apio.spec"

# -- Run the pyinstaller
cmd = [
    "pyinstaller",
    "--distpath",
    str(dist),
    "--workpath",
    str(build),
    spec_file,
]
print(f"\nRun: {cmd}")
result: CompletedProcess = run(cmd)
assert result.returncode == 0, "Pyinstaller exited with an error code."
print("Pyinstaller completed successfully")

# -- Rename the dist/main directory.
main = dist / "main"
package = dist / NAME
print(f"\nRenaming [{str(main)}] to [{str(package)}]")
shutil.move(main, package)

# -- Add the darwin activate file.
resources = Path("resources")
if apio_ctx.is_darwin:
    print(f"\nWriting darwin activate file.")
    shutil.copyfile(resources / "darwin-activate", package / "activate")

# -- Add readme file.
print(f"\nWriting the README.txt file.")
shutil.copyfile(resources / "README.txt", package / "README.txt")

# -- Add LICENSE file.
print(f"\nWriting the LICENSE file.")
shutil.copyfile(resources / "LICENSE", package / "LICENSE")

# -- Compress the package
print("\nCompressing the package.")
package_zip_fname = shutil.make_archive(base_name = package, format= "zip", root_dir = package)

# -- Compress the osx bundle
if apio_ctx.is_darwin:
 print("Compressing the osx bundle.")
 osx_bundle_zip_fname = shutil.make_archive(base_name = dist / OSX_BUNDLE_NAME, format="zip", root_dir= dist, base_dir= "apio.app")

# -- Copy the package to packages directory
shutil.copy(package_zip_fname, package_file)
print(f"\nCreated {package_file}.")

# -- Copy the bundle to packages directory
if apio_ctx.is_darwin:
  shutil.copy(dist / (OSX_BUNDLE_NAME + ".zip"), osx_bundle_file)
  print(f"Created {osx_bundle_file}.")
