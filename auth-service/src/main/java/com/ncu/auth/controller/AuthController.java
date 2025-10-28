package com.ncu.auth.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ncu.auth.dto.AuthDto;
import com.ncu.auth.dto.ReturnDto;
import com.ncu.auth.dto.SignUpDto;
import com.ncu.auth.service.AuthService;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/signup")
    public ResponseEntity<ReturnDto> signUp(@RequestBody SignUpDto signUpDto) {
        try {
            System.out.println("POST: Signup request for email: " + signUpDto.getEmail());
            ReturnDto response = authService.signUp(signUpDto);
            
            if (response.getStatus().contains("successful")) {
                return ResponseEntity.ok(response);
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
        } catch (Exception e) {
            System.err.println("Error during signup: " + e.getMessage());
            ReturnDto errorResponse = new ReturnDto("Error: " + e.getMessage(), signUpDto.getEmail());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @PostMapping("/authenticate")
    public ResponseEntity<ReturnDto> authenticate(@RequestBody AuthDto authDto) {
        try {
            System.out.println("POST: Authentication request for email: " + authDto.getEmail());
            boolean isAuthenticated = authService.authenticate(authDto);
            
            ReturnDto response = new ReturnDto();
            response.setEmail(authDto.getEmail());
            
            if (isAuthenticated) {
                response.setStatus("success");
                return ResponseEntity.ok(response);
            } else {
                response.setStatus("Invalid credentials");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
        } catch (Exception e) {
            System.err.println("Error during authentication: " + e.getMessage());
            ReturnDto errorResponse = new ReturnDto("error", authDto.getEmail());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        }
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Auth Service is running");
    }
}
