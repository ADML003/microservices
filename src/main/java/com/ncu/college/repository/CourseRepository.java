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

import com.ncu.college.model.Course;

@Repository
public class CourseRepository {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    private final RowMapper<Course> courseRowMapper = (rs, rowNum) -> {
        Course course = new Course();
        course.setCourseId(rs.getLong("course_id"));
        course.setName(rs.getString("name"));
        course.setCredits(rs.getInt("credits"));
        return course;
    };
    
    // Find all courses
    public List<Course> findAll() {
        String sql = "SELECT * FROM courses";
        return jdbcTemplate.query(sql, courseRowMapper);
    }
    
    // Find course by ID
    public Optional<Course> findById(Long courseId) {
        String sql = "SELECT * FROM courses WHERE course_id = ?";
        List<Course> courses = jdbcTemplate.query(sql, courseRowMapper, courseId);
        return courses.isEmpty() ? Optional.empty() : Optional.of(courses.get(0));
    }
    
    // Save new course
    public Course save(Course course) {
        if (course.getCourseId() == null) {
            // Insert new course
            String sql = "INSERT INTO courses (name, credits) VALUES (?, ?)";
            
            KeyHolder keyHolder = new GeneratedKeyHolder();
            
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, course.getName());
                ps.setInt(2, course.getCredits());
                return ps;
            }, keyHolder);
            
            // Set the generated ID
            course.setCourseId(keyHolder.getKey().longValue());
        } else {
            // Update existing course
            String sql = "UPDATE courses SET name = ?, credits = ? WHERE course_id = ?";
            jdbcTemplate.update(sql, course.getName(), course.getCredits(), course.getCourseId());
        }
        return course;
    }
    
    // Delete course
    public void deleteById(Long courseId) {
        String sql = "DELETE FROM courses WHERE course_id = ?";
        jdbcTemplate.update(sql, courseId);
    }
    
    // Check if course exists
    public boolean existsById(Long courseId) {
        String sql = "SELECT COUNT(*) FROM courses WHERE course_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, courseId);
        return count != null && count > 0;
    }
}
