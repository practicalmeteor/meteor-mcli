#!/bin/bash -xe

# Test the mcli package
METEOR_TEST_PACKAGES=1 & spacejam test-packages ./

# Test the mcli and mcli-bundle tools
export PATH=/usr/local/bin:$PATH:$PWD/bin
export PACKAGE_DIRS=$(dirname $PWD)
cd starter-mcli-app
mcli hello-world
mcli echo --stderr=true I am an stderr echo
mcli find-one --collection Todos
# Async command
mcli ls
mcli-bundle find-one --collection Todos
# Async command
mcli-bundle ls

# Test the install-starter-kit.sh script
cd ..
mkdir -p tmp
cd tmp
curl https://raw.githubusercontent.com/practicalmeteor/meteor-mcli/$TRAVIS_COMMIT/bin/install-starter-kit.sh | bash
if [ $(which mcli) != "/usr/local/bin/mcli" ]; then
  exit 1
fi
if [ $(which mcli-bundle) != "/usr/local/bin/mcli-bundle" ]; then
  exit 1
fi
if [ ! -d starter-mcli-app ]; then
  exit 1
fi
