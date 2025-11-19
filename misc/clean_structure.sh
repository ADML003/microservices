#!/bin/bash

# 🧹 Clean Microservices Structure Script
# This script creates a clean 4-microservices architecture

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🧹 Cleaning Microservices Structure${NC}"
echo -e "${BLUE}====================================${NC}"
echo ""

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Create clean README for the root
cat > README.md << 'EOF'
# 🏗️ Microservices Architecture

A complete microservices architecture with 4 independent services, each with its own database and running on different ports.

## 📋 Services Overview

| Service | Port | Database | Purpose |
|---------|------|----------|---------|
| **Student Service** | 8585 | student_management | Manage student data |
| **Course Service** | 8586 | course_management | Manage course information |
| **Teacher Service** | 8587 | teacher_management | Manage teacher profiles |
| **Enrollment Service** | 8588 | enrollment_management | Handle enrollments & orchestrate services |

## 🚀 Quick Start

### 1. Setup Databases
```bash
./setup_microservices.sh
```

### 2. Start Services (in separate terminals)
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

### 3. Test APIs
```bash
# Test all services
curl http://localhost:8585/students
curl http://localhost:8586/courses
curl http://localhost:8587/teachers
curl http://localhost:8588/enrollments
```

## 🔄 Inter-Service Communication

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
EOF

print_success "Created clean README.md"

# Create root .gitignore
cat > .gitignore << 'EOF'
# Compiled class file
*.class

# Log files
*.log

# Package Files
*.jar
*.war
*.nar
*.ear
*.zip
*.tar.gz
*.rar

# Virtual machine crash logs
hs_err_pid*

# Maven
target/
pom.xml.tag
pom.xml.releaseBackup
pom.xml.versionsBackup
pom.xml.next
release.properties
dependency-reduced-pom.xml

# IDE
.idea/
*.iws
*.iml
*.ipr
.vscode/
.classpath
.project
.settings/

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Application
*.pid
app.log
*.tmp
EOF

print_success "Updated .gitignore"

echo ""
print_status "📁 Current Clean Structure:"
echo "microservices/"
echo "├── README.md"
echo "├── .gitignore"
echo "├── setup_microservices.sh"
echo "├── MICROSERVICES_ARCHITECTURE_GUIDE.md"
echo "├── COMMUNICATION_GUIDE.md"
echo "├── DATABASE_COMMANDS.md"
echo "├── student-service/"
echo "│   ├── src/main/java/com/ncu/student/"
echo "│   ├── src/main/resources/"
echo "│   ├── pom.xml"
echo "│   └── database_setup.sql"
echo "├── course-service/"
echo "│   ├── src/main/java/com/ncu/course/"
echo "│   ├── src/main/resources/"
echo "│   ├── pom.xml"
echo "│   └── database_setup.sql"
echo "├── teacher-service/"
echo "│   ├── src/main/java/com/ncu/teacher/"
echo "│   ├── src/main/resources/"
echo "│   ├── pom.xml"
echo "│   └── database_setup.sql"
echo "└── enrollment-service/"
echo "    ├── src/main/java/com/ncu/enrollment/"
echo "    ├── src/main/resources/"
echo "    ├── pom.xml"
echo "    └── database_setup.sql"
echo ""

print_success "Clean microservices structure created!"
print_warning "Run this script to clean up the structure completely."
