package com.ncu.college.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.ncu.college.model.Course;
import com.ncu.college.model.Enrollment;
import com.ncu.college.model.Student;
import com.ncu.college.model.Teacher;
import com.ncu.college.repository.EnrollmentRepository;

@RestController
@RequestMapping("/enrollments")
public class EnrollmentController {
    
    @Autowired
    private EnrollmentRepository enrollmentRepository;
    
    @Autowired
    private RestTemplate restTemplate;
    
    // Base URLs for microservices
    private static final String STUDENT_SERVICE_URL = "http://localhost:8585";
    private static final String COURSE_SERVICE_URL = "http://localhost:8586"; 
    private static final String TEACHER_SERVICE_URL = "http://localhost:8587";
    
    // Get all enrollments
    @GetMapping
    public ResponseEntity<List<Enrollment>> getAllEnrollments() {
        try {
            List<Enrollment> enrollments = enrollmentRepository.findAll();
            return ResponseEntity.ok(enrollments);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Get enrollment by ID with full details
    @GetMapping("/{enrollmentId}")
    public ResponseEntity<Map<String, Object>> getEnrollmentById(@PathVariable Long enrollmentId) {
        try {
            Optional<Enrollment> enrollmentOpt = enrollmentRepository.findById(enrollmentId);
            if (enrollmentOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }
            
            Enrollment enrollment = enrollmentOpt.get();
            Map<String, Object> response = new HashMap<>();
            response.put("enrollment", enrollment);
            
            // Fetch related data from other services
            try {
                Student student = restTemplate.getForObject(
                    STUDENT_SERVICE_URL + "/students/" + enrollment.getStudentId(), 
                    Student.class
                );
                response.put("student", student);
            } catch (Exception e) {
                response.put("student", "Service unavailable");
            }
            
            try {
                Course course = restTemplate.getForObject(
                    COURSE_SERVICE_URL + "/courses/" + enrollment.getCourseId(), 
                    Course.class
                );
                response.put("course", course);
            } catch (Exception e) {
                response.put("course", "Service unavailable");
            }
            
            try {
                Teacher teacher = restTemplate.getForObject(
                    TEACHER_SERVICE_URL + "/teachers/" + enrollment.getTeacherId(), 
                    Teacher.class
                );
                response.put("teacher", teacher);
            } catch (Exception e) {
                response.put("teacher", "Service unavailable");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Get enrollments by student ID
    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<Enrollment>> getEnrollmentsByStudentId(@PathVariable Long studentId) {
        try {
            List<Enrollment> enrollments = enrollmentRepository.findByStudentId(studentId);
            return ResponseEntity.ok(enrollments);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Get enrollments by course ID
    @GetMapping("/course/{courseId}")
    public ResponseEntity<List<Enrollment>> getEnrollmentsByCourseId(@PathVariable Long courseId) {
        try {
            List<Enrollment> enrollments = enrollmentRepository.findByCourseId(courseId);
            return ResponseEntity.ok(enrollments);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Get enrollments by teacher ID
    @GetMapping("/teacher/{teacherId}")
    public ResponseEntity<List<Enrollment>> getEnrollmentsByTeacherId(@PathVariable Long teacherId) {
        try {
            List<Enrollment> enrollments = enrollmentRepository.findByTeacherId(teacherId);
            return ResponseEntity.ok(enrollments);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Create new enrollment with validation
    @PostMapping
    public ResponseEntity<Map<String, Object>> createEnrollment(@RequestBody Enrollment enrollment) {
        try {
            // Validate that student, course, and teacher exist
            boolean studentExists = validateStudentExists(enrollment.getStudentId());
            boolean courseExists = validateCourseExists(enrollment.getCourseId());
            boolean teacherExists = validateTeacherExists(enrollment.getTeacherId());
            
            Map<String, Object> response = new HashMap<>();
            
            if (!studentExists) {
                response.put("error", "Student with ID " + enrollment.getStudentId() + " not found");
                return ResponseEntity.badRequest().body(response);
            }
            
            if (!courseExists) {
                response.put("error", "Course with ID " + enrollment.getCourseId() + " not found");
                return ResponseEntity.badRequest().body(response);
            }
            
            if (!teacherExists) {
                response.put("error", "Teacher with ID " + enrollment.getTeacherId() + " not found");
                return ResponseEntity.badRequest().body(response);
            }
            
            enrollment.setEnrollmentId(null); // Ensure it's a new enrollment
            Enrollment savedEnrollment = enrollmentRepository.save(enrollment);
            
            response.put("enrollment", savedEnrollment);
            response.put("message", "Enrollment created successfully");
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("error", "Failed to create enrollment: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }
    
    // Delete enrollment
    @DeleteMapping("/{enrollmentId}")
    public ResponseEntity<Void> deleteEnrollment(@PathVariable Long enrollmentId) {
        try {
            if (!enrollmentRepository.existsById(enrollmentId)) {
                return ResponseEntity.notFound().build();
            }
            
            enrollmentRepository.deleteById(enrollmentId);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    // Helper methods for validation
    private boolean validateStudentExists(Long studentId) {
        try {
            ResponseEntity<Student> response = restTemplate.getForEntity(
                STUDENT_SERVICE_URL + "/students/" + studentId, 
                Student.class
            );
            return response.getStatusCode().is2xxSuccessful();
        } catch (Exception e) {
            return false;
        }
    }
    
    private boolean validateCourseExists(Long courseId) {
        try {
            ResponseEntity<Course> response = restTemplate.getForEntity(
                COURSE_SERVICE_URL + "/courses/" + courseId, 
                Course.class
            );
            return response.getStatusCode().is2xxSuccessful();
        } catch (Exception e) {
            return false;
        }
    }
    
    private boolean validateTeacherExists(Long teacherId) {
        try {
            ResponseEntity<Teacher> response = restTemplate.getForEntity(
                TEACHER_SERVICE_URL + "/teachers/" + teacherId, 
                Teacher.class
            );
            return response.getStatusCode().is2xxSuccessful();
        } catch (Exception e) {
            return false;
        }
    }
}
