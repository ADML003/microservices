package com.ncu.enrollment.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ncu.enrollment.dto.EnrollmentDto;
import com.ncu.enrollment.model.Enrollment;
import com.ncu.enrollment.repository.EnrollmentRepository;

@Service
public class EnrollmentServiceImpl implements IEnrollmentService {
    
    @Autowired
    private EnrollmentRepository enrollmentRepository;
    
    @Override
    public List<Enrollment> getAllEnrollments() {
        return enrollmentRepository.findAll();
    }
    
    @Override
    public Optional<Enrollment> getEnrollmentById(Long id) {
        return enrollmentRepository.findById(id);
    }
    
    @Override
    public Enrollment createEnrollment(EnrollmentDto enrollmentDto) {
        // Validate input
        if (enrollmentDto.getCourseId() == null) {
            throw new IllegalArgumentException("Course ID is required");
        }
        if (enrollmentDto.getStudentId() == null) {
            throw new IllegalArgumentException("Student ID is required");
        }
        
        // Check if enrollment already exists
        if (enrollmentRepository.existsByCourseIdAndStudentId(
                enrollmentDto.getCourseId(), enrollmentDto.getStudentId())) {
            throw new IllegalArgumentException("Student is already enrolled in this course");
        }
        
        Enrollment enrollment = convertToEntity(enrollmentDto);
        return enrollmentRepository.save(enrollment);
    }
    
    @Override
    public Enrollment updateEnrollment(Long id, EnrollmentDto enrollmentDto) {
        Optional<Enrollment> existingEnrollment = enrollmentRepository.findById(id);
        if (!existingEnrollment.isPresent()) {
            throw new RuntimeException("Enrollment not found with id: " + id);
        }
        
        Enrollment enrollment = existingEnrollment.get();
        enrollment.setStatus(enrollmentDto.getStatus());
        enrollment.setTeacherId(enrollmentDto.getTeacherId());
        
        return enrollmentRepository.save(enrollment);
    }
    
    @Override
    public void deleteEnrollment(Long id) {
        if (!enrollmentRepository.existsById(id)) {
            throw new RuntimeException("Enrollment not found with id: " + id);
        }
        enrollmentRepository.deleteById(id);
    }
    
    @Override
    public List<Enrollment> getEnrollmentsByCourseId(Long courseId) {
        return enrollmentRepository.findByCourseId(courseId);
    }
    
    @Override
    public List<Enrollment> getEnrollmentsByStudentId(Long studentId) {
        return enrollmentRepository.findByStudentId(studentId);
    }
    
    @Override
    public List<Enrollment> getEnrollmentsByTeacherId(Long teacherId) {
        return enrollmentRepository.findByTeacherId(teacherId);
    }
    
    // Helper method to convert EnrollmentDto to Enrollment entity
    private Enrollment convertToEntity(EnrollmentDto dto) {
        Enrollment enrollment = new Enrollment();
        enrollment.setCourseId(dto.getCourseId());
        enrollment.setStudentId(dto.getStudentId());
        enrollment.setTeacherId(dto.getTeacherId());
        enrollment.setStatus(dto.getStatus() != null ? dto.getStatus() : "ACTIVE");
        return enrollment;
    }
}
