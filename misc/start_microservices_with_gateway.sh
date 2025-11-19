#!/bin/bash

# Microservices with Eureka Server and API Gateway Startup Script
# This script starts all components in the correct order

set -e

echo "============================================"
echo "🚀 MICROSERVICES WITH EUREKA & GATEWAY"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if a service is running on a port
check_service() {
    local port=$1
    local service_name=$2
    local max_attempts=30
    local attempt=1
    
    echo -e "${BLUE}[INFO] Waiting for $service_name to start on port $port...${NC}"
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s http://localhost:$port/actuator/health > /dev/null 2>&1 || 
           curl -s http://localhost:$port/health > /dev/null 2>&1 ||
           nc -z localhost $port 2>/dev/null; then
            echo -e "${GREEN}[SUCCESS] $service_name is ready!${NC}"
            return 0
        fi
        echo -n "."
        sleep 2
        ((attempt++))
    done
    
    echo -e "${RED}[ERROR] $service_name failed to start within 60 seconds${NC}"
    return 1
}

# Cleanup function
cleanup() {
    echo -e "${YELLOW}[WARNING] Stopping all services...${NC}"
    pkill -f "eureka-server" 2>/dev/null || true
    pkill -f "api-gateway" 2>/dev/null || true
    pkill -f "student-service" 2>/dev/null || true
    pkill -f "course-service" 2>/dev/null || true
    pkill -f "teacher-service" 2>/dev/null || true
    pkill -f "enrollment-service" 2>/dev/null || true
    echo -e "${GREEN}[SUCCESS] All services stopped${NC}"
}

# Set trap for cleanup on script exit
trap cleanup EXIT

echo -e "${BLUE}[INFO] Checking prerequisites...${NC}"

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}[ERROR] Maven is not installed or not in PATH${NC}"
    exit 1
fi

# Check if MySQL is running
if ! nc -z localhost 3306 2>/dev/null; then
    echo -e "${RED}[ERROR] MySQL is not running on port 3306${NC}"
    echo -e "${YELLOW}[INFO] Please start MySQL before running this script${NC}"
    exit 1
fi

echo -e "${GREEN}[SUCCESS] Prerequisites check passed${NC}"

echo -e "${BLUE}[INFO] Cleaning up any existing services...${NC}"
cleanup
sleep 2

echo -e "${BLUE}[INFO] 🎯 Starting services in order...${NC}"

# 1. Start Eureka Server
echo -e "${YELLOW}[SERVICE] Starting Eureka Server on port 8761...${NC}"
cd eureka-server
nohup mvn spring-boot:run > ../Eureka_server.log 2>&1 &
EUREKA_PID=$!
echo -e "${BLUE}[INFO] Eureka Server started with PID $EUREKA_PID${NC}"
cd ..

# Wait for Eureka Server
if ! check_service 8761 "Eureka Server"; then
    echo -e "${RED}[ERROR] Failed to start Eureka Server${NC}"
    exit 1
fi

sleep 10  # Extra time for Eureka to be fully ready

# 2. Start API Gateway
echo -e "${YELLOW}[SERVICE] Starting API Gateway on port 8080...${NC}"
cd api-gateway
nohup mvn spring-boot:run > ../API_gateway.log 2>&1 &
GATEWAY_PID=$!
echo -e "${BLUE}[INFO] API Gateway started with PID $GATEWAY_PID${NC}"
cd ..

# Wait for API Gateway
if ! check_service 8080 "API Gateway"; then
    echo -e "${RED}[ERROR] Failed to start API Gateway${NC}"
    exit 1
fi

sleep 5

# 3. Start Student Service
echo -e "${YELLOW}[SERVICE] Starting Student Service on port 8585...${NC}"
cd student-service
nohup mvn spring-boot:run > ../Student_service.log 2>&1 &
STUDENT_PID=$!
echo -e "${BLUE}[INFO] Student Service started with PID $STUDENT_PID${NC}"
cd ..

if ! check_service 8585 "Student Service"; then
    echo -e "${RED}[ERROR] Failed to start Student Service${NC}"
    exit 1
fi

# 4. Start Course Service
echo -e "${YELLOW}[SERVICE] Starting Course Service on port 8586...${NC}"
cd course-service
nohup mvn spring-boot:run > ../Course_service.log 2>&1 &
COURSE_PID=$!
echo -e "${BLUE}[INFO] Course Service started with PID $COURSE_PID${NC}"
cd ..

if ! check_service 8586 "Course Service"; then
    echo -e "${RED}[ERROR] Failed to start Course Service${NC}"
    exit 1
fi

# 5. Start Teacher Service
echo -e "${YELLOW}[SERVICE] Starting Teacher Service on port 8587...${NC}"
cd teacher-service
nohup mvn spring-boot:run > ../Teacher_service.log 2>&1 &
TEACHER_PID=$!
echo -e "${BLUE}[INFO] Teacher Service started with PID $TEACHER_PID${NC}"
cd ..

if ! check_service 8587 "Teacher Service"; then
    echo -e "${RED}[ERROR] Failed to start Teacher Service${NC}"
    exit 1
fi

# 6. Start Enrollment Service
echo -e "${BLUE}[INFO] Waiting 5 seconds before starting Enrollment Service...${NC}"
sleep 5

echo -e "${YELLOW}[SERVICE] Starting Enrollment Service on port 8588...${NC}"
cd enrollment-service
nohup mvn spring-boot:run > ../Enrollment_service.log 2>&1 &
ENROLLMENT_PID=$!
echo -e "${BLUE}[INFO] Enrollment Service started with PID $ENROLLMENT_PID${NC}"
cd ..

if ! check_service 8588 "Enrollment Service"; then
    echo -e "${RED}[ERROR] Failed to start Enrollment Service${NC}"
    exit 1
fi

echo -e "${GREEN}[SUCCESS] 🎉 All services started successfully!${NC}"

echo ""
echo "📊 MICROSERVICES ARCHITECTURE DASHBOARD"
echo "======================================="
echo ""
echo -e "${GREEN}✅ Eureka Server     → http://localhost:8761${NC}"
echo -e "${GREEN}✅ API Gateway       → http://localhost:8080${NC}"
echo -e "${GREEN}✅ Student Service   → http://localhost:8585/students${NC}"
echo -e "${GREEN}✅ Course Service    → http://localhost:8586/courses${NC}"
echo -e "${GREEN}✅ Teacher Service   → http://localhost:8587/teachers${NC}"
echo -e "${GREEN}✅ Enrollment Service → http://localhost:8588/enrollments${NC}"
echo ""
echo "🔍 PROCESS INFORMATION"
echo "======================"
echo "Eureka Server PID:     $EUREKA_PID"
echo "API Gateway PID:       $GATEWAY_PID"
echo "Student Service PID:   $STUDENT_PID"
echo "Course Service PID:    $COURSE_PID"
echo "Teacher Service PID:   $TEACHER_PID"
echo "Enrollment Service PID: $ENROLLMENT_PID"
echo ""
echo "📋 LOG FILES"
echo "============"
echo "Eureka Server:    Eureka_server.log"
echo "API Gateway:      API_gateway.log"
echo "Student Service:  Student_service.log"
echo "Course Service:   Course_service.log"
echo "Teacher Service:  Teacher_service.log"
echo "Enrollment Service: Enrollment_service.log"
echo ""
echo "🧪 QUICK TEST COMMANDS (via API Gateway)"
echo "==========================================="
echo "Test via API Gateway:"
echo "  curl http://localhost:8080/api/students"
echo "  curl http://localhost:8080/api/courses"
echo "  curl http://localhost:8080/api/teachers"
echo "  curl http://localhost:8080/api/enrollments"
echo ""
echo "Test direct access:"
echo "  curl http://localhost:8585/students/health"
echo "  curl http://localhost:8586/courses/health"
echo "  curl http://localhost:8587/teachers/health"
echo "  curl http://localhost:8588/enrollments/health"
echo ""
echo "🛑 TO STOP ALL SERVICES"
echo "========================"
echo "Press Ctrl+C or run: ./stop_microservices_with_gateway.sh"
echo ""
echo -e "${GREEN}[SUCCESS] Microservices with Eureka and Gateway startup complete!${NC}"
echo -e "${BLUE}[INFO] Check Eureka dashboard at http://localhost:8761${NC}"
echo -e "${YELLOW}[WARNING] Keep this terminal open to maintain services running...${NC}"

# Monitor services
while true; do
    sleep 30
    echo -e "${BLUE}[MONITOR] All services running... $(date +%H:%M:%S)${NC}"
done
