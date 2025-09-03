package com.ncu.student.controller;

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

import com.ncu.student.dto.StudentDto;
import com.ncu.student.service.IStudentService;

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
            if (student != null) {
                return ResponseEntity.ok(student);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            System.err.println("Error fetching student by ID: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // POST - Create new student
    @PostMapping
    public ResponseEntity<StudentDto> createStudent(@RequestBody StudentDto studentDto) {
        try {
            System.out.println("POST: Creating new student: " + studentDto.getName());
            StudentDto savedStudent = studentService.saveStudent(studentDto);
            return ResponseEntity.status(HttpStatus.CREATED).body(savedStudent);
        } catch (Exception e) {
            System.err.println("Error creating student: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // PUT - Update existing student
    @PutMapping("/{id}")
    public ResponseEntity<StudentDto> updateStudent(@PathVariable Long id, @RequestBody StudentDto studentDto) {
        try {
            System.out.println("PUT: Updating student with ID: " + id);
            StudentDto updatedStudent = studentService.updateStudent(id, studentDto);
            if (updatedStudent != null) {
                return ResponseEntity.ok(updatedStudent);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            System.err.println("Error updating student: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    // DELETE - Delete student
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable Long id) {
        try {
            System.out.println("DELETE: Deleting student with ID: " + id);
            boolean deleted = studentService.deleteStudent(id);
            if (deleted) {
                return ResponseEntity.noContent().build();
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            System.err.println("Error deleting student: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
