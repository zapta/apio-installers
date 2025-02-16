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
package_file:Path = Path("packages") / (NAME + ".zip")

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

# apio_dir = Path(sys.modules["apio"].__file__).parent
# print(f"{apio_dir=}")

# -- Run the pyinstaller
cmd = [
    "pyinstaller",
    "--distpath",
    str(dist),
    "--workpath",
    str(build),
    "./apio.spec",
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

# -- Zip package
print("\nCompressing the package.")
zip_fname = shutil.make_archive(package, "zip", package)

# -- Copy to packages directory
shutil.copy(zip_fname, package_file)
print(f"\nCreated {package_file}.")
