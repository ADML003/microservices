package com.ncu.enrollment.dto;

public class EnrollmentDto {
    private Long id;
    private Long courseId;
    private Long studentId;
    private Long teacherId;
    private String status;

    // Constructors
    public EnrollmentDto() {}

    public EnrollmentDto(Long courseId, Long studentId, Long teacherId, String status) {
        this.courseId = courseId;
        this.studentId = studentId;
        this.teacherId = teacherId;
        this.status = status;
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

    @Override
    public String toString() {
        return "EnrollmentDto{" +
                "id=" + id +
                ", courseId=" + courseId +
                ", studentId=" + studentId +
                ", teacherId=" + teacherId +
                ", status='" + status + '\'' +
                '}';
    }
}
