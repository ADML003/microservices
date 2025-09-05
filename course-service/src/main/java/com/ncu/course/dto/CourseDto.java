package com.ncu.course.dto;

public class CourseDto {
    private Long courseId;
    private String name;
    private Integer credits;
    private String description;

    // Constructors
    public CourseDto() {}

    public CourseDto(String name, Integer credits, String description) {
        this.name = name;
        this.credits = credits;
        this.description = description;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "CourseDto{" +
                "courseId=" + courseId +
                ", name='" + name + '\'' +
                ", credits=" + credits +
                ", description='" + description + '\'' +
                '}';
    }
}
