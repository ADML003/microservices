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

import com.ncu.college.model.Enrollment;

@Repository
public class EnrollmentRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private final RowMapper<Enrollment> enrollmentRowMapper = (rs, rowNum) -> {
        Enrollment enrollment = new Enrollment();
        enrollment.setEnrollmentId(rs.getLong("enrollment_id"));
        enrollment.setCourseId(rs.getLong("course_id"));
        enrollment.setStudentId(rs.getLong("student_id"));
        enrollment.setTeacherId(rs.getLong("teacher_id"));
        return enrollment;
    };
    
    // Find all enrollments
    public List<Enrollment> findAll() {
        String sql = "SELECT * FROM enrollments";
        return jdbcTemplate.query(sql, enrollmentRowMapper);
    }
    
    // Find enrollment by ID
    public Optional<Enrollment> findById(Long enrollmentId) {
        String sql = "SELECT * FROM enrollments WHERE enrollment_id = ?";
        List<Enrollment> enrollments = jdbcTemplate.query(sql, enrollmentRowMapper, enrollmentId);
        return enrollments.isEmpty() ? Optional.empty() : Optional.of(enrollments.get(0));
    }
    
    // Find enrollments by student ID
    public List<Enrollment> findByStudentId(Long studentId) {
        String sql = "SELECT * FROM enrollments WHERE student_id = ?";
        return jdbcTemplate.query(sql, enrollmentRowMapper, studentId);
    }
    
    // Find enrollments by course ID
    public List<Enrollment> findByCourseId(Long courseId) {
        String sql = "SELECT * FROM enrollments WHERE course_id = ?";
        return jdbcTemplate.query(sql, enrollmentRowMapper, courseId);
    }
    
    // Find enrollments by teacher ID
    public List<Enrollment> findByTeacherId(Long teacherId) {
        String sql = "SELECT * FROM enrollments WHERE teacher_id = ?";
        return jdbcTemplate.query(sql, enrollmentRowMapper, teacherId);
    }
    
    // Save new enrollment
    public Enrollment save(Enrollment enrollment) {
        if (enrollment.getEnrollmentId() == null) {
            // Insert new enrollment
            String sql = "INSERT INTO enrollments (course_id, student_id, teacher_id) VALUES (?, ?, ?)";
            
            KeyHolder keyHolder = new GeneratedKeyHolder();
            
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setLong(1, enrollment.getCourseId());
                ps.setLong(2, enrollment.getStudentId());
                ps.setLong(3, enrollment.getTeacherId());
                return ps;
            }, keyHolder);
            
            // Set the generated ID
            enrollment.setEnrollmentId(keyHolder.getKey().longValue());
        } else {
            // Update existing enrollment
            String sql = "UPDATE enrollments SET course_id = ?, student_id = ?, teacher_id = ? WHERE enrollment_id = ?";
            jdbcTemplate.update(sql, enrollment.getCourseId(), enrollment.getStudentId(), 
                              enrollment.getTeacherId(), enrollment.getEnrollmentId());
        }
        return enrollment;
    }
    
    // Delete enrollment
    public void deleteById(Long enrollmentId) {
        String sql = "DELETE FROM enrollments WHERE enrollment_id = ?";
        jdbcTemplate.update(sql, enrollmentId);
    }
    
    // Check if enrollment exists
    public boolean existsById(Long enrollmentId) {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE enrollment_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, enrollmentId);
        return count != null && count > 0;
    }
}
