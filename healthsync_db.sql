-- ====================================================================
-- DỰ ÁN HEALTHSYNC: TÁI CẤU TRÚC VÀ TỐI ƯU CƠ SỞ DỮ LIỆU PHÒNG KHÁM
-- ====================================================================

DROP DATABASE IF EXISTS healthsync_db;
CREATE DATABASE healthsync_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE healthsync_db;

-- 1. Bảng Bệnh nhân (Patients)
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL
);

-- 2. Bảng Bác sĩ (Doctors)
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    specialty VARCHAR(50)
);

-- 3. Bảng Lịch hẹn (Appointments) - Đã tái cấu trúc chuẩn hóa
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    deposit_amount DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    penalty_fee DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    cancel_reason VARCHAR(255) NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE RESTRICT,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE RESTRICT
);

-- 4. Bảng Đơn thuốc (Prescriptions)
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL UNIQUE,
    medication_details TEXT NOT NULL,
    issued_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

-- ====================================================================
-- MÔ PHỎNG DỮ LIỆU THỰC TẾ (DML)
-- ====================================================================

INSERT INTO Patients (full_name, phone) VALUES 
('Nguyen Van An', '0912345678'),
('Tran Thi Binh', '0987654321');

INSERT INTO Doctors (full_name, specialty) VALUES 
('BS. Le Minh Quan', 'Noi tong quat'),
('BS. Pham Thu Huong', 'Tai mui hong');

-- Kịch bản 1: Luồng hoàn tất (Happy Path)
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (1, 1, '2026-10-05 08:30:00', 'PENDING', 500000.00);

UPDATE Appointments SET status = 'CONFIRMED' WHERE appointment_id = 1;
UPDATE Appointments SET status = 'CHECKED_IN' WHERE appointment_id = 1;
UPDATE Appointments SET status = 'COMPLETED' WHERE appointment_id = 1;

INSERT INTO Prescriptions (appointment_id, medication_details)
VALUES (1, '1. Paracetamol 500mg: 10 vien - 2. Vitamin C 500mg: 10 vien');

-- Kịch bản 2: Hủy lịch và phạt tiền cọc
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status, deposit_amount)
VALUES (2, 2, '2026-10-06 14:00:00', 'CONFIRMED', 300000.00);

UPDATE Appointments 
SET status = 'CANCELLED',
    cancel_reason = 'Ban viec dot xuat',
    penalty_fee = 150000.00
WHERE appointment_id = 2;

-- Truy vấn kiểm tra
SELECT a.appointment_id, p.full_name AS patient_name, d.full_name AS doctor_name, a.status, pr.medication_details
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
JOIN Prescriptions pr ON a.appointment_id = pr.appointment_id
WHERE a.status = 'COMPLETED';

SELECT a.appointment_id, p.full_name AS patient_name, a.status, a.deposit_amount, a.penalty_fee, (a.deposit_amount - a.penalty_fee) AS refund_to_patient, a.cancel_reason
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.status = 'CANCELLED';
