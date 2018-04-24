# Spring Boot 项目发布

---


## 简介

在公司从移动端转后端已经快一年了，使用的技术框架一直是Spring Boot，和以前大学时候基于Tomcat的不太一样。

这篇文章简单介绍下如何发布Spring Boot 项目，原先使用Tomcat时候，发布的文件是war文件，现在使用Spring Boot就变得很简单了，直接是一个jar文件，启动方式按照启动jar文件方式即可。


## 准备工作

使用Idea创建一个带Spring Boot的项目，使用gradle管理项目。

使用gradle依赖很简单，同时创建两个Controller，一个用户表示线上api接口，一个表示心跳接口，用于测试。

```groovy
dependencies {
    compileOnly('org.projectlombok:lombok')

    compile('org.springframework.boot:spring-boot-starter-web')

    testCompile('org.springframework.boot:spring-boot-starter-test')
}
```

```java
@Slf4j
@RestController
public class HelloWorldController {

    @Value("${app.env}")
    String env;

    @RequestMapping(path = "/hello", method = RequestMethod.GET)
    public Object hello() {
        log.info("hello>>>");

        Map<String, Object> map = new HashMap<>();
        map.put("hello", "world");
        map.put("env", env);

        log.info("map = " + map);
        return map;
    }
}
```

```java
@Slf4j
@RestController
public class HeartbeatController {

    @RequestMapping(path = "/heartbeat")
    public Object heartbeat() {
        return "success";
    }
}
```

同时配置好对应的配置文件，我这又三个配置文件，一个dev环境，一个表示prod环境，还有一个表示开关。