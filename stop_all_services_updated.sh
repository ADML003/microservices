#!/bin/bash

# 🛑 Stop All Microservices Script (Updated with Config Server and Auth Service)
# This script stops all running microservices gracefully

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

echo -e "${BLUE}🛑 STOPPING ALL MICROSERVICES${NC}"
echo -e "${BLUE}==============================${NC}"
echo ""

services_stopped=0

# Function to stop service by PID file
stop_service() {
    SERVICE_NAME=$1
    PID_FILE=$2
    
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if ps -p $pid > /dev/null 2>&1; then
            print_status "Stopping $SERVICE_NAME (PID: $pid)..."
            kill $pid 2>/dev/null || true
            sleep 2
            if ! ps -p $pid > /dev/null 2>&1; then
                print_success "$SERVICE_NAME stopped"
                services_stopped=$((services_stopped + 1))
            else
                print_warning "Force stopping $SERVICE_NAME..."
                kill -9 $pid 2>/dev/null || true
                services_stopped=$((services_stopped + 1))
            fi
        else
            print_warning "$SERVICE_NAME was not running"
        fi
        rm -f "$PID_FILE"
    else
        print_warning "$SERVICE_NAME PID file not found"
    fi
}

# Function to stop service by port
stop_by_port() {
    SERVICE_NAME=$1
    PORT=$2
    
    pid=$(lsof -ti:$PORT 2>/dev/null)
    if [ ! -z "$pid" ]; then
        print_status "Stopping $SERVICE_NAME on port $PORT (PID: $pid)..."
        kill $pid 2>/dev/null || true
        sleep 2
        if ! ps -p $pid > /dev/null 2>&1; then
            print_success "$SERVICE_NAME stopped"
            services_stopped=$((services_stopped + 1))
        else
            print_warning "Force stopping $SERVICE_NAME..."
            kill -9 $pid 2>/dev/null || true
            services_stopped=$((services_stopped + 1))
        fi
    else
        print_warning "$SERVICE_NAME was not running on port $PORT"
    fi
}

# Stop services in reverse order of startup

# Stop Enrollment Service
print_status "Checking Enrollment Service..."
stop_service "Enrollment Service" "enrollment-service.pid"
stop_by_port "Enrollment Service" 8588

# Stop Teacher Service
print_status "Checking Teacher Service..."
stop_service "Teacher Service" "teacher-service.pid"
stop_by_port "Teacher Service" 8587

# Stop Course Service
print_status "Checking Course Service..."
stop_service "Course Service" "course-service.pid"
stop_by_port "Course Service" 8586

# Stop Student Service
print_status "Checking Student Service..."
stop_service "Student Service" "student-service.pid"
stop_service "Student Service" ".student_pid"
stop_by_port "Student Service" 8585

# Stop Auth Service
print_status "Checking Auth Service..."
stop_service "Auth Service" "auth-service.pid"
stop_by_port "Auth Service" 8589

# Stop Config Server
print_status "Checking Config Server..."
stop_service "Config Server" "config-server.pid"
stop_by_port "Config Server" 8888

# Stop API Gateway (if running)
print_status "Checking API Gateway..."
stop_service "API Gateway" "api-gateway.pid"
stop_by_port "API Gateway" 8080

# Stop Eureka Server (if running)
print_status "Checking Eureka Server..."
stop_service "Eureka Server" "eureka-server.pid"
stop_by_port "Eureka Server" 8761

# Clean up old PID files
rm -f .course_pid .teacher_pid .enrollment_pid .student_pid

echo ""
echo -e "${BLUE}==============================${NC}"
if [ $services_stopped -gt 0 ]; then
    print_success "Stopped $services_stopped service(s)"
else
    print_warning "No services were running"
fi
echo -e "${BLUE}==============================${NC}"
echo ""
