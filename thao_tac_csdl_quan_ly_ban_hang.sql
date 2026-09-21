@'
-- ====================================================================
-- BÀI TẬP: THAO TÁC VỚI CƠ SỞ DỮ LIỆU QUẢN LÝ BÁN HÀNG
-- ====================================================================

USE QuanLyBanHang;

-- --------------------------------------------------------------------
-- 1. THÊM DỮ LIỆU VÀO CÁC BẢNG (INSERT)
-- --------------------------------------------------------------------

-- Thêm vào bảng Customer
INSERT INTO Customer (cID, cName, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

-- Thêm vào bảng Order
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

-- Thêm vào bảng Product
INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

-- Thêm vào bảng OrderDetail
INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

-- --------------------------------------------------------------------
-- 2. CÁC CÂU TRUY VẤN DỮ LIỆU (SELECT)
-- --------------------------------------------------------------------

-- Câu 1: Hiển thị các thông tin gồm oID, oDate, oTotalPrice của tất cả các hóa đơn trong bảng Order
SELECT 
    oID, 
    oDate, 
    oTotalPrice 
FROM `Order`;

-- Câu 2: Hiển thị danh sách khách hàng đã mua hàng và danh sách sản phẩm được mua bởi các khách
SELECT DISTINCT 
    c.cName AS CustomerName, 
    p.pName AS ProductName
FROM Customer c
JOIN `Order` o ON c.cID = o.cID
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID;

-- Câu 3: Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
SELECT 
    c.cID, 
    c.cName 
FROM Customer c
LEFT JOIN `Order` o ON c.cID = o.cID
WHERE o.oID IS NULL;

-- Câu 4: Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (tổng giá = SUM(odQTY * pPrice))
SELECT 
    o.oID, 
    o.oDate, 
    SUM(od.odQTY * p.pPrice) AS oTotalPrice
FROM `Order` o
JOIN OrderDetail od ON o.oID = od.oID
JOIN Product p ON od.pID = p.pID
GROUP BY o.oID, o.oDate;
'@ | Out-File -FilePath "thao_tac_csdl_quan_ly_ban_hang.sql" -Encoding utf8