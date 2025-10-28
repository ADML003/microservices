package com.ncu.auth.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.ncu.auth.dto.AuthDto;
import com.ncu.auth.dto.ReturnDto;
import com.ncu.auth.dto.SignUpDto;
import com.ncu.auth.repository.AuthRepository;

@Service
public class AuthService {

    @Autowired
    private AuthRepository authRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public ReturnDto signUp(SignUpDto signUpDto) {
        ReturnDto response = new ReturnDto();
        
        // Validate email format
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (!signUpDto.getEmail().matches(emailRegex)) {
            response.setStatus("User registration failed: Invalid email format");
            response.setEmail(signUpDto.getEmail());
            return response;
        }
        
        // Check if email already exists
        if (authRepository.emailExists(signUpDto.getEmail())) {
            response.setStatus("User registration failed: Email already exists");
            response.setEmail(signUpDto.getEmail());
            return response;
        }

        // Encrypt password
        signUpDto.setPassword(passwordEncoder.encode(signUpDto.getPassword()));
        
        // Save user
        boolean success = authRepository.signUp(signUpDto);
        
        if (success) {
            response.setStatus("User registration successful");
        } else {
            response.setStatus("User registration failed: Database error");
        }
        response.setEmail(signUpDto.getEmail());
        
        return response;
    }

    public boolean authenticate(AuthDto authDto) {
        try {
            System.out.println("Authenticating user: " + authDto.getEmail());
            String storedPassword = authRepository.getPasswordByEmail(authDto.getEmail());
            System.out.println("Stored password hash: " + storedPassword);
            System.out.println("Input password: " + authDto.getPassword());
            
            if (storedPassword == null) {
                System.out.println("No user found with email: " + authDto.getEmail());
                return false;
            }
            
            boolean matches = passwordEncoder.matches(authDto.getPassword(), storedPassword);
            System.out.println("Password matches: " + matches);
            return matches;
        } catch (Exception e) {
            System.err.println("Error during authentication: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
