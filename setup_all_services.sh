#!/bin/bash

echo "�� Setting up all microservices..."

# Create all databases
echo "📊 Setting up databases..."
mysql -u root < student-service/database_setup.sql
mysql -u root < course-service/database_setup.sql
mysql -u root < teacher-service/database_setup.sql
mysql -u root < enrollment-service/database_setup.sql

echo "✅ All databases created successfully!"

# Create application.properties for each service
echo "⚙️ Creating configuration files..."

# Course Service
mkdir -p course-service/src/main/resources
cat > course-service/src/main/resources/application.properties << 'PROPS'
server.port=8586
spring.application.name=course-service

spring.datasource.url=jdbc:mysql://localhost:3306/course_db
spring.datasource.username=root
spring.datasource.password=
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

logging.level.com.ncu.course=DEBUG

student.service.url=http://localhost:8585
teacher.service.url=http://localhost:8587
enrollment.service.url=http://localhost:8588
PROPS

# Teacher Service
mkdir -p teacher-service/src/main/resources
cat > teacher-service/src/main/resources/application.properties << 'PROPS'
server.port=8587
spring.application.name=teacher-service

spring.datasource.url=jdbc:mysql://localhost:3306/teacher_db
spring.datasource.username=root
spring.datasource.password=
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

logging.level.com.ncu.teacher=DEBUG

student.service.url=http://localhost:8585
course.service.url=http://localhost:8586
enrollment.service.url=http://localhost:8588
PROPS

# Enrollment Service
mkdir -p enrollment-service/src/main/resources
cat > enrollment-service/src/main/resources/application.properties << 'PROPS'
server.port=8588
spring.application.name=enrollment-service

spring.datasource.url=jdbc:mysql://localhost:3306/enrollment_db
spring.datasource.username=root
spring.datasource.password=
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

logging.level.com.ncu.enrollment=DEBUG

student.service.url=http://localhost:8585
course.service.url=http://localhost:8586
teacher.service.url=http://localhost:8587
PROPS

echo "✅ Configuration files created!"

# Copy pom.xml to other services (modified for each service)
cp course-service/pom.xml teacher-service/pom.xml
cp course-service/pom.xml enrollment-service/pom.xml

# Update artifactId in each pom.xml
sed -i '' 's/course-service/teacher-service/g' teacher-service/pom.xml
sed -i '' 's/Course Service/Teacher Service/g' teacher-service/pom.xml
sed -i '' 's/Course Management/Teacher Management/g' teacher-service/pom.xml

sed -i '' 's/course-service/enrollment-service/g' enrollment-service/pom.xml
sed -i '' 's/Course Service/Enrollment Service/g' enrollment-service/pom.xml
sed -i '' 's/Course Management/Enrollment Management/g' enrollment-service/pom.xml

echo "✅ Maven files configured!"

echo "🎯 Setup completed! You can now run each service on different ports:"
echo "  Student Service:    mvn spring-boot:run (Port 8585)"
echo "  Course Service:     mvn spring-boot:run (Port 8586)"
echo "  Teacher Service:    mvn spring-boot:run (Port 8587)"
echo "  Enrollment Service: mvn spring-boot:run (Port 8588)"
