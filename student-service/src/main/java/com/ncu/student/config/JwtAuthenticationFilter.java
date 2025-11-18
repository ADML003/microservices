package com.ncu.student.config;

import com.ncu.student.service.JwtService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.ArrayList;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtService jwtService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        try {
            // Get Authorization header
            String authHeader = request.getHeader("Authorization");
            
            // Check if header is present and starts with "Bearer "
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                // Extract token
                String token = authHeader.substring(7);
                
                // Validate token
                if (jwtService.validateToken(token) && !jwtService.isTokenExpired(token)) {
                    // Extract user email from token
                    String email = jwtService.extractEmail(token);
                    
                    if (email != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                        // Create authentication object
                        UsernamePasswordAuthenticationToken authentication = 
                            new UsernamePasswordAuthenticationToken(email, null, new ArrayList<>());
                        
                        authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                        
                        // Set authentication in security context
                        SecurityContextHolder.getContext().setAuthentication(authentication);
                        
                        System.out.println("Authenticated user: " + email);
                    }
                } else {
                    System.out.println("Invalid or expired token");
                }
            }
        } catch (Exception e) {
            System.err.println("Error in JWT filter: " + e.getMessage());
        }
        
        // Continue filter chain
        filterChain.doFilter(request, response);
    }
}
