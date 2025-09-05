package com.ncu.teacher.service;

import java.util.List;
import java.util.Optional;

import com.ncu.teacher.dto.TeacherDto;
import com.ncu.teacher.model.Teacher;

public interface ITeacherService {
    List<Teacher> getAllTeachers();
    Optional<Teacher> getTeacherById(Long id);
    Teacher createTeacher(TeacherDto teacherDto);
    Teacher updateTeacher(Long id, TeacherDto teacherDto);
    void deleteTeacher(Long id);
}
