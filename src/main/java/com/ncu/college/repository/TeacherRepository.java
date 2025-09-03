package com.ncu.college.repository;

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

import com.ncu.college.model.Teacher;

@Repository
public class TeacherRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private final RowMapper<Teacher> teacherRowMapper = (rs, rowNum) -> {
        Teacher teacher = new Teacher();
        teacher.setTeacherId(rs.getLong("teacher_id"));
        teacher.setName(rs.getString("name"));
        return teacher;
    };
    
    // Find all teachers
    public List<Teacher> findAll() {
        String sql = "SELECT * FROM teachers";
        return jdbcTemplate.query(sql, teacherRowMapper);
    }
    
    // Find teacher by ID
    public Optional<Teacher> findById(Long teacherId) {
        String sql = "SELECT * FROM teachers WHERE teacher_id = ?";
        List<Teacher> teachers = jdbcTemplate.query(sql, teacherRowMapper, teacherId);
        return teachers.isEmpty() ? Optional.empty() : Optional.of(teachers.get(0));
    }
    
    // Save new teacher
    public Teacher save(Teacher teacher) {
        if (teacher.getTeacherId() == null) {
            // Insert new teacher
            String sql = "INSERT INTO teachers (name) VALUES (?)";
            
            KeyHolder keyHolder = new GeneratedKeyHolder();
            
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, teacher.getName());
                return ps;
            }, keyHolder);
            
            // Set the generated ID
            teacher.setTeacherId(keyHolder.getKey().longValue());
        } else {
            // Update existing teacher
            String sql = "UPDATE teachers SET name = ? WHERE teacher_id = ?";
            jdbcTemplate.update(sql, teacher.getName(), teacher.getTeacherId());
        }
        return teacher;
    }
    
    // Delete teacher
    public void deleteById(Long teacherId) {
        String sql = "DELETE FROM teachers WHERE teacher_id = ?";
        jdbcTemplate.update(sql, teacherId);
    }
    
    // Check if teacher exists
    public boolean existsById(Long teacherId) {
        String sql = "SELECT COUNT(*) FROM teachers WHERE teacher_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, teacherId);
        return count != null && count > 0;
    }
}
