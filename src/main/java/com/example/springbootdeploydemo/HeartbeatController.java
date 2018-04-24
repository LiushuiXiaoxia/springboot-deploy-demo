package com.example.springbootdeploydemo;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * HelloWorldController <br/>
 * Created by Leon on 2018-04-24.
 */
@Slf4j
@RestController
public class HeartbeatController {

    @RequestMapping(path = "/heartbeat")
    public Object heartbeat() {
        return "success";
    }
}