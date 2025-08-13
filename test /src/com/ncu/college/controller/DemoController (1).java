package com.ncu.college.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/demo")
@RestController



public class DemoController {

       @GetMapping(path = "/")
    public String getAllStudents() 
    {
        System.out.println("Hello from student controller!");
        //_StudentService.getAllStudents();
        return "Hello from student controller!";
    }
    
}

