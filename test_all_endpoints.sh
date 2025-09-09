#!/bin/bash

# Microservices API Testing Script
echo "============================================"
echo "🧪 MICROSERVICES API TESTING"
echo "============================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test function
test_endpoint() {
    local url=$1
    local description=$2
    local method=${3:-GET}
    
    echo -e "\n${BLUE}Testing: $description${NC}"
    echo "URL: $url"
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$url")
        http_code=$(echo "$response" | tail -n1)
        body=$(echo "$response" | head -n -1)
    else
        response=$(curl -s -w "\n%{http_code}" -X "$method" -H "Content-Type: application/json" "$url")
        http_code=$(echo "$response" | tail -n1)
        body=$(echo "$response" | head -n -1)
    fi
    
    if [ "$http_code" -eq 200 ] || [ "$http_code" -eq 201 ]; then
        echo -e "${GREEN}✅ SUCCESS ($http_code)${NC}"
        echo "Response: $body"
    else
        echo -e "${RED}❌ FAILED ($http_code)${NC}"
        echo "Response: $body"
    fi
    echo "----------------------------------------"
}

echo -e "\n${YELLOW}🔍 INFRASTRUCTURE HEALTH CHECKS${NC}"

# 1. Eureka Server
test_endpoint "http://localhost:8761/actuator/health" "Eureka Server Health"

# 2. API Gateway  
test_endpoint "http://localhost:8080/actuator/health" "API Gateway Health"

echo -e "\n${YELLOW}🏥 DIRECT SERVICE HEALTH CHECKS${NC}"

# 3. Student Service Direct
test_endpoint "http://localhost:8585/students/health" "Student Service Health (Direct)"

# 4. Course Service Direct
test_endpoint "http://localhost:8586/courses/health" "Course Service Health (Direct)"

# 5. Teacher Service Direct
test_endpoint "http://localhost:8587/teachers/health" "Teacher Service Health (Direct)"

# 6. Enrollment Service Direct
test_endpoint "http://localhost:8588/enrollments/health" "Enrollment Service Health (Direct)"

echo -e "\n${YELLOW}🌐 API GATEWAY ROUTING TESTS${NC}"

# 7. Student Service via Gateway
test_endpoint "http://localhost:8080/api/students/health" "Student Service via Gateway"

# 8. Course Service via Gateway
test_endpoint "http://localhost:8080/api/courses/health" "Course Service via Gateway"

# 9. Teacher Service via Gateway
test_endpoint "http://localhost:8080/api/teachers/health" "Teacher Service via Gateway"

# 10. Enrollment Service via Gateway
test_endpoint "http://localhost:8080/api/enrollments/health" "Enrollment Service via Gateway"

echo -e "\n${YELLOW}📊 DATA ENDPOINTS (GET ALL)${NC}"

# 11. Get All Students (Direct)
test_endpoint "http://localhost:8585/students" "Get All Students (Direct)"

# 12. Get All Students (via Gateway)
test_endpoint "http://localhost:8080/api/students" "Get All Students (via Gateway)"

# 13. Get All Courses (Direct)
test_endpoint "http://localhost:8586/courses" "Get All Courses (Direct)"

# 14. Get All Courses (via Gateway)
test_endpoint "http://localhost:8080/api/courses" "Get All Courses (via Gateway)"

# 15. Get All Teachers (Direct)
test_endpoint "http://localhost:8587/teachers" "Get All Teachers (Direct)"

# 16. Get All Teachers (via Gateway)
test_endpoint "http://localhost:8080/api/teachers" "Get All Teachers (via Gateway)"

# 17. Get All Enrollments (Direct)
test_endpoint "http://localhost:8588/enrollments" "Get All Enrollments (Direct)"

# 18. Get All Enrollments (via Gateway)
test_endpoint "http://localhost:8080/api/enrollments" "Get All Enrollments (via Gateway)"

echo -e "\n${YELLOW}🔍 SERVICE DISCOVERY CHECK${NC}"

# 19. Check Eureka Registered Services
echo -e "\n${BLUE}Checking Eureka Service Registry:${NC}"
curl -s "http://localhost:8761/eureka/apps" | grep -o "<name>[^<]*</name>" | sed 's/<name>//g' | sed 's/<\/name>//g' | sort | uniq

echo -e "\n\n${GREEN}🎉 Testing Complete!${NC}"
echo "Check results above for any failed endpoints."
