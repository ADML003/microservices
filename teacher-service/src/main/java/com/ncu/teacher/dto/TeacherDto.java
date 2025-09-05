package com.ncu.teacher.dto;

public class TeacherDto {
    private String name;
    private String teacherId;
    private String department;
    private String email;
    private String phone;

    // Constructors
    public TeacherDto() {}

    public TeacherDto(String name, String teacherId, String department, String email, String phone) {
        this.name = name;
        this.teacherId = teacherId;
        this.department = department;
        this.email = email;
        this.phone = phone;
    }

    // Getters and Setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getTeacherId() { return teacherId; }
    public void setTeacherId(String teacherId) { this.teacherId = teacherId; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}
