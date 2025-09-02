package com.ncu.college.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.ncu.college.model.Student;

@Repository
public class StudentRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    // Row mapper to convert SQL result to Student object
    private RowMapper<Student> studentRowMapper = (rs, rowNum) -> {
        Student student = new Student();
        student.setId(rs.getLong("id"));
        student.setName(rs.getString("name"));
        student.setEmail(rs.getString("email"));
        student.setAge(rs.getInt("age"));
        student.setAddress(rs.getString("address"));
        student.setPhoneNumber(rs.getString("phone_number"));
        return student;
    };
    
    // Get all students
    public List<Student> findAll() {
        String sql = "SELECT * FROM students";
        return jdbcTemplate.query(sql, studentRowMapper);
    }
    
    // Get student by ID
    public Optional<Student> findById(Long id) {
        String sql = "SELECT * FROM students WHERE id = ?";
        List<Student> students = jdbcTemplate.query(sql, studentRowMapper, id);
        return students.isEmpty() ? Optional.empty() : Optional.of(students.get(0));
    }
    
    // Save new student
    public Student save(Student student) {
        if (student.getId() == null) {
            // Insert new student
            String sql = "INSERT INTO students (name, email, age, address, phone_number) VALUES (?, ?, ?, ?, ?)";
            jdbcTemplate.update(sql, student.getName(), student.getEmail(), student.getAge(), 
                              student.getAddress(), student.getPhoneNumber());
            return student;
        } else {
            // Update existing student
            String sql = "UPDATE students SET name = ?, email = ?, age = ?, address = ?, phone_number = ? WHERE id = ?";
            jdbcTemplate.update(sql, student.getName(), student.getEmail(), student.getAge(),
                              student.getAddress(), student.getPhoneNumber(), student.getId());
            return student;
        }
    }
    
    // Delete student
    public void deleteById(Long id) {
        String sql = "DELETE FROM students WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }
    
    // Check if student exists
    public boolean existsById(Long id) {
        String sql = "SELECT COUNT(*) FROM students WHERE id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, id);
        return count != null && count > 0;
    }
    
    // Find by email
    public Optional<Student> findByEmail(String email) {
        String sql = "SELECT * FROM students WHERE email = ?";
        List<Student> students = jdbcTemplate.query(sql, studentRowMapper, email);
        return students.isEmpty() ? Optional.empty() : Optional.of(students.get(0));
    }
    
    // Find by age range
    public List<Student> findByAgeBetween(Integer minAge, Integer maxAge) {
        String sql = "SELECT * FROM students WHERE age BETWEEN ? AND ?";
        return jdbcTemplate.query(sql, studentRowMapper, minAge, maxAge);
    }
    
    // Search by name (case insensitive)
    public List<Student> findByNameContainingIgnoreCase(String name) {
        String sql = "SELECT * FROM students WHERE LOWER(name) LIKE LOWER(?)";
        return jdbcTemplate.query(sql, studentRowMapper, "%" + name + "%");
    }
}
