# Configuration Server - Setup & Usage Guide

## Overview

The Configuration Server centralizes all microservice configurations in one location, enabling:

- Dynamic configuration updates without rebuilding services
- Environment-specific configurations (dev/prod/test)
- Version control for all configurations
- Consistent settings across all services

## Architecture

```
config-server (Port 8888)
    ↓
config-repo/ (Configuration Files)
    ├── application.properties          (Common for all services)
    ├── student-service.properties      (Student service specific)
    ├── course-service.properties       (Course service specific)
    ├── teacher-service.properties      (Teacher service specific)
    ├── enrollment-service.properties   (Enrollment service specific)
    └── api-gateway.properties          (API Gateway specific)
```

## Startup Sequence

### **IMPORTANT: Config Server MUST start FIRST!**

1. **Start Config Server** (Port 8888)

```bash
cd config-server
mvn clean install
mvn spring-boot:run
```

Wait for: `Started ConfigServerApplication in X seconds`

2. **Verify Config Server is working:**

```bash
# Test if config server is serving configurations
curl http://localhost:8888/student-service/default
curl http://localhost:8888/course-service/default
curl http://localhost:8888/api-gateway/default
```

You should see JSON response with configurations.

3. **Start other services in order:**

```bash
# Start Eureka Server
cd eureka-server
mvn spring-boot:run

# Start all microservices (they will fetch config from Config Server)
cd student-service
mvn spring-boot:run

cd course-service
mvn spring-boot:run

cd teacher-service
mvn spring-boot:run

cd enrollment-service
mvn spring-boot:run

# Start API Gateway last
cd api-gateway
mvn spring-boot:run
```

## Configuration Files Location

All configuration files are in: `/config-repo/`

### Common Configuration (`application.properties`)

Shared by ALL services:

- Eureka client settings
- Database common settings
- JPA/Hibernate settings
- Actuator endpoints

### Service-Specific Configuration

Each service has its own file:

- `student-service.properties` - Student service port, database URL, logging
- `course-service.properties` - Course service specific settings
- `teacher-service.properties` - Teacher service specific settings
- `enrollment-service.properties` - Enrollment service specific settings
- `api-gateway.properties` - Gateway routes and CORS settings

## How It Works

### Service Startup Flow:

```
1. Service starts
2. Reads bootstrap.properties (contains Config Server URL)
3. Contacts Config Server: GET /student-service/default
4. Config Server returns merged configuration:
   - application.properties (common)
   - student-service.properties (specific)
5. Service uses this configuration to start
6. Service registers with Eureka
7. Service ready to serve requests
```

### Configuration Priority (Highest to Lowest):

1. Service-specific file (e.g., `student-service.properties`)
2. Common file (`application.properties`)

## Dynamic Configuration Updates

### Update configuration without restart:

1. **Edit configuration in config-repo:**

```bash
# Example: Change student service port
vim config-repo/student-service.properties
# Change: server.port=8585 → server.port=8590
```

2. **Refresh the service:**

```bash
curl -X POST http://localhost:8585/actuator/refresh
```

Service picks up new configuration immediately!

## Testing Configuration Server

### Test 1: Check if Config Server is running

```bash
curl http://localhost:8888/actuator/health
# Expected: {"status":"UP"}
```

### Test 2: Fetch student-service configuration

```bash
curl http://localhost:8888/student-service/default | jq
```

Expected response:

```json
{
  "name": "student-service",
  "profiles": ["default"],
  "propertySources": [
    {
      "name": "file:///path/to/config-repo/student-service.properties",
      "source": {
        "server.port": "8585",
        "spring.application.name": "student-service",
        ...
      }
    },
    {
      "name": "file:///path/to/config-repo/application.properties",
      "source": {
        "eureka.client.service-url.defaultZone": "http://localhost:8761/eureka/",
        ...
      }
    }
  ]
}
```

### Test 3: Verify service is using Config Server

```bash
# Check student service logs for:
"Fetching config from server at: http://localhost:8888"
"Located environment: student-service, [default]"
```

## Troubleshooting

### Problem: Service fails to start with "Connection refused"

**Solution:** Config Server is not running. Start Config Server first!

### Problem: Service uses old configuration

**Solution:**

1. Verify config file changes in `config-repo/`
2. Call refresh endpoint: `curl -X POST http://localhost:8585/actuator/refresh`

### Problem: Config Server returns 404

**Solution:** Check `config-repo/` path in Config Server's `application.properties`:

```properties
spring.cloud.config.server.native.search-locations=file:///${user.dir}/config-repo
```

### Problem: Service starts but doesn't use Config Server

**Solution:** Ensure `bootstrap.properties` exists in service's `src/main/resources/`

## Configuration Server Endpoints

| Endpoint                     | Description                               |
| ---------------------------- | ----------------------------------------- |
| `GET /{application}/default` | Get default configuration for application |
| `GET /{application}/dev`     | Get dev environment configuration         |
| `GET /{application}/prod`    | Get production environment configuration  |
| `GET /actuator/health`       | Health check                              |
| `GET /actuator/info`         | Service info                              |

## Benefits Achieved

✅ **Centralized Management:** All configs in one place  
✅ **Zero Downtime Updates:** Change configs without restart  
✅ **Environment Support:** Easy dev/prod configuration switching  
✅ **Version Control:** Track configuration changes in Git  
✅ **Consistency:** Same Eureka URL, same JPA settings across all services  
✅ **Security:** Can encrypt sensitive data (passwords, API keys)

## Next Steps

After Config Server is working:

1. All services will fetch configuration from Config Server
2. No need to rebuild services for config changes
3. Can add environment-specific configs (dev/prod)
4. Can add encryption for sensitive data

## Port Summary

| Service            | Port |
| ------------------ | ---- |
| Config Server      | 8888 |
| Eureka Server      | 8761 |
| Student Service    | 8585 |
| Course Service     | 8586 |
| Teacher Service    | 8587 |
| Enrollment Service | 8588 |
| API Gateway        | 8080 |
