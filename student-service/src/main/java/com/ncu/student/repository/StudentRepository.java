package com.ncu.student.repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.ncu.student.model.Student;

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
            
            // Use KeyHolder to get the generated ID
            KeyHolder keyHolder = new GeneratedKeyHolder();
            
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, student.getName());
                ps.setString(2, student.getEmail());
                Integer age = student.getAge();
                if (age != null) {
                    ps.setInt(3, age.intValue());
                } else {
                    ps.setNull(3, java.sql.Types.INTEGER);
                }
                ps.setString(4, student.getAddress());
                ps.setString(5, student.getPhoneNumber());
                return ps;
            }, keyHolder);
            
            // Set the generated ID
            Number generatedId = keyHolder.getKey();
            if (generatedId != null) {
                student.setId(generatedId.longValue());
            }
            
            return student;
        } else {
            // Update existing student
            String sql = "UPDATE students SET name = ?, email = ?, age = ?, address = ?, phone_number = ? WHERE id = ?";
            jdbcTemplate.update(sql, student.getName(), student.getEmail(), student.getAge(), 
                              student.getAddress(), student.getPhoneNumber(), student.getId());
            return student;
        }
    }
    
    // Delete student by ID
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
}
