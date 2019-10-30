#!/bin/sh

# start.sh

#get pwd
DIR_HOME="${BASH_SOURCE-$0}"
DIR_HOME="$(dirname "$DIR_HOME")"
PRGDIR="$(cd "${DIR_HOME}"; pwd)"


jarfile=$PRGDIR/springboot-deploy-demo-0.0.1-SNAPSHOT.jar


#get runing pid
pid=$(ps -ef | grep java | grep $jarfile | awk '{print $2}')

#create log dir
mkdir -p $PRGDIR/log/

mkdir ../log
nohup java -jar $jarfile -Dfile.encoding=UTF-8 --spring.profiles.active=prod > $PRGDIR/../log/start.log 2>&1 &
pid=$(ps -ef | grep java | grep $jarfile | awk '{print $2}')
echo "INFO: $jarfile is running! pid=$pid"