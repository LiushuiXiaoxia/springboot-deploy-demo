#!/usr/bin/env bash

rm deploy/*.jar
./gradlew clean assemble && cp build/libs/* deploy/