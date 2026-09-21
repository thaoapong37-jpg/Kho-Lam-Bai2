@'
-- ====================================================================
-- BÀI THỰC HÀNH: CHỈ MỤC TRONG MYSQL (INDEX & EXPLAIN)
-- ====================================================================

USE classicmodels;

-- 1. Xem kế hoạch thực thi trước khi đánh index (Full Table Scan - Type: ALL)
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- 2. Thêm chỉ mục đơn (Single-column Index) cho cột customerName
ALTER TABLE customers ADD INDEX idx_customerName(customerName);

-- 3. Kiểm tra lại kế hoạch thực thi sau khi tạo index (Type: ref, Rows: 1)
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';

-- 4. Thêm chỉ mục kết hợp (Composite Index) cho cặp họ và tên
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

-- 5. Kiểm tra kế hoạch thực thi với chỉ mục kết hợp
EXPLAIN SELECT * FROM customers WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';

-- 6. Xóa chỉ mục khỏi bảng khi không còn nhu cầu sử dụng
ALTER TABLE customers DROP INDEX idx_full_name;
'@ | Out-File -FilePath "chi_muc_trong_mysql.sql" -Encoding utf8