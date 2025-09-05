package com.ncu.enrollment.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ncu.enrollment.model.Enrollment;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {
    // JpaRepository provides all basic CRUD operations
    List<Enrollment> findByCourseId(Long courseId);
    List<Enrollment> findByStudentId(Long studentId);
    List<Enrollment> findByTeacherId(Long teacherId);
    boolean existsByCourseIdAndStudentId(Long courseId, Long studentId);
}
