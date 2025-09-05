package com.ncu.course.service;

import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ncu.course.dto.CourseDto;
import com.ncu.course.model.Course;
import com.ncu.course.repository.CourseRepository;

@Service
public class CourseServiceImpl implements ICourseService {
    
    @Autowired
    private CourseRepository courseRepository;
    
    @Override
    public List<Course> getAllCourses() {
        return courseRepository.findAll();
    }
    
    @Override
    public Optional<Course> getCourseById(Long courseId) {
        return courseRepository.findById(courseId);
    }
    
    @Override
    public Course createCourse(CourseDto courseDto) {
        Course course = convertToEntity(courseDto);
        return courseRepository.save(course);
    }
    
    @Override
    public Course updateCourse(Long courseId, CourseDto courseDto) {
        Optional<Course> existingCourse = courseRepository.findById(courseId);
        if (existingCourse.isPresent()) {
            Course course = existingCourse.get();
            course.setName(courseDto.getName());
            course.setCredits(courseDto.getCredits());
            course.setDescription(courseDto.getDescription());
            return courseRepository.save(course);
        }
        throw new RuntimeException("Course not found with id: " + courseId);
    }
    
    @Override
    public void deleteCourse(Long courseId) {
        if (!courseRepository.existsById(courseId)) {
            throw new RuntimeException("Course not found with id: " + courseId);
        }
        courseRepository.deleteById(courseId);
    }
    
    // Helper method to convert CourseDto to Course entity
    private Course convertToEntity(CourseDto dto) {
        Course course = new Course();
        course.setName(dto.getName());
        course.setCredits(dto.getCredits());
        course.setDescription(dto.getDescription());
        return course;
    }
}
