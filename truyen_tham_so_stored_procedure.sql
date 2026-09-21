@'
-- ====================================================================
-- BÀI THỰC HÀNH: TRUYỀN THAM SỐ VÀO STORED PROCEDURE (IN, OUT, INOUT)
-- ====================================================================

USE classicmodels;

-- --------------------------------------------------------------------
-- 1. THAM SỐ LOẠI IN (Tham số đầu vào chỉ đọc)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS getCusById;

DELIMITER //

CREATE PROCEDURE getCusById(IN cusNum INT)
BEGIN
    SELECT * 
    FROM customers 
    WHERE customerNumber = cusNum;
END //

DELIMITER ;

-- Triệu gọi procedure với tham số IN = 175
CALL getCusById(175);


-- --------------------------------------------------------------------
-- 2. THAM SỐ LOẠI OUT (Tham số trả kết quả ra biến bên ngoài)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS GetCustomersCountByCity;

DELIMITER //

CREATE PROCEDURE GetCustomersCountByCity(
    IN  in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //

DELIMITER ;

-- Triệu gọi procedure và hứng kết quả vào biến session @total
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total AS TotalCustomersInLyon;


-- --------------------------------------------------------------------
-- 3. THAM SỐ LOẠI INOUT (Kết hợp nhận giá trị ban đầu và trả giá trị mới)
-- --------------------------------------------------------------------
DROP PROCEDURE IF EXISTS SetCounter;

DELIMITER //

CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //

DELIMITER ;

-- Thiết lập giá trị khởi tạo cho biến @counter
SET @counter = 1;

-- Triệu gọi nhiều lần để quan sát giá trị biến thay đổi liên tục
CALL SetCounter(@counter, 1); -- @counter = 2
CALL SetCounter(@counter, 1); -- @counter = 3
CALL SetCounter(@counter, 5); -- @counter = 8

-- Hiển thị kết quả cuối cùng
SELECT @counter AS FinalCounterValue;
'@ | Out-File -FilePath "truyen_tham_so_stored_procedure.sql" -Encoding utf8