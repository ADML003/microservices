package com.ncu.college.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ncu.college.model.Course;
import com.ncu.college.repository.CourseRepository;

@RestController
@RequestMapping("/courses")
public class CourseController {
    
    @Autowired
    private CourseRepository courseRepository;
    
    // Get all courses
    @GetMapping
    public ResponseEntity<List<Course>> getAllCourses() {
        try {
            List<Course> courses = courseRepository.findAll();
            return ResponseEntity.ok(courses);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Get course by ID
    @GetMapping("/{courseId}")
    public ResponseEntity<Course> getCourseById(@PathVariable Long courseId) {
        try {
            Optional<Course> course = courseRepository.findById(courseId);
            return course.map(ResponseEntity::ok)
                        .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Create new course
    @PostMapping
    public ResponseEntity<Course> createCourse(@RequestBody Course course) {
        try {
            // Validate input
            if (course.getName() == null || course.getName().trim().isEmpty()) {
                return ResponseEntity.badRequest().build();
            }
            if (course.getCredits() == null || course.getCredits() <= 0) {
                return ResponseEntity.badRequest().build();
            }
            
            course.setCourseId(null); // Ensure it's a new course
            Course savedCourse = courseRepository.save(course);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedCourse);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Update course
    @PutMapping("/{courseId}")
    public ResponseEntity<Course> updateCourse(@PathVariable Long courseId, @RequestBody Course course) {
        try {
            if (!courseRepository.existsById(courseId)) {
                return ResponseEntity.notFound().build();
            }
            
            // Validate input
            if (course.getName() == null || course.getName().trim().isEmpty()) {
                return ResponseEntity.badRequest().build();
            }
            if (course.getCredits() == null || course.getCredits() <= 0) {
                return ResponseEntity.badRequest().build();
            }
            
            course.setCourseId(courseId);
            Course updatedCourse = courseRepository.save(course);
            return ResponseEntity.ok(updatedCourse);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Delete course
    @DeleteMapping("/{courseId}")
    public ResponseEntity<Void> deleteCourse(@PathVariable Long courseId) {
        try {
            if (!courseRepository.existsById(courseId)) {
                return ResponseEntity.notFound().build();
            }
            
            courseRepository.deleteById(courseId);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
