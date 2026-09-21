@'
-- ====================================================================
-- DỰ ÁN QUICKFEED: GIẢI PHÁP TỐI ƯU INDEX VÀ DUNG LƯỢNG LƯU TRỮ
-- ====================================================================

CREATE DATABASE IF NOT EXISTS quickfeed_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE quickfeed_db;

-- 1. Khởi tạo cấu trúc bảng Posts
DROP TABLE IF EXISTS Posts;
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10), -- 'TEXT', 'IMAGE', 'VIDEO'
    is_visible BOOLEAN DEFAULT 1, -- 1 (Hiện), 0 (Ẩn)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tái hiện thảm họa Over-Indexing ban đầu
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255));
CREATE INDEX idx_post_type ON Posts(post_type);
CREATE INDEX idx_is_visible ON Posts(is_visible);
CREATE INDEX idx_created_at ON Posts(created_at);

-- ====================================================================
-- BƯỚC 1: ĐO LƯỜNG TÀI NGUYÊN TRƯỚC KHI TỐI ƯU
-- ====================================================================
SELECT 
    table_name AS `Table`,
    ROUND((data_length / 1024 / 1024), 2) AS `Data_MB`,
    ROUND((index_length / 1024 / 1024), 2) AS `Index_MB`,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Total_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

SHOW TABLE STATUS LIKE 'Posts';

-- ====================================================================
-- BƯỚC 2: TIẾN HÀNH PHẪU THUẬT LOẠI BỎ CÁC INDEX DƯ THỪA
-- ====================================================================
-- Xóa idx_content: Cột TEXT kích thước lớn gây phình to ổ cứng, B-Tree không tối ưu cho tìm kiếm chuỗi
ALTER TABLE Posts DROP INDEX idx_content;

-- Xóa idx_post_type: Cardinality thấp (chỉ có 3 giá trị), Optimizer bỏ qua và quét bảng
ALTER TABLE Posts DROP INDEX idx_post_type;

-- Xóa idx_is_visible: Cardinality cực thấp (chỉ có 0 và 1), vô nghĩa với B-Tree
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- ====================================================================
-- BƯỚC 3: KIỂM TRA LẠI CHỈ MỤC VÀ TÀI NGUYÊN SAU TỐI ƯU
-- ====================================================================
-- Xác nhận chỉ còn lại 2 chỉ mục giá trị cao: idx_user_id và idx_created_at
SHOW INDEX FROM Posts;

-- Đo lường lại dung lượng sau khi loại bỏ 3 cây B-Tree dư thừa
SELECT 
    table_name AS `Table`,
    ROUND((data_length / 1024 / 1024), 2) AS `Data_MB`,
    ROUND((index_length / 1024 / 1024), 2) AS `Index_MB`,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS `Total_MB`
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';
'@ | Out-File -FilePath "quickfeed_index_optimization.sql" -Encoding utf8