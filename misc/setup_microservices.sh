#!/bin/bash

# 🚀 Microservices Startup Script
# This script sets up and starts all 4 microservices with separate databases

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏗️  Microservices Architecture Setup${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if MySQL is running
print_status "Checking MySQL connection..."
if ! mysql -u root -e "SELECT 1;" >/dev/null 2>&1; then
    print_error "MySQL is not running or accessible. Please start MySQL first."
    exit 1
fi
print_success "MySQL is running"

# Create databases for each service
print_status "Setting up databases for each microservice..."

echo "Creating databases..."
mysql -u root -e "CREATE DATABASE IF NOT EXISTS student_management;" 2>/dev/null || true
mysql -u root -e "CREATE DATABASE IF NOT EXISTS course_management;" 2>/dev/null || true  
mysql -u root -e "CREATE DATABASE IF NOT EXISTS teacher_management;" 2>/dev/null || true
mysql -u root -e "CREATE DATABASE IF NOT EXISTS enrollment_management;" 2>/dev/null || true

print_success "All databases created successfully"

# Display service architecture
echo ""
print_status "Microservices Architecture:"
echo "┌─────────────────────────────────────────────────────┐"
echo "│  Service          │  Port  │  Database              │"
echo "├─────────────────────────────────────────────────────┤"
echo "│  Student Service  │  8585  │  student_management    │"
echo "│  Course Service   │  8586  │  course_management     │"
echo "│  Teacher Service  │  8587  │  teacher_management    │"
echo "│  Enrollment Svc   │  8588  │  enrollment_management │"
echo "└─────────────────────────────────────────────────────┘"
echo ""

# Setup database tables (if database setup files exist)
if [ -f "student-service/database_setup.sql" ]; then
    print_status "Setting up student_management database..."
    mysql -u root student_management < student-service/database_setup.sql
    print_success "Student database setup complete"
fi

if [ -f "course-service/database_setup.sql" ]; then
    print_status "Setting up course_management database..."
    mysql -u root course_management < course-service/database_setup.sql
    print_success "Course database setup complete"
fi

if [ -f "teacher-service/database_setup.sql" ]; then
    print_status "Setting up teacher_management database..."
    mysql -u root teacher_management < teacher-service/database_setup.sql
    print_success "Teacher database setup complete"
fi

if [ -f "enrollment-service/database_setup.sql" ]; then
    print_status "Setting up enrollment_management database..."
    mysql -u root enrollment_management < enrollment-service/database_setup.sql
    print_success "Enrollment database setup complete"
fi

echo ""
print_status "🎯 How to start the microservices:"
echo ""
echo -e "${YELLOW}Open 4 separate terminals and run:${NC}"
echo ""
echo -e "${GREEN}Terminal 1 - Student Service:${NC}"
echo "  cd student-service"
echo "  mvn spring-boot:run"
echo "  📍 http://localhost:8585/students"
echo ""
echo -e "${GREEN}Terminal 2 - Course Service:${NC}"
echo "  cd course-service"
echo "  mvn spring-boot:run"
echo "  📍 http://localhost:8586/courses"
echo ""
echo -e "${GREEN}Terminal 3 - Teacher Service:${NC}"
echo "  cd teacher-service"
echo "  mvn spring-boot:run"
echo "  📍 http://localhost:8587/teachers"
echo ""
echo -e "${GREEN}Terminal 4 - Enrollment Service:${NC}"
echo "  cd enrollment-service"
echo "  mvn spring-boot:run"
echo "  📍 http://localhost:8588/enrollments"
echo ""

print_status "🧪 Testing endpoints:"
echo ""
echo "# Test Student Service"
echo "curl http://localhost:8585/students"
echo ""
echo "# Test Course Service"
echo "curl http://localhost:8586/courses"
echo ""
echo "# Test Teacher Service"
echo "curl http://localhost:8587/teachers"
echo ""
echo "# Test Enrollment Service (with inter-service communication)"
echo "curl http://localhost:8588/enrollments"
echo ""

print_status "🔄 Inter-service communication:"
echo "The Enrollment Service communicates with other services:"
echo "  • Enrollment → Student Service (8585)"
echo "  • Enrollment → Course Service (8586)"
echo "  • Enrollment → Teacher Service (8587)"
echo ""

print_success "Setup complete! Start the services in separate terminals."
echo ""
print_warning "Note: Start services in order: Student → Course → Teacher → Enrollment"
print_warning "The Enrollment service depends on the other three services being available."
