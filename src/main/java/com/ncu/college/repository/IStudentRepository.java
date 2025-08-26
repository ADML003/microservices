package com.ncu.college.repository;

import java.util.List;
import java.util.Optional;

import com.ncu.college.model.Student;

public interface IStudentRepository {
    
    List<Student> getAllStudents();
    
    Optional<Student> getStudentById(Long id);
    
    Student saveStudent(Student student);
    
    void deleteStudent(Long id);
    
    void deleteAllStudents();
    
    Long getStudentCount();
}
