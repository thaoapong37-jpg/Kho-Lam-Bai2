-- ===================================================
-- BÀI TẬP: XÂY DỰNG CƠ SỞ DỮ LIỆU QUẢN LÝ BÁN HÀNG
-- ===================================================

CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- 1. Bảng Khách hàng (Customer)
CREATE TABLE IF NOT EXISTS Customer (
    cID INT AUTO_INCREMENT PRIMARY KEY,
    cName VARCHAR(50) NOT NULL,
    cAge TINYINT
);

-- 2. Bảng Hóa đơn (Order) - Dùng dấu backtick ` ` vì Order là từ khóa đặc biệt của MySQL
CREATE TABLE IF NOT EXISTS `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL,
    oTotalPrice DECIMAL(12, 2),
    FOREIGN KEY (cID) REFERENCES Customer(cID)
);

-- 3. Bảng Sản phẩm (Product)
CREATE TABLE IF NOT EXISTS Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(50) NOT NULL,
    pPrice DECIMAL(12, 2) NOT NULL
);

-- 4. Bảng Chi tiết hóa đơn (OrderDetail - trung gian quan hệ N-N giữa Order và Product)
CREATE TABLE IF NOT EXISTS OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL DEFAULT 1,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);
