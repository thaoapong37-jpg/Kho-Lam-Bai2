@'
-- ====================================================================
-- BÀI THỰC HÀNH: STORED PROCEDURE TRONG MYSQL
-- ====================================================================

USE classicmodels;

-- 1. Xóa Procedure nếu đã tồn tại trước đó
DROP PROCEDURE IF EXISTS findAllCustomers;

-- 2. Đổi Delimiter và tạo Stored Procedure đầu tiên: Lấy danh sách tất cả khách hàng
DELIMITER //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //

DELIMITER ;

-- 3. Gọi Stored Procedure vừa tạo
CALL findAllCustomers();

-- 4. Sửa Stored Procedure: Trong MySQL không có lệnh ALTER PROCEDURE sửa logic bên trong,
-- vì vậy ta xóa đi (DROP) và định nghĩa lại với điều kiện mới (lấy customerNumber = 175)
DELIMITER //

DROP PROCEDURE IF EXISTS `findAllCustomers` //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers WHERE customerNumber = 175;
END //

DELIMITER ;

-- 5. Triệu gọi lại Procedure sau khi đã cập nhật logic
CALL findAllCustomers();
'@ | Out-File -FilePath "stored_procedure_trong_mysql.sql" -Encoding utf8