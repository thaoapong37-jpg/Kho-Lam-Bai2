@'
-- ====================================================================
-- BÀI THỰC HÀNH: VIEW TRONG MYSQL
-- ====================================================================

USE classicmodels;

-- 1. Tạo bảng ảo View có tên customer_views lấy 3 cột từ bảng customers
CREATE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- 2. Truy vấn dữ liệu từ bảng ảo customer_views
SELECT * FROM customer_views;

-- 3. Cập nhật cấu trúc View (CREATE OR REPLACE VIEW)
-- Bổ sung contactFirstName, contactLastName và lọc khách hàng ở thành phố 'Nantes'
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- 4. Truy vấn lại View sau khi đã cập nhật
SELECT * FROM customer_views;

-- 5. Xóa bảng ảo View khi không còn nhu cầu sử dụng
DROP VIEW IF EXISTS customer_views;
'@ | Out-File -FilePath "view_trong_mysql.sql" -Encoding utf8