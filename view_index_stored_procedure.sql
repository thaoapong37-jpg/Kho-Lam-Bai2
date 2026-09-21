@'
-- ====================================================================
-- BÀI TẬP: VIEW, INDEX, STORED PROCEDURE
-- ====================================================================

-- --------------------------------------------------------------------
-- BƯỚC 1 & 2: TẠO CƠ SỞ DỮ LIỆU DEMO, BẢNG PRODUCTS VÀ CHÈN DỮ LIỆU
-- --------------------------------------------------------------------
DROP DATABASE IF EXISTS demo;
CREATE DATABASE demo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE demo;

CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(12, 2) NOT NULL,
    productAmount INT NOT NULL DEFAULT 0,
    productDescription TEXT,
    productStatus BIT DEFAULT 1 -- 1: Đang bán, 0: Tạm ngưng
);

-- Chèn dữ liệu mẫu
INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus) VALUES
('P001', 'iPhone 15 Pro', 25000000.00, 50, 'Dien thoai cao cap Apple', 1),
('P002', 'Samsung Galaxy S24', 21000000.00, 30, 'Dien thoai flagship Samsung', 1),
('P003', 'MacBook Air M2', 26000000.00, 20, 'Laptop Apple sieu mong nhe', 1),
('P004', 'Chuot Logitech MX Master 3S', 2200000.00, 100, 'Chuot cong thai hoc khong day', 1),
('P005', 'Ban phim co Keychron K2', 1800000.00, 45, 'Ban phim co Bluetooth', 0);

-- --------------------------------------------------------------------
-- BƯỚC 3: TẠO INDEX VÀ SO SÁNH VỚI LỆNH EXPLAIN
-- --------------------------------------------------------------------
-- 1. EXPLAIN trước khi tạo Index (Type: ALL - Quét toàn bảng)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P002';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 25000000.00;

-- 2. Tạo Unique Index trên cột productCode
CREATE UNIQUE INDEX idx_productCode ON Products(productCode);

-- 3. Tạo Composite Index trên cặp cột (productName, productPrice)
CREATE INDEX idx_name_price ON Products(productName, productPrice);

-- 4. EXPLAIN sau khi tạo Index:
-- - Truy vấn productCode: type chuyển sang 'const', rows = 1 (sử dụng idx_productCode)
-- - Truy vấn name + price: type chuyển sang 'ref', rows = 1 (sử dụng idx_name_price)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P002';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 25000000.00;

-- --------------------------------------------------------------------
-- BƯỚC 4: TẠO, SỬA ĐỔI VÀ XÓA VIEW
-- --------------------------------------------------------------------
-- 1. Tạo View lấy về: productCode, productName, productPrice, productStatus
CREATE VIEW view_products AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Truy vấn dữ liệu từ View
SELECT * FROM view_products;

-- 2. Sửa đổi View (Bổ sung thêm cột productAmount và lọc các sản phẩm có giá > 2.000.000)
CREATE OR REPLACE VIEW view_products AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products
WHERE productPrice > 2000000.00;

-- Truy vấn lại View sau khi sửa
SELECT * FROM view_products;

-- 3. Xóa View
DROP VIEW IF EXISTS view_products;

-- --------------------------------------------------------------------
-- BƯỚC 5: STORED PROCEDURES (CRUD SẢN PHẨM)
-- --------------------------------------------------------------------

-- 1. Procedure lấy tất cả thông tin của tất cả sản phẩm
DROP PROCEDURE IF EXISTS sp_GetAllProducts;
DELIMITER //
CREATE PROCEDURE sp_GetAllProducts()
BEGIN
    SELECT * FROM Products;
END //
DELIMITER ;

-- 2. Procedure thêm một sản phẩm mới
DROP PROCEDURE IF EXISTS sp_AddProduct;
DELIMITER //
CREATE PROCEDURE sp_AddProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status BIT
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //
DELIMITER ;

-- 3. Procedure sửa thông tin sản phẩm theo Id
DROP PROCEDURE IF EXISTS sp_UpdateProductById;
DELIMITER //
CREATE PROCEDURE sp_UpdateProductById(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(12, 2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status BIT
)
BEGIN
    UPDATE Products
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //
DELIMITER ;

-- 4. Procedure xóa sản phẩm theo Id
DROP PROCEDURE IF EXISTS sp_DeleteProductById;
DELIMITER //
CREATE PROCEDURE sp_DeleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //
DELIMITER ;

-- --------------------------------------------------------------------
-- THỬ NGHIỆM GỌI CÁC STORED PROCEDURE
-- --------------------------------------------------------------------
-- Thêm sản phẩm mới
CALL sp_AddProduct('P006', 'Tai nghe Sony WH-1000XM5', 7500000.00, 15, 'Tai nghe chong on chu dong', 1);

-- Sửa sản phẩm vừa thêm (Id = 6)
CALL sp_UpdateProductById(6, 'P006', 'Tai nghe Sony WH-1000XM5 (Black)', 7200000.00, 20, 'Tai nghe chong on mau den', 1);

-- Xóa sản phẩm có Id = 5
CALL sp_DeleteProductById(5);

-- Lấy danh sách sản phẩm sau các thao tác
CALL sp_GetAllProducts();
'@ | Out-File -FilePath "view_index_stored_procedure.sql" -Encoding utf8