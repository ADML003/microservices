-- Course Service Database Setup
CREATE DATABASE IF NOT EXISTS course_management;
USE course_management;

-- Create courses table
CREATE TABLE IF NOT EXISTS courses (
    course_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    credits INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO courses (name, credits, description) VALUES
('Computer Science Fundamentals', 4, 'Introduction to programming and CS concepts'),
('Database Management Systems', 3, 'Relational databases and SQL'),
('Web Development', 3, 'HTML, CSS, JavaScript and frameworks'),
('Data Structures and Algorithms', 4, 'Core CS data structures and algorithms'),
('Software Engineering', 3, 'Software development lifecycle and practices');

-- Verify data
SELECT * FROM courses;
