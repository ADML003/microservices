-- Teacher Service Database Setup
CREATE DATABASE IF NOT EXISTS teacher_db;
USE teacher_db;

-- Create teachers table
CREATE TABLE IF NOT EXISTS teachers (
    teacher_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    department VARCHAR(255),
    phone_number VARCHAR(20),
    specialization VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO teachers (name, email, department, phone_number, specialization) VALUES
('Dr. Sarah Johnson', 'sarah.j@university.edu', 'Computer Science', '+1234567800', 'Software Engineering'),
('Prof. Michael Chen', 'michael.c@university.edu', 'Computer Science', '+1234567801', 'Database Systems'),
('Dr. Emily Davis', 'emily.d@university.edu', 'Computer Science', '+1234567802', 'Web Development'),
('Prof. David Wilson', 'david.w@university.edu', 'Computer Science', '+1234567803', 'Algorithms'),
('Dr. Lisa Brown', 'lisa.b@university.edu', 'Computer Science', '+1234567804', 'Data Science');

-- Verify data
SELECT * FROM teachers;
