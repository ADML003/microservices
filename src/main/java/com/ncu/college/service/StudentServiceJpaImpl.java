package com.ncu.college.service;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ncu.college.dto.StudentDto;
import com.ncu.college.model.Student;
import com.ncu.college.repository.StudentJpaRepository;

@Service("StudentService")
public class StudentServiceJpaImpl implements IStudentService {
    
    private final StudentJpaRepository studentRepository;
    private final ModelMapper modelMapper;
    
    @Autowired
    public StudentServiceJpaImpl(StudentJpaRepository studentRepository, ModelMapper modelMapper) {
        this.studentRepository = studentRepository;
        this.modelMapper = modelMapper;
    }
    
    @Override
    public List<StudentDto> getAllStudents() {
        List<Student> students = studentRepository.findAll();
        return students.stream()
                .map(student -> modelMapper.map(student, StudentDto.class))
                .collect(Collectors.toList());
    }
    
    @Override
    public StudentDto getStudentById(Long id) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found with id: " + id));
        return modelMapper.map(student, StudentDto.class);
    }
    
    @Override
    public StudentDto createStudent(StudentDto studentDto) {
        Student student = modelMapper.map(studentDto, Student.class);
        Student savedStudent = studentRepository.save(student);
        System.out.println("Student saved: " + savedStudent);
        return modelMapper.map(savedStudent, StudentDto.class);
    }
    
    @Override
    public StudentDto updateStudent(Long id, StudentDto studentDto) {
        Student existingStudent = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found with id: " + id));
        
        // Update fields
        existingStudent.setName(studentDto.getName());
        existingStudent.setEmail(studentDto.getEmail());
        existingStudent.setAge(studentDto.getAge());
        
        Student updatedStudent = studentRepository.save(existingStudent);
        return modelMapper.map(updatedStudent, StudentDto.class);
    }
    
    @Override
    public void deleteStudent(Long id) {
        if (!studentRepository.existsById(id)) {
            throw new RuntimeException("Student not found with id: " + id);
        }
        studentRepository.deleteById(id);
    }
    
    @Override
    public void deleteAllStudents() {
        studentRepository.deleteAll();
    }
    
    @Override
    public Long getStudentCount() {
        return studentRepository.count();
    }
}
