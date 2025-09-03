package com.ncu.college.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ncu.college.model.Student;
import com.ncu.college.repository.StudentRepository;

@RestController
@RequestMapping("/test")
public class DatabaseTestController {

    @Autowired
    private StudentRepository studentRepository;

    @GetMapping("/sql-connection")
    public ResponseEntity<String> testSqlConnection() {
        try {
            List<Student> students = studentRepository.findAll();
            long count = students.size();
            return ResponseEntity.ok("✅ SQL Connection Test SUCCESSFUL! Found " + count + " students in MySQL database.");
        } catch (Exception e) {
            return ResponseEntity.ok("❌ SQL Connection Failed: " + e.getMessage());
        }
    }

    @GetMapping("/students-direct")
    public ResponseEntity<List<Student>> getStudentsDirectly() {
        try {
            List<Student> students = studentRepository.findAll();
            return ResponseEntity.ok(students);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/database-info")
    public ResponseEntity<String> getDatabaseInfo() {
        try {
            List<Student> students = studentRepository.findAll();
            long count = students.size();
            
            String info = String.format(
                "🗄️ Database: MySQL student_management\n" +
                "📊 Total Students: %d\n" +
                "🔗 JDBC Connection: Active\n" +
                "🏗️ JPA/Hibernate: Working\n" +
                "📝 Sample Student: %s",
                count,
                students.isEmpty() ? "No data" : students.get(0).getName()
            );
            
            return ResponseEntity.ok(info);
        } catch (Exception e) {
            return ResponseEntity.ok("❌ Database connection failed: " + e.getMessage());
        }
    }
}
