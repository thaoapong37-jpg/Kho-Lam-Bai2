@'
-- ====================================================================
-- BÀI TẬP: LUYỆN TẬP CÁC HÀM THÔNG DỤNG TRONG SQL (QUANLYSINHVIEN)
-- ====================================================================

USE QuanLySinhVien;

-- 1. Hiển thị tất cả các thông tin môn học (bảng Subject) có credit lớn nhất
SELECT *
FROM Subject
WHERE Credit = (SELECT MAX(Credit) FROM Subject);

-- 2. Hiển thị các thông tin môn học có điểm thi lớn nhất
SELECT 
    Sub.SubID, 
    Sub.SubName, 
    Sub.Credit, 
    Sub.Status, 
    M.Mark
FROM Subject Sub
JOIN Mark M ON Sub.SubID = M.SubID
WHERE M.Mark = (SELECT MAX(Mark) FROM Mark);

-- 3. Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên,
-- xếp hạng theo thứ tự điểm giảm dần
SELECT 
    S.StudentID, 
    S.StudentName, 
    S.Address, 
    S.Phone, 
    S.Status, 
    S.ClassID, 
    AVG(M.Mark) AS DiemTrungBinh
FROM Student S
JOIN Mark M ON S.StudentID = M.StudentID
GROUP BY S.StudentID, S.StudentName, S.Address, S.Phone, S.Status, S.ClassID
ORDER BY DiemTrungBinh DESC;
'@ | Out-File -FilePath "luyen_tap_ham_thong_dung_quan_ly_sinh_vien.sql" -Encoding utf8