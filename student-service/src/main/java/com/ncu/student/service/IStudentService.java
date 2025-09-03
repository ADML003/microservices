package com.ncu.student.service;

import java.util.List;
import com.ncu.student.dto.StudentDto;

public interface IStudentService {
    List<StudentDto> getAllStudents();
    StudentDto getStudentById(Long id);
    StudentDto saveStudent(StudentDto studentDto);
    StudentDto updateStudent(Long id, StudentDto studentDto);
    boolean deleteStudent(Long id);
}
