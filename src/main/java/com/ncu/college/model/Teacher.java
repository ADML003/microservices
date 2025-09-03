package com.ncu.college.model;

public class Teacher {
    private Long teacherId;
    private String name;

    // Constructors
    public Teacher() {}

    public Teacher(Long teacherId, String name) {
        this.teacherId = teacherId;
        this.name = name;
    }

    // Getters and Setters
    public Long getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(Long teacherId) {
        this.teacherId = teacherId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Teacher{" +
                "teacherId=" + teacherId +
                ", name='" + name + '\'' +
                '}';
    }
}
