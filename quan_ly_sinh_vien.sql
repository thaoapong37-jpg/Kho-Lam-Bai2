-- Bai tap: Xay dung co so du lieu quan ly sinh vien
CREATE DATABASE IF NOT EXISTS `student-management`;
USE `student-management`;

-- 1. Tao bang Class
CREATE TABLE IF NOT EXISTS Class (
    id INT,
    name VARCHAR(100)
);

-- 2. Tao bang Teacher
CREATE TABLE IF NOT EXISTS Teacher (
    id INT,
    name VARCHAR(100),
    age INT,
    country VARCHAR(50)
);
