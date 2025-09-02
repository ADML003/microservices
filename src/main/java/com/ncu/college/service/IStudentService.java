package com.ncu.college.service;

import java.util.List;

import com.ncu.college.dto.StudentDto;

public interface IStudentService {
    
    List<StudentDto> getAllStudents();
    
    StudentDto getStudentById(Long id);
    
    StudentDto saveStudent(StudentDto studentDto);
    
    StudentDto updateStudent(Long id, StudentDto studentDto);
    
    void deleteStudent(Long id);
    
    List<StudentDto> findStudentsByAge(Integer minAge, Integer maxAge);
    
    List<StudentDto> searchStudentsByName(String name);
    
    StudentDto findStudentByEmail(String email);
}
