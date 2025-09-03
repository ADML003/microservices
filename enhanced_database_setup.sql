-- 🔄 Updated Database Setup Script for Enhanced Microservices
-- This script updates the existing database structure to support new microservices

USE student_management;

-- Update courses table to match our Course model
DROP TABLE IF EXISTS courses;
CREATE TABLE courses (
    course_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_course_name (name)
);

-- Update teachers table to match our Teacher model
DROP TABLE IF EXISTS teachers;
CREATE TABLE teachers (
    teacher_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_teacher_name (name)
);

-- Update enrollments table to match our Enrollment model
DROP TABLE IF EXISTS enrollments;
CREATE TABLE enrollments (
    enrollment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    course_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_course_id (course_id),
    INDEX idx_student_id (student_id),
    INDEX idx_teacher_id (teacher_id),
    UNIQUE KEY unique_enrollment (student_id, course_id, teacher_id)
);

-- Insert sample courses
INSERT INTO courses (name, credits) VALUES
('Introduction to Computer Science', 3),
('Data Structures and Algorithms', 4),
('Calculus I', 4),
('General Physics', 3),
('English Composition', 3),
('Database Management Systems', 3),
('Software Engineering', 4),
('Operating Systems', 3),
('Computer Networks', 3),
('Artificial Intelligence', 4);

-- Insert sample teachers
INSERT INTO teachers (name) VALUES
('Prof. John Smith'),
('Dr. Emily Johnson'),
('Prof. Michael Williams'),
('Dr. Sarah Brown'),
('Prof. David Davis'),
('Dr. Lisa Wilson'),
('Prof. Robert Taylor'),
('Dr. Jennifer Anderson'),
('Prof. Christopher Martinez'),
('Dr. Amanda Garcia');

-- Insert sample enrollments (linking students, courses, and teachers)
INSERT INTO enrollments (course_id, student_id, teacher_id) VALUES
-- Computer Science courses
(1, 1, 1),  -- John Doe in Intro CS with Prof. Smith
(1, 2, 1),  -- Jane Smith in Intro CS with Prof. Smith
(1, 3, 1),  -- Alice Johnson in Intro CS with Prof. Smith
(2, 1, 2),  -- John Doe in Data Structures with Dr. Johnson
(2, 4, 2),  -- Bob Wilson in Data Structures with Dr. Johnson
(6, 2, 1),  -- Jane Smith in Database Management with Prof. Smith
(7, 3, 2),  -- Alice Johnson in Software Engineering with Dr. Johnson

-- Math courses
(3, 1, 3),  -- John Doe in Calculus with Prof. Williams
(3, 5, 3),  -- Charlie Brown in Calculus with Prof. Williams
(3, 6, 3),  -- Diana Prince in Calculus with Prof. Williams

-- Physics courses
(4, 4, 4),  -- Bob Wilson in Physics with Dr. Brown
(4, 7, 4),  -- Edward Norton in Physics with Dr. Brown

-- English courses
(5, 5, 5),  -- Charlie Brown in English with Prof. Davis
(5, 8, 5),  -- Fiona Davis in English with Prof. Davis
(5, 9, 5),  -- George Miller in English with Prof. Davis

-- Advanced CS courses
(8, 6, 6),  -- Diana Prince in Operating Systems with Dr. Wilson
(9, 7, 7),  -- Edward Norton in Networks with Prof. Taylor
(10, 8, 8); -- Fiona Davis in AI with Dr. Anderson

-- Create view for enrollment details with all related information
CREATE OR REPLACE VIEW enrollment_details AS
SELECT 
    e.enrollment_id,
    e.student_id,
    s.name AS student_name,
    s.email AS student_email,
    e.course_id,
    c.name AS course_name,
    c.credits AS course_credits,
    e.teacher_id,
    t.name AS teacher_name,
    e.created_at AS enrollment_date
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN courses c ON e.course_id = c.course_id
JOIN teachers t ON e.teacher_id = t.teacher_id
ORDER BY e.enrollment_id;

-- Display setup completion message
SELECT 'Enhanced microservices database setup completed!' as Status;

-- Show statistics
SELECT 
    'Updated Statistics:' as Info,
    (SELECT COUNT(*) FROM students) as Total_Students,
    (SELECT COUNT(*) FROM courses) as Total_Courses,
    (SELECT COUNT(*) FROM teachers) as Total_Teachers,
    (SELECT COUNT(*) FROM enrollments) as Total_Enrollments;

-- Show sample enrollment details
SELECT 'Sample Enrollment Details:' as Info;
SELECT * FROM enrollment_details LIMIT 10;
