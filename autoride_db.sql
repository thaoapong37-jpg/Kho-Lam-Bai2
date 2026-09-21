@'
-- ====================================================================
-- DỰ ÁN AUTORIDE: TÁI CẤU TRÚC VÀ TỐI ƯU CƠ SỞ DỮ LIỆU THUÊ XE TỰ LÁI
-- ====================================================================

DROP DATABASE IF EXISTS autoride_db;
CREATE DATABASE autoride_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE autoride_db;

-- 1. Bảng Xe (Cars)
CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

-- 2. Bảng Hợp đồng thuê xe (Rentals)
CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME NULL,
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'BOOKED',
    security_deposit DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    late_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    damage_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE RESTRICT
);

-- 3. Bảng Biên bản kiểm tra xe (Inspections)
CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
);

-- ====================================================================
-- MÔ PHỎNG QUY TRÌNH NGHIỆP VỤ THỰC TẾ (DML)
-- ====================================================================

-- Thêm xe mẫu
INSERT INTO Cars (model_name, license_plate) VALUES 
('Toyota Vios 2023', '30A-123.45'),
('Hyundai Accent 2024', '29B-987.65');

-- Kịch bản: Khách "Nguyen Van A" thuê xe cọc 10.000.000 VNĐ, trạng thái ACTIVE
INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit)
VALUES (1, 'Nguyen Van A', '2026-10-01 08:00:00', 'ACTIVE', 10000000.00);

-- Khách trả xe: Lập biên bản phát hiện vỡ đèn pha trái
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES (1, '2026-10-05 17:30:00', 'Vo den pha trai, can thay moi', 'Tran Van Kiem');

-- Hoàn tất hợp đồng: status COMPLETED, late_fee = 0, damage_fee = 2.000.000 VNĐ
UPDATE Rentals 
SET return_date = '2026-10-05 17:30:00',
    status = 'COMPLETED',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = 1;

-- ====================================================================
-- TRUY VẤN TÍNH TOÁN TIỀN HOÀN TRẢ (REFUND)
-- ====================================================================

SELECT 
    r.rental_id,
    r.customer_name,
    c.model_name,
    c.license_plate,
    r.status,
    r.security_deposit AS tien_coc,
    r.late_fee AS phi_tre,
    r.damage_fee AS phi_sua_chua,
    (r.security_deposit - r.late_fee - r.damage_fee) AS tien_hoan_lai_cho_khach,
    i.damage_description AS ghi_chu_kiem_tra,
    i.inspector_name AS nhan_vien_kiem_tra
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 1;
'@ | Out-File -FilePath "autoride_db.sql" -Encoding utf8