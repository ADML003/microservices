# 💻 Terminal Database Management Commands

## Quick Command Reference for Managing MySQL Database

### 🔧 MySQL Service Management

```bash
# macOS (using Homebrew)
brew services start mysql          # Start MySQL
brew services stop mysql           # Stop MySQL
brew services restart mysql        # Restart MySQL
brew services list | grep mysql    # Check MySQL status

# Linux (Ubuntu/Debian)
sudo systemctl start mysql         # Start MySQL
sudo systemctl stop mysql          # Stop MySQL
sudo systemctl restart mysql       # Restart MySQL
sudo systemctl status mysql        # Check MySQL status

# Windows
net start mysql                    # Start MySQL
net stop mysql                     # Stop MySQL
```

### 🗄️ Database Connection Commands

```bash
# Connect to MySQL as root
mysql -u root -p

# Connect directly to student_management database
mysql -u root -p student_management

# Connect with specific host and port
mysql -h localhost -P 3306 -u root -p

# Execute a single command
mysql -u root -p -e "SHOW DATABASES;"

# Run SQL script from file
mysql -u root -p < database_setup.sql
mysql -u root -p student_management < database_setup.sql
```

### 📊 Essential Database Commands (Run inside MySQL prompt)

```sql
-- Database Management
SHOW DATABASES;                          -- List all databases
USE student_management;                  -- Switch to database
SELECT DATABASE();                       -- Show current database
DROP DATABASE IF EXISTS student_management;  -- Delete database (CAREFUL!)

-- Table Management
SHOW TABLES;                            -- List all tables
DESCRIBE students;                      -- Show table structure
SHOW CREATE TABLE students;            -- Show table creation SQL
DROP TABLE IF EXISTS students;         -- Delete table (CAREFUL!)

-- Data Queries
SELECT * FROM students;                 -- Show all students
SELECT COUNT(*) FROM students;         -- Count total students
SELECT * FROM students LIMIT 5;        -- Show first 5 students
SELECT * FROM students ORDER BY age DESC; -- Sort by age (descending)

-- Filtering Data
SELECT * FROM students WHERE age > 20;
SELECT * FROM students WHERE name LIKE '%John%';
SELECT * FROM students WHERE age BETWEEN 20 AND 25;
SELECT * FROM students WHERE email = 'john@example.com';

-- Aggregate Functions
SELECT AVG(age) as average_age FROM students;
SELECT MIN(age) as youngest, MAX(age) as oldest FROM students;
SELECT age, COUNT(*) as count FROM students GROUP BY age;

-- Insert New Records
INSERT INTO students (name, email, age, address, phone_number)
VALUES ('New Student', 'new@example.com', 24, 'New Address', '+1111111111');

-- Update Records
UPDATE students SET age = 26 WHERE id = 1;
UPDATE students SET address = 'Updated Address' WHERE email = 'john@example.com';

-- Delete Records
DELETE FROM students WHERE id = 999;
DELETE FROM students WHERE age > 30;  -- (CAREFUL!)

-- Exit MySQL
EXIT;
-- or
QUIT;
-- or press Ctrl+D
```

### 🔍 Advanced Query Examples

```sql
-- Students with their enrollment count
SELECT
    s.id,
    s.name,
    s.email,
    COUNT(e.course_id) as courses_enrolled
FROM students s
LEFT JOIN enrollments e ON s.id = e.student_id
GROUP BY s.id, s.name, s.email;

-- Find students not enrolled in any course
SELECT s.*
FROM students s
LEFT JOIN enrollments e ON s.id = e.student_id
WHERE e.student_id IS NULL;

-- Course enrollment statistics
SELECT
    c.course_name,
    COUNT(e.student_id) as enrolled_students
FROM courses c
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.course_name
ORDER BY enrolled_students DESC;

-- Search for students by partial name or email
SELECT * FROM students
WHERE name LIKE '%john%' OR email LIKE '%john%';
```

### 💾 Backup and Restore Commands

```bash
# Full database backup
mysqldump -u root -p student_management > backup_$(date +%Y%m%d).sql

# Backup only data (no structure)
mysqldump -u root -p --no-create-info student_management > data_backup.sql

# Backup only structure (no data)
mysqldump -u root -p --no-data student_management > structure_backup.sql

# Backup specific table
mysqldump -u root -p student_management students > students_backup.sql

# Restore from backup
mysql -u root -p student_management < backup_20241202.sql

# Create compressed backup
mysqldump -u root -p student_management | gzip > backup_$(date +%Y%m%d).sql.gz

# Restore from compressed backup
gunzip < backup_20241202.sql.gz | mysql -u root -p student_management
```

### 📈 Performance and Monitoring

```sql
-- Show database status
SHOW STATUS LIKE 'Conn%';              -- Connection statistics
SHOW STATUS LIKE 'Table%';             -- Table statistics
SHOW STATUS LIKE 'Key%';               -- Index statistics

-- Show running processes
SHOW PROCESSLIST;                      -- Active connections
SHOW FULL PROCESSLIST;                 -- Detailed process info

-- Table sizes and statistics
SELECT
    table_name AS "Table",
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "Size (MB)",
    table_rows AS "Rows"
FROM information_schema.TABLES
WHERE table_schema = 'student_management';

-- Index information
SHOW INDEX FROM students;

-- Analyze table performance
ANALYZE TABLE students;
```

### 🔧 User Management (Admin tasks)

```sql
-- Create new user
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'password123';

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON student_management.* TO 'app_user'@'localhost';

-- Grant all permissions to database
GRANT ALL PRIVILEGES ON student_management.* TO 'app_user'@'localhost';

-- Show user permissions
SHOW GRANTS FOR 'app_user'@'localhost';

-- Remove user
DROP USER 'app_user'@'localhost';

-- Change password
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';

-- Reload privileges
FLUSH PRIVILEGES;
```

### 🐛 Troubleshooting Commands

```bash
# Check if MySQL is running
ps aux | grep mysql                    # Linux/macOS
brew services list | grep mysql        # macOS with Homebrew

# Check MySQL version
mysql --version

# Check MySQL configuration
mysql -u root -p -e "SHOW VARIABLES LIKE 'version%';"

# Check MySQL data directory
mysql -u root -p -e "SHOW VARIABLES LIKE 'datadir';"

# Check MySQL port
mysql -u root -p -e "SHOW VARIABLES LIKE 'port';"

# Check MySQL logs (location varies by system)
tail -f /usr/local/var/mysql/*.err     # macOS with Homebrew
tail -f /var/log/mysql/error.log       # Linux

# Test connection without password (if no password set)
mysql -u root

# Reset MySQL root password (if forgotten)
sudo mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_password';
FLUSH PRIVILEGES;
EXIT;
```

### 📱 Quick Testing Commands

```bash
# Test if application can connect to database
curl http://localhost:8585/test/sql-connection

# Test database info endpoint
curl http://localhost:8585/test/database-info

# Get all students via API
curl http://localhost:8585/students

# Get specific student
curl http://localhost:8585/students/1

# Create new student via API
curl -X POST http://localhost:8585/students \
  -H "Content-Type: application/json" \
  -d '{
    "name": "API Test Student",
    "email": "apitest@example.com",
    "age": 22,
    "address": "API Test Address",
    "phoneNumber": "+1111111111"
  }'
```

### 📋 Useful One-Liners

```bash
# Count students in database
mysql -u root -p -e "SELECT COUNT(*) as student_count FROM student_management.students;"

# Show all student names
mysql -u root -p -e "SELECT name FROM student_management.students ORDER BY name;"

# Find oldest and youngest students
mysql -u root -p -e "SELECT MIN(age) as youngest, MAX(age) as oldest FROM student_management.students;"

# Show students by age groups
mysql -u root -p -e "SELECT age, COUNT(*) as count FROM student_management.students GROUP BY age ORDER BY age;"

# Export student data to CSV
mysql -u root -p -e "SELECT * FROM student_management.students;" \
  --batch --raw | sed 's/\t/,/g' > students_export.csv
```

### 🎯 Database Maintenance Tasks

```sql
-- Optimize all tables
OPTIMIZE TABLE students, courses, teachers, enrollments;

-- Check table integrity
CHECK TABLE students;

-- Repair table (if corrupted)
REPAIR TABLE students;

-- Update table statistics
ANALYZE TABLE students;

-- Show table status
SHOW TABLE STATUS FROM student_management;

-- Clean up old data (example: remove students older than 30)
-- DELETE FROM students WHERE age > 30;  -- UNCOMMENT TO USE (CAREFUL!)

-- Update statistics after large data changes
ANALYZE TABLE students;
```

### 🚨 Safety Commands (Use with caution)

```sql
-- DANGEROUS COMMANDS - USE WITH EXTREME CAUTION!

-- Remove all data from table (keeps structure)
-- TRUNCATE TABLE students;

-- Delete all records (slower but with transaction log)
-- DELETE FROM students;

-- Drop entire table
-- DROP TABLE students;

-- Drop entire database
-- DROP DATABASE student_management;

-- Always backup before running dangerous commands!
```

### 📝 Quick Cheat Sheet

| Task                | Command                                                |
| ------------------- | ------------------------------------------------------ |
| Connect to MySQL    | `mysql -u root -p`                                     |
| Use database        | `USE student_management;`                              |
| Show tables         | `SHOW TABLES;`                                         |
| Count records       | `SELECT COUNT(*) FROM students;`                       |
| Show all students   | `SELECT * FROM students;`                              |
| Exit MySQL          | `EXIT;`                                                |
| Backup database     | `mysqldump -u root -p student_management > backup.sql` |
| Restore database    | `mysql -u root -p student_management < backup.sql`     |
| Test API connection | `curl http://localhost:8585/test/sql-connection`       |

Remember to always backup your data before making significant changes!
