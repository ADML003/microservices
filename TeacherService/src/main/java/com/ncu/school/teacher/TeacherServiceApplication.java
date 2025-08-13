package com.ncu.school.teacher;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;


@SpringBootApplication
@ComponentScan
(basePackages = "com.ncu.school.teacher")
public class TeacherServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(TeacherServiceApplication.class, args);
    }
}
