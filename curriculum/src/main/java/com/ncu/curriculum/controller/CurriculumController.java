package com.ncu.curriculum.controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/curriculum")
public class CurriculumController {

    @GetMapping("/all")
    public String getAllCurriculums() {
        System.out.println("Hello from curriculum controller!");
        return "Hello from curriculum controller!";
    }
}