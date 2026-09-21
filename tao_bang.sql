-- Bài thực hành: Tạo bảng trên MySQL
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

CREATE TABLE IF NOT EXISTS Student (
    id INT,
    name VARCHAR(200),
    age INT,
    country VARCHAR(50)
);