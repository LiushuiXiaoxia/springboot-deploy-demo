#!/usr/bin/env bash

url="http://127.0.0.1:9090/heartbeat";
echo ${url}

for ((i=1; i<=120; i ++))
do
    sleep 1
    HTTP_CODE=`curl -G -m 10 -o /dev/null -s -w %{http_code} ${url}`
    echo "No.$i --> http code: ${HTTP_CODE}"
    if [[ ${HTTP_CODE} -eq 200 ]]
    then
        echo "server start success..."
        exit 0
    fi
done