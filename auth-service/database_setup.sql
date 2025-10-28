-- Auth Service Database Setup

-- Create database
CREATE DATABASE IF NOT EXISTS auth_db;
USE auth_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);

-- Sample data (password is 'password123' encrypted with BCrypt)
-- BCrypt hash for 'password123': $2a$10$9Jn3kGP5kZx6P4eHq7lZ4OxXN5ZF8hXZ0Pv4JXy3jN8K3hZ5X0E3W
INSERT INTO users (name, email, password) VALUES
('John Doe', 'john@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8ssC9pzx2GRk8u3d7u'),
('Jane Smith', 'jane@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8ssC9pzx2GRk8u3d7u'),
('Admin User', 'admin@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8ssC9pzx2GRk8u3d7u')
ON DUPLICATE KEY UPDATE name=name;

-- Verify table structure
DESCRIBE users;

-- Show sample data
SELECT id, name, email, created_at FROM users;
