package com.example.springbootdeploydemo;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * HelloWorldController <br/>
 * Created by Leon on 2018-04-24.
 */
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