#!/bin/sh


#get pwd
DIR_HOME="${BASH_SOURCE-$0}"
DIR_HOME="$(dirname "$DIR_HOME")"
PRGDIR="$(cd "${DIR_HOME}"; pwd)"


jarfile=$PRGDIR/springboot-deploy-demo-0.0.1-SNAPSHOT.jar


#get runing pid
pid=$(ps -ef | grep java | grep $jarfile | awk '{print $2}')

#create log dir
mkdir -p $PRGDIR/log/

if [ "$pid" != "" ];then
    echo "ERROR: $jarfile is running! pid=$pid. You must stop it first!"
else
    nohup java -jar $jarfile -Dfile.encoding=UTF-8 --spring.config.location=$PRGDIR/ >$PRGDIR/log/start.log 2>&1 &
    pid=$(ps -ef | grep java | grep $jarfile | awk '{print $2}')
    echo "INFO: $jarfile is running! pid=$pid"

    url="http://127.0.0.1:8081/heartbeat";
    echo $url
    while [ true ]
    do
        sleep 1
        HTTP_CODE=`curl -G -m 10 -o /dev/null -s -w %{http_code} $url`
        echo "http code: ${HTTP_CODE}"
        if [ ${HTTP_CODE} -eq 200 ]
        then
            echo "server start success..."
            exit 0
        fi
    done
fi