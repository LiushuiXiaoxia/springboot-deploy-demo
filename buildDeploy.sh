#!/usr/bin/env bash

rm deploy/*.jar
./gradlew clean build && ./gradlew --stop && cp build/libs/* deploy/