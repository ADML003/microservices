package com.ncu.course.service;

import java.util.List;
import java.util.Optional;

import com.ncu.course.dto.CourseDto;
import com.ncu.course.model.Course;

public interface ICourseService {
    List<Course> getAllCourses();
    Optional<Course> getCourseById(Long courseId);
    Course createCourse(CourseDto courseDto);
    Course updateCourse(Long courseId, CourseDto courseDto);
    void deleteCourse(Long courseId);
}
