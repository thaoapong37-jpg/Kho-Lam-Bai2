@'
-- ====================================================================
-- DỰ ÁN SMARTFACTORY: GIẢI PHÁP TỐI ƯU INDEX CHO HỆ THỐNG IOT
-- ====================================================================

CREATE DATABASE IF NOT EXISTS smartfactory_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smartfactory_db;

-- 1. Cấu trúc bảng SensorLogs
DROP TABLE IF EXISTS SensorLogs;
CREATE TABLE SensorLogs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    recorded_at DATETIME NOT NULL,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    status VARCHAR(20) -- 'NORMAL', 'WARNING', 'CRITICAL'
);

-- 2. Tái hiện Fat Covering Index gây thảm họa ghi và lưu trữ
CREATE INDEX idx_fat_covering ON SensorLogs(sensor_id, recorded_at, temperature, humidity, status);

-- Kiểm tra dung lượng Index trước khi gỡ bỏ
SHOW TABLE STATUS LIKE 'SensorLogs';

-- Kế hoạch thực thi với Fat Covering Index (Extra có 'Using index')
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';

-- ====================================================================
-- BƯỚC TỐI ƯU: CHUYỂN ĐỔI TỪ FAT INDEX SANG LEAN INDEX
-- ====================================================================

-- 3. Xóa bỏ Fat Covering Index khổng lồ
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- 4. Tạo Lean Index tinh gọn: chỉ giữ 2 cột phục vụ lọc dữ liệu (WHERE)
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);

-- 5. Đo lường lại dung lượng bảng và kích thước Index sau khi tối ưu
SHOW TABLE STATUS LIKE 'SensorLogs';

-- 6. Kế hoạch thực thi sau khi tối ưu:
-- Quan sát: key = idx_lean_search, type = range. 
-- Cột Extra không còn 'Using index' (do phải Bookmark Lookup về Clustered Index để lấy temperature, humidity, status), 
-- nhưng câu truy vấn vẫn đạt hiệu năng cao và loại bỏ hoàn toàn Write Bottleneck.
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';
'@ | Out-File -FilePath "smartfactory_reindex.sql" -Encoding utf8