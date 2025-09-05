package com.ncu.enrollment.service;

import java.util.List;
import java.util.Optional;

import com.ncu.enrollment.dto.EnrollmentDto;
import com.ncu.enrollment.model.Enrollment;

public interface IEnrollmentService {
    List<Enrollment> getAllEnrollments();
    Optional<Enrollment> getEnrollmentById(Long id);
    Enrollment createEnrollment(EnrollmentDto enrollmentDto);
    Enrollment updateEnrollment(Long id, EnrollmentDto enrollmentDto);
    void deleteEnrollment(Long id);
    List<Enrollment> getEnrollmentsByCourseId(Long courseId);
    List<Enrollment> getEnrollmentsByStudentId(Long studentId);
    List<Enrollment> getEnrollmentsByTeacherId(Long teacherId);
}
