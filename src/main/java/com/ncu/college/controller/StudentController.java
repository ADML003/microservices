package com.ncu.college.controller;

import java.util.List;

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

import com.ncu.college.dto.StudentDto;
import com.ncu.college.service.IStudentService;

@RequestMapping("/students")
@RestController
public class StudentController {

    @Autowired
    private IStudentService studentService;

    // GET - Get all students
    @GetMapping
    public ResponseEntity<List<StudentDto>> getAllStudents() {
        try {
            System.out.println("GET: Fetching all students");
            List<StudentDto> students = studentService.getAllStudents();
            return ResponseEntity.ok(students);
        } catch (Exception e) {
            System.err.println("Error fetching students: " + e.getMessage());
            throw new RuntimeException("Error fetching students", e);
        }
    }

    // GET - Get student by ID
    @GetMapping("/{id}")
    public ResponseEntity<StudentDto> getStudentById(@PathVariable Long id) {
        try {
            System.out.println("GET: Fetching student with ID: " + id);
            StudentDto student = studentService.getStudentById(id);
            return ResponseEntity.ok(student);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            System.err.println("Error fetching student by ID: " + e.getMessage());
            throw new RuntimeException("Error fetching student by ID", e);
        }
    }

    // POST - Create new student
    @PostMapping
    public ResponseEntity<StudentDto> createStudent(@RequestBody StudentDto studentDto) {
        try {
            System.out.println("POST: Creating new student: " + studentDto.getName());
            StudentDto createdStudent = studentService.saveStudent(studentDto);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdStudent);
        } catch (RuntimeException e) {
            System.err.println("Error creating student: " + e.getMessage());
            if (e.getMessage().contains("Duplicate entry") && e.getMessage().contains("email")) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(null); // Could return error details in a proper error DTO
            }
            throw e;
        } catch (Exception e) {
            System.err.println("Error creating student: " + e.getMessage());
            throw new RuntimeException("Error creating student", e);
        }
    }

    // PUT - Update existing student (full update)
    @PutMapping("/{id}")
    public ResponseEntity<StudentDto> updateStudent(@PathVariable Long id, @RequestBody StudentDto studentDto) {
        try {
            System.out.println("PUT: Updating student with ID: " + id);
            StudentDto updatedStudent = studentService.updateStudent(id, studentDto);
            return ResponseEntity.ok(updatedStudent);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            System.err.println("Error updating student: " + e.getMessage());
            throw new RuntimeException("Error updating student", e);
        }
    }

        // DELETE - Delete student by ID
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteStudent(@PathVariable Long id) {
        try {
            System.out.println("DELETE: Deleting student with ID: " + id);
            studentService.deleteStudent(id);
            return ResponseEntity.ok("Student with ID " + id + " has been deleted successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            System.err.println("Error deleting student: " + e.getMessage());
            throw new RuntimeException("Error deleting student", e);
        }
    }

        // Note: deleteAllStudents method removed for simplicity
    // Individual student deletion available via DELETE /{id}

    // Simple Student class
    public static class Student {
        private Long id;
        private String name;
        private String email;
        private Integer age;

        public Student() {}

        public Student(Long id, String name, String email, Integer age) {
            this.id = id;
            this.name = name;
            this.email = email;
            this.age = age;
        }

        // Getters and Setters
        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public Integer getAge() { return age; }
        public void setAge(Integer age) { this.age = age; }

        @Override
        public String toString() {
            return "Student{id=" + id + ", name='" + name + "', email='" + email + "', age=" + age + "}";
        }
    }
}
 