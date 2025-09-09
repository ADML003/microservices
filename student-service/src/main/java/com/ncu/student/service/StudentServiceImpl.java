package com.ncu.student.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ncu.student.dto.StudentDto;
import com.ncu.student.model.Student;
import com.ncu.student.repository.StudentRepository;

@Service
public class StudentServiceImpl implements IStudentService {
    
    @Autowired
    private StudentRepository studentRepository;
    
    @Override
    public List<StudentDto> getAllStudents() {
        List<Student> students = studentRepository.findAll();
        return students.stream().map(this::convertToDto).collect(Collectors.toList());
    }
    
    @Override
    public StudentDto getStudentById(Long id) {
        Optional<Student> student = studentRepository.findById(id);
        return student.map(this::convertToDto).orElse(null);
    }
    
    @Override
    public StudentDto saveStudent(StudentDto studentDto) {
        Student student = convertToEntity(studentDto);
        Student savedStudent = studentRepository.save(student);
        return convertToDto(savedStudent);
    }
    
    @Override
    public StudentDto updateStudent(Long id, StudentDto studentDto) {
        Optional<Student> existingStudent = studentRepository.findById(id);
        if (existingStudent.isPresent()) {
            Student student = existingStudent.get();
            student.setName(studentDto.getName());
            student.setEmail(studentDto.getEmail());
            student.setAge(studentDto.getAge());
            student.setAddress(studentDto.getAddress());
            student.setPhoneNumber(studentDto.getPhoneNumber());
            Student savedStudent = studentRepository.save(student);
            return convertToDto(savedStudent);
        }
        return null;
    }
    
    @Override
    public boolean deleteStudent(Long id) {
        if (studentRepository.existsById(id)) {
            studentRepository.deleteById(id);
            return true;
        }
        return false;
    }
    
    // Helper method to convert Student entity to StudentDto
    private StudentDto convertToDto(Student student) {
        StudentDto dto = new StudentDto();
        dto.setId(student.getId());
        dto.setName(student.getName());
        dto.setEmail(student.getEmail());
        dto.setAge(student.getAge());
        dto.setAddress(student.getAddress());
        dto.setPhoneNumber(student.getPhoneNumber());
        return dto;
    }
    
    // Helper method to convert StudentDto to Student entity
    private Student convertToEntity(StudentDto dto) {
        Student student = new Student();
        // Don't set ID for new students - it will be auto-generated
        if (dto.getId() != null) {
            student.setId(dto.getId());
        }
        student.setName(dto.getName());
        student.setEmail(dto.getEmail());
        student.setAge(dto.getAge());
        student.setAddress(dto.getAddress());
        student.setPhoneNumber(dto.getPhoneNumber());
        return student;
    }
}
