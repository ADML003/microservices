package com.ncu.college.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.stereotype.Repository;

import com.ncu.college.model.Student;

@Repository(value = "StudentRepositoryImpl")
public class StudentRepositoryImpl implements IStudentRepository {
    
    // In-memory storage (simulating database)
    private final Map<Long, Student> students = new HashMap<>();
    private Long nextId = 1L;
    
    // Constructor to initialize with sample data
    public StudentRepositoryImpl() {
        students.put(1L, new Student(1L, "John Doe", "john@example.com", 20));
        students.put(2L, new Student(2L, "Jane Smith", "jane@example.com", 22));
        nextId = 3L;
    }
    
    @Override
    public List<Student> getAllStudents() {
        try {
            return students.values().stream().collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Error fetching all students: " + e.getMessage());
            throw new RuntimeException("Error fetching students", e);
        }
    }
    
    @Override
    public Optional<Student> getStudentById(Long id) {
        try {
            return Optional.ofNullable(students.get(id));
        } catch (Exception e) {
            System.err.println("Error fetching student by ID " + id + ": " + e.getMessage());
            throw new RuntimeException("Error fetching student by ID", e);
        }
    }
    
    @Override
    public Student saveStudent(Student student) {
        try {
            if (student.getId() == null) {
                // New student - assign ID
                student.setId(nextId++);
            }
            students.put(student.getId(), student);
            System.out.println("Student saved: " + student);
            return student;
        } catch (Exception e) {
            System.err.println("Error saving student: " + e.getMessage());
            throw new RuntimeException("Error saving student", e);
        }
    }
    
    @Override
    public void deleteStudent(Long id) {
        try {
            Student removed = students.remove(id);
            if (removed != null) {
                System.out.println("Student deleted: " + removed);
            } else {
                throw new RuntimeException("Student not found with ID: " + id);
            }
        } catch (Exception e) {
            System.err.println("Error deleting student with ID " + id + ": " + e.getMessage());
            throw new RuntimeException("Error deleting student", e);
        }
    }
    
    @Override
    public void deleteAllStudents() {
        try {
            students.clear();
            nextId = 1L;
            System.out.println("All students deleted");
        } catch (Exception e) {
            System.err.println("Error deleting all students: " + e.getMessage());
            throw new RuntimeException("Error deleting all students", e);
        }
    }
    
    @Override
    public Long getStudentCount() {
        try {
            return (long) students.size();
        } catch (Exception e) {
            System.err.println("Error getting student count: " + e.getMessage());
            throw new RuntimeException("Error getting student count", e);
        }
    }
}
