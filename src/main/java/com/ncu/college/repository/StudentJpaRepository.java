package com.ncu.college.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.ncu.college.model.Student;

@Repository
public interface StudentJpaRepository extends JpaRepository<Student, Long> {
    
    // Custom query methods
    Optional<Student> findByEmail(String email);
    
    List<Student> findByAgeBetween(Integer minAge, Integer maxAge);
    
    List<Student> findByNameContainingIgnoreCase(String name);
    
    @Query("SELECT COUNT(s) FROM Student s")
    Long countAllStudents();
    
    @Query("SELECT s FROM Student s WHERE s.age > :age")
    List<Student> findStudentsOlderThan(Integer age);
}
