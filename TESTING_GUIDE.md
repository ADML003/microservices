# 🧪 Complete Testing Guide for Microservices

This guide explains how to test all microservices with proper exception handling and validation.

## 📋 Testing Overview

### Services to Test:

1. **Configuration Server** (Port 8888) - ✅ Already implemented
2. **Authentication Service** (Port 8589) - ✅ Already implemented
3. **Student Service** (Port 8585)
4. **Course Service** (Port 8586)
5. **Teacher Service** (Port 8587)
6. **Enrollment Service** (Port 8588)

---

## 🚀 Quick Start Testing

### Step 1: Start All Services

```bash
./start_all_services_with_config_auth.sh
```

This will start all 6 services in the correct order:

- Config Server first (provides configuration to all services)
- Auth Service
- Student, Course, Teacher Services
- Enrollment Service last (depends on other services)

### Step 2: Run Comprehensive Tests

```bash
./test_all_services_comprehensive.sh
```

This automated test script will:

- ✅ Test all service health endpoints
- ✅ Test positive cases (valid data)
- ✅ Test negative cases (invalid data, error handling)
- ✅ Test CRUD operations for each service
- ✅ Validate proper HTTP status codes
- ✅ Check exception handling

### Step 3: Stop All Services

```bash
./stop_all_services_updated.sh
```

---

## 📊 Manual Testing Guide

### 1. Configuration Server Testing

**Test 1: Health Check**

```bash
curl http://localhost:8888/actuator/health
```

Expected: `{"status":"UP"}`

**Test 2: Student Service Config**

```bash
curl http://localhost:8888/student-service/default
```

Expected: Configuration with `student_db` database

**Test 3: Auth Service Config**

```bash
curl http://localhost:8888/auth-service/default
```

Expected: Configuration with `auth_db` database

---

### 2. Authentication Service Testing

**Test 1: Health Endpoint**

```bash
curl http://localhost:8589/auth/health
```

Expected: `{"status":"healthy"}`

**Test 2: User Signup (Valid Data)**

```bash
curl -X POST http://localhost:8589/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john.doe@test.com",
    "password": "SecurePass@123"
  }'
```

Expected:

```json
{
  "status": "success",
  "message": "User john.doe@test.com signed up successfully"
}
```

**Test 3: Duplicate Email (Should Fail Gracefully)**

```bash
curl -X POST http://localhost:8589/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@test.com",
    "password": "password123"
  }'
```

Expected:

```json
{
  "status": "error",
  "message": "Email john@test.com already exists"
}
```

**Test 4: Invalid Email Format**

```bash
curl -X POST http://localhost:8589/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "invalid-email",
    "password": "password123"
  }'
```

Expected: Error message about invalid email format

**Test 5: Login with Valid Credentials**

```bash
curl -X POST http://localhost:8589/auth/authenticate \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@test.com",
    "password": "password123"
  }'
```

Expected:

```json
{
  "status": "success",
  "message": "Authentication successful for john@test.com"
}
```

**Test 6: Login with Invalid Password**

```bash
curl -X POST http://localhost:8589/auth/authenticate \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@test.com",
    "password": "wrongpassword"
  }'
```

Expected:

```json
{
  "status": "error",
  "message": "Invalid credentials"
}
```

---

### 3. Student Service Testing

**Test 1: Get All Students**

```bash
curl http://localhost:8585/students
```

Expected: HTTP 200, list of students

**Test 2: Get Student by Valid ID**

```bash
curl http://localhost:8585/students/1
```

Expected: HTTP 200, student data

**Test 3: Get Student by Invalid ID (Error Handling)**

```bash
curl -i http://localhost:8585/students/99999
```

Expected: HTTP 404 Not Found

**Test 4: Create Student (Valid Data)**

```bash
curl -X POST http://localhost:8585/students \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Alice Smith",
    "email": "alice@test.com",
    "phoneNumber": "1234567890"
  }'
```

Expected: HTTP 201 Created, student data with ID

**Test 5: Create Student with Missing Name (Error Handling)**

```bash
curl -i -X POST http://localhost:8585/students \
  -H "Content-Type: application/json" \
  -d '{
    "email": "bob@test.com",
    "phoneNumber": "1234567890"
  }'
```

Expected: HTTP 400 Bad Request with error message

**Test 6: Update Student**

```bash
curl -X PUT http://localhost:8585/students/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Name",
    "email": "updated@test.com",
    "phoneNumber": "9876543210"
  }'
```

Expected: HTTP 200, updated student data

**Test 7: Delete Student**

```bash
curl -i -X DELETE http://localhost:8585/students/1
```

Expected: HTTP 204 No Content

---

### 4. Course Service Testing

**Test 1: Get All Courses**

```bash
curl http://localhost:8586/courses
```

**Test 2: Create Course**

```bash
curl -X POST http://localhost:8586/courses \
  -H "Content-Type: application/json" \
  -d '{
    "courseName": "Data Structures",
    "credit": 4
  }'
```

**Test 3: Get Course by ID**

```bash
curl http://localhost:8586/courses/1
```

**Test 4: Update Course**

```bash
curl -X PUT http://localhost:8586/courses/1 \
  -H "Content-Type: application/json" \
  -d '{
    "courseName": "Advanced Data Structures",
    "credit": 4
  }'
```

**Test 5: Delete Course**

```bash
curl -X DELETE http://localhost:8586/courses/1
```

---

### 5. Teacher Service Testing

**Test 1: Get All Teachers**

```bash
curl http://localhost:8587/teachers
```

**Test 2: Create Teacher**

```bash
curl -X POST http://localhost:8587/teachers \
  -H "Content-Type: application/json" \
  -d '{
    "teacherName": "Dr. Smith",
    "department": "Computer Science",
    "email": "smith@university.edu"
  }'
```

**Test 3: Get Teacher by ID**

```bash
curl http://localhost:8587/teachers/1
```

---

### 6. Enrollment Service Testing

**Test 1: Get All Enrollments**

```bash
curl http://localhost:8588/enrollments
```

**Test 2: Create Enrollment (Requires existing student, course, teacher)**

```bash
curl -X POST http://localhost:8588/enrollments \
  -H "Content-Type: application/json" \
  -d '{
    "studentId": 1,
    "courseId": 1,
    "teacherId": 1,
    "enrollmentDate": "2024-01-15"
  }'
```

---

## ✅ Exception Handling Checklist

### What to Verify During Testing:

#### ✅ Configuration Server

- [x] Serves configuration to all services
- [x] Returns 200 for health check
- [x] Provides correct database configurations

#### ✅ Authentication Service

- [x] Validates email format
- [x] Checks for duplicate emails
- [x] BCrypt password encryption working
- [x] Invalid credentials rejected
- [x] Proper HTTP status codes (200, 400, 409)

#### Student Service

- [ ] Handles missing required fields
- [ ] Validates email format
- [ ] Returns 404 for non-existent students
- [ ] Handles database connection errors gracefully
- [ ] Duplicate email validation

#### Course Service

- [ ] Validates course name not empty
- [ ] Validates credit hours are positive
- [ ] Handles non-existent course IDs
- [ ] Database error handling

#### Teacher Service

- [ ] Validates required fields
- [ ] Email validation
- [ ] Handles database errors
- [ ] Returns proper HTTP codes

#### Enrollment Service

- [ ] Validates student exists
- [ ] Validates course exists
- [ ] Validates teacher exists
- [ ] Prevents duplicate enrollments
- [ ] Foreign key constraint handling

---

## 🎯 Expected HTTP Status Codes

| Code | Meaning               | When to Use                           |
| ---- | --------------------- | ------------------------------------- |
| 200  | OK                    | Successful GET, PUT, DELETE           |
| 201  | Created               | Successful POST (resource created)    |
| 204  | No Content            | Successful DELETE (no body returned)  |
| 400  | Bad Request           | Invalid input data, validation errors |
| 404  | Not Found             | Resource doesn't exist                |
| 409  | Conflict              | Duplicate resource (email, etc.)      |
| 500  | Internal Server Error | Unexpected errors                     |
| 503  | Service Unavailable   | Database connection failed            |

---

## 📝 Log Files

Check service logs for detailed error messages:

- `config-server.log`
- `auth-service.log`
- `Student_service.log`
- `Course_service.log`
- `Teacher_service.log`
- `Enrollment_service.log`

View real-time logs:

```bash
tail -f Student_service.log
tail -f auth-service.log
```

---

## 🔍 Troubleshooting

### Service won't start?

1. Check if port is already in use: `lsof -i :<PORT>`
2. Check log file for errors
3. Ensure MySQL is running and databases exist
4. Verify Config Server is running first

### Database connection errors?

1. Ensure MySQL is running: `brew services list`
2. Check database exists: `mysql -u root -e "SHOW DATABASES;"`
3. Verify connection settings in `config-repo/*.properties`

### Configuration not loading?

1. Ensure Config Server started successfully
2. Check `bootstrap.properties` in each service points to Config Server
3. Verify configuration files exist in `config-repo/`

---

## 🎓 For Your Viva

### Key Points to Mention:

1. **Configuration Server (Spring Cloud Config)**

   - Centralized configuration management
   - All services fetch config from one place
   - Easy to change configurations without rebuilding services

2. **Authentication Service**

   - Dedicated microservice for user authentication
   - BCrypt password encryption for security
   - Email validation and duplicate checking
   - Proper exception handling with meaningful error messages

3. **Exception Handling Best Practices**

   - Try-catch blocks in all controller methods
   - Specific exception types (DataAccessException, IllegalArgumentException)
   - Proper HTTP status codes for different scenarios
   - User-friendly error messages

4. **Testing Approach**
   - Positive test cases (valid data)
   - Negative test cases (invalid data, missing fields)
   - Edge cases (duplicate emails, non-existent IDs)
   - Database connection failure handling

---

Good luck with your viva! 🎉
