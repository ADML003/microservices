#!/bin/bash

# Quick Testing Script for Currently Running Services
# Tests Config Server, Auth Service, and Student Service

echo "======================================"
echo "🧪 TESTING RUNNING SERVICES"
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

# Test Config Server
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Testing Configuration Server (Port: 8888)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Health check
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8888/actuator/health 2>/dev/null)
if [ "$RESPONSE" == "200" ]; then
    print_result 0 "Config Server health check"
else
    print_result 1 "Config Server health check (HTTP $RESPONSE)"
fi

# Test student-service configuration
RESPONSE=$(curl -s http://localhost:8888/student-service/default 2>/dev/null | grep -o "student_db")
if [ ! -z "$RESPONSE" ]; then
    print_result 0 "Student Service configuration available"
else
    print_result 1 "Student Service configuration not found"
fi

# Test auth-service configuration
RESPONSE=$(curl -s http://localhost:8888/auth-service/default 2>/dev/null | grep -o "auth_db")
if [ ! -z "$RESPONSE" ]; then
    print_result 0 "Auth Service configuration available"
else
    print_result 1 "Auth Service configuration not found"
fi

# Test Auth Service
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Testing Authentication Service (Port: 8589)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Health check
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8589/auth/health 2>/dev/null)
if [ "$RESPONSE" == "200" ]; then
    print_result 0 "Auth Service health endpoint"
else
    print_result 1 "Auth Service health endpoint (HTTP $RESPONSE)"
fi

# Test signup with valid data
TIMESTAMP=$(date +%s)
SIGNUP_RESPONSE=$(curl -s -X POST http://localhost:8589/auth/signup \
    -H "Content-Type: application/json" \
    -d '{
        "name": "Test User",
        "email": "test'$TIMESTAMP'@test.com",
        "password": "Test@1234"
    }' 2>/dev/null)

if echo "$SIGNUP_RESPONSE" | grep -q "success"; then
    print_result 0 "User signup with valid data"
else
    print_result 1 "User signup failed - Response: $SIGNUP_RESPONSE"
fi

# Test signup with invalid email
INVALID_EMAIL_RESPONSE=$(curl -s -X POST http://localhost:8589/auth/signup \
    -H "Content-Type: application/json" \
    -d '{
        "name": "Test User",
        "email": "invalid-email",
        "password": "Test@1234"
    }' 2>/dev/null)

if echo "$INVALID_EMAIL_RESPONSE" | grep -q "Invalid email format"; then
    print_result 0 "Invalid email validation working"
else
    print_result 1 "Invalid email validation not working properly"
fi

# Test login with valid credentials (using existing user from database_setup.sql)
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8589/auth/authenticate \
    -H "Content-Type: application/json" \
    -d '{
        "email": "john@test.com",
        "password": "password123"
    }' 2>/dev/null)

if echo "$LOGIN_RESPONSE" | grep -q "success"; then
    print_result 0 "Authentication with valid credentials"
else
    print_result 1 "Authentication failed - Response: $LOGIN_RESPONSE"
fi

# Test login with wrong password
WRONG_PWD_RESPONSE=$(curl -s -X POST http://localhost:8589/auth/authenticate \
    -H "Content-Type: application/json" \
    -d '{
        "email": "john@test.com",
        "password": "wrongpassword"
    }' 2>/dev/null)

if echo "$WRONG_PWD_RESPONSE" | grep -q "Invalid credentials"; then
    print_result 0 "Invalid password rejection working"
else
    print_result 1 "Invalid password handling not working properly"
fi

# Test Student Service
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Testing Student Service (Port: 8585)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Health check
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8585/actuator/health 2>/dev/null)
if [ "$RESPONSE" == "200" ]; then
    print_result 0 "Student Service health check"
else
    print_result 1 "Student Service health check (HTTP $RESPONSE)"
fi

# Test GET all students
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8585/students 2>/dev/null)
if [ "$RESPONSE" == "200" ]; then
    print_result 0 "GET all students"
else
    print_result 1 "GET all students (HTTP $RESPONSE)"
fi

# Test CREATE student with valid data
STUDENT_RESPONSE=$(curl -s -X POST http://localhost:8585/students \
    -H "Content-Type: application/json" \
    -d '{
        "name": "Alice Johnson",
        "email": "alice'$TIMESTAMP'@test.com",
        "phoneNumber": "9876543210"
    }' 2>/dev/null)

STUDENT_ID=$(echo $STUDENT_RESPONSE | grep -o '"id":[0-9]*' | grep -o '[0-9]*' | head -1)

if [ ! -z "$STUDENT_ID" ]; then
    print_result 0 "CREATE student (ID: $STUDENT_ID)"
else
    print_result 1 "CREATE student failed"
    STUDENT_ID=1  # Fallback for remaining tests
fi

# Test GET student by valid ID
if [ ! -z "$STUDENT_ID" ]; then
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8585/students/$STUDENT_ID 2>/dev/null)
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "GET student by valid ID ($STUDENT_ID)"
    else
        print_result 1 "GET student by ID (HTTP $RESPONSE)"
    fi
fi

# Test GET student by invalid ID (should return 404)
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8585/students/99999 2>/dev/null)
if [ "$RESPONSE" == "404" ]; then
    print_result 0 "GET student by invalid ID (404 handled correctly)"
else
    print_result 1 "Invalid ID not handled properly (HTTP $RESPONSE, expected 404)"
fi

# Test UPDATE student
if [ ! -z "$STUDENT_ID" ]; then
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X PUT http://localhost:8585/students/$STUDENT_ID \
        -H "Content-Type: application/json" \
        -d '{
            "name": "Alice Updated",
            "email": "alice.updated'$TIMESTAMP'@test.com",
            "phoneNumber": "1112223333"
        }' 2>/dev/null)
    
    if [ "$RESPONSE" == "200" ]; then
        print_result 0 "UPDATE student"
    else
        print_result 1 "UPDATE student (HTTP $RESPONSE)"
    fi
fi

# Test DELETE student
if [ ! -z "$STUDENT_ID" ]; then
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE http://localhost:8585/students/$STUDENT_ID 2>/dev/null)
    if [ "$RESPONSE" == "204" ]; then
        print_result 0 "DELETE student"
    else
        print_result 1 "DELETE student (HTTP $RESPONSE, expected 204)"
    fi
fi

# Print summary
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}📊 TEST SUMMARY${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Total Tests: ${BLUE}$TOTAL_TESTS${NC}"
echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed: ${RED}$FAILED_TESTS${NC}"

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed! 🎉${NC}"
else
    PASS_RATE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    echo -e "${YELLOW}Pass Rate: ${PASS_RATE}%${NC}"
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

exit 0
