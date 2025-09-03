-- Enrollment Service Database Setup
CREATE DATABASE IF NOT EXISTS enrollment_db;
USE enrollment_db;

-- Create enrollments table
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'ACTIVE',
    grade VARCHAR(5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_enrollment (student_id, course_id)
);

-- Insert sample data
INSERT INTO enrollments (student_id, course_id, teacher_id, status) VALUES
(1, 1, 1, 'ACTIVE'),
(1, 2, 2, 'ACTIVE'),
(2, 1, 1, 'ACTIVE'),
(2, 3, 3, 'ACTIVE'),
(3, 2, 2, 'ACTIVE'),
(3, 4, 4, 'ACTIVE'),
(4, 1, 1, 'COMPLETED'),
(4, 5, 5, 'ACTIVE'),
(5, 3, 3, 'ACTIVE'),
(5, 4, 4, 'ACTIVE');

-- Verify data
SELECT * FROM enrollments;
