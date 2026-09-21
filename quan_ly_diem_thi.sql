-- ===================================================
-- BÀI THỰC HÀNH: TẠO BẢNG TRONG CƠ SỞ DỮ LIỆU
-- ===================================================

-- Bước 1: Tạo cơ sở dữ liệu QuanLyDiemThi
CREATE DATABASE IF NOT EXISTS QuanLyDiemThi;

-- Bước 2: Chọn Database QuanLyDiemThi
USE QuanLyDiemThi;

-- Bước 3: Tạo bảng HocSinh
CREATE TABLE IF NOT EXISTS HocSinh (
    MaHS VARCHAR(20) PRIMARY KEY,
    TenHS VARCHAR(50),
    NgaySinh DATETIME,
    Lop VARCHAR(20),
    GT VARCHAR(20)
);

-- Bước 4: Tạo bảng MonHoc (tạo trước khi bổ sung khóa ngoại)
CREATE TABLE IF NOT EXISTS MonHoc (
    MaMH VARCHAR(20) PRIMARY KEY,
    TenMH VARCHAR(50),
    MaGV VARCHAR(20)
);

-- Bước 5: Tạo bảng BangDiem (bảng trung gian quan hệ n-n)
CREATE TABLE IF NOT EXISTS BangDiem (
    MaHS VARCHAR(20),
    MaMH VARCHAR(20),
    DiemThi INT,
    NgayKT DATETIME,
    PRIMARY KEY (MaHS, MaMH),
    FOREIGN KEY (MaHS) REFERENCES HocSinh(MaHS),
    FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)
);

-- Bước 6: Tạo bảng GiaoVien
CREATE TABLE IF NOT EXISTS GiaoVien (
    MaGV VARCHAR(20) PRIMARY KEY,
    TenGV VARCHAR(50),
    SDT VARCHAR(10)
);

-- Bước 7: Bổ sung khóa ngoại cho bảng MonHoc tham chiếu đến bảng GiaoVien
ALTER TABLE MonHoc ADD CONSTRAINT FK_MaGV FOREIGN KEY (MaGV) REFERENCES GiaoVien(MaGV);
