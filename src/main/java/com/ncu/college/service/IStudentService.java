package com.ncu.college.service;

import java.util.List;

import com.ncu.college.dto.StudentDto;

public interface IStudentService {
    
    List<StudentDto> getAllStudents();
    
    StudentDto getStudentById(Long id);
    
    StudentDto createStudent(StudentDto studentDto);
    
    StudentDto updateStudent(Long id, StudentDto studentDto);
    
    void deleteStudent(Long id);
    
    void deleteAllStudents();
    
    Long getStudentCount();
}
