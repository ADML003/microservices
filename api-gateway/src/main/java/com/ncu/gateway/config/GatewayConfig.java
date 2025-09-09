package com.ncu.gateway.config;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // Student Service Routes
                .route("student-service", r -> r.path("/api/students/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("lb://student-service"))
                
                // Course Service Routes
                .route("course-service", r -> r.path("/api/courses/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("lb://course-service"))
                
                // Teacher Service Routes
                .route("teacher-service", r -> r.path("/api/teachers/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("lb://teacher-service"))
                
                // Enrollment Service Routes
                .route("enrollment-service", r -> r.path("/api/enrollments/**")
                        .filters(f -> f.stripPrefix(1))
                        .uri("lb://enrollment-service"))
                
                // Health check routes (direct access without API prefix)
                .route("student-health", r -> r.path("/students/health")
                        .uri("lb://student-service"))
                .route("course-health", r -> r.path("/courses/health")
                        .uri("lb://course-service"))
                .route("teacher-health", r -> r.path("/teachers/health")
                        .uri("lb://teacher-service"))
                .route("enrollment-health", r -> r.path("/enrollments/health")
                        .uri("lb://enrollment-service"))
                
                .build();
    }
}
