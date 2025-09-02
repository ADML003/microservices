#!/bin/bash

# 🚀 Quick Start Script for Microservices Application
# This script helps you get everything up and running quickly

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}"
echo "  🎯 Microservices Quick Start Script"
echo "  ===================================="
echo -e "${NC}"

# Function to print status
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if service is running
check_service() {
    local port=$1
    local service_name=$2
    if curl -s "http://localhost:$port" >/dev/null 2>&1; then
        print_success "$service_name is running on port $port"
        return 0
    else
        print_warning "$service_name is not running on port $port"
        return 1
    fi
}

print_status "Checking prerequisites..."

# Check Java
if command_exists java; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -ge "17" ]; then
        print_success "Java $JAVA_VERSION found"
    else
        print_error "Java 17+ required, found Java $JAVA_VERSION"
        exit 1
    fi
else
    print_error "Java not found. Please install Java 17 or later."
    exit 1
fi

# Check Maven
if command_exists mvn; then
    MVN_VERSION=$(mvn -version | head -n 1 | cut -d' ' -f3)
    print_success "Maven $MVN_VERSION found"
else
    print_error "Maven not found. Please install Maven."
    exit 1
fi

# Check MySQL
if command_exists mysql; then
    print_success "MySQL client found"
else
    print_warning "MySQL client not found. You may need to install it."
fi

print_status "Setting up the project..."

# Navigate to project directory
PROJECT_DIR="/Users/ADML/Desktop/microservices "
if [ ! -d "$PROJECT_DIR" ]; then
    print_error "Project directory not found: $PROJECT_DIR"
    exit 1
fi

cd "$PROJECT_DIR"

# Check if pom.xml exists
if [ ! -f "pom.xml" ]; then
    print_error "pom.xml not found in project directory"
    exit 1
fi

print_status "Cleaning and compiling the project..."
mvn clean compile -q

print_status "Checking MySQL connection..."

# Try to connect to MySQL and check database
if mysql -u root -e "USE student_management; SELECT 1;" >/dev/null 2>&1; then
    print_success "Connected to MySQL and student_management database exists"
    
    # Check if students table exists and has data
    STUDENT_COUNT=$(mysql -u root -e "SELECT COUNT(*) FROM student_management.students;" -s -N 2>/dev/null || echo "0")
    if [ "$STUDENT_COUNT" -gt "0" ]; then
        print_success "Students table has $STUDENT_COUNT records"
    else
        print_warning "Students table is empty or doesn't exist"
        read -p "Would you like to set up the database with sample data? (y/N): " setup_db
        if [[ $setup_db =~ ^[Yy]$ ]]; then
            print_status "Setting up database with sample data..."
            mysql -u root < database_setup.sql
            print_success "Database setup completed"
        fi
    fi
else
    print_warning "Cannot connect to MySQL or database doesn't exist"
    read -p "Would you like to try setting up the database? (y/N): " setup_db
    if [[ $setup_db =~ ^[Yy]$ ]]; then
        print_status "Setting up database..."
        mysql -u root < database_setup.sql
        print_success "Database setup completed"
    else
        print_warning "Continuing without database setup. Some features may not work."
    fi
fi

print_status "Starting the main application..."

# Start the application in background
mvn spring-boot:run > app.log 2>&1 &
APP_PID=$!

print_status "Application starting... PID: $APP_PID"
print_status "Waiting for application to start (this may take 30-60 seconds)..."

# Wait for application to start
for i in {1..30}; do
    if curl -s http://localhost:8585/test/sql-connection >/dev/null 2>&1; then
        print_success "Application is running on port 8585!"
        break
    fi
    if [ $i -eq 30 ]; then
        print_error "Application failed to start within 30 seconds"
        print_status "Check app.log for details"
        kill $APP_PID 2>/dev/null || true
        exit 1
    fi
    echo -n "."
    sleep 2
done

echo

print_status "Testing application endpoints..."

# Test database connectivity
if curl -s http://localhost:8585/test/sql-connection | grep -q "SUCCESSFUL"; then
    print_success "Database connectivity test passed"
else
    print_warning "Database connectivity test failed"
fi

# Test students endpoint
if curl -s http://localhost:8585/students >/dev/null 2>&1; then
    print_success "Students API endpoint is working"
else
    print_warning "Students API endpoint is not responding"
fi

print_success "Setup completed!"

echo
echo -e "${PURPLE}🎉 Your microservices application is ready!${NC}"
echo
echo -e "${BLUE}📊 Quick Status:${NC}"
echo "  • Main Application: http://localhost:8585"
echo "  • Database Test: http://localhost:8585/test/sql-connection"
echo "  • Students API: http://localhost:8585/students"
echo "  • Application PID: $APP_PID"
echo
echo -e "${BLUE}📝 Next Steps:${NC}"
echo "  1. Open test_endpoints.html in your browser for interactive testing"
echo "  2. Import Microservices_API_Collection.postman_collection.json into Postman"
echo "  3. Run './test_microservice.sh' to test all endpoints"
echo "  4. Check DATABASE_COMMANDS.md for database management commands"
echo
echo -e "${BLUE}🔧 Useful Commands:${NC}"
echo "  • Check logs: tail -f app.log"
echo "  • Test all endpoints: ./test_microservice.sh"
echo "  • Connect to database: mysql -u root -p student_management"
echo "  • Stop application: kill $APP_PID"
echo
echo -e "${BLUE}📚 Documentation:${NC}"
echo "  • Complete guide: COMPLETE_SETUP_GUIDE.md"
echo "  • Database commands: DATABASE_COMMANDS.md"
echo "  • HTML testing: test_endpoints.html"
echo

# Save PID for easy stopping
echo $APP_PID > .app_pid

echo -e "${GREEN}🚀 Application is running! Press Ctrl+C to view logs or check app.log${NC}"

# Option to show logs
read -p "Would you like to view the application logs now? (y/N): " show_logs
if [[ $show_logs =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}📋 Application Logs (Press Ctrl+C to exit):${NC}"
    tail -f app.log
fi
