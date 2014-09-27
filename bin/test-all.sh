#!/bin/bash -xe

export PATH=$PWD/bin:$PATH
spacejam test-packages ./
export PACKAGE_DIRS=$(dirname $PWD)
cd starter-cli-app
mcli hello-world
mcli echo --stderr=true I am an stderr echo
mcli find-one --collection Todos
mcli-bundle find-one --collection Todos
