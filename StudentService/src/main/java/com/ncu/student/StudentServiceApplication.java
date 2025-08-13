package com.ncu.student;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;


@SpringBootApplication
@ComponentScan(basePackages = "com.ncu.student")
public class StudentServiceApplication 
{
    public static void main(String[] args) 
    {
        SpringApplication.run(StudentServiceApplication.class, args);
    }
}