package com.ncu.auth.repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.ncu.auth.dto.SignUpDto;

@Repository
public class AuthRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public boolean signUp(SignUpDto signUpDto) {
        try {
            String sql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
            jdbcTemplate.update(sql, signUpDto.getName(), signUpDto.getEmail(), signUpDto.getPassword());
            return true;
        } catch (Exception e) {
            System.err.println("Error during user signup: " + e.getMessage());
            return false;
        }
    }

    public String getPasswordByEmail(String email) {
        try {
            String sql = "SELECT password FROM users WHERE email = ?";
            return jdbcTemplate.queryForObject(sql, String.class, email);
        } catch (Exception e) {
            System.err.println("Error fetching password for email " + email + ": " + e.getMessage());
            return null;
        }
    }

    public boolean emailExists(String email) {
        try {
            String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
            return count != null && count > 0;
        } catch (Exception e) {
            return false;
        }
    }
}
