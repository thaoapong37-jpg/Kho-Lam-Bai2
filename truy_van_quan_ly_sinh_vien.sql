@'
-- ===================================================
-- BÀI THỰC HÀNH: TRUY VẤN DỮ LIỆU VỚI CSDL QUẢN LÝ SINH VIÊN
-- ===================================================

USE QuanLySinhVien;

-- 1. Hiển thị danh sách tất cả các học viên
SELECT * 
FROM Student;

-- 2. Hiển thị danh sách các học viên đang theo học (Status = true)
SELECT * 
FROM Student 
WHERE Status = true;

-- 3. Hiển thị danh sách các môn học có thời gian học/tín chỉ nhỏ hơn 10
SELECT * 
FROM Subject 
WHERE Credit < 10;

-- 4. Hiển thị danh sách học viên lớp A1
SELECT S.StudentID, S.StudentName, C.ClassName
FROM Student S 
JOIN Class C ON S.ClassID = C.ClassID
WHERE C.ClassName = 'A1';

-- 5. Hiển thị điểm môn CF của các học viên
SELECT S.StudentID, S.StudentName, Sub.SubName, M.Mark
FROM Student S 
JOIN Mark M ON S.StudentID = M.StudentID 
JOIN Subject Sub ON M.SubID = Sub.SubID
WHERE Sub.SubName = 'CF';
'@ | Out-File -FilePath "truy_van_quan_ly_sinh_vien.sql" -Encoding utf8