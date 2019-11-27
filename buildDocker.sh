#!/usr/bin/env bash

#VERSION=`git branch | awk  '$1 == "*"{print $2}'`
#
#VERSION=latest
#
#echo ${VERSION}
#
#./gradlew clean assemble && docker build -t myspringbootdemo:${VERSION} .
#
#docker tag myspringbootdemo:latest 127.0.0.1/library/myspringbootdemo:${VERSION}
#
#docker push 127.0.0.1/library/myspringbootdemo:${VERSION}

echo 'docker ps'
docker -H tcp://10.211.55.6:2375 ps
sleep 2

echo 'docker stop'
docker -H tcp://10.211.55.6:2375 stop myspringbootdemo
sleep 10

echo 'docker rmi'
docker -H tcp://10.211.55.6:2375 rmi 192.168.237.23/library/myspringbootdemo -f
sleep 2

echo 'docker pull'
docker -H tcp://10.211.55.6:2375 pull 192.168.237.23/library/myspringbootdemo:latest
sleep 15

echo 'docker run'
docker -H tcp://10.211.55.6:2375 run -d -p 9090:9090 --name myspringbootdemo 192.168.237.23/library/myspringbootdemo
sleep 2

echo 'docker ps'
docker -H tcp://10.211.55.6:2375 ps