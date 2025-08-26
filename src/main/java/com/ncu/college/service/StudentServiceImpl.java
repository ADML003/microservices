package com.ncu.college.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

import com.ncu.college.dto.StudentDto;
import com.ncu.college.model.Student;
import com.ncu.college.repository.IStudentRepository;

@Service(value = "StudentService")
@Scope(value = BeanDefinition.SCOPE_SINGLETON)
public class StudentServiceImpl implements IStudentService {
    
    private final IStudentRepository studentRepository;
    private final ModelMapper modelMapper;
    
    @Autowired
    public StudentServiceImpl(IStudentRepository studentRepository, ModelMapper modelMapper) {
        this.studentRepository = studentRepository;
        this.modelMapper = modelMapper;
    }
    
    @Override
    public List<StudentDto> getAllStudents() {
        try {
            List<Student> students = studentRepository.getAllStudents();
            return students.stream()
                    .map(student -> modelMapper.map(student, StudentDto.class))
                    .collect(Collectors.toList());
        } catch (Exception e) {
            System.err.println("Error in service while fetching all students: " + e.getMessage());
            throw new RuntimeException("Error fetching students", e);
        }
    }
    
    @Override
    public StudentDto getStudentById(Long id) {
        try {
            Optional<Student> student = studentRepository.getStudentById(id);
            if (student.isPresent()) {
                return modelMapper.map(student.get(), StudentDto.class);
            } else {
                throw new RuntimeException("Student not found with ID: " + id);
            }
        } catch (Exception e) {
            System.err.println("Error in service while fetching student by ID " + id + ": " + e.getMessage());
            throw new RuntimeException("Error fetching student by ID", e);
        }
    }
    
    @Override
    public StudentDto createStudent(StudentDto studentDto) {
        try {
            // Convert DTO to entity
            Student student = modelMapper.map(studentDto, Student.class);
            student.setId(null); // Ensure new student gets auto-generated ID
            
            // Save student
            Student savedStudent = studentRepository.saveStudent(student);
            
            // Convert back to DTO and return
            return modelMapper.map(savedStudent, StudentDto.class);
        } catch (Exception e) {
            System.err.println("Error in service while creating student: " + e.getMessage());
            throw new RuntimeException("Error creating student", e);
        }
    }
    
    @Override
    public StudentDto updateStudent(Long id, StudentDto studentDto) {
        try {
            // Check if student exists
            Optional<Student> existingStudent = studentRepository.getStudentById(id);
            if (!existingStudent.isPresent()) {
                throw new RuntimeException("Student not found with ID: " + id);
            }
            
            // Convert DTO to entity and set the ID
            Student student = modelMapper.map(studentDto, Student.class);
            student.setId(id);
            
            // Save updated student
            Student savedStudent = studentRepository.saveStudent(student);
            
            // Convert back to DTO and return
            return modelMapper.map(savedStudent, StudentDto.class);
        } catch (Exception e) {
            System.err.println("Error in service while updating student with ID " + id + ": " + e.getMessage());
            throw new RuntimeException("Error updating student", e);
        }
    }
    
    @Override
    public void deleteStudent(Long id) {
        try {
            // Check if student exists before deleting
            Optional<Student> existingStudent = studentRepository.getStudentById(id);
            if (!existingStudent.isPresent()) {
                throw new RuntimeException("Student not found with ID: " + id);
            }
            
            studentRepository.deleteStudent(id);
        } catch (Exception e) {
            System.err.println("Error in service while deleting student with ID " + id + ": " + e.getMessage());
            throw new RuntimeException("Error deleting student", e);
        }
    }
    
    @Override
    public void deleteAllStudents() {
        try {
            studentRepository.deleteAllStudents();
        } catch (Exception e) {
            System.err.println("Error in service while deleting all students: " + e.getMessage());
            throw new RuntimeException("Error deleting all students", e);
        }
    }
    
    @Override
    public Long getStudentCount() {
        try {
            return studentRepository.getStudentCount();
        } catch (Exception e) {
            System.err.println("Error in service while getting student count: " + e.getMessage());
            throw new RuntimeException("Error getting student count", e);
        }
    }
}
