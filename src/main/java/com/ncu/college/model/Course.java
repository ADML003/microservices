package com.ncu.college.model;

public class Course {
    private Long courseId;
    private String name;
    private Integer credits;

    // Constructors
    public Course() {}

    public Course(Long courseId, String name, Integer credits) {
        this.courseId = courseId;
        this.name = name;
        this.credits = credits;
    }

    // Getters and Setters
    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getCredits() {
        return credits;
    }

    public void setCredits(Integer credits) {
        this.credits = credits;
    }

    @Override
    public String toString() {
        return "Course{" +
                "courseId=" + courseId +
                ", name='" + name + '\'' +
                ", credits=" + credits +
                '}';
    }
}
