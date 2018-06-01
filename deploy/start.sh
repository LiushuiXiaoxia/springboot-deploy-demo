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

nohup java -jar $jarfile -Dfile.encoding=UTF-8 --spring.config.location=$PRGDIR/ >$PRGDIR/log/start.log
pid=$(ps -ef | grep java | grep $jarfile | awk '{print $2}')
echo "INFO: $jarfile is running! pid=$pid"