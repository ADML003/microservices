package com.ncu.college.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ncu.college.model.Student;

@Repository("StudentJpaRepositoryImpl")
public class StudentJpaRepositoryImpl implements IStudentRepository {
    
    private final StudentJpaRepository jpaRepository;
    
    @Autowired
    public StudentJpaRepositoryImpl(StudentJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }
    
    @Override
    public List<Student> getAllStudents() {
        return jpaRepository.findAll();
    }
    
    @Override
    public Optional<Student> getStudentById(Long id) {
        return jpaRepository.findById(id);
    }
    
    @Override
    public Student saveStudent(Student student) {
        return jpaRepository.save(student);
    }
    
    @Override
    public void deleteStudent(Long id) {
        jpaRepository.deleteById(id);
    }
    
    @Override
    public void deleteAllStudents() {
        jpaRepository.deleteAll();
    }
    
    @Override
    public Long getStudentCount() {
        return jpaRepository.count();
    }
}
