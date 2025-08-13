package com.ncu.course.controller;



import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;







@RequestMapping("/course")
@RestController


public class Coursecontroller {
    @GetMapping(path="/allcourses")
    public String allCourse(@RequestParam(required = false) String param) {
        return "All courses endpoint" + (param != null ? (", param: " + param) : "");
    }
}

  /* @GetMapping(path="/course/{courseid}")
public String getCoursebyId(@RequestParam("courseid")String courseid){
    System.out.println("Welcome to the course with ID: " + courseid);
    return "Welcome to the course with ID: " + courseid;
}*/

    /*@PostMapping(path="/course")
    public String postMethodName(@RequestBody String entity) {
        System.out.println("Received course data: " + entity);
        
        return entity;
    }

    @PutMapping("path/courses/{id}")
    public String updateCourseId(@PathVariable String id, @RequestBody String entity) {
        System.out.println("Updating course with ID: " + id + " with data: " + entity);
        
        return entity;
    }

   @PatchMapping(path="/course/{courseid}")
    public String patchCourse(@PathVariable("courseid") String courseid, @RequestBody String entity) {
        System.out.println("Patching course with ID: " + courseid + " with data: " + entity);
        
        return entity;
    }
    
}*/

