package com.ncu.college;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;


@SpringBootApplication
@ComponentScan(basePackages = "com.ncu.college")
public class DemoServiceApplication 
{
    public static void main(String[] args) 
    {
        SpringApplication.run(DemoServiceApplication.class, args);
    }
}
