#!/bin/bash

# Comprehensive Testing Script for All Microservices
# Tests all endpoints with positive and negative test cases

echo "======================================"
echo "🧪 COMPREHENSIVE MICROSERVICES TESTING"
echo "======================================"
echo ""

# Color codes for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Function to print test results
print_result() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}: $2"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo -e "${RED}✗ FAIL${NC}: $2"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

# Function to test service health
test_service_health() {
    SERVICE_NAME=$1
    PORT=$2
    
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Testing $SERVICE_NAME (Port: $PORT)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Health check
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/actuator/health 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "$SERVICE_NAME is UP and running"
    else
        print_result 1 "$SERVICE_NAME is DOWN (HTTP $RESPONSE)"
        return 1
    fi
    
    return 0
}

# Function to test Config Server
test_config_server() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Testing Configuration Server (Port: 8888)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Test Config Server health
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8888/actuator/health 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "Config Server is UP"
    else
        print_result 1 "Config Server is DOWN"
        return 1
    fi
    
    # Test student-service configuration
    RESPONSE=$(curl -s http://localhost:8888/student-service/default 2>/dev/null | grep -o "student_db")
    if [ ! -z "$RESPONSE" ]; then
        print_result 0 "Student Service configuration loaded"
    else
        print_result 1 "Failed to load Student Service configuration"
    fi
    
    # Test course-service configuration
    RESPONSE=$(curl -s http://localhost:8888/course-service/default 2>/dev/null | grep -o "course_management")
    if [ ! -z "$RESPONSE" ]; then
        print_result 0 "Course Service configuration loaded"
    else
        print_result 1 "Failed to load Course Service configuration"
    fi
    
    # Test auth-service configuration
    RESPONSE=$(curl -s http://localhost:8888/auth-service/default 2>/dev/null | grep -o "auth_db")
    if [ ! -z "$RESPONSE" ]; then
        print_result 0 "Auth Service configuration loaded"
    else
        print_result 1 "Failed to load Auth Service configuration"
    fi
}

# Function to test Authentication Service
test_auth_service() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Testing Authentication Service (Port: 8589)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Health check
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8589/auth/health 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "Auth Service health endpoint working"
    else
        print_result 1 "Auth Service health endpoint failed (HTTP $RESPONSE)"
    fi
    
    # Test signup with valid data
    RESPONSE=$(curl -s -X POST http://localhost:8589/auth/signup \
        -H "Content-Type: application/json" \
        -d '{
            "name": "Test User",
            "email": "testuser'$(date +%s)'@test.com",
            "password": "Test@1234"
        }' 2>/dev/null | grep -o "success")
    
    if [ ! -z "$RESPONSE" ]; then
        print_result 0 "User signup with valid data"
    else
        print_result 1 "User signup failed"
    fi
    
    # Test signup with duplicate email (should fail gracefully)
    RESPONSE=$(curl -s -X POST http://localhost:8589/auth/signup \
        -H "Content-Type: application/json" \
        -d '{
            "name": "Duplicate User",
            "email": "john@test.com",
            "password": "Test@1234"
        }' 2>/dev/null | grep -o "already exists")
    
    if [ ! -z "$RESPONSE" ]; then
        print_result 0 "Duplicate email validation working"
    else
        print_result 1 "Duplicate email validation failed"
    fi
    
    # Test login with valid credentials
    RESPONSE=$(curl -s -X POST http://localhost:8589/auth/authenticate \
        -H "Content-Type: application/json" \
        -d '{
            "email": "john@test.com",
            "password": "password123"
        }' 2>/dev/null | grep -o "success")
    
    if [ ! -z "$RESPONSE" ]; then
        print_result 0 "Authentication with valid credentials"
    else
        print_result 1 "Authentication failed"
    fi
    
    # Test login with invalid password (should fail gracefully)
    RESPONSE=$(curl -s -X POST http://localhost:8589/auth/authenticate \
        -H "Content-Type: application/json" \
        -d '{
            "email": "john@test.com",
            "password": "wrongpassword"
        }' 2>/dev/null | grep -o "Invalid")
    
    if [ ! -z "$RESPONSE" ]; then
        print_result 0 "Invalid password validation working"
    else
        print_result 1 "Invalid password validation failed"
    fi
}

# Function to test Student Service
test_student_service() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Testing Student Service (Port: 8585)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    test_service_health "Student Service" 8585 || return 1
    
    # Test GET all students
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8585/students 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "GET all students"
    else
        print_result 1 "GET all students failed (HTTP $RESPONSE)"
    fi
    
    # Test CREATE student with valid data
    STUDENT_RESPONSE=$(curl -s -X POST http://localhost:8585/students \
        -H "Content-Type: application/json" \
        -d '{
            "name": "Test Student",
            "email": "teststudent'$(date +%s)'@test.com",
            "phoneNumber": "1234567890"
        }' 2>/dev/null)
    
    STUDENT_ID=$(echo $STUDENT_RESPONSE | grep -o '"id":[0-9]*' | grep -o '[0-9]*')
    
    if [ ! -z "$STUDENT_ID" ]; then
        print_result 0 "CREATE student (ID: $STUDENT_ID)"
    else
        print_result 1 "CREATE student failed"
        return 1
    fi
    
    # Test GET student by valid ID
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8585/students/$STUDENT_ID 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "GET student by valid ID"
    else
        print_result 1 "GET student by ID failed (HTTP $RESPONSE)"
    fi
    
    # Test GET student by invalid ID (should return 404)
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8585/students/99999 2>/dev/null)
    if [ "$RESPONSE" == "404" ]; then
        print_result 0 "GET student by invalid ID (404 handled)"
    else
        print_result 1 "Invalid ID not handled properly (HTTP $RESPONSE)"
    fi
    
    # Test UPDATE student
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT http://localhost:8585/students/$STUDENT_ID \
        -H "Content-Type: application/json" \
        -d '{
            "name": "Updated Student",
            "email": "updated'$(date +%s)'@test.com",
            "phoneNumber": "9876543210"
        }' 2>/dev/null)
    
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "UPDATE student"
    else
        print_result 1 "UPDATE student failed (HTTP $RESPONSE)"
    fi
    
    # Test DELETE student
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE http://localhost:8585/students/$STUDENT_ID 2>/dev/null)
    if [ "$RESPONSE" == "204" ]; then
        print_result 0 "DELETE student"
    else
        print_result 1 "DELETE student failed (HTTP $RESPONSE)"
    fi
}

# Function to test Course Service
test_course_service() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Testing Course Service (Port: 8586)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    test_service_health "Course Service" 8586 || return 1
    
    # Test GET all courses
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8586/courses 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "GET all courses"
    else
        print_result 1 "GET all courses failed (HTTP $RESPONSE)"
    fi
    
    # Test CREATE course
    COURSE_RESPONSE=$(curl -s -X POST http://localhost:8586/courses \
        -H "Content-Type: application/json" \
        -d '{
            "courseName": "Test Course '$(date +%s)'",
            "credit": 3
        }' 2>/dev/null)
    
    COURSE_ID=$(echo $COURSE_RESPONSE | grep -o '"courseId":[0-9]*' | grep -o '[0-9]*')
    
    if [ ! -z "$COURSE_ID" ]; then
        print_result 0 "CREATE course (ID: $COURSE_ID)"
    else
        print_result 1 "CREATE course failed"
        return 1
    fi
    
    # Test GET course by ID
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8586/courses/$COURSE_ID 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "GET course by ID"
    else
        print_result 1 "GET course by ID failed (HTTP $RESPONSE)"
    fi
    
    # Test UPDATE course
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT http://localhost:8586/courses/$COURSE_ID \
        -H "Content-Type: application/json" \
        -d '{
            "courseName": "Updated Course",
            "credit": 4
        }' 2>/dev/null)
    
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "UPDATE course"
    else
        print_result 1 "UPDATE course failed (HTTP $RESPONSE)"
    fi
    
    # Test DELETE course
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE http://localhost:8586/courses/$COURSE_ID 2>/dev/null)
    if [ "$RESPONSE" == "200" ] || [ "$RESPONSE" == "204" ]; then
        print_result 0 "DELETE course"
    else
        print_result 1 "DELETE course failed (HTTP $RESPONSE)"
    fi
}

# Function to test Teacher Service
test_teacher_service() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Testing Teacher Service (Port: 8587)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    test_service_health "Teacher Service" 8587 || return 1
    
    # Test GET all teachers
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8587/teachers 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "GET all teachers"
    else
        print_result 1 "GET all teachers failed (HTTP $RESPONSE)"
    fi
    
    # Test CREATE teacher
    TEACHER_RESPONSE=$(curl -s -X POST http://localhost:8587/teachers \
        -H "Content-Type: application/json" \
        -d '{
            "teacherName": "Test Teacher '$(date +%s)'",
            "department": "Computer Science",
            "email": "teacher'$(date +%s)'@test.com"
        }' 2>/dev/null)
    
    TEACHER_ID=$(echo $TEACHER_RESPONSE | grep -o '"teacherId":[0-9]*' | grep -o '[0-9]*')
    
    if [ ! -z "$TEACHER_ID" ]; then
        print_result 0 "CREATE teacher (ID: $TEACHER_ID)"
    else
        print_result 1 "CREATE teacher failed"
        return 1
    fi
    
    # Test GET teacher by ID
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8587/teachers/$TEACHER_ID 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "GET teacher by ID"
    else
        print_result 1 "GET teacher by ID failed (HTTP $RESPONSE)"
    fi
    
    # Test UPDATE teacher
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT http://localhost:8587/teachers/$TEACHER_ID \
        -H "Content-Type: application/json" \
        -d '{
            "teacherName": "Updated Teacher",
            "department": "Mathematics",
            "email": "updated'$(date +%s)'@test.com"
        }' 2>/dev/null)
    
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "UPDATE teacher"
    else
        print_result 1 "UPDATE teacher failed (HTTP $RESPONSE)"
    fi
    
    # Test DELETE teacher
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE http://localhost:8587/teachers/$TEACHER_ID 2>/dev/null)
    if [ "$RESPONSE" == "200" ] || [ "$RESPONSE" == "204" ]; then
        print_result 0 "DELETE teacher"
    else
        print_result 1 "DELETE teacher failed (HTTP $RESPONSE)"
    fi
}

# Function to test Enrollment Service
test_enrollment_service() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}Testing Enrollment Service (Port: 8588)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    test_service_health "Enrollment Service" 8588 || return 1
    
    # Test GET all enrollments
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8588/enrollments 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "GET all enrollments"
    else
        print_result 1 "GET all enrollments failed (HTTP $RESPONSE)"
    fi
    
    # Note: Creating enrollment requires existing student, course, and teacher
    echo -e "${YELLOW}Note: Enrollment creation tests require existing student, course, and teacher${NC}"
}

# Main execution
echo -e "${YELLOW}Starting comprehensive testing...${NC}\n"

# Test all services
test_config_server
test_auth_service
test_student_service
test_course_service
test_teacher_service
test_enrollment_service

# Print summary
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📊 TEST SUMMARY${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Total Tests: ${BLUE}$TOTAL_TESTS${NC}"
echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed! 🎉${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please review the results above.${NC}"
    exit 1
fi
