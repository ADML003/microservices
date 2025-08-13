package com.ncu.college.controller;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

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

@RequestMapping("/students")
@RestController
public class StudentController {

    // Simulated in-memory data store
    private Map<Long, Student> students = new HashMap<>();
    private Long nextId = 1L;

    // Constructor to add some sample data
    public StudentController() {
        students.put(1L, new Student(1L, "John Doe", "john@example.com", 20));
        students.put(2L, new Student(2L, "Jane Smith", "jane@example.com", 22));
        nextId = 3L;
    }

    // GET - Get all students
    @GetMapping
    public ResponseEntity<Collection<Student>> getAllStudents() {
        System.out.println("GET: Fetching all students");
        return ResponseEntity.ok(students.values());
    }

    // GET - Get student by ID
    @GetMapping("/{id}")
    public ResponseEntity<Student> getStudentById(@PathVariable Long id) {
        System.out.println("GET: Fetching student with ID: " + id);
        Student student = students.get(id);
        if (student != null) {
            return ResponseEntity.ok(student);
        }
        return ResponseEntity.notFound().build();
    }

    // POST - Create new student
    @PostMapping
    public ResponseEntity<Student> createStudent(@RequestBody Student student) {
        System.out.println("POST: Creating new student: " + student.getName());
        student.setId(nextId++);
        students.put(student.getId(), student);
        return ResponseEntity.status(HttpStatus.CREATED).body(student);
    }

    // PUT - Update existing student (full update)
    @PutMapping("/{id}")
    public ResponseEntity<Student> updateStudent(@PathVariable Long id, @RequestBody Student studentDetails) {
        System.out.println("PUT: Updating student with ID: " + id);
        Student student = students.get(id);
        if (student != null) {
            student.setName(studentDetails.getName());
            student.setEmail(studentDetails.getEmail());
            student.setAge(studentDetails.getAge());
            return ResponseEntity.ok(student);
        }
        return ResponseEntity.notFound().build();
    }

    // DELETE - Delete student by ID
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable Long id) {
        System.out.println("DELETE: Deleting student with ID: " + id);
        Student removed = students.remove(id);
        if (removed != null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    // DELETE - Delete all students
    @DeleteMapping
    public ResponseEntity<Void> deleteAllStudents() {
        System.out.println("DELETE: Deleting all students");
        students.clear();
        nextId = 1L;
        return ResponseEntity.noContent().build();
    }

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
 