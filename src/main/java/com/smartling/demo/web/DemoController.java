package com.smartling.demo.web;

import com.smartling.demo.model.Greeting;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

@Controller
public class DemoController
{
    @RequestMapping(value = "/chasopys-api/v1/greeting/{adjective}", method = GET)
    @ResponseBody
    Greeting getGreeting(@PathVariable(name = "adjective") String adjective)
    {
        return new Greeting("Hi, " + adjective + " Chasopys!");
    }
}
