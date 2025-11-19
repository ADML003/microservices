# 🎓 Viva Quick Reference Card

## Project Overview

**Microservices Architecture with Spring Boot + Spring Cloud**

---

## 🏗️ Architecture Components

### 1. Configuration Server (Port 8888)

**What:** Spring Cloud Config Server for centralized configuration  
**Why:** Single source of truth for all service configurations  
**How:** Uses native file system (`config-repo/`) to store properties

**Key Points:**

- All services connect to Config Server on startup via `bootstrap.properties`
- Configuration changes don't require service rebuild
- Supports different profiles (dev, prod, test)

---

### 2. Authentication Service (Port 8589)

**What:** Dedicated microservice for user authentication  
**Why:** Separation of concerns - authentication logic in one place  
**Tech:** Spring Security + BCrypt password encryption

**Endpoints:**

- `POST /auth/signup` - User registration
- `POST /auth/authenticate` - User login
- `GET /auth/health` - Health check

**Exception Handling:**

- Email validation (regex pattern)
- Duplicate email check (409 Conflict)
- Invalid credentials (401 Unauthorized)
- Database errors (503 Service Unavailable)

---

### 3. Business Services

| Service    | Port | Database          | Purpose                  |
| ---------- | ---- | ----------------- | ------------------------ |
| Student    | 8585 | student_db        | Manage students          |
| Course     | 8586 | course_management | Manage courses           |
| Teacher    | 8587 | teacher_db        | Manage teachers          |
| Enrollment | 8588 | enrollment_db     | Orchestrate all services |

**Database Per Service Pattern:**

- Each service has its own database
- Data isolation and independence
- Services can scale independently

---

## 🔄 Communication Flow

```
Client → API Gateway (8080) → Service Discovery (Eureka)
                                      ↓
                        [Student, Course, Teacher Services]
                                      ↓
                            Enrollment Service
                        (Orchestrates all services)
```

---

## ⚠️ Exception Handling Strategy

### HTTP Status Codes Used:

- **200 OK** - Successful GET, PUT
- **201 Created** - Successful POST
- **204 No Content** - Successful DELETE
- **400 Bad Request** - Validation errors, missing fields
- **404 Not Found** - Resource doesn't exist
- **409 Conflict** - Duplicate resource (email, etc.)
- **503 Service Unavailable** - Database down

### Try-Catch Pattern:

```java
try {
    // Business logic
} catch (DuplicateKeyException e) {
    // 409 Conflict
} catch (DataAccessException e) {
    // 503 Service Unavailable
} catch (Exception e) {
    // 500 Internal Server Error
}
```

---

## 🧪 Testing Approach

### 1. Positive Tests

- Valid data
- Expected successful responses
- Verify CRUD operations work

### 2. Negative Tests

- Missing required fields → 400
- Invalid email format → 400
- Duplicate email → 409
- Non-existent ID → 404
- Database connection failure → 503

### 3. Automated Testing

```bash
./test_all_services_comprehensive.sh
```

- Tests all endpoints
- Validates HTTP codes
- Checks exception handling

---

## 💡 Key Technical Decisions

### Why Microservices?

1. **Independent Deployment** - Update one service without affecting others
2. **Scalability** - Scale only the services that need it
3. **Technology Flexibility** - Different tech stack per service
4. **Fault Isolation** - One service failure doesn't crash everything

### Why Configuration Server?

1. **Centralized Management** - One place for all configs
2. **Dynamic Updates** - Change config without rebuild
3. **Environment Separation** - Different configs for dev/prod

### Why Separate Auth Service?

1. **Security Separation** - Auth logic isolated
2. **Reusability** - Other services can use it
3. **Single Responsibility** - One service, one job

---

## 🛠️ Technologies Used

| Technology            | Purpose                              |
| --------------------- | ------------------------------------ |
| Spring Boot 3.3.4     | Microservices framework              |
| Spring Cloud 2023.0.3 | Microservices infrastructure         |
| Spring Cloud Config   | Configuration management             |
| Spring Security       | Authentication & password encryption |
| BCrypt                | Password hashing                     |
| MySQL                 | Database per service                 |
| JDBC Template         | Database operations (Student)        |
| JPA/Hibernate         | ORM (Course, Teacher, Enrollment)    |
| Maven                 | Build tool                           |
| Netflix Eureka        | Service discovery                    |
| Spring Cloud Gateway  | API Gateway & routing                |

---

## 📊 Database Schema

### Auth Service (auth_db)

```sql
users (id, name, email, password, created_at)
- Email is UNIQUE
- Password is BCrypt encrypted
```

### Student Service (student_db)

```sql
students (id, name, email, phone_number)
- Uses JDBC Template
```

### Course Service (course_management)

```sql
courses (course_id, course_name, credit)
- Uses JPA/Hibernate
```

### Teacher Service (teacher_db)

```sql
teachers (teacher_id, teacher_name, department, email)
- Uses JPA/Hibernate
```

### Enrollment Service (enrollment_db)

```sql
enrollments (enrollment_id, student_id, course_id, teacher_id, enrollment_date)
- Foreign keys to other services' entities
- Orchestrates communication
```

---

## 🎯 Interview Questions & Answers

**Q: What is a microservice?**  
A: Independent, self-contained service that does one thing well. Has its own database, can be deployed independently, and communicates via REST APIs.

**Q: Why use Config Server?**  
A: Centralized configuration management. Instead of hardcoding configs in each service, all services fetch from Config Server. Easy to change without rebuilding.

**Q: How do services communicate?**  
A: REST APIs over HTTP. For example, Enrollment Service calls Student Service via `http://localhost:8585/students/{id}` to get student details.

**Q: What is BCrypt?**  
A: One-way password hashing algorithm. Takes plain text password, generates secure hash. Can't reverse engineer original password. Used in Auth Service.

**Q: How do you handle exceptions?**  
A: Try-catch blocks in controllers. Catch specific exceptions (DuplicateKeyException, DataAccessException). Return appropriate HTTP status codes with meaningful error messages.

**Q: What is the Database per Service pattern?**  
A: Each microservice has its own database. Provides data isolation, allows independent scaling, and prevents tight coupling between services.

**Q: How do you test microservices?**  
A: Unit tests, integration tests, and end-to-end tests. Test positive cases (valid data), negative cases (invalid data), and edge cases (null values, duplicates).

---

## 🚀 Demo Flow for Viva

1. **Show Architecture Diagram** (from TESTING_GUIDE.md)

2. **Start Services:**

   ```bash
   ./start_all_services_with_config_auth.sh
   ```

3. **Demo Config Server:**

   ```bash
   curl http://localhost:8888/student-service/default
   ```

4. **Demo Auth Service:**

   ```bash
   # Signup
   curl -X POST http://localhost:8589/auth/signup \
     -H "Content-Type: application/json" \
     -d '{"name":"Demo User","email":"demo@test.com","password":"Test@123"}'

   # Login
   curl -X POST http://localhost:8589/auth/authenticate \
     -H "Content-Type: application/json" \
     -d '{"email":"demo@test.com","password":"Test@123"}'
   ```

5. **Demo Student Service:**

   ```bash
   # Get all students
   curl http://localhost:8585/students

   # Create student
   curl -X POST http://localhost:8585/students \
     -H "Content-Type: application/json" \
     -d '{"name":"Alice","email":"alice@test.com","phoneNumber":"1234567890"}'
   ```

6. **Run Automated Tests:**
   ```bash
   ./test_all_services_comprehensive.sh
   ```

---

## ✅ Checklist Before Viva

- [ ] All services can start successfully
- [ ] Config Server serving configurations
- [ ] Auth Service signup/login working
- [ ] Student CRUD operations working
- [ ] Course CRUD operations working
- [ ] Teacher CRUD operations working
- [ ] Exception handling tested (try invalid data)
- [ ] Automated test script runs successfully
- [ ] Know the architecture diagram
- [ ] Can explain why you chose microservices

---

**Remember:** Focus on the concepts, not just the code. Explain WHY you made each decision! 🎉

Good luck with your viva tomorrow! 🚀
