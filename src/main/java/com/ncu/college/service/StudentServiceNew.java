package com.ncu.college.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ncu.college.dto.StudentDto;
import com.ncu.college.model.Student;
import com.ncu.college.repository.StudentJpaRepository;

@Service
public class StudentServiceImpl implements IStudentService {
    
    @Autowired
    private StudentJpaRepository studentRepository;
    
    @Autowired
    private ModelMapper modelMapper;
    
    @Override
    public List<StudentDto> getAllStudents() {
        try {
            List<Student> students = studentRepository.findAll();
            return students.stream()
                    .map(student -> modelMapper.map(student, StudentDto.class))
                    .collect(Collectors.toList());
        } catch (Exception e) {
            throw new RuntimeException("Error fetching students", e);
        }
    }
    
    @Override
    public StudentDto getStudentById(Long id) {
        try {
            Optional<Student> student = studentRepository.findById(id);
            if (student.isPresent()) {
                return modelMapper.map(student.get(), StudentDto.class);
            } else {
                throw new RuntimeException("Student not found with id: " + id);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error fetching student with id: " + id, e);
        }
    }
    
    @Override
    public StudentDto createStudent(StudentDto studentDto) {
        try {
            Student student = modelMapper.map(studentDto, Student.class);
            Student savedStudent = studentRepository.save(student);
            return modelMapper.map(savedStudent, StudentDto.class);
        } catch (Exception e) {
            throw new RuntimeException("Error creating student", e);
        }
    }
    
    @Override
    public StudentDto updateStudent(Long id, StudentDto studentDto) {
        try {
            Optional<Student> existingStudent = studentRepository.findById(id);
            if (existingStudent.isPresent()) {
                Student student = existingStudent.get();
                student.setName(studentDto.getName());
                student.setEmail(studentDto.getEmail());
                student.setAge(studentDto.getAge());
                
                Student savedStudent = studentRepository.save(student);
                return modelMapper.map(savedStudent, StudentDto.class);
            } else {
                throw new RuntimeException("Student not found with id: " + id);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error updating student with id: " + id, e);
        }
    }
    
    @Override
    public void deleteStudent(Long id) {
        try {
            if (studentRepository.existsById(id)) {
                studentRepository.deleteById(id);
            } else {
                throw new RuntimeException("Student not found with id: " + id);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error deleting student with id: " + id, e);
        }
    }
    
    @Override
    public void deleteAllStudents() {
        try {
            studentRepository.deleteAll();
        } catch (Exception e) {
            throw new RuntimeException("Error deleting all students", e);
        }
    }
    
    @Override
    public Long getStudentCount() {
        try {
            return studentRepository.count();
        } catch (Exception e) {
            throw new RuntimeException("Error getting student count", e);
        }
    }
}
