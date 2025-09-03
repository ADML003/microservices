#!/bin/bash

# 🛑 Stop All Microservices Script
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

# Stop Student Service
if [ -f .student_pid ]; then
    pid=$(cat .student_pid)
    if ps -p $pid > /dev/null 2>&1; then
        print_status "Stopping Student Service (PID: $pid)..."
        kill $pid 2>/dev/null || true
        sleep 2
        if ! ps -p $pid > /dev/null 2>&1; then
            print_success "Student Service stopped"
            services_stopped=$((services_stopped + 1))
        else
            print_warning "Force stopping Student Service..."
            kill -9 $pid 2>/dev/null || true
        fi
    fi
    rm -f .student_pid
else
    print_warning "Student Service PID file not found"
fi

# Stop Course Service
if [ -f .course_pid ]; then
    pid=$(cat .course_pid)
    if ps -p $pid > /dev/null 2>&1; then
        print_status "Stopping Course Service (PID: $pid)..."
        kill $pid 2>/dev/null || true
        sleep 2
        if ! ps -p $pid > /dev/null 2>&1; then
            print_success "Course Service stopped"
            services_stopped=$((services_stopped + 1))
        else
            print_warning "Force stopping Course Service..."
            kill -9 $pid 2>/dev/null || true
        fi
    fi
    rm -f .course_pid
else
    print_warning "Course Service PID file not found"
fi

# Stop Teacher Service
if [ -f .teacher_pid ]; then
    pid=$(cat .teacher_pid)
    if ps -p $pid > /dev/null 2>&1; then
        print_status "Stopping Teacher Service (PID: $pid)..."
        kill $pid 2>/dev/null || true
        sleep 2
        if ! ps -p $pid > /dev/null 2>&1; then
            print_success "Teacher Service stopped"
            services_stopped=$((services_stopped + 1))
        else
            print_warning "Force stopping Teacher Service..."
            kill -9 $pid 2>/dev/null || true
        fi
    fi
    rm -f .teacher_pid
else
    print_warning "Teacher Service PID file not found"
fi

# Stop Enrollment Service
if [ -f .enrollment_pid ]; then
    pid=$(cat .enrollment_pid)
    if ps -p $pid > /dev/null 2>&1; then
        print_status "Stopping Enrollment Service (PID: $pid)..."
        kill $pid 2>/dev/null || true
        sleep 2
        if ! ps -p $pid > /dev/null 2>&1; then
            print_success "Enrollment Service stopped"
            services_stopped=$((services_stopped + 1))
        else
            print_warning "Force stopping Enrollment Service..."
            kill -9 $pid 2>/dev/null || true
        fi
    fi
    rm -f .enrollment_pid
else
    print_warning "Enrollment Service PID file not found"
fi

# Clean up log files
print_status "Cleaning up log files..."
rm -f student_service.log course_service.log teacher_service.log enrollment_service.log

echo ""
print_success "🎉 Stopped $services_stopped microservices"
print_status "All services have been stopped and cleaned up"
echo ""

# Check if any Java processes are still running on our ports
print_status "Checking for any remaining processes on microservice ports..."
for port in 8585 8586 8587 8588; do
    if lsof -ti:$port >/dev/null 2>&1; then
        print_warning "Port $port is still in use!"
        print_status "You may need to manually kill the process:"
        print_status "lsof -ti:$port | xargs kill"
    fi
done

print_success "All microservices shutdown complete!"
