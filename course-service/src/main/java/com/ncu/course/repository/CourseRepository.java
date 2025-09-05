package com.ncu.course.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.ncu.course.model.Course;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {
    // JpaRepository provides all basic CRUD operations
}
