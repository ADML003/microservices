-- 🗄️ MySQL Database Setup Script for Microservices Application
-- Run this script to set up the complete database structure

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS student_management;

-- Use the database
USE student_management;

-- Drop table if exists (for clean setup)
DROP TABLE IF EXISTS students;

-- Create students table with all required fields
CREATE TABLE students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INT CHECK (age >= 0 AND age <= 150),
    address VARCHAR(500),
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_name (name),
    INDEX idx_age (age)
);

-- Insert comprehensive sample data
INSERT INTO students (name, email, age, address, phone_number) VALUES 
('John Doe', 'john@example.com', 20, '123 Main St, Springfield', '+1234567890'),
('Jane Smith', 'jane@example.com', 22, '456 Oak Ave, Riverside', '+1234567891'),
('Alice Johnson', 'alice@example.com', 21, '789 Pine Rd, Lakewood', '+1234567892'),
('Bob Wilson', 'bob@example.com', 23, '321 Elm St, Hillview', '+1234567893'),
('Charlie Brown', 'charlie@example.com', 19, '654 Maple Dr, Sunset', '+1234567894'),
('Diana Prince', 'diana@example.com', 24, '987 Cedar Ln, Valley View', '+1234567895'),
('Edward Norton', 'edward@example.com', 26, '147 Birch Ave, Mountain View', '+1234567896'),
('Fiona Davis', 'fiona@example.com', 25, '258 Walnut St, Ocean View', '+1234567897'),
('George Miller', 'george@example.com', 27, '369 Ash Rd, Forest Hill', '+1234567898'),
('Helen Clark', 'helen@example.com', 28, '741 Spruce Ct, Green Valley', '+1234567899');

-- Create additional tables for future expansion
CREATE TABLE IF NOT EXISTS courses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    credits INT DEFAULT 3,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS teachers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    department VARCHAR(100),
    salary DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS enrollments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT,
    course_id BIGINT,
    enrollment_date DATE DEFAULT (CURRENT_DATE),
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id)
);

-- Insert sample courses
INSERT INTO courses (course_code, course_name, credits, description) VALUES
('CS101', 'Introduction to Computer Science', 3, 'Basic concepts of programming and computer science'),
('CS201', 'Data Structures and Algorithms', 4, 'Advanced programming concepts and algorithm analysis'),
('MATH101', 'Calculus I', 4, 'Differential and integral calculus'),
('PHYS101', 'General Physics', 3, 'Introduction to mechanics and thermodynamics'),
('ENG101', 'English Composition', 3, 'Academic writing and communication skills');

-- Insert sample teachers
INSERT INTO teachers (name, email, department, salary) VALUES
('Prof. Smith', 'prof.smith@university.edu', 'Computer Science', 75000.00),
('Dr. Johnson', 'dr.johnson@university.edu', 'Mathematics', 68000.00),
('Prof. Williams', 'prof.williams@university.edu', 'Physics', 72000.00),
('Dr. Brown', 'dr.brown@university.edu', 'English', 65000.00),
('Prof. Davis', 'prof.davis@university.edu', 'Computer Science', 78000.00);

-- Insert sample enrollments
INSERT INTO enrollments (student_id, course_id, grade) VALUES
(1, 1, 'A'),   -- John in CS101
(1, 3, 'B+'),  -- John in MATH101
(2, 1, 'A-'),  -- Jane in CS101
(2, 2, 'B'),   -- Jane in CS201
(3, 1, 'A'),   -- Alice in CS101
(3, 4, 'B+'),  -- Alice in PHYS101
(4, 2, 'B-'),  -- Bob in CS201
(4, 3, 'A-'),  -- Bob in MATH101
(5, 1, 'B+'),  -- Charlie in CS101
(5, 5, 'A');   -- Charlie in ENG101

-- Create views for common queries
CREATE VIEW student_summary AS
SELECT 
    s.id,
    s.name,
    s.email,
    s.age,
    COUNT(e.course_id) as enrolled_courses,
    AVG(CASE 
        WHEN e.grade = 'A' THEN 4.0
        WHEN e.grade = 'A-' THEN 3.7
        WHEN e.grade = 'B+' THEN 3.3
        WHEN e.grade = 'B' THEN 3.0
        WHEN e.grade = 'B-' THEN 2.7
        WHEN e.grade = 'C+' THEN 2.3
        WHEN e.grade = 'C' THEN 2.0
        ELSE 1.0
    END) as gpa
FROM students s
LEFT JOIN enrollments e ON s.id = e.student_id
GROUP BY s.id, s.name, s.email, s.age;

-- Create view for course enrollment summary
CREATE VIEW course_enrollment_summary AS
SELECT 
    c.course_code,
    c.course_name,
    c.credits,
    COUNT(e.student_id) as enrolled_students,
    AVG(CASE 
        WHEN e.grade = 'A' THEN 4.0
        WHEN e.grade = 'A-' THEN 3.7
        WHEN e.grade = 'B+' THEN 3.3
        WHEN e.grade = 'B' THEN 3.0
        WHEN e.grade = 'B-' THEN 2.7
        WHEN e.grade = 'C+' THEN 2.3
        WHEN e.grade = 'C' THEN 2.0
        ELSE 1.0
    END) as average_grade
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.course_code, c.course_name, c.credits;

-- Display setup completion message
SELECT 'Database setup completed successfully!' as Status;

-- Display summary statistics
SELECT 
    'Students' as Table_Name, 
    COUNT(*) as Record_Count 
FROM students
UNION ALL
SELECT 
    'Courses' as Table_Name, 
    COUNT(*) as Record_Count 
FROM courses
UNION ALL
SELECT 
    'Teachers' as Table_Name, 
    COUNT(*) as Record_Count 
FROM teachers
UNION ALL
SELECT 
    'Enrollments' as Table_Name, 
    COUNT(*) as Record_Count 
FROM enrollments;

-- Show sample data
SELECT 'Sample Students:' as Info;
SELECT id, name, email, age FROM students LIMIT 5;

SELECT 'Sample Courses:' as Info;
SELECT course_code, course_name, credits FROM courses LIMIT 5;

SELECT 'Student Summary View:' as Info;
SELECT * FROM student_summary LIMIT 5;
