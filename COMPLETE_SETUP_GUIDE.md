# 🎯 Complete Microservices Application Setup & Testing Guide

## 📑 Table of Contents

1. [Project Overview](#-project-overview)
2. [Prerequisites](#-prerequisites)
3. [Database Setup](#-database-setup)
4. [Running the Applications](#-running-the-applications)
5. [Testing Database Connectivity](#-testing-database-connectivity)
6. [API Testing with Postman](#-api-testing-with-postman)
7. [Managing Database via Terminal](#-managing-database-via-terminal)
8. [Microservices Architecture](#-microservices-architecture)
9. [Troubleshooting](#-troubleshooting)

---

## 🚀 Project Overview

This is a Spring Boot Student Management application with the following component:

- **Student Service** (Port 8585) - Full CRUD operations with MySQL database

---

## 🔧 Prerequisites

### Required Software:

1. **Java 22** (JDK 22 or later)
2. **Maven 3.6+**
3. **MySQL 8.0+**
4. **Postman** (for API testing)
5. **Terminal/Command Prompt**

### Verify Installation:

```bash
# Check Java version
java -version

# Check Maven version
mvn -version

# Check MySQL version
mysql --version
```

---

## 🗄️ Database Setup

### 1. Install MySQL

```bash
# macOS (using Homebrew)
brew install mysql
brew services start mysql

# Linux (Ubuntu/Debian)
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql

# Windows
# Download MySQL installer from https://dev.mysql.com/downloads/mysql/
```

### 2. Create Database and Table

```sql
-- Connect to MySQL as root
mysql -u root -p

-- Create database
CREATE DATABASE student_management;

-- Use the database
USE student_management;

-- Create students table
CREATE TABLE students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INT,
    address VARCHAR(500),
    phone_number VARCHAR(20)
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
```

### 3. Database Configuration

The application is configured to connect to:

- **Database**: `student_management`
- **Host**: `localhost:3306`
- **Username**: `root`
- **Password**: ``(empty - update in`application.properties` if needed)

---

## ▶️ Running the Applications

### Option 2: Run as JAR files

```bash
# Navigate to project root
cd "/Users/ADML/Desktop/microservices "

# Compile the project
mvn clean compile

# Run the student application (Port 8585)
mvn spring-boot:run
```

```bash
# Build JAR files
mvn clean package

# Run the student application
java -jar target/studentservice-1.0-SNAPSHOT.jar
```

---

## 🔍 Testing Database Connectivity

### 1. Quick Database Test Endpoints

Once the main application is running (Port 8585), test these endpoints:

```bash
# Test SQL connection
curl http://localhost:8585/test/sql-connection

# Get database info
curl http://localhost:8585/test/database-info

# Get students directly from database
curl http://localhost:8585/test/students-direct
```

### 2. Expected Responses

**Successful Connection:**

```
✅ SQL Connection Test SUCCESSFUL! Found 5 students in MySQL database.
```

**Database Info:**

```
🗄️ Database: MySQL student_management
📊 Total Students: 5
🔗 JDBC Connection: Active
🏗️ JPA/Hibernate: Working
📝 Sample Student: John Doe
```

---

## 📮 API Testing with Postman

### 1. Import Postman Collection

Create a new collection in Postman with these requests:

### 2. Student Service API (Port 8585)

#### GET - Fetch All Students

```
Method: GET
URL: http://localhost:8585/students
Headers: Content-Type: application/json
```

#### GET - Fetch Student by ID

```
Method: GET
URL: http://localhost:8585/students/1
Headers: Content-Type: application/json
```

#### POST - Create New Student

```
Method: POST
URL: http://localhost:8585/students
Headers: Content-Type: application/json
Body (raw JSON):
{
    "name": "David Miller",
    "email": "david@example.com",
    "age": 25,
    "address": "999 Broadway St",
    "phoneNumber": "+1234567899"
}
```

#### PUT - Update Student

```
Method: PUT
URL: http://localhost:8585/students/1
Headers: Content-Type: application/json
Body (raw JSON):
{
    "name": "John Doe Updated",
    "email": "john.updated@example.com",
    "age": 21,
    "address": "123 Updated St",
    "phoneNumber": "+1234567800"
}
```

#### DELETE - Remove Student

```
Method: DELETE
URL: http://localhost:8585/students/1
Headers: Content-Type: application/json
```

### 3. Testing Tips

For effective testing:

- Start with the database connectivity test
- Verify GET endpoints before testing POST/PUT
- Use the provided JSON templates for POST/PUT requests
- Check the application logs if any endpoint fails

### 4. Sample Postman Test Scripts

Add this to the "Tests" tab in Postman:

```javascript
// Test for successful response
pm.test("Status code is 200", function () {
  pm.response.to.have.status(200);
});

// Test response time
pm.test("Response time is less than 1000ms", function () {
  pm.expect(pm.response.responseTime).to.be.below(1000);
});

// Test for JSON response
pm.test("Response is JSON", function () {
  pm.response.to.be.json;
});

// For GET all students - test array response
pm.test("Students array is returned", function () {
  const jsonData = pm.response.json();
  pm.expect(jsonData).to.be.an("array");
});
```

---

## 💻 Managing Database via Terminal

### 1. Connect to MySQL

```bash
# Connect as root user
mysql -u root -p

# Connect with specific database
mysql -u root -p student_management
```

### 2. Basic Database Operations

```sql
-- Show all databases
SHOW DATABASES;

-- Use student_management database
USE student_management;

-- Show all tables
SHOW TABLES;

-- Describe table structure
DESCRIBE students;

-- View all students
SELECT * FROM students;

-- View students with specific criteria
SELECT * FROM students WHERE age > 20;
SELECT * FROM students WHERE name LIKE '%John%';

-- Count total students
SELECT COUNT(*) FROM students;

-- Insert new student
INSERT INTO students (name, email, age, address, phone_number)
VALUES ('New Student', 'new@example.com', 24, 'New Address', '+1111111111');

-- Update student
UPDATE students
SET age = 26
WHERE id = 1;

-- Delete student
DELETE FROM students WHERE id = 6;
```

### 3. Advanced Database Queries

```sql
-- Students by age range
SELECT * FROM students WHERE age BETWEEN 20 AND 22;

-- Students sorted by age
SELECT * FROM students ORDER BY age DESC;

-- Get average age
SELECT AVG(age) as average_age FROM students;

-- Group by age
SELECT age, COUNT(*) as count FROM students GROUP BY age;

-- Find duplicate emails (should be none due to UNIQUE constraint)
SELECT email, COUNT(*) FROM students GROUP BY email HAVING COUNT(*) > 1;
```

### 4. Database Backup and Restore

```bash
# Backup database
mysqldump -u root -p student_management > student_backup.sql

# Restore database
mysql -u root -p student_management < student_backup.sql

# Backup only data (no structure)
mysqldump -u root -p --no-create-info student_management > data_only.sql

# Backup only structure (no data)
mysqldump -u root -p --no-data student_management > structure_only.sql
```

### 5. Monitor Database Performance

```sql
-- Show running processes
SHOW PROCESSLIST;

-- Show database status
SHOW STATUS LIKE 'Conn%';

-- Show table sizes
SELECT
    table_name AS "Table",
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)"
FROM information_schema.TABLES
WHERE table_schema = 'student_management';
```

---

## 🏗️ Student Management Application

### Service Overview:

| Service         | Port | Purpose              | Database |
| --------------- | ---- | -------------------- | -------- |
| Student Service | 8585 | Full CRUD with MySQL | ✅ MySQL |

### Application Features:

- ✅ Full CRUD operations
- ✅ MySQL database integration
- ✅ RESTful API endpoints
- ✅ Database connection testing
- ✅ Error handling
- ✅ Data validation

---

## 🔧 Troubleshooting

### Common Issues and Solutions:

#### 1. MySQL Connection Failed

```bash
# Check if MySQL is running
brew services list | grep mysql  # macOS
sudo systemctl status mysql      # Linux

# Start MySQL service
brew services start mysql        # macOS
sudo systemctl start mysql       # Linux

# Check MySQL connection
mysql -u root -p -e "SELECT 1"
```

#### 2. Port Already in Use

```bash
# Find process using port
lsof -i :8585
netstat -tulpn | grep :8585

# Kill process
kill -9 <PID>
```

#### 3. Database Access Denied

```sql
-- Reset MySQL root password
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
FLUSH PRIVILEGES;
```

#### 4. Maven Build Issues

```bash
# Clean and rebuild
mvn clean install -U

# Skip tests if needed
mvn clean install -DskipTests

# Check Java version compatibility
mvn -version
java -version
```

#### 5. Application Startup Issues

```bash
# Check logs for errors
tail -f app.log

# Increase memory if needed
export MAVEN_OPTS="-Xmx1024m"
mvn spring-boot:run
```

### Debug Mode:

```bash
# Run with debug logging
mvn spring-boot:run -Dspring.profiles.active=debug

# Enable SQL logging (add to application.properties)
logging.level.org.springframework.jdbc.core=DEBUG
```

---

## 📝 Quick Start Checklist

- [ ] Java 22 installed
- [ ] Maven installed
- [ ] MySQL installed and running
- [ ] Database `student_management` created
- [ ] Table `students` created with sample data
- [ ] Main application running on port 8585
- [ ] Database connectivity tested via `/test/sql-connection`
- [ ] Postman collection created and tested
- [ ] All CRUD operations verified
- [ ] Database accessed via terminal

---

## 📚 Additional Resources

### Useful Commands Reference:

```bash
# Application Management
mvn spring-boot:run                    # Run application
mvn clean package                      # Build JAR
java -jar target/app.jar              # Run JAR

# Database Management
mysql -u root -p                      # Connect to MySQL
mysqldump -u root -p db_name > backup.sql  # Backup
mysql -u root -p db_name < backup.sql      # Restore

# Network & Process Management
lsof -i :PORT                         # Check port usage
netstat -tulpn | grep :PORT          # Check port (Linux)
curl -X GET http://localhost:8585/students  # Test API
```

### Log Files:

- Application logs: `app.log` (in project root)
- MySQL logs: Check MySQL configuration for log location
- Spring Boot logs: Console output during `mvn spring-boot:run`

---

**🎉 Congratulations! Your microservices application is now fully configured and ready for development and testing.**

For any issues, check the troubleshooting section or review the application logs for detailed error messages.
