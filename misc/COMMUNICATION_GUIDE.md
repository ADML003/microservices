# 🎯 Microservices Communication & Deployment Guide

## 📊 **Current Status**

Your microservices project is set up with the following structure:

### **✅ What's Already Created:**

- ✅ Course Service (Port 8586) - Partially configured
- ✅ Student Service (original code in `/src/main/java/com/ncu/college/`)
- ✅ Basic project structure for all services
- ✅ Database setup scripts
- ✅ RestTemplate configuration for inter-service communication

### **🔧 What Needs to be Completed:**

- 🔲 Move Student Service to separate folder structure
- 🔲 Complete Teacher Service implementation
- 🔲 Complete Enrollment Service implementation
- 🔲 Set up proper pom.xml for each service

## 🏗️ **Architecture Overview**

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Student Service│◄───┤Enrollment Service│───►│ Teacher Service │
│   Port: 8585    │    │   Port: 8588    │    │   Port: 8587    │
│student_mgmt DB  │    │enrollment_mgmt DB│    │teacher_mgmt DB  │
└─────────────────┘    └─────────┬───────┘    └─────────────────┘
                                 │
                                 ▼
                       ┌─────────────────┐
                       │  Course Service │
                       │   Port: 8586    │
                       │ course_mgmt DB  │
                       └─────────────────┘
```

## 🚀 **How Services Communicate**

### **1. Direct REST API Calls**

Each service exposes REST endpoints that other services can call:

```java
// Example: Enrollment Service calling Student Service
@Service
public class EnrollmentService {
    @Autowired
    private RestTemplate restTemplate;

    public StudentDto getStudentDetails(Long studentId) {
        return restTemplate.getForObject(
            "http://localhost:8585/students/" + studentId,
            StudentDto.class
        );
    }
}
```

### **2. Service Endpoints**

**Student Service (8585):**

- `GET /students` - Get all students
- `GET /students/{id}` - Get student by ID
- `POST /students` - Create new student
- `PUT /students/{id}` - Update student
- `DELETE /students/{id}` - Delete student

**Course Service (8586):**

- `GET /courses` - Get all courses
- `GET /courses/{id}` - Get course by ID
- `POST /courses` - Create new course
- `PUT /courses/{id}` - Update course
- `DELETE /courses/{id}` - Delete course

**Teacher Service (8587):**

- `GET /teachers` - Get all teachers
- `GET /teachers/{id}` - Get teacher by ID
- `POST /teachers` - Create new teacher
- `PUT /teachers/{id}` - Update teacher
- `DELETE /teachers/{id}` - Delete teacher

**Enrollment Service (8588):**

- `GET /enrollments` - Get all enrollments
- `GET /enrollments/{id}` - Get enrollment by ID
- `GET /enrollments/{id}/details` - Get enrollment with full student/course/teacher details
- `POST /enrollments` - Create new enrollment
- `PUT /enrollments/{id}` - Update enrollment
- `DELETE /enrollments/{id}` - Delete enrollment

## 🗄️ **Database Setup**

### **1. Run Database Setup:**

```bash
# Execute the setup script
./setup_microservices.sh
```

### **2. Manual Database Setup:**

```bash
# Create all databases
mysql -u root -e "CREATE DATABASE student_management;"
mysql -u root -e "CREATE DATABASE course_management;"
mysql -u root -e "CREATE DATABASE teacher_management;"
mysql -u root -e "CREATE DATABASE enrollment_management;"

# Setup tables with sample data
mysql -u root student_management < student-service/database_setup.sql
mysql -u root course_management < course-service/database_setup.sql
mysql -u root teacher_management < teacher-service/database_setup.sql
mysql -u root enrollment_management < enrollment-service/database_setup.sql
```

## 🎮 **How to Run All Services**

### **Start Services in Order:**

**Terminal 1 - Student Service:**

```bash
cd student-service
mvn spring-boot:run
```

✅ **Available at:** http://localhost:8585

**Terminal 2 - Course Service:**

```bash
cd course-service
mvn spring-boot:run
```

✅ **Available at:** http://localhost:8586

**Terminal 3 - Teacher Service:**

```bash
cd teacher-service
mvn spring-boot:run
```

✅ **Available at:** http://localhost:8587

**Terminal 4 - Enrollment Service:**

```bash
cd enrollment-service
mvn spring-boot:run
```

✅ **Available at:** http://localhost:8588

## 🧪 **Testing Inter-Service Communication**

### **1. Create Data First:**

```bash
# Create a student
curl -X POST http://localhost:8585/students \
-H "Content-Type: application/json" \
-d '{"name":"John Doe","email":"john@example.com","age":20}'

# Create a course
curl -X POST http://localhost:8586/courses \
-H "Content-Type: application/json" \
-d '{"name":"Java Programming","credits":3,"description":"Learn Java"}'

# Create a teacher
curl -X POST http://localhost:8587/teachers \
-H "Content-Type: application/json" \
-d '{"name":"Prof. Smith","email":"smith@university.edu","department":"Computer Science"}'
```

### **2. Create Enrollment (Links All Services):**

```bash
# Create enrollment - this will call all other services
curl -X POST http://localhost:8588/enrollments \
-H "Content-Type: application/json" \
-d '{"studentId":1,"courseId":1,"teacherId":1}'

# Get enrollment details - shows data from all services
curl http://localhost:8588/enrollments/1/details
```

### **Expected Response (with inter-service data):**

```json
{
  "enrollmentId": 1,
  "student": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  },
  "course": {
    "courseId": 1,
    "name": "Java Programming",
    "credits": 3
  },
  "teacher": {
    "teacherId": 1,
    "name": "Prof. Smith",
    "department": "Computer Science"
  },
  "enrollmentDate": "2025-09-03T10:30:00"
}
```

## 🔥 **Key Benefits**

1. **🔒 Isolation:** Each service has its own database and can be deployed independently
2. **📈 Scalability:** Scale individual services based on demand
3. **🛠️ Technology Freedom:** Use different technologies for different services
4. **👥 Team Autonomy:** Different teams can work on different services
5. **🔄 Fault Tolerance:** If one service fails, others continue working
6. **🚀 Independent Deployment:** Deploy and update services separately

## 📋 **Next Steps**

1. **✅ Run the setup script:** `./setup_microservices.sh`
2. **✅ Start all services** in separate terminals
3. **✅ Test each service** individually
4. **✅ Test inter-service communication** through enrollment service
5. **🔧 Monitor logs** to see services communicating
6. **📊 Use Postman** or API testing tools for comprehensive testing

The Enrollment Service acts as the **orchestrator** that demonstrates how microservices communicate with each other to provide a complete business function!
