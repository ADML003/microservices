#!/bin/bash

# 🔧 Student Service Testing Script
# This script tests all endpoints and database connectivity

echo "🚀 Starting Student Service Testing..."
echo "===================================="

# Configuration
MAIN_SERVICE="http://localhost:8585"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to test endpoint
test_endpoint() {
    local url=$1
    local description=$2
    local expected_status=${3:-200}
    
    echo -n "Testing: $description ... "
    
    # Make request and capture status code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$status_code" -eq "$expected_status" ]; then
        echo -e "${GREEN}✅ PASS${NC} (Status: $status_code)"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC} (Status: $status_code, Expected: $expected_status)"
        return 1
    fi
}

# Function to test endpoint with response content
test_endpoint_with_content() {
    local url=$1
    local description=$2
    local expected_content=$3
    
    echo -n "Testing: $description ... "
    
    # Make request and capture response
    response=$(curl -s "$url")
    status_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$status_code" -eq 200 ] && [[ "$response" == *"$expected_content"* ]]; then
        echo -e "${GREEN}✅ PASS${NC}"
        echo "  Response preview: ${response:0:100}..."
        return 0
    else
        echo -e "${RED}❌ FAIL${NC} (Status: $status_code)"
        echo "  Response: $response"
        return 1
    fi
}

# Function to test POST endpoint
test_post_endpoint() {
    local url=$1
    local description=$2
    local data=$3
    local expected_status=${4:-201}
    
    echo -n "Testing: $description ... "
    
    # Make POST request
    status_code=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST \
        -H "Content-Type: application/json" \
        -d "$data" \
        "$url")
    
    if [ "$status_code" -eq "$expected_status" ]; then
        echo -e "${GREEN}✅ PASS${NC} (Status: $status_code)"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC} (Status: $status_code, Expected: $expected_status)"
        return 1
    fi
}

# Counter for results
TOTAL_TESTS=0
PASSED_TESTS=0

# Function to run test and update counters
run_test() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if "$@"; then
        PASSED_TESTS=$((PASSED_TESTS + 1))
    fi
}

echo ""
echo -e "${BLUE}📊 Testing Database Connectivity${NC}"
echo "================================"

# Test database endpoints
run_test test_endpoint_with_content "$STUDENT_SERVICE/test/sql-connection" "SQL Connection Test" "SQL Connection Test SUCCESSFUL"
run_test test_endpoint "$STUDENT_SERVICE/test/database-info" "Database Info"
run_test test_endpoint "$STUDENT_SERVICE/test/students-direct" "Direct Student Query"

echo ""
echo -e "${BLUE}👥 Testing Student Service API (Port 8585)${NC}"
echo "==========================================="

# Test main CRUD operations
run_test test_endpoint "$STUDENT_SERVICE/students" "GET All Students"
run_test test_endpoint "$STUDENT_SERVICE/students/1" "GET Student by ID"

# Test POST - Create new student
NEW_STUDENT_DATA='{
    "name": "Test Student",
    "email": "test@example.com",
    "age": 25,
    "address": "Test Address",
    "phoneNumber": "+1234567890"
}'
run_test test_post_endpoint "$MAIN_SERVICE/students" "POST Create Student" "$NEW_STUDENT_DATA"

echo ""
echo -e "${BLUE}📋 Testing Advanced Database Operations${NC}"
echo "====================================="

# Test database queries via MySQL command line (if available)
if command -v mysql &> /dev/null; then
    echo -n "Testing: MySQL Command Line Access ... "
    if mysql -u root -e "USE student_management; SELECT COUNT(*) FROM students;" &> /dev/null; then
        echo -e "${GREEN}✅ PASS${NC}"
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
        PASSED_TESTS=$((PASSED_TESTS + 1))
        
        # Get student count
        student_count=$(mysql -u root -e "USE student_management; SELECT COUNT(*) FROM students;" -s -N 2>/dev/null)
        echo "  📊 Total students in database: $student_count"
    else
        echo -e "${RED}❌ FAIL${NC} (MySQL access denied or database not found)"
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
    fi
else
    echo -e "${YELLOW}⚠️  MySQL command not available - skipping direct database test${NC}"
fi

echo ""
echo -e "${BLUE}📈 Test Results Summary${NC}"
echo "======================"

# Calculate success rate
if [ $TOTAL_TESTS -gt 0 ]; then
    success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
else
    success_rate=0
fi

echo "Total Tests: $TOTAL_TESTS"
echo "Passed: $PASSED_TESTS"
echo "Failed: $((TOTAL_TESTS - PASSED_TESTS))"
echo "Success Rate: $success_rate%"

if [ $success_rate -ge 80 ]; then
    echo -e "${GREEN}🎉 Overall Status: EXCELLENT${NC}"
elif [ $success_rate -ge 60 ]; then
    echo -e "${YELLOW}⚠️  Overall Status: GOOD (Some issues detected)${NC}"
else
    echo -e "${RED}❌ Overall Status: POOR (Multiple failures detected)${NC}"
fi

echo ""
echo -e "${BLUE}💡 Next Steps:${NC}"
echo "============="
if [ $PASSED_TESTS -lt $TOTAL_TESTS ]; then
    echo "1. Check that the service is running:"
    echo "   - Main Student Service (8585): mvn spring-boot:run"
    echo ""
    echo "2. Verify MySQL is running and database exists:"
    echo "   mysql -u root -p -e 'SHOW DATABASES;'"
    echo ""
    echo "3. Check application logs for errors"
else
    echo "✅ All tests passed! Your student service is working correctly."
    echo "🔗 You can now use Postman to interact with the APIs"
    echo "📊 Check the database using: mysql -u root -p student_management"
fi

echo ""
echo "🏁 Testing Complete!"
echo "=================="

# Exit with appropriate code
if [ $PASSED_TESTS -eq $TOTAL_TESTS ]; then
    exit 0
else
    exit 1
fi