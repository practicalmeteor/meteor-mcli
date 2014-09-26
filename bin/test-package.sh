#!/bin/bash -e

export PATH=$PWD/bin:$PATH
spacejam test-packages ./
mcli hello-world
mcli echo --stderr=true I am an stderr echo
mcli find-one --collection Todos
mcli-bundle find-one --collection Todos
