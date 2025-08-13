package com.ncu.student.controller;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PathVariable;

@RequestMapping("/students")
@RestController
public class StudentController{

    @GetMapping("/")
    public String getAllStudents(){
        System.out.println("hello fro student controller");
        return "Hello from student Controller";
    }

        @GetMapping(path = "/student/{studentname}")
    public String getStudentByName(@PathVariable("studentname") String studentname) 
    {
        System.out.println("Hi!! " + "welcome " + studentname + " to the course!");
        //_StudentService.getStudentByName(studentname);
        return "Hi!! " + "welcome " + studentname + " to the course!";
    }

        /*
     * http://localhost:9002/students/student?studentname=NaveenS
     */
    @GetMapping(path = "/student")
    public String getStudentByNameFromRequest(@RequestParam("studentname") String studentname)
    {
        System.out.println("Hi!! " + "welcome " + studentname + " to the course!");
        //_StudentService.getStudentByNameFromRequest(studentname);
        return "Hi!! " + "welcome " + studentname + " to the course!";
    }
}