-- Student Service Database Setup
CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;

-- Create students table
CREATE TABLE IF NOT EXISTS students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INT,
    address VARCHAR(500),
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO students (name, email, age, address, phone_number) VALUES
('John Doe', 'john@example.com', 20, '123 Main St', '+1234567890'),
('Jane Smith', 'jane@example.com', 22, '456 Oak Ave', '+1234567891'),
('Alice Johnson', 'alice@example.com', 21, '789 Pine Rd', '+1234567892'),
('Bob Wilson', 'bob@example.com', 23, '321 Elm St', '+1234567893'),
('Charlie Brown', 'charlie@example.com', 19, '654 Maple Dr', '+1234567894');

-- Verify data
SELECT * FROM students;
