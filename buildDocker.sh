#!/usr/bin/env bash

# VERSION=`git branch | awk  '$1 == "*"{print $2}'`

VERSION=latest

echo ${VERSION}

set -e

./gradlew clean build -x test

docker build -t myspringbootdemo:${VERSION} .