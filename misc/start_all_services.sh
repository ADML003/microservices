#!/bin/bash

# 🚀 Start All Microservices Script
# This script starts all 4 microservices in the background and monitors them

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Function to print colored output
print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}🚀 MICROSERVICES STARTUP ORCHESTRATOR${NC}"
    echo -e "${BLUE}============================================${NC}"
}

print_status() {
    echo -e "${CYAN}[INFO]${NC} $1"
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

print_service() {
    echo -e "${PURPLE}[SERVICE]${NC} $1"
}

# Cleanup function to kill all background processes
cleanup() {
    print_warning "Stopping all microservices..."
    if [ -f .student_pid ]; then
        kill $(cat .student_pid) 2>/dev/null || true
        rm -f .student_pid
    fi
    if [ -f .course_pid ]; then
        kill $(cat .course_pid) 2>/dev/null || true
        rm -f .course_pid
    fi
    if [ -f .teacher_pid ]; then
        kill $(cat .teacher_pid) 2>/dev/null || true
        rm -f .teacher_pid
    fi
    if [ -f .enrollment_pid ]; then
        kill $(cat .enrollment_pid) 2>/dev/null || true
        rm -f .enrollment_pid
    fi
    print_success "All services stopped"
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM EXIT

# Function to check if a port is available
check_port() {
    local port=$1
    if lsof -ti:$port >/dev/null 2>&1; then
        return 1  # Port is busy
    else
        return 0  # Port is available
    fi
}

# Function to kill process on port if needed
free_port() {
    local port=$1
    if lsof -ti:$port >/dev/null 2>&1; then
        print_warning "Port $port is in use. Stopping existing process..."
        lsof -ti:$port | xargs kill 2>/dev/null || true
        sleep 2
        if lsof -ti:$port >/dev/null 2>&1; then
            print_warning "Force killing process on port $port..."
            lsof -ti:$port | xargs kill -9 2>/dev/null || true
            sleep 1
        fi
    fi
}

# Function to wait for service to start
wait_for_service() {
    local service_name=$1
    local port=$2
    local max_attempts=30
    local attempt=0
    
    print_status "Waiting for $service_name to start on port $port..."
    
    while [ $attempt -lt $max_attempts ]; do
        if curl -s -f http://localhost:$port/actuator/health >/dev/null 2>&1 || 
           curl -s -f http://localhost:$port/students >/dev/null 2>&1 ||
           curl -s -f http://localhost:$port/courses >/dev/null 2>&1 ||
           curl -s -f http://localhost:$port/teachers >/dev/null 2>&1 ||
           curl -s -f http://localhost:$port/enrollments >/dev/null 2>&1; then
            print_success "$service_name is ready!"
            return 0
        fi
        
        echo -n "."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    print_error "$service_name failed to start within $((max_attempts * 2)) seconds"
    return 1
}

# Function to start a service
start_service() {
    local service_name=$1
    local port=$2
    local directory=$3
    local pid_file=$4
    
    print_service "Starting $service_name on port $port..."
    
    # Check if port is available
    if ! check_port $port; then
        print_warning "Port $port is already in use!"
        free_port $port
        if ! check_port $port; then
            print_error "Unable to free port $port. Please manually stop the process."
            print_status "You can run: lsof -ti:$port | xargs kill"
            return 1
        fi
        print_success "Port $port is now available"
    fi
    
    # Start the service
    cd "$directory"
    nohup mvn spring-boot:run > "../${service_name}_service.log" 2>&1 &
    local pid=$!
    echo $pid > "../$pid_file"
    cd ..
    
    print_status "$service_name started with PID $pid"
    
    # Wait for service to be ready
    if wait_for_service "$service_name" "$port"; then
        return 0
    else
        return 1
    fi
}

print_header

# Check prerequisites
print_status "Checking prerequisites..."

if ! command -v mvn &> /dev/null; then
    print_error "Maven is not installed or not in PATH"
    exit 1
fi

if ! command -v java &> /dev/null; then
    print_error "Java is not installed or not in PATH"
    exit 1
fi

print_success "Prerequisites check passed"

# Clean up any existing processes and PID files
print_status "Cleaning up any existing services..."
cleanup_existing_services() {
    for port in 8585 8586 8587 8588; do
        if lsof -ti:$port >/dev/null 2>&1; then
            print_warning "Found existing process on port $port, stopping it..."
            lsof -ti:$port | xargs kill 2>/dev/null || true
            sleep 1
        fi
    done
    
    # Remove any existing PID files
    rm -f .student_pid .course_pid .teacher_pid .enrollment_pid
    print_success "Cleanup completed"
}

cleanup_existing_services

# Check if MySQL is running
print_status "Checking MySQL connection..."
if ! mysql -u root -e "SELECT 1;" >/dev/null 2>&1; then
    print_error "MySQL is not running. Please start MySQL first."
    print_status "You can run: ./setup_microservices.sh to setup databases"
    exit 1
fi
print_success "MySQL is running"

echo ""
print_status "🎯 Starting microservices in order..."
echo ""

# Start services in dependency order
services_started=0

# 1. Start Student Service (Port 8585)
if start_service "Student" "8585" "student-service" ".student_pid"; then
    services_started=$((services_started + 1))
else
    print_error "Failed to start Student Service"
    exit 1
fi

echo ""

# 2. Start Course Service (Port 8586)
if start_service "Course" "8586" "course-service" ".course_pid"; then
    services_started=$((services_started + 1))
else
    print_error "Failed to start Course Service"
    exit 1
fi

echo ""

# 3. Start Teacher Service (Port 8587)
if start_service "Teacher" "8587" "teacher-service" ".teacher_pid"; then
    services_started=$((services_started + 1))
else
    print_error "Failed to start Teacher Service"
    exit 1
fi

echo ""

# 4. Start Enrollment Service (Port 8588) - depends on all others
print_status "Waiting 5 seconds before starting Enrollment Service..."
sleep 5

if start_service "Enrollment" "8588" "enrollment-service" ".enrollment_pid"; then
    services_started=$((services_started + 1))
else
    print_error "Failed to start Enrollment Service"
    exit 1
fi

echo ""
print_success "🎉 All $services_started microservices started successfully!"
echo ""

# Display status dashboard
echo -e "${BLUE}📊 MICROSERVICES STATUS DASHBOARD${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""
echo -e "${GREEN}✅ Student Service${NC}    → http://localhost:8585/students"
echo -e "${GREEN}✅ Course Service${NC}     → http://localhost:8586/courses"  
echo -e "${GREEN}✅ Teacher Service${NC}    → http://localhost:8587/teachers"
echo -e "${GREEN}✅ Enrollment Service${NC} → http://localhost:8588/enrollments"
echo ""

# Show process information
echo -e "${BLUE}🔍 PROCESS INFORMATION${NC}"
echo -e "${BLUE}======================${NC}"
echo "Student Service PID:    $(cat .student_pid 2>/dev/null || echo 'N/A')"
echo "Course Service PID:     $(cat .course_pid 2>/dev/null || echo 'N/A')"
echo "Teacher Service PID:    $(cat .teacher_pid 2>/dev/null || echo 'N/A')"
echo "Enrollment Service PID: $(cat .enrollment_pid 2>/dev/null || echo 'N/A')"
echo ""

# Show log files
echo -e "${BLUE}📋 LOG FILES${NC}"
echo -e "${BLUE}=============${NC}"
echo "Student Service:   Student_service.log"
echo "Course Service:    Course_service.log"
echo "Teacher Service:   Teacher_service.log"  
echo "Enrollment Service: Enrollment_service.log"
echo ""

# Quick test commands
echo -e "${BLUE}🧪 QUICK TEST COMMANDS${NC}"
echo -e "${BLUE}======================${NC}"
echo "Test all services are running:"
echo "  curl http://localhost:8585/students"
echo "  curl http://localhost:8586/courses"
echo "  curl http://localhost:8587/teachers"
echo "  curl http://localhost:8588/enrollments"
echo ""

echo -e "${BLUE}🛑 TO STOP ALL SERVICES${NC}"
echo -e "${BLUE}========================${NC}"
echo "Press Ctrl+C or run: ./stop_microservices.sh"
echo ""

print_success "Microservices startup complete!"
print_status "Run './test_interconnectivity.sh' to test service communication"
print_warning "Keep this terminal open to maintain services running..."

# Keep script running and monitor services
while true; do
    sleep 30
    
    # Check if all services are still running
    services_running=0
    
    if [ -f .student_pid ] && ps -p $(cat .student_pid) > /dev/null 2>&1; then
        services_running=$((services_running + 1))
    else
        print_warning "Student Service stopped unexpectedly"
    fi
    
    if [ -f .course_pid ] && ps -p $(cat .course_pid) > /dev/null 2>&1; then
        services_running=$((services_running + 1))
    else
        print_warning "Course Service stopped unexpectedly"
    fi
    
    if [ -f .teacher_pid ] && ps -p $(cat .teacher_pid) > /dev/null 2>&1; then
        services_running=$((services_running + 1))
    else
        print_warning "Teacher Service stopped unexpectedly"
    fi
    
    if [ -f .enrollment_pid ] && ps -p $(cat .enrollment_pid) > /dev/null 2>&1; then
        services_running=$((services_running + 1))
    else
        print_warning "Enrollment Service stopped unexpectedly"
    fi
    
    if [ $services_running -eq 4 ]; then
        echo -e "\r${GREEN}[MONITOR]${NC} All 4 services running... $(date '+%H:%M:%S')"
    else
        print_error "Only $services_running/4 services are running!"
    fi
done
