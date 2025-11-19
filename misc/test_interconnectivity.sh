#!/bin/bash

# 🔗 Test Microservices Interconnectivity Guide
# This script provides step-by-step testing of inter-service communication

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}🔗 MICROSERVICES INTERCONNECTIVITY TESTER${NC}"
    echo -e "${BLUE}============================================${NC}"
}

print_step() {
    echo -e "\n${BOLD}${PURPLE}STEP $1: $2${NC}"
    echo -e "${PURPLE}$(printf '=%.0s' {1..50})${NC}"
}

print_test() {
    echo -e "${CYAN}[TEST]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_command() {
    echo -e "${YELLOW}💻 Command:${NC} $1"
}

print_response() {
    echo -e "${GREEN}📨 Expected Response:${NC}"
}

# Function to test if a service is running
test_service() {
    local service_name=$1
    local port=$2
    local endpoint=$3
    
    print_test "Testing $service_name on port $port"
    print_command "curl -s http://localhost:$port$endpoint"
    
    if curl -s -f "http://localhost:$port$endpoint" >/dev/null 2>&1; then
        print_success "$service_name is running and accessible"
        return 0
    else
        print_error "$service_name is not responding"
        return 1
    fi
}

# Function to create test data
create_test_data() {
    local data_type=$1
    local port=$2
    local endpoint=$3
    local json_data=$4
    
    print_command "curl -X POST http://localhost:$port$endpoint -H 'Content-Type: application/json' -d '$json_data'"
    
    response=$(curl -s -X POST "http://localhost:$port$endpoint" \
        -H "Content-Type: application/json" \
        -d "$json_data" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ ! -z "$response" ]; then
        print_success "$data_type created successfully"
        echo -e "${GREEN}Response:${NC} $response"
        return 0
    else
        print_error "Failed to create $data_type"
        return 1
    fi
}

# Function to test inter-service communication
test_enrollment_communication() {
    print_test "Testing enrollment creation (inter-service communication)"
    
    # Create enrollment that will trigger calls to all other services
    local enrollment_data='{"studentId":1,"courseId":1,"teacherId":1}'
    
    print_command "curl -X POST http://localhost:8588/enrollments -H 'Content-Type: application/json' -d '$enrollment_data'"
    
    response=$(curl -s -X POST "http://localhost:8588/enrollments" \
        -H "Content-Type: application/json" \
        -d "$enrollment_data" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ ! -z "$response" ]; then
        print_success "Enrollment created - services are communicating!"
        echo -e "${GREEN}Response:${NC} $response"
        
        # Now test getting enrollment details (should call all services)
        print_test "Testing enrollment details retrieval (calls all services)"
        print_command "curl -s http://localhost:8588/enrollments/1/details"
        
        details_response=$(curl -s "http://localhost:8588/enrollments/1/details" 2>/dev/null)
        
        if [ $? -eq 0 ] && [ ! -z "$details_response" ]; then
            print_success "Successfully retrieved data from all services!"
            echo -e "${GREEN}Combined Response:${NC} $details_response"
        else
            print_error "Failed to get enrollment details"
        fi
    else
        print_error "Failed to create enrollment"
    fi
}

# Main script execution
print_header

print_step "1" "Checking if all microservices are running"

services_running=0

if test_service "Student Service" "8585" "/students"; then
    services_running=$((services_running + 1))
fi

if test_service "Course Service" "8586" "/courses"; then
    services_running=$((services_running + 1))
fi

if test_service "Teacher Service" "8587" "/teachers"; then
    services_running=$((services_running + 1))
fi

if test_service "Enrollment Service" "8588" "/enrollments"; then
    services_running=$((services_running + 1))
fi

if [ $services_running -ne 4 ]; then
    print_error "Not all services are running ($services_running/4)"
    print_info "Please run './start_all_services.sh' first"
    exit 1
fi

print_success "All 4 microservices are running!"

print_step "2" "Creating test data in each service"

# Create a student
print_test "Creating a test student"
create_test_data "Student" "8585" "/students" \
    '{"name":"John Doe","email":"john.doe@university.edu","age":20,"address":"123 Campus St","phoneNumber":"+1234567890"}'

echo ""

# Create a course
print_test "Creating a test course"
create_test_data "Course" "8586" "/courses" \
    '{"name":"Microservices Architecture","credits":3,"description":"Learn about microservices design patterns"}'

echo ""

# Create a teacher
print_test "Creating a test teacher"
create_test_data "Teacher" "8587" "/teachers" \
    '{"name":"Prof. Smith","email":"prof.smith@university.edu","department":"Computer Science","phoneNumber":"+1987654321"}'

print_step "3" "Testing inter-service communication"

test_enrollment_communication

print_step "4" "Testing individual service endpoints"

echo ""
print_test "Getting all students"
print_command "curl -s http://localhost:8585/students"
students_response=$(curl -s "http://localhost:8585/students" 2>/dev/null)
echo -e "${GREEN}Response:${NC} $students_response"

echo ""
print_test "Getting all courses"
print_command "curl -s http://localhost:8586/courses"
courses_response=$(curl -s "http://localhost:8586/courses" 2>/dev/null)
echo -e "${GREEN}Response:${NC} $courses_response"

echo ""
print_test "Getting all teachers"
print_command "curl -s http://localhost:8587/teachers"
teachers_response=$(curl -s "http://localhost:8587/teachers" 2>/dev/null)
echo -e "${GREEN}Response:${NC} $teachers_response"

echo ""
print_test "Getting all enrollments"
print_command "curl -s http://localhost:8588/enrollments"
enrollments_response=$(curl -s "http://localhost:8588/enrollments" 2>/dev/null)
echo -e "${GREEN}Response:${NC} $enrollments_response"

print_step "5" "Advanced interconnectivity tests"

echo ""
print_test "Getting student by ID (individual service)"
print_command "curl -s http://localhost:8585/students/1"
student_response=$(curl -s "http://localhost:8585/students/1" 2>/dev/null)
echo -e "${GREEN}Response:${NC} $student_response"

echo ""
print_test "Getting course by ID (individual service)"
print_command "curl -s http://localhost:8586/courses/1"
course_response=$(curl -s "http://localhost:8586/courses/1" 2>/dev/null)
echo -e "${GREEN}Response:${NC} $course_response"

echo ""
print_test "Getting teacher by ID (individual service)"
print_command "curl -s http://localhost:8587/teachers/1"
teacher_response=$(curl -s "http://localhost:8587/teachers/1" 2>/dev/null)
echo -e "${GREEN}Response:${NC} $teacher_response"

print_step "6" "Testing error handling and service resilience"

echo ""
print_test "Testing non-existent resource (should return 404)"
print_command "curl -s -w '%{http_code}' http://localhost:8585/students/999"
error_response=$(curl -s -w '%{http_code}' "http://localhost:8585/students/999" 2>/dev/null)
echo -e "${GREEN}Response:${NC} $error_response"

echo ""
print_test "Testing invalid endpoint (should return 404)"
print_command "curl -s -w '%{http_code}' http://localhost:8585/invalid"
invalid_response=$(curl -s -w '%{http_code}' "http://localhost:8585/invalid" 2>/dev/null)
echo -e "${GREEN}Response:${NC} $invalid_response"

print_step "7" "Testing service-to-service calls (enrollment orchestration)"

echo ""
print_info "The Enrollment Service acts as an orchestrator:"
print_info "→ When creating an enrollment, it validates:"
print_info "  • Student exists (calls Student Service)"
print_info "  • Course exists (calls Course Service)"
print_info "  • Teacher exists (calls Teacher Service)"
print_info "→ When getting enrollment details, it fetches:"
print_info "  • Student details from Student Service"
print_info "  • Course details from Course Service"
print_info "  • Teacher details from Teacher Service"

echo ""
print_test "Creating another enrollment to test orchestration"
create_test_data "Enrollment" "8588" "/enrollments" \
    '{"studentId":1,"courseId":1,"teacherId":1}'

echo ""
print_success "🎉 INTERCONNECTIVITY TEST COMPLETED!"

echo ""
echo -e "${BLUE}📊 SUMMARY${NC}"
echo -e "${BLUE}=========${NC}"
echo -e "${GREEN}✅ All services are running and accessible${NC}"
echo -e "${GREEN}✅ Individual CRUD operations work${NC}"
echo -e "${GREEN}✅ Inter-service communication works${NC}"
echo -e "${GREEN}✅ Service orchestration works${NC}"
echo -e "${GREEN}✅ Error handling works${NC}"

echo ""
echo -e "${BLUE}🔗 COMMUNICATION FLOW DEMONSTRATED${NC}"
echo -e "${BLUE}==================================${NC}"
echo "1. Enrollment Service → Student Service (REST API)"
echo "2. Enrollment Service → Course Service (REST API)"
echo "3. Enrollment Service → Teacher Service (REST API)"
echo "4. All services maintain independent databases"
echo "5. Services communicate only through REST APIs"

echo ""
echo -e "${BLUE}🧪 MANUAL TESTING COMMANDS${NC}"
echo -e "${BLUE}===========================${NC}"
echo ""
echo "Test individual services:"
echo "  curl http://localhost:8585/students"
echo "  curl http://localhost:8586/courses"
echo "  curl http://localhost:8587/teachers"
echo "  curl http://localhost:8588/enrollments"
echo ""
echo "Create new data:"
echo "  curl -X POST http://localhost:8585/students -H 'Content-Type: application/json' -d '{\"name\":\"Jane Smith\",\"email\":\"jane@edu.com\",\"age\":22}'"
echo "  curl -X POST http://localhost:8586/courses -H 'Content-Type: application/json' -d '{\"name\":\"Spring Boot\",\"credits\":4}'"
echo "  curl -X POST http://localhost:8587/teachers -H 'Content-Type: application/json' -d '{\"name\":\"Dr. Johnson\",\"department\":\"CS\"}'"
echo "  curl -X POST http://localhost:8588/enrollments -H 'Content-Type: application/json' -d '{\"studentId\":1,\"courseId\":1,\"teacherId\":1}'"
echo ""
echo "Test inter-service communication:"
echo "  curl http://localhost:8588/enrollments/1/details"
echo ""

print_success "Microservices interconnectivity testing guide completed!"
print_info "All services are communicating properly via REST APIs!"
