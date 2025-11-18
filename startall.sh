#!/bin/bash

# Start All Services Script with Config Server and Auth Service
# This script starts all microservices in the correct order

echo "======================================"
echo "🚀 Starting All Microservices"
echo "======================================"

BASE_DIR="/Users/ADML/Desktop/microservices "

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to check if a port is in use
check_port() {
    PORT=$1
    lsof -i :$PORT | grep LISTEN > /dev/null 2>&1
    return $?
}

# Function to wait for service to start
wait_for_service() {
    SERVICE_NAME=$1
    PORT=$2
    MAX_WAIT=60
    WAITED=0
    
    echo -e "${YELLOW}Waiting for $SERVICE_NAME to start on port $PORT...${NC}"
    
    while [ $WAITED -lt $MAX_WAIT ]; do
        if check_port $PORT; then
            echo -e "${GREEN}✓ $SERVICE_NAME is UP on port $PORT${NC}"
            return 0
        fi
        sleep 2
        WAITED=$((WAITED + 2))
        echo -n "."
    done
    
    echo -e "\n${YELLOW}⚠ $SERVICE_NAME did not start within $MAX_WAIT seconds${NC}"
    return 1
}

# 1. Start Config Server (if not running)
echo -e "\n${BLUE}1. Starting Configuration Server...${NC}"
if check_port 8888; then
    echo -e "${GREEN}✓ Config Server is already running on port 8888${NC}"
else
    cd "$BASE_DIR/config-server"
    nohup mvn spring-boot:run > ../config-server.log 2>&1 &
    echo $! > ../config-server.pid
    wait_for_service "Config Server" 8888
fi

# Wait a bit for config server to be ready
sleep 3

# 2. Start Auth Service
echo -e "\n${BLUE}2. Starting Authentication Service...${NC}"
if check_port 8589; then
    echo -e "${GREEN}✓ Auth Service is already running on port 8589${NC}"
else
    cd "$BASE_DIR/auth-service"
    nohup mvn spring-boot:run > ../auth-service.log 2>&1 &
    echo $! > ../auth-service.pid
    wait_for_service "Auth Service" 8589
fi

# 3. Start Student Service
echo -e "\n${BLUE}3. Starting Student Service...${NC}"
if check_port 8585; then
    echo -e "${GREEN}✓ Student Service is already running on port 8585${NC}"
else
    cd "$BASE_DIR/student-service"
    nohup mvn spring-boot:run > ../Student_service.log 2>&1 &
    echo $! > ../student-service.pid
    wait_for_service "Student Service" 8585
fi

# 4. Start Course Service
echo -e "\n${BLUE}4. Starting Course Service...${NC}"
if check_port 8586; then
    echo -e "${GREEN}✓ Course Service is already running on port 8586${NC}"
else
    cd "$BASE_DIR/course-service"
    nohup mvn spring-boot:run > ../Course_service.log 2>&1 &
    echo $! > ../course-service.pid
    wait_for_service "Course Service" 8586
fi

# 5. Start Teacher Service
echo -e "\n${BLUE}5. Starting Teacher Service...${NC}"
if check_port 8587; then
    echo -e "${GREEN}✓ Teacher Service is already running on port 8587${NC}"
else
    cd "$BASE_DIR/teacher-service"
    nohup mvn spring-boot:run > ../Teacher_service.log 2>&1 &
    echo $! > ../teacher-service.pid
    wait_for_service "Teacher Service" 8587
fi

# 6. Start Enrollment Service
echo -e "\n${BLUE}6. Starting Enrollment Service...${NC}"
if check_port 8588; then
    echo -e "${GREEN}✓ Enrollment Service is already running on port 8588${NC}"
else
    cd "$BASE_DIR/enrollment-service"
    nohup mvn spring-boot:run > ../Enrollment_service.log 2>&1 &
    echo $! > ../enrollment-service.pid
    wait_for_service "Enrollment Service" 8588
fi

# 7. Start API Gateway
echo -e "\n${BLUE}7. Starting API Gateway...${NC}"
if check_port 8080; then
    echo -e "${GREEN}✓ API Gateway is already running on port 8080${NC}"
else
    cd "$BASE_DIR/api-gateway"
    nohup mvn spring-boot:run > ../api-gateway.log 2>&1 &
    echo $! > ../api-gateway.pid
    wait_for_service "API Gateway" 8080
fi

echo ""
echo "======================================"
echo -e "${GREEN}✓ All Services Started!${NC}"
echo "======================================"
echo ""
echo "Service Status:"
echo "  Config Server:      http://localhost:8888"
echo "  Auth Service:       http://localhost:8589"
echo "  Student Service:    http://localhost:8585"
echo "  Course Service:     http://localhost:8586"
echo "  Teacher Service:    http://localhost:8587"
echo "  Enrollment Service: http://localhost:8588"
echo "  API Gateway:        http://localhost:8080"
echo ""
echo "Log files created in: $BASE_DIR"
echo "PID files created in: $BASE_DIR"
echo ""
echo "To test all services, run:"
echo "  ./test_all_services_comprehensive.sh"
echo ""
echo "To stop all services, run:"
echo "  ./stop_all_services.sh"
