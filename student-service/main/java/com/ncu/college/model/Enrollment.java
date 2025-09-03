package com.ncu.college.model;

public class Enrollment {
    private Long enrollmentId;
    private Long courseId;
    private Long studentId;
    private Long teacherId;

    // Constructors
    public Enrollment() {}

    public Enrollment(Long enrollmentId, Long courseId, Long studentId, Long teacherId) {
        this.enrollmentId = enrollmentId;
        this.courseId = courseId;
        this.studentId = studentId;
        this.teacherId = teacherId;
    }

    // Getters and Setters
    public Long getEnrollmentId() {
        return enrollmentId;
    }

    public void setEnrollmentId(Long enrollmentId) {
        this.enrollmentId = enrollmentId;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public Long getStudentId() {
        return studentId;
    }

    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }

    public Long getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(Long teacherId) {
        this.teacherId = teacherId;
    }

    @Override
    public String toString() {
        return "Enrollment{" +
                "enrollmentId=" + enrollmentId +
                ", courseId=" + courseId +
                ", studentId=" + studentId +
                ", teacherId=" + teacherId +
                '}';
    }
}
