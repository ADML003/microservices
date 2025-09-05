package com.ncu.teacher.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ncu.teacher.dto.TeacherDto;
import com.ncu.teacher.model.Teacher;
import com.ncu.teacher.repository.TeacherRepository;

@Service
public class TeacherServiceImpl implements ITeacherService {

    @Autowired
    private TeacherRepository teacherRepository;

    @Override
    public List<Teacher> getAllTeachers() {
        return teacherRepository.findAll();
    }

    @Override
    public Optional<Teacher> getTeacherById(Long id) {
        return teacherRepository.findById(id);
    }

    @Override
    public Teacher createTeacher(TeacherDto teacherDto) {
        // Validate input
        if (teacherDto.getName() == null || teacherDto.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Teacher name is required");
        }
        if (teacherDto.getTeacherId() == null || teacherDto.getTeacherId().trim().isEmpty()) {
            throw new IllegalArgumentException("Teacher ID is required");
        }

        // Check if teacher ID already exists
        if (teacherRepository.existsByTeacherId(teacherDto.getTeacherId())) {
            throw new IllegalArgumentException("Teacher ID already exists: " + teacherDto.getTeacherId());
        }

        Teacher teacher = new Teacher();
        teacher.setName(teacherDto.getName());
        teacher.setTeacherId(teacherDto.getTeacherId());
        teacher.setDepartment(teacherDto.getDepartment());
        teacher.setEmail(teacherDto.getEmail());
        teacher.setPhone(teacherDto.getPhone());

        return teacherRepository.save(teacher);
    }

    @Override
    public Teacher updateTeacher(Long id, TeacherDto teacherDto) {
        Optional<Teacher> existingTeacher = teacherRepository.findById(id);
        if (!existingTeacher.isPresent()) {
            throw new RuntimeException("Teacher not found with id: " + id);
        }

        // Validate input
        if (teacherDto.getName() == null || teacherDto.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Teacher name is required");
        }

        Teacher teacher = existingTeacher.get();
        teacher.setName(teacherDto.getName());
        teacher.setDepartment(teacherDto.getDepartment());
        teacher.setEmail(teacherDto.getEmail());
        teacher.setPhone(teacherDto.getPhone());

        return teacherRepository.save(teacher);
    }

    @Override
    public void deleteTeacher(Long id) {
        if (!teacherRepository.existsById(id)) {
            throw new RuntimeException("Teacher not found with id: " + id);
        }
        teacherRepository.deleteById(id);
    }
}
