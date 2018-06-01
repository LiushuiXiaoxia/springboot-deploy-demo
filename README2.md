# Spring Boot 项目自动发布与Supervisor

---

<!-- TOC -->

- [Spring Boot 项目自动发布与Supervisor](#spring-boot-项目自动发布与supervisor)
    - [专题](#专题)
    - [简介](#简介)
    - [安装](#安装)
    - [配置](#配置)
    - [设置supervisor开机自启](#设置supervisor开机自启)
    - [源码地址](#源码地址)

<!-- /TOC -->


## 专题

[Spring Boot 项目自动发布](https://github.com/LiushuiXiaoxia/springboot-deploy-demo/blob/master/README.md)

[Spring Boot 项目自动发布与Supervisor](https://github.com/LiushuiXiaoxia/springboot-deploy-demo/blob/master/README2.md)

## 简介

前面写了一遍关于Spring Boot项目自动发布的[文章](https://www.jianshu.com/p/51459fc4560d)，[这里是Github地址](https://github.com/LiushuiXiaoxia/springboot-deploy-demo)。
还是受到不少欢迎的，有不少点赞的朋友，这次再接再厉，跟着上一篇，介绍使用Supervisor管理Spring Boot项目。

supervisor是用Python开发的一套通用的进程管理程序，能将一个普通的命令行进程变为后台daemon，并监控进程状态，异常退出时能自动重启。

什么意思呢？就是说，原先启动的Spring boot项目，正常情况下可以一直运行，但是如果程序中出现了Bug，程序会自动退出，那么服务就不可用了，可以使用用Supervisor来管理服务，当程序退出后服务可以自动重启。

## 安装

安装supervisor很简单，我这边使用的是ubuntu，直接用`apt-get`安装即可，命令是`sudo apt-get install supervisor`。

```bash
sudo apt-get install supervisor
正在读取软件包列表... 完成
正在分析软件包的依赖关系树
正在读取状态信息... 完成
建议安装：
  supervisor-doc
下列【新】软件包将被安装：
  supervisor
升级了 0 个软件包，新安装了 1 个软件包，要卸载 0 个软件包，有 0 个软件包未被升级。
需要下载 253 kB 的归档。
解压缩后会消耗 1,401 kB 的额外空间。
获取:1 http://mirrors.aliyun.com/ubuntu xenial-updates/universe amd64 supervisor all 3.2.0-2ubuntu0.2 [253 kB]
已下载 253 kB，耗时 0秒 (508 kB/s)
正在选中未选择的软件包 supervisor。
(正在读取数据库 ... 系统当前共安装有 229783 个文件和目录。)
正准备解包 .../supervisor_3.2.0-2ubuntu0.2_all.deb  ...
正在解包 supervisor (3.2.0-2ubuntu0.2) ...
正在处理用于 man-db (2.7.5-1) 的触发器 ...
正在处理用于 systemd (229-4ubuntu21.2) 的触发器 ...
正在处理用于 ureadahead (0.100.0-19) 的触发器 ...
正在设置 supervisor (3.2.0-2ubuntu0.2) ...
```

安装成功后可以在 `/etc/supervisor/` 目录下找到`supervisord.conf`配置文件，用`vi`命令来编辑。

```bash
# xiaqiulei @ ubuntu in /etc/supervisor [15:08:39]
$ cd /etc/supervisor/

# xiaqiulei @ ubuntu in /etc/supervisor [15:08:46]
$ cat supervisord.conf
; supervisor config file

[unix_http_server]
file=/var/run/supervisor.sock   ; (the path to the socket file)
chmod=0700                       ; sockef file mode (default 0700)

[supervisord]
logfile=/var/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
childlogdir=/var/log/supervisor            ; ('AUTO' child log dir, default $TEMP)

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock ; use a unix:// URL  for a unix socket

; The [include] section can just contain the "files" setting.  This
; setting can list multiple files (separated by whitespace or
; newlines).  It can also contain wildcards.  The filenames are
; interpreted as relative to this file.  Included files *cannot*
; include files themselves.

[include]
files = /etc/supervisor/conf.d/*.conf
```

## 配置

在`supervisord.conf`这个文件的最后加上以下内容

```bash
[program:you program name] # 你的程序名，随便命名
command=python /home/pi/test.py # 你的命令，可以是任何运行在终端的命令
autostart=true # 自动启动
autorestart=true
user=root
log_stderr=true
logfile=/var/log/testpy.log # 日志文件的地址
```

在前面，是使用`start.sh`来启动程序，现在也只需要在supervisor中配置执行这个文件即可。

```bash
# xiaqiulei @ ubuntu in ~/deploy [15:18:35]
$ ls
application-prod.properties  application.properties  log  logback-spring.xml  restart.sh  springboot-deploy-demo-0.0.1-SNAPSHOT.jar  start.sh  stop.sh

# xiaqiulei @ ubuntu in ~/deploy [15:18:36]
$ ls -al
总用量 15764
drwxrwxr-x  3 xiaqiulei xiaqiulei     4096 4月  24 22:24 .
drwxr-xr-x 34 xiaqiulei xiaqiulei     4096 6月   1 15:18 ..
-rw-r--r--  1 xiaqiulei xiaqiulei       63 6月   1 15:17 application-prod.properties
-rw-r--r--  1 xiaqiulei xiaqiulei       27 6月   1 15:17 application.properties
drwxrwxr-x  2 xiaqiulei xiaqiulei     4096 6月   1 15:16 log
-rw-r--r--  1 xiaqiulei xiaqiulei      881 6月   1 15:17 logback-spring.xml
-rwxr-xr-x  1 xiaqiulei xiaqiulei       32 6月   1 15:17 restart.sh
-rw-r--r--  1 xiaqiulei xiaqiulei 16103697 6月   1 15:17 springboot-deploy-demo-0.0.1-SNAPSHOT.jar
-rwxr--r--  1 xiaqiulei xiaqiulei      970 6月   1 15:17 start.sh
-rwxr-xr-x  1 xiaqiulei xiaqiulei      291 6月   1 15:17 stop.sh

# xiaqiulei @ ubuntu in ~/deploy [15:18:39]
$ ./start.sh
INFO: /home/xiaqiulei/deploy/springboot-deploy-demo-0.0.1-SNAPSHOT.jar is running! pid=114791
http://127.0.0.1:8088/heartbeat
http code: 000
http code: 000
http code: 000
http code: 000
http code: 200
server start success...
```

需要先修改下`start.sh`文件，然后在修改下supervisor配置。因为原先的`start.sh`启动方式会将java程序作为一个后台进程。
主要语句是去除 `2>&1 &`，原先的校验功能也需要去除。如果此功能是必要的，可单独写成一个文件。

```bash
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
```

单独的校验文件。

```bash
#!/usr/bin/env bash

# validate.sh

url="http://127.0.0.1:8088/heartbeat";
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
```

完成脚本的修改操作后，就可以修改supervisor的配置。 

```bash
[program:spring_boot_demo]
user = xiaqiulei
directory = /home/xiaqiulei/deploy
command = bash -c ./start.sh
autostart = true
autorestart =  true
```

然后重新加载配置，最后开启服务即可。

```bash
$ sudo supervisorctl status

$ sudo supervisorctl reload
Restarted supervisord

$ sudo supervisorctl status
spring_boot_demo                 STOPPED   Jun 01 04:25 PM

$ sudo supervisorctl start spring_boot_demo
spring_boot_demo: started

$ sudo supervisorctl status
spring_boot_demo                 RUNNING   pid 119403, uptime 0:00:10
```

可以测试下，当程序退出的时候，服务会自动重启，如下所示，kill掉当前的进程，然后在看下状态，服务还在，并且pid是和原先不一样的。

```bash
$ sudo supervisorctl status
spring_boot_demo                 RUNNING   pid 119607, uptime 0:03:16

$ sudo supervisorctl

$ kill -9 119607

$ sudo supervisorctl status
spring_boot_demo                 RUNNING   pid 119807, uptime 0:00:02
```

可以使用校验文件，检查下服务。

```bash
$ ./validate.sh
http://127.0.0.1:8088/heartbeat
http code: 200
server start success...
```

## 设置supervisor开机自启

编辑`/etc/rc.local`文件 ，让 `supervisor` 开机启动，这样就可以使脚本在开机的时候随supervisor启动运行。
在这个配置文件的`exit 0`前面一行加上 `service supervisor start`保存。

## 源码地址


[源码地址 https://github.com/LiushuiXiaoxia/springboot-deploy-demo](https://github.com/LiushuiXiaoxia/springboot-deploy-demo)

[Spring Boot 项目自动发布与Supervisor](https://github.com/LiushuiXiaoxia/springboot-deploy-demo/blob/master/README2.md)