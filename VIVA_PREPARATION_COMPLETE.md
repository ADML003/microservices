# 🎓 COMPLETE VIVA PREPARATION GUIDE

## 📋 PROJECT OVERVIEW

**Project Name:** Microservices Architecture with Spring Boot & Spring Cloud  
**Your Focus Service:** Student Service  
**Total Services:** 6 (Config Server, Auth Service, + 4 Business Services)

---

## 🏗️ ARCHITECTURE COMPONENTS

### **1. Configuration Server** (Port: 8888)

- **Technology:** Spring Cloud Config Server
- **Purpose:** Centralized configuration management
- **Configuration Location:** `/config-repo/` directory
- **Status:** ✅ IMPLEMENTED & TESTED

**Why Config Server?**

- Single source of truth for all configurations
- Change configuration without rebuilding services
- Supports different profiles (dev, prod, test)
- Services connect on startup via `bootstrap.properties`

**How It Works:**

1. All services have `spring.cloud.config.uri=http://localhost:8888` in bootstrap.properties
2. On startup, each service connects to Config Server
3. Config Server serves properties from `config-repo/` based on service name
4. Services get database credentials, ports, and other configs

---

### **2. Authentication Service** (Port: 8589)

- **Technology:** Spring Boot + BCrypt Encryption
- **Database:** `auth_db` (MySQL)
- **Purpose:** Centralized user authentication

**Key Features:**

- User signup with email validation
- Password encryption using BCrypt
- Duplicate email prevention
- Login/authentication endpoints

**Endpoints:**

```
POST /auth/signup       - Register new user
POST /auth/authenticate - Login
GET  /auth/health       - Health check
```

**Why Separate Auth Service?**

- Separation of Concerns (SoC principle)
- Security logic in one place
- Easier to secure and audit
- Can be scaled independently

---

### **3. STUDENT SERVICE** (Port: 8585) - YOUR MAIN SERVICE

- **Database:** `student_db` (MySQL)
- **Purpose:** Complete CRUD operations for student management

**Database Schema:**

```sql
CREATE TABLE students (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    age INT,
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**Architecture Layers:**

1. **Controller Layer** (`StudentController.java`)

   - REST endpoints
   - HTTP request/response handling
   - Validation

2. **Service Layer** (`StudentServiceImpl.java`, `IStudentService.java`)

   - Business logic
   - Data transformation
   - Exception handling

3. **Repository Layer** (`StudentRepository.java`)

   - Database operations
   - Extends JpaRepository
   - Auto-generates CRUD methods

4. **Model Layer** (`Student.java`)

   - Entity class
   - Maps to database table
   - JPA annotations

5. **DTO Layer** (`StudentDto.java`)
   - Data Transfer Object
   - Separates internal model from API responses
   - Clean API design

**REST Endpoints:**

```
GET    /students        - Get all students
GET    /students/{id}   - Get student by ID
POST   /students        - Create new student
PUT    /students/{id}   - Update student
DELETE /students/{id}   - Delete student
```

**Exception Handling:**

- `400 Bad Request` - Invalid data, missing required fields
- `404 Not Found` - Student doesn't exist
- `409 Conflict` - Duplicate email
- `500 Internal Server Error` - Database connection issues

**Key Constraints:**

- ✅ Email must be UNIQUE (enforced by database)
- ✅ Name can be duplicate
- ✅ Phone can be duplicate
- ✅ ID is auto-generated (don't send in POST requests)

---

### **4. Course Service** (Port: 8586)

- **Database:** `course_management` (MySQL)
- **Purpose:** Manage course information

**Database Schema:**

```sql
CREATE TABLE courses (
    course_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**Endpoints:**

```
GET    /courses        - Get all courses
GET    /courses/{id}   - Get course by ID
POST   /courses        - Create new course
PUT    /courses/{id}   - Update course
DELETE /courses/{id}   - Delete course
```

---

### **5. Teacher Service** (Port: 8587)

- **Database:** `teacher_db` (MySQL)
- **Purpose:** Manage teacher profiles

**Database Schema:**

```sql
CREATE TABLE teachers (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    teacher_id VARCHAR(50),
    department VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**Endpoints:**

```
GET    /teachers        - Get all teachers
GET    /teachers/{id}   - Get teacher by ID
POST   /teachers        - Create new teacher
PUT    /teachers/{id}   - Update teacher
DELETE /teachers/{id}   - Delete teacher
```

---

### **6. Enrollment Service** (Port: 8588)

- **Database:** `enrollment_db` (MySQL)
- **Purpose:** Orchestrate student-course-teacher relationships

**Database Schema:**

```sql
CREATE TABLE enrollments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    student_id BIGINT NOT NULL,
    course_id BIGINT NOT NULL,
    teacher_id BIGINT,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_enrollment (student_id, course_id)
);
```

**Key Constraint:**

- ❌ Same student CANNOT enroll in same course twice
- ✅ Must reference existing student_id, course_id, teacher_id

**Endpoints:**

```
GET    /enrollments        - Get all enrollments
GET    /enrollments/{id}   - Get enrollment by ID
POST   /enrollments        - Create new enrollment
PUT    /enrollments/{id}   - Update enrollment
DELETE /enrollments/{id}   - Delete enrollment
```

---

## 🔄 MICROSERVICES DESIGN PATTERNS

### **1. Database Per Service Pattern**

- Each service has its own database
- **Benefits:**
  - Data isolation and independence
  - Services can scale independently
  - Technology flexibility (can use different DB types)
  - Prevents tight coupling

### **2. API Gateway Pattern** (Optional - Port 8080)

- Single entry point for all client requests
- Routes requests to appropriate services
- Can handle authentication, rate limiting, logging

### **3. Service Discovery Pattern** (Eureka - Port 8761)

- Services register themselves on startup
- Dynamic service location
- Load balancing
- Health monitoring

### **4. Externalized Configuration Pattern**

- Config Server provides centralized configuration
- Environment-specific configs (dev, prod)
- Secrets management

---

## 🔑 KEY TECHNICAL CONCEPTS

### **Spring Boot Annotations:**

**@RestController**

- Combines @Controller + @ResponseBody
- Returns JSON/XML instead of HTML views

**@RequestMapping("/students")**

- Base path for all endpoints in controller

**@GetMapping, @PostMapping, @PutMapping, @DeleteMapping**

- Shortcuts for @RequestMapping with specific HTTP methods

**@PathVariable**

- Extracts value from URI path (e.g., /students/5 → id=5)

**@RequestBody**

- Converts JSON request body to Java object

**@Service**

- Marks class as service layer component
- Business logic container

**@Repository**

- Marks interface as data access layer
- Exception translation

**@Entity**

- Marks class as JPA entity
- Maps to database table

**@Table(name = "students")**

- Specifies database table name

**@Id, @GeneratedValue**

- Primary key configuration
- Auto-increment strategy

**@Column(unique = true)**

- Database constraints

**@Autowired**

- Dependency injection
- Spring manages object creation

---

## 🧪 TESTING YOUR SERVICES

### **Manual Testing Order:**

**1. Test Config Server:**

```bash
curl http://localhost:8888/actuator/health
# Expected: {"status":"UP"}

curl http://localhost:8888/student-service/default
# Expected: JSON with student-service configuration
```

**2. Test Auth Service:**

```bash
# Health Check
curl http://localhost:8589/auth/health
# Expected: {"status":"healthy"}

# Signup
curl -X POST http://localhost:8589/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
# Expected: User created successfully

# Login
curl -X POST http://localhost:8589/auth/authenticate \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
# Expected: {"message":"Authentication successful"}
```

**3. Test Student Service (YOUR FOCUS):**

```bash
# Get all students
curl http://localhost:8585/students
# Expected: JSON array of students (might be empty initially)

# Create student
curl -X POST http://localhost:8585/students \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "1234567890",
    "age": 20,
    "address": "123 Main St"
  }'
# Expected: 201 Created with student object

# Get student by ID
curl http://localhost:8585/students/1
# Expected: Student object with ID 1

# Update student
curl -X PUT http://localhost:8585/students/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Updated",
    "email": "john@example.com",
    "phone": "9876543210",
    "age": 21,
    "address": "456 Oak Ave"
  }'
# Expected: Updated student object

# Delete student
curl -X DELETE http://localhost:8585/students/1
# Expected: 204 No Content
```

**4. Test Course Service:**

```bash
# Get all courses
curl http://localhost:8586/courses

# Create course
curl -X POST http://localhost:8586/courses \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Data Structures",
    "credits": 4,
    "description": "Advanced data structures course"
  }'
```

**5. Test Teacher Service:**

```bash
# Get all teachers
curl http://localhost:8587/teachers

# Create teacher
curl -X POST http://localhost:8587/teachers \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Dr. Smith",
    "teacherId": "T001",
    "department": "Computer Science",
    "email": "smith@university.edu",
    "phone": "555-1234"
  }'
```

**6. Test Enrollment Service:**

```bash
# Get all enrollments
curl http://localhost:8588/enrollments

# Create enrollment (requires existing student, course, teacher IDs)
curl -X POST http://localhost:8588/enrollments \
  -H "Content-Type: application/json" \
  -d '{
    "studentId": 1,
    "courseId": 1,
    "teacherId": 1,
    "status": "ACTIVE"
  }'
```

---

## 📱 POSTMAN TESTING COLLECTION

### Import into Postman:

**BASE URLs:**

- Config Server: `http://localhost:8888`
- Auth Service: `http://localhost:8589`
- Student Service: `http://localhost:8585`
- Course Service: `http://localhost:8586`
- Teacher Service: `http://localhost:8587`
- Enrollment Service: `http://localhost:8588`

### Student Service Collection:

**1. GET All Students**

- Method: GET
- URL: `http://localhost:8585/students`
- Headers: None
- Body: None

**2. GET Student by ID**

- Method: GET
- URL: `http://localhost:8585/students/1`
- Headers: None
- Body: None

**3. CREATE Student**

- Method: POST
- URL: `http://localhost:8585/students`
- Headers: `Content-Type: application/json`
- Body (raw JSON):

```json
{
  "name": "Alice Johnson",
  "email": "alice@example.com",
  "phone": "1234567890",
  "age": 22,
  "address": "789 Elm St"
}
```

**4. UPDATE Student**

- Method: PUT
- URL: `http://localhost:8585/students/1`
- Headers: `Content-Type: application/json`
- Body (raw JSON):

```json
{
  "name": "Alice Updated",
  "email": "alice@example.com",
  "phone": "9999999999",
  "age": 23,
  "address": "New Address"
}
```

**5. DELETE Student**

- Method: DELETE
- URL: `http://localhost:8585/students/1`
- Headers: None
- Body: None

---

## ⚠️ COMMON ERRORS & SOLUTIONS

### **Error: "Address already in use" on port 8585**

**Solution:**

```bash
lsof -ti:8585 | xargs kill
# Or
pkill -f "student-service"
```

### **Error: "Failed to configure DataSource"**

**Problem:** Database configuration not found
**Solution:**

1. Ensure Config Server is running on port 8888
2. Check `bootstrap.properties` has correct config server URL
3. Verify `/config-repo/student-service.properties` exists
4. Restart the service

### **Error: "Access denied for user 'root'@'localhost'"**

**Problem:** MySQL credentials incorrect
**Solution:**

1. Update `/config-repo/application.properties`:

```properties
spring.datasource.username=root
spring.datasource.password=root
```

2. Restart Config Server and all services

### **Error: "Duplicate entry for key 'email'"**

**Problem:** Trying to create student with existing email
**Solution:** This is expected! Email must be unique. Use different email.

---

## 🎤 VIVA QUESTIONS & ANSWERS

### **Q1: Why did you use microservices instead of monolithic architecture?**

**Answer:**

- **Scalability:** Each service scales independently based on demand
- **Technology Flexibility:** Different services can use different technologies
- **Fault Isolation:** One service failure doesn't crash entire system
- **Team Autonomy:** Different teams can work on different services
- **Easier Deployment:** Deploy one service without affecting others

### **Q2: Explain the Student Service architecture.**

**Answer:**

- **Controller Layer:** Handles HTTP requests, returns responses
- **Service Layer:** Contains business logic, validation, exception handling
- **Repository Layer:** Database operations using Spring Data JPA
- **Model Layer:** Entity classes mapped to database tables
- **DTO Layer:** Data transfer objects for clean API design

### **Q3: Why separate Config Server?**

**Answer:**

- **Centralized Management:** All configs in one place
- **Environment Profiles:** Different configs for dev, test, prod
- **No Rebuild Required:** Change config without recompiling
- **Version Control:** Track configuration changes in Git
- **Security:** Encrypt sensitive data like passwords

### **Q4: What is the purpose of DTO (Data Transfer Object)?**

**Answer:**

- **Separation of Concerns:** Internal model vs API representation
- **Security:** Don't expose internal entity structure
- **Flexibility:** API can change without changing database
- **Performance:** Send only required fields, not entire entity
- **Validation:** Add validation specific to API requests

### **Q5: How does exception handling work in Student Service?**

**Answer:**

- **Try-Catch Blocks:** Catch specific exceptions
- **HTTP Status Codes:** Return appropriate codes (404, 409, 500)
- **Custom Messages:** User-friendly error messages
- **Logging:** Log errors for debugging
- **Graceful Degradation:** Handle errors without crashing service

### **Q6: What is the difference between @Service and @Repository?**

**Answer:**

- **@Service:** Business logic layer, transaction management
- **@Repository:** Data access layer, exception translation
- **Spring treats them differently for exception handling and AOP**

### **Q7: Why did you use JPA instead of JDBC?**

**Answer:**

- **Object-Relational Mapping:** Work with objects, not SQL
- **Automatic CRUD:** JpaRepository provides built-in methods
- **Less Boilerplate:** No need to write SQL for simple operations
- **Database Independence:** Switch databases without changing code
- **Type Safety:** Compile-time checking

### **Q8: How do services communicate with each other?**

**Answer:**

- **REST APIs:** Services expose HTTP endpoints
- **RestTemplate/WebClient:** Spring tools for HTTP calls
- **Service Discovery:** Eureka helps services find each other
- **Example:** Enrollment service calls Student service to verify student exists

### **Q9: What happens if one microservice is down?**

**Answer:**

- **Circuit Breaker Pattern:** Prevent cascading failures
- **Fallback Mechanisms:** Return default response
- **Retry Logic:** Attempt request again after delay
- **Health Checks:** Monitor service availability
- **Independent Operation:** Other services continue working

### **Q10: Explain the database schema for Student Service.**

**Answer:**

```
students table:
- id (BIGINT, PRIMARY KEY, AUTO_INCREMENT)
- name (VARCHAR(100), NOT NULL)
- email (VARCHAR(100), UNIQUE, NOT NULL)
- phone (VARCHAR(15))
- age (INT)
- address (VARCHAR(255))
- created_at (TIMESTAMP)
- updated_at (TIMESTAMP)

Unique constraint on email prevents duplicates
```

---

## 🚀 STARTING ALL SERVICES

### **Automated Script:**

```bash
cd "/Users/ADML/Desktop/microservices "
export PATH="/usr/local/bin:$PATH"
./start_all_services_with_config_auth.sh
```

### **Manual Startup (if script fails):**

```bash
# Terminal 1 - Config Server
cd config-server
mvn spring-boot:run

# Terminal 2 - Auth Service
cd auth-service
mvn spring-boot:run

# Terminal 3 - Student Service
cd student-service
mvn spring-boot:run

# Terminal 4 - Course Service
cd course-service
mvn spring-boot:run

# Terminal 5 - Teacher Service
cd teacher-service
mvn spring-boot:run

# Terminal 6 - Enrollment Service
cd enrollment-service
mvn spring-boot:run
```

### **Stop All Services:**

```bash
./stop_all_services_updated.sh
```

---

## ✅ PRE-VIVA CHECKLIST

- [ ] All 6 services can start without errors
- [ ] Config Server returns configuration for each service
- [ ] Auth Service signup/login works
- [ ] Student Service all CRUD operations work
- [ ] Can create student with unique email
- [ ] Get error when creating duplicate email
- [ ] Can update and delete students
- [ ] Course, Teacher, Enrollment services respond
- [ ] Know the architecture layers of Student Service
- [ ] Can explain why microservices over monolithic
- [ ] Can explain Config Server purpose
- [ ] Can explain database-per-service pattern
- [ ] Can handle common error questions
- [ ] Know how to test endpoints with curl/Postman

---

## 📝 QUICK REFERENCE COMMANDS

```bash
# Check if service is running
lsof -i :8585

# View service logs
tail -f student-service.log

# Stop specific service
pkill -f "student-service"

# Check MySQL databases
mysql -u root -p'root' -e "SHOW DATABASES;"

# Check if Maven is available
mvn --version

# Test endpoint
curl http://localhost:8585/students
```

---

## 🎯 KEY TAKEAWAYS FOR VIVA

1. **Student Service** is your main focus - know it thoroughly
2. **Config Server** provides centralized configuration
3. **Auth Service** handles authentication separately (SoC principle)
4. Each service has **its own database** (isolation)
5. **DTO pattern** separates API from internal model
6. **Exception handling** provides proper HTTP status codes
7. **Email must be unique** - enforced by database constraint
8. Services communicate via **REST APIs**
9. **Microservices** enable independent scaling and deployment
10. **Spring Boot** simplifies development with auto-configuration

---

## 🔗 HELPFUL DOCUMENTATION LINKS

- Spring Boot: https://spring.io/projects/spring-boot
- Spring Cloud Config: https://spring.io/projects/spring-cloud-config
- Spring Data JPA: https://spring.io/projects/spring-data-jpa
- Microservices Pattern: https://microservices.io/patterns

---

**Good luck with your viva! You've got this! 💪**
