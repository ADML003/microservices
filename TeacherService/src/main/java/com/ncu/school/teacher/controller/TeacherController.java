package com.ncu.school.teacher.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;


@RequestMapping("/teachers")
@RestController
public class TeacherController{
@GetMapping("/getTeacher")
public String getTeachers() {
    System.out.println("hello I am the teacher");
    return "hello I am the teacher";
}

@GetMapping("/getTeacher/{teacherName}")
public String getTeacherByName(@PathVariable ("teacherName") String teacherName){
    System.out.println("hello from  " + teacherName);
    return("hello from " + teacherName);
}


@GetMapping("/teacher")
public String getTeacher(@RequestParam ("teacherName") String teacherName){
    System.out.println("hello from  " + teacherName);
    return("hello from " + teacherName);
}
}

