# 🏗️ Microservices Architecture

A complete microservices architecture with 4 independent services, each with its own database and running on different ports.

## 📋 Services Overview

| Service                | Port | Database              | Purpose                                   |
| ---------------------- | ---- | --------------------- | ----------------------------------------- |
| **Student Service**    | 8585 | student_management    | Manage student data                       |
| **Course Service**     | 8586 | course_management     | Manage course information                 |
| **Teacher Service**    | 8587 | teacher_management    | Manage teacher profiles                   |
| **Enrollment Service** | 8588 | enrollment_management | Handle enrollments & orchestrate services |

## 🚀 Quick Start

### 1. Setup Databases

```bash
./setup_microservices.sh
```

### 2. Start All Services (Automated)

```bash
# Start all 4 microservices automatically
./start_all_services.sh
```

**OR** Start Services Manually (in separate terminals):

```bash
# Terminal 1 - Student Service
cd student-service && mvn spring-boot:run

# Terminal 2 - Course Service
cd course-service && mvn spring-boot:run

# Terminal 3 - Teacher Service
cd teacher-service && mvn spring-boot:run

# Terminal 4 - Enrollment Service
cd enrollment-service && mvn spring-boot:run
```

### 3. Test Interconnectivity

```bash
# Test all services and their communication
./test_interconnectivity.sh
```

### 4. Stop All Services

```bash
# Stop all microservices gracefully
./stop_all_services.sh
```

## �️ Management Scripts

| Script                      | Purpose                            | Usage                         |
| --------------------------- | ---------------------------------- | ----------------------------- |
| `setup_microservices.sh`    | Setup databases                    | `./setup_microservices.sh`    |
| `start_all_services.sh`     | Start all 4 services automatically | `./start_all_services.sh`     |
| `test_interconnectivity.sh` | Test service communication         | `./test_interconnectivity.sh` |
| `stop_all_services.sh`      | Stop all services gracefully       | `./stop_all_services.sh`      |

## �🔄 Inter-Service Communication

The Enrollment Service orchestrates communication between all other services:

- Creates enrollments linking students, courses, and teachers
- Retrieves data from other services via REST APIs
- Demonstrates microservices communication patterns

## 📚 Documentation

- [Architecture Guide](MICROSERVICES_ARCHITECTURE_GUIDE.md)
- [Communication Guide](COMMUNICATION_GUIDE.md)
- [Database Commands](DATABASE_COMMANDS.md)

## 🏗️ Architecture Benefits

- **🔒 Data Isolation**: Each service has its own database
- **📈 Independent Scaling**: Scale services individually
- **🛠️ Technology Flexibility**: Different tech stacks per service
- **👥 Team Autonomy**: Independent development workflows
- **🚀 Independent Deployment**: Deploy services separately
