package com.smartling.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;

/**
 * Application entry point.
 */
@SpringBootApplication
public class ChasopysDemoServiceApp extends SpringBootServletInitializer
{
    /**
     * Initializes this application when running as a standalone application.
     *
     * @param args program arguments
     */
    public static void main(String[] args)
    {
        SpringApplication.run(ChasopysDemoServiceApp.class, args);
    }

    /**
     * Initializes this application when running in a servlet container (e.g. Tomcat)
     *
     * @param application the <code>SpringApplicationBuilder</code> for this application
     */
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application)
    {
        return application.sources(ChasopysDemoServiceApp.class);
    }

}
