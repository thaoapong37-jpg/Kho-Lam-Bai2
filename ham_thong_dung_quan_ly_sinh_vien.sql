@'
-- ====================================================================
-- BÀI THỰC HÀNH: SỬ DỤNG CÁC HÀM THÔNG DỤNG TRONG SQL (GROUP BY & HAVING)
-- ====================================================================

USE QuanLySinhVien;

-- 1. Hiển thị số lượng sinh viên ở từng nơi
SELECT 
    Address, 
    COUNT(StudentID) AS 'SoLuongSinhVien'
FROM Student
GROUP BY Address;

-- 2. Tính điểm trung bình các môn học của mỗi học viên
SELECT 
    S.StudentID, 
    S.StudentName, 
    AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S
JOIN Mark M ON S.StudentID = M.StudentID
GROUP BY S.StudentID, S.StudentName;

-- 3. Hiển thị những bạn học viên có điểm trung bình các môn học lớn hơn 15
SELECT 
    S.StudentID, 
    S.StudentName, 
    AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S
JOIN Mark M ON S.StudentID = M.StudentID
GROUP BY S.StudentID, S.StudentName
HAVING AVG(M.Mark) > 15;

-- 4. Hiển thị thông tin các học viên có điểm trung bình lớn nhất
SELECT 
    S.StudentID, 
    S.StudentName, 
    AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S
JOIN Mark M ON S.StudentID = M.StudentID
GROUP BY S.StudentID, S.StudentName
HAVING AVG(M.Mark) >= ALL (
    SELECT AVG(Mark) 
    FROM Mark 
    GROUP BY StudentID
);
'@ | Out-File -FilePath "ham_thong_dung_quan_ly_sinh_vien.sql" -Encoding utf8