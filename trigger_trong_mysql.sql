@'
-- ====================================================================
-- BÀI THỰC HÀNH: TRIGGER TRONG MYSQL
-- ====================================================================

-- 1. Tạo cơ sở dữ liệu và chuyển vùng sử dụng
CREATE DATABASE IF NOT EXISTS company CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE company;

-- 2. Tạo bảng nhân viên (employees)
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL
);

-- 3. Xóa Trigger nếu đã tồn tại trước đó
DROP TRIGGER IF EXISTS update_department;

-- 4. Tạo Trigger BEFORE INSERT để tự động cập nhật department theo mức lương (salary)
DELIMITER //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //

DELIMITER ;

-- 5. Chèn dữ liệu thử nghiệm (phòng ban ban đầu để là 'A')
INSERT INTO employees (name, department, salary) VALUES
('John Doe', 'A', 3500),
('Jane Smith', 'A', 2000),
('David Johnson', 'A', 6000);

-- 6. Kiểm tra dữ liệu sau khi Trigger tự động phân loại phòng ban
SELECT * FROM employees;
'@ | Out-File -FilePath "trigger_trong_mysql.sql" -Encoding utf8