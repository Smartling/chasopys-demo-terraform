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
    @RequestMapping(value = "/chasopys-api/v1/greeting/{text}", method = GET)
    @ResponseBody
    Greeting getGreeting(@PathVariable(name = "text") String text)
    {
        return new Greeting("Hi, people! Your message is: " + text);
    }
}
