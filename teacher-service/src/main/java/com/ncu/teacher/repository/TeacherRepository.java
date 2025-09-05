package com.ncu.teacher.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.ncu.teacher.model.Teacher;

@Repository
public interface TeacherRepository extends JpaRepository<Teacher, Long> {
    // JpaRepository provides all basic CRUD operations
    boolean existsByTeacherId(String teacherId);
}
