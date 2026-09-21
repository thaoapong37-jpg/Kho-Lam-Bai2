@'
-- ====================================================================
-- DỰ ÁN PAYFLOW: GIẢI CỨU HỆ THỐNG BẰNG EXPLAIN VÀ B-TREE INDEX
-- ====================================================================

CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

-- 1. Cấu trúc bảng giao dịch
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
);

-- ====================================================================
-- PHẦN 1: TRUY VẤN CŨ GÂY SẬP HỆ THỐNG (FULL TABLE SCAN - TYPE = ALL)
-- ====================================================================
-- Điểm nghẽn: Non-SARGable do bọc hàm YEAR(), MONTH() trên cột created_at
-- khiến MySQL không thể dùng Index và phải duyệt toàn bộ 5 triệu dòng.

EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND YEAR(created_at) = 2026 
  AND MONTH(created_at) = 6;

-- ====================================================================
-- PHẦN 2: THIẾT KẾ COMPOSITE INDEX ĐỂ TỐI ƯU
-- ====================================================================
-- Đặt transaction_type (phép so sánh bằng '=') trước created_at (phép so sánh khoảng 'range')
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- ====================================================================
-- PHẦN 3: TRUY VẤN MỚI ĐÃ TỐI ƯU (SARGABLE QUERY)
-- ====================================================================
-- Khắc phục: Thay hàm ngày tháng bằng điều kiện so sánh khoảng (Range condition)
-- Giúp MySQL tận dụng trực tiếp B-Tree Index để nhảy tới vị trí dữ liệu (Index Range Scan)

EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';
'@ | Out-File -FilePath "payflow_optimized.sql" -Encoding utf8