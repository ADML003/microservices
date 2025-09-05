package com.ncu.enrollment.controller;

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

import com.ncu.enrollment.dto.EnrollmentDto;
import com.ncu.enrollment.model.Enrollment;
import com.ncu.enrollment.service.IEnrollmentService;

@RestController
@RequestMapping("/enrollments")
public class EnrollmentController {
    
    @Autowired
    private IEnrollmentService enrollmentService;
    
    // Get all enrollments
    @GetMapping
    public ResponseEntity<List<Enrollment>> getAllEnrollments() {
        try {
            List<Enrollment> enrollments = enrollmentService.getAllEnrollments();
            return ResponseEntity.ok(enrollments);
        } catch (Exception e) {
            System.err.println("Error fetching enrollments: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Get enrollment by ID
    @GetMapping("/{enrollmentId}")
    public ResponseEntity<Enrollment> getEnrollmentById(@PathVariable Long enrollmentId) {
        try {
            Optional<Enrollment> enrollment = enrollmentService.getEnrollmentById(enrollmentId);
            return enrollment.map(ResponseEntity::ok)
                           .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            System.err.println("Error fetching enrollment by ID: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Create new enrollment
    @PostMapping
    public ResponseEntity<Enrollment> createEnrollment(@RequestBody EnrollmentDto enrollmentDto) {
        try {
            Enrollment savedEnrollment = enrollmentService.createEnrollment(enrollmentDto);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedEnrollment);
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error: " + e.getMessage());
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            System.err.println("Error creating enrollment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Update enrollment
    @PutMapping("/{enrollmentId}")
    public ResponseEntity<Enrollment> updateEnrollment(@PathVariable Long enrollmentId, @RequestBody EnrollmentDto enrollmentDto) {
        try {
            Enrollment updatedEnrollment = enrollmentService.updateEnrollment(enrollmentId, enrollmentDto);
            return ResponseEntity.ok(updatedEnrollment);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            System.err.println("Error updating enrollment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Delete enrollment
    @DeleteMapping("/{enrollmentId}")
    public ResponseEntity<Void> deleteEnrollment(@PathVariable Long enrollmentId) {
        try {
            enrollmentService.deleteEnrollment(enrollmentId);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            System.err.println("Error deleting enrollment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Get enrollments by course ID
    @GetMapping("/course/{courseId}")
    public ResponseEntity<List<Enrollment>> getEnrollmentsByCourse(@PathVariable Long courseId) {
        try {
            List<Enrollment> enrollments = enrollmentService.getEnrollmentsByCourseId(courseId);
            return ResponseEntity.ok(enrollments);
        } catch (Exception e) {
            System.err.println("Error fetching enrollments by course: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Get enrollments by student ID
    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<Enrollment>> getEnrollmentsByStudent(@PathVariable Long studentId) {
        try {
            List<Enrollment> enrollments = enrollmentService.getEnrollmentsByStudentId(studentId);
            return ResponseEntity.ok(enrollments);
        } catch (Exception e) {
            System.err.println("Error fetching enrollments by student: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Get enrollments by teacher ID
    @GetMapping("/teacher/{teacherId}")
    public ResponseEntity<List<Enrollment>> getEnrollmentsByTeacher(@PathVariable Long teacherId) {
        try {
            List<Enrollment> enrollments = enrollmentService.getEnrollmentsByTeacherId(teacherId);
            return ResponseEntity.ok(enrollments);
        } catch (Exception e) {
            System.err.println("Error fetching enrollments by teacher: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Health check endpoint
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("Enrollment Service is UP and running!");
    }
}
