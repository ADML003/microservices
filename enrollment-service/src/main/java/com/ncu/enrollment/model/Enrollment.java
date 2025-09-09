package com.ncu.enrollment.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;

@Entity
@Table(name = "enrollments")
public class Enrollment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "enrollment_id")
    private Long id;
    
    @Column(name = "course_id", nullable = false)
    private Long courseId;
    
    @Column(name = "student_id", nullable = false)
    private Long studentId;
    
    @Column(name = "teacher_id")
    private Long teacherId;
    
    @Column(name = "status")
    private String status;
    
    @Column(name = "enrollment_date")
    private LocalDateTime enrollmentDate;

    // Constructors
    public Enrollment() {}

    public Enrollment(Long courseId, Long studentId, Long teacherId, String status) {
        this.courseId = courseId;
        this.studentId = studentId;
        this.teacherId = teacherId;
        this.status = status;
        this.enrollmentDate = LocalDateTime.now();
    }

    @PrePersist
    protected void onCreate() {
        if (enrollmentDate == null) {
            enrollmentDate = LocalDateTime.now();
        }
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getCourseId() { return courseId; }
    public void setCourseId(Long courseId) { this.courseId = courseId; }

    public Long getStudentId() { return studentId; }
    public void setStudentId(Long studentId) { this.studentId = studentId; }

    public Long getTeacherId() { return teacherId; }
    public void setTeacherId(Long teacherId) { this.teacherId = teacherId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getEnrollmentDate() { return enrollmentDate; }
    public void setEnrollmentDate(LocalDateTime enrollmentDate) { this.enrollmentDate = enrollmentDate; }

    @Override
    public String toString() {
        return "Enrollment{" +
                "id=" + id +
                ", courseId=" + courseId +
                ", studentId=" + studentId +
                ", teacherId=" + teacherId +
                ", status='" + status + '\'' +
                ", enrollmentDate=" + enrollmentDate +
                '}';
    }
}
