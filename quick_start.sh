#!/bin/bash

# SIMPLE Quick Start Script for All Microservices

export PATH="/usr/local/bin:$PATH"
BASE_DIR="/Users/ADML/Desktop/microservices "

echo "🚀 Starting all 6 microservices..."
echo ""

# 1. Config Server (MUST start first!)
echo "1️⃣  Starting Config Server (8888)..."
cd "$BASE_DIR/config-server"
nohup mvn spring-boot:run > ../config-server.log 2>&1 &
sleep 15  # Wait for config server to be ready

# 2. Auth Service
echo "2️⃣  Starting Auth Service (8589)..."
cd "$BASE_DIR/auth-service"
nohup mvn spring-boot:run > ../auth-service.log 2>&1 &
sleep 5

# 3. Student Service
echo "3️⃣  Starting Student Service (8585)..."
cd "$BASE_DIR/student-service"
nohup mvn spring-boot:run > ../student-service.log 2>&1 &
sleep 5

# 4. Course Service
echo "4️⃣  Starting Course Service (8586)..."
cd "$BASE_DIR/course-service"
nohup mvn spring-boot:run > ../course-service.log 2>&1 &
sleep 5

# 5. Teacher Service
echo "5️⃣  Starting Teacher Service (8587)..."
cd "$BASE_DIR/teacher-service"
nohup mvn spring-boot:run > ../teacher-service.log 2>&1 &
sleep 5

# 6. Enrollment Service
echo "6️⃣  Starting Enrollment Service (8588)..."
cd "$BASE_DIR/enrollment-service"
nohup mvn spring-boot:run > ../enrollment-service.log 2>&1 &

echo ""
echo "⏳ Waiting 30 seconds for all services to start..."
sleep 30

echo ""
echo "✅ ALL SERVICES STARTED!"
echo ""
echo "Test with:"
echo "  curl http://localhost:8888/actuator/health  # Config Server"
echo "  curl http://localhost:8589/auth/health      # Auth Service"
echo "  curl http://localhost:8585/students         # Student Service"
echo "  curl http://localhost:8586/courses          # Course Service"
echo "  curl http://localhost:8587/teachers         # Teacher Service"
echo "  curl http://localhost:8588/enrollments      # Enrollment Service"
echo ""
echo "To stop: pkill -f 'mvn spring-boot:run'"
