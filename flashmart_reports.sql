@'
-- ====================================================================
-- DỰ ÁN FLASHMART: KHẮC PHỤC LỖI TRUY VẤN DỮ LIỆU JOIN
-- ====================================================================

DROP DATABASE IF EXISTS flashmart_db;
CREATE DATABASE flashmart_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE flashmart_db;

-- 1. Tạo bảng và chèn dữ liệu mẫu
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY, 
    name VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY, 
    product_name VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY, 
    customer_id INT, 
    product_id INT
);

INSERT INTO Customers VALUES 
(1, 'Alice'), 
(2, 'Bob'), 
(3, 'Charlie'); -- Charlie chưa từng mua hàng

INSERT INTO Products VALUES 
(101, 'Laptop'), 
(102, 'Mouse'), 
(103, 'Keyboard'); -- Keyboard chưa từng được ai mua

INSERT INTO Orders VALUES 
(1001, 1, 101), 
(1002, 1, 102), 
(1003, 2, 101);

-- ========================================================
-- BÁO CÁO 1 (CHO MARKETING): Lấy toàn bộ khách hàng và số đơn hàng (Giữ lại Charlie)
-- Sử dụng LEFT JOIN kết hợp COUNT(o.order_id) để đếm chính xác số đơn (trả về 0 cho khách chưa mua)
-- ========================================================
SELECT 
    c.customer_id, 
    c.name, 
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- ========================================================
-- BÁO CÁO 2 (CHO KHO VẬN): Lấy danh sách sản phẩm chưa từng bán ra (Sản phẩm ế / Anti-Join)
-- Sử dụng LEFT JOIN từ Products sang Orders kết hợp WHERE o.order_id IS NULL
-- ========================================================
SELECT 
    p.product_id, 
    p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;
'@ | Out-File -FilePath "flashmart_reports.sql" -Encoding utf8