# 🏗️ Microservices Architecture - Complete Setup Guide

## 📋 **Service Overview**

This project consists of 4 independent microservices, each with its own database and running on different ports:

| Service            | Port | Database              | Purpose                                          |
| ------------------ | ---- | --------------------- | ------------------------------------------------ |
| Student Service    | 8585 | student_management    | Manage student data                              |
| Course Service     | 8586 | course_management     | Manage course data                               |
| Teacher Service    | 8587 | teacher_management    | Manage teacher data                              |
| Enrollment Service | 8588 | enrollment_management | Manage enrollments & inter-service communication |

## 📁 **Project Structure**

```
microservices/
├── student-service/              # Port 8585
│   ├── src/main/java/com/ncu/student/
│   │   ├── model/Student.java
│   │   ├── dto/StudentDto.java
│   │   ├── repository/StudentRepository.java
│   │   ├── service/IStudentService.java
│   │   ├── service/StudentServiceImpl.java
│   │   ├── controller/StudentController.java
│   │   └── StudentServiceApplication.java
│   ├── src/main/resources/application.properties
│   ├── pom.xml
│   └── database_setup.sql
│
├── course-service/               # Port 8586
│   ├── src/main/java/com/ncu/course/
│   │   ├── model/Course.java
│   │   ├── dto/CourseDto.java
│   │   ├── repository/CourseRepository.java
│   │   ├── service/ICourseService.java
│   │   ├── service/CourseServiceImpl.java
│   │   ├── controller/CourseController.java
│   │   └── CourseServiceApplication.java
│   ├── src/main/resources/application.properties
│   ├── pom.xml
│   └── database_setup.sql
│
├── teacher-service/              # Port 8587
│   ├── src/main/java/com/ncu/teacher/
│   │   ├── model/Teacher.java
│   │   ├── dto/TeacherDto.java
│   │   ├── repository/TeacherRepository.java
│   │   ├── service/ITeacherService.java
│   │   ├── service/TeacherServiceImpl.java
│   │   ├── controller/TeacherController.java
│   │   └── TeacherServiceApplication.java
│   ├── src/main/resources/application.properties
│   ├── pom.xml
│   └── database_setup.sql
│
└── enrollment-service/           # Port 8588
    ├── src/main/java/com/ncu/enrollment/
    │   ├── model/Enrollment.java
    │   ├── dto/EnrollmentDto.java
    │   ├── repository/EnrollmentRepository.java
    │   ├── service/IEnrollmentService.java
    │   ├── service/EnrollmentServiceImpl.java
    │   ├── controller/EnrollmentController.java
    │   ├── config/RestTemplateConfig.java
    │   └── EnrollmentServiceApplication.java
    ├── src/main/resources/application.properties
    ├── pom.xml
    └── database_setup.sql
```

## 🛢️ **Database Architecture**

Each service has its own isolated MySQL database:

### 1. **Student Management Database** (Port 8585)

```sql
Database: student_management
Table: students
- id (BIGINT, PRIMARY KEY, AUTO_INCREMENT)
- name (VARCHAR(255))
- email (VARCHAR(255), UNIQUE)
- age (INT)
- address (VARCHAR(500))
- phone_number (VARCHAR(20))
```

### 2. **Course Management Database** (Port 8586)

```sql
Database: course_management
Table: courses
- course_id (BIGINT, PRIMARY KEY, AUTO_INCREMENT)
- name (VARCHAR(255))
- credits (INT)
- description (TEXT)
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

### 3. **Teacher Management Database** (Port 8587)

```sql
Database: teacher_management
Table: teachers
- teacher_id (BIGINT, PRIMARY KEY, AUTO_INCREMENT)
- name (VARCHAR(255))
- email (VARCHAR(255), UNIQUE)
- department (VARCHAR(255))
- phone_number (VARCHAR(20))
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)
```

### 4. **Enrollment Management Database** (Port 8588)

```sql
Database: enrollment_management
Table: enrollments
- id (BIGINT, PRIMARY KEY, AUTO_INCREMENT)
- course_id (BIGINT) -- Reference to Course Service
- student_id (BIGINT) -- Reference to Student Service
- teacher_id (BIGINT) -- Reference to Teacher Service
- enrollment_date (TIMESTAMP)
- status (VARCHAR(50)) -- ACTIVE, COMPLETED, DROPPED
```

## 🔄 **Inter-Service Communication**

The Enrollment Service acts as an orchestrator and communicates with other services via REST APIs:

### **Communication Flow:**

```
Enrollment Service (8588)
    ↓ GET /students/{id}
Student Service (8585)
    ↓ GET /courses/{id}
Course Service (8586)
    ↓ GET /teachers/{id}
Teacher Service (8587)
```

### **Example API Calls:**

```java
// Enrollment Service calling other services
Student student = restTemplate.getForObject("http://localhost:8585/students/" + studentId, Student.class);
Course course = restTemplate.getForObject("http://localhost:8586/courses/" + courseId, Course.class);
Teacher teacher = restTemplate.getForObject("http://localhost:8587/teachers/" + teacherId, Teacher.class);
```

## 🚀 **How to Run All Services**

### **1. Setup Databases (Run these SQL commands):**

```bash
# Student Service Database
mysql -u root -p -e "CREATE DATABASE student_management;"
mysql -u root -p student_management < student-service/database_setup.sql

# Course Service Database
mysql -u root -p -e "CREATE DATABASE course_management;"
mysql -u root -p course_management < course-service/database_setup.sql

# Teacher Service Database
mysql -u root -p -e "CREATE DATABASE teacher_management;"
mysql -u root -p teacher_management < teacher-service/database_setup.sql

# Enrollment Service Database
mysql -u root -p -e "CREATE DATABASE enrollment_management;"
mysql -u root -p enrollment_management < enrollment-service/database_setup.sql
```

### **2. Start Services (Each in separate terminal):**

**Terminal 1 - Student Service:**

```bash
cd student-service
mvn spring-boot:run
# Runs on http://localhost:8585
```

**Terminal 2 - Course Service:**

```bash
cd course-service
mvn spring-boot:run
# Runs on http://localhost:8586
```

**Terminal 3 - Teacher Service:**

```bash
cd teacher-service
mvn spring-boot:run
# Runs on http://localhost:8587
```

**Terminal 4 - Enrollment Service:**

```bash
cd enrollment-service
mvn spring-boot:run
# Runs on http://localhost:8588
```

## 🧪 **Testing the APIs**

### **Student Service (Port 8585):**

```bash
# Get all students
curl http://localhost:8585/students

# Get student by ID
curl http://localhost:8585/students/1

# Create new student
curl -X POST http://localhost:8585/students \
-H "Content-Type: application/json" \
-d '{"name":"John Doe","email":"john@example.com","age":20}'
```

### **Course Service (Port 8586):**

```bash
# Get all courses
curl http://localhost:8586/courses

# Create new course
curl -X POST http://localhost:8586/courses \
-H "Content-Type: application/json" \
-d '{"name":"Java Programming","credits":3,"description":"Learn Java"}'
```

### **Teacher Service (Port 8587):**

```bash
# Get all teachers
curl http://localhost:8587/teachers

# Create new teacher
curl -X POST http://localhost:8587/teachers \
-H "Content-Type: application/json" \
-d '{"name":"Prof. Smith","email":"smith@university.edu","department":"Computer Science"}'
```

### **Enrollment Service (Port 8588):**

```bash
# Create enrollment (links student, course, teacher)
curl -X POST http://localhost:8588/enrollments \
-H "Content-Type: application/json" \
-d '{"studentId":1,"courseId":1,"teacherId":1}'

# Get enrollment with full details
curl http://localhost:8588/enrollments/1/details
```

## 🎯 **Key Benefits of This Architecture**

1. **🔒 Data Isolation:** Each service has its own database
2. **📈 Independent Scaling:** Scale services based on load
3. **🛠️ Technology Flexibility:** Different tech stacks per service
4. **🔄 Fault Tolerance:** One service failure doesn't affect others
5. **👥 Team Independence:** Different teams can work on different services
6. **🚀 Deployment Flexibility:** Deploy services independently

## 🔧 **Configuration Details**

Each service runs on a different port and connects to its own database:

- **Student Service**: `localhost:8585` → `student_management` DB
- **Course Service**: `localhost:8586` → `course_management` DB
- **Teacher Service**: `localhost:8587` → `teacher_management` DB
- **Enrollment Service**: `localhost:8588` → `enrollment_management` DB

The Enrollment Service uses RestTemplate to communicate with other services and orchestrate the complete enrollment process.
