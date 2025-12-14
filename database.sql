DROP DATABASE IF EXISTS train_schedule_db;
CREATE DATABASE IF NOT EXISTS train_schedule_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE train_schedule_db;

-- Roles Table
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    role_id INT,
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- Stations Table
CREATE TABLE IF NOT EXISTS stations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

-- Trains Table
CREATE TABLE IF NOT EXISTS trains (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    total_seats INT DEFAULT 100
);

-- Schedules Table
CREATE TABLE IF NOT EXISTS schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    train_id INT,
    departure_station_id INT,
    arrival_station_id INT,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (train_id) REFERENCES trains(id),
    FOREIGN KEY (departure_station_id) REFERENCES stations(id),
    FOREIGN KEY (arrival_station_id) REFERENCES stations(id)
);

-- Bookings Table (NEW)
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    schedule_id INT,
    booking_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'BOOKED', -- BOOKED, CANCELLED
    
    -- Passenger Info
    full_name VARCHAR(100),
    id_card VARCHAR(20),
    phone VARCHAR(15),
    email VARCHAR(100),
    
    -- Ticket Details
    quantity INT DEFAULT 1,
    notes TEXT,
    
    -- Payment Info
    payment_method VARCHAR(50),
    total_price DECIMAL(10, 2),
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (schedule_id) REFERENCES schedules(id)
);

-- ==========================================
-- SEED DATA
-- ==========================================

-- 1. Roles
DELETE FROM roles WHERE id > 0;
ALTER TABLE roles AUTO_INCREMENT = 1;
INSERT INTO roles (name) VALUES ('ADMIN'), ('USER');

-- 2. Users
DELETE FROM users WHERE id > 0;
ALTER TABLE users AUTO_INCREMENT = 1;
INSERT INTO users (username, password, full_name, role_id) VALUES 
('admin', '123456', 'Super Administrator', 1),
('manager', '123456', 'Train Manager', 1),
('staff1', '123456', 'Train Staff 1', 2),
('staff2', '123456', 'Train Staff 2', 2),
('staff3', '123456', 'Train Staff 3', 2);

-- 3. Stations (Major Vietnamese Cities)
DELETE FROM stations WHERE id > 0;
ALTER TABLE stations AUTO_INCREMENT = 1;
INSERT INTO stations (name, city) VALUES 
('Ga Ha Noi', 'Ha Noi'),
('Ga Phu Ly', 'Ha Nam'),
('Ga Nam Dinh', 'Nam Dinh'),
('Ga Ninh Binh', 'Ninh Binh'),
('Ga Thanh Hoa', 'Thanh Hoa'),
('Ga Vinh', 'Nghe An'),
('Ga Dong Hoi', 'Quang Binh'),
('Ga Dong Ha', 'Quang Tri'),
('Ga Hue', 'Hue'),
('Ga Da Nang', 'Da Nang'),
('Ga Tam Ky', 'Quang Nam'),
('Ga Quang Ngai', 'Quang Ngai'),
('Ga Dieu Tri', 'Binh Dinh'),
('Ga Tuy Hoa', 'Phu Yen'),
('Ga Nha Trang', 'Khanh Hoa'),
('Ga Thap Cham', 'Ninh Thuan'),
('Ga Binh Thuan', 'Binh Thuan'),
('Ga Bien Hoa', 'Dong Nai'),
('Ga Sai Gon', 'Ho Chi Minh');

-- 4. Trains
DELETE FROM trains WHERE id > 0;
ALTER TABLE trains AUTO_INCREMENT = 1;
INSERT INTO trains (code, name, total_seats) VALUES 
('SE1', 'Thong Nhat Express SE1', 300),
('SE2', 'Thong Nhat Express SE2', 300),
('SE3', 'Thong Nhat Express SE3', 250),
('SE4', 'Thong Nhat Express SE4', 250),
('SE5', 'Thong Nhat Express SE5', 280),
('SE6', 'Thong Nhat Express SE6', 280),
('SE7', 'Thong Nhat Express SE7', 320),
('SE8', 'Thong Nhat Express SE8', 320),
('TN1', 'Thong Nhat Slow TN1', 400),
('TN2', 'Thong Nhat Slow TN2', 400),
('SNT1', 'Saigon - Nha Trang SNT1', 200),
('SNT2', 'Nha Trang - Saigon SNT2', 200),
('SPT1', 'Saigon - Phan Thiet SPT1', 180),
('SPT2', 'Phan Thiet - Saigon SPT2', 180);

-- 5. Schedules (Generating varied data)
DELETE FROM schedules WHERE id > 0;
ALTER TABLE schedules AUTO_INCREMENT = 1;

-- Helper variables for IDs (Assuming AI sequential)
-- Ha Noi = 1, Da Nang = 10, Sai Gon = 19, Nha Trang = 15

-- SE1: Ha Noi -> Sai Gon (Next 7 days)
INSERT INTO schedules (train_id, departure_station_id, arrival_station_id, departure_time, arrival_time, price) VALUES 
(1, 1, 10, DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL '1 14' DAY_HOUR), 850000), -- Hanoi -> Danang
(1, 10, 15, DATE_ADD(NOW(), INTERVAL '1 15' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '2 1' DAY_HOUR), 450000), -- Danang -> NhaTrang
(1, 15, 19, DATE_ADD(NOW(), INTERVAL '2 2' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '2 10' DAY_HOUR), 350000); -- NhaTrang -> Saigon

-- SE2: Sai Gon -> Ha Noi
INSERT INTO schedules (train_id, departure_station_id, arrival_station_id, departure_time, arrival_time, price) VALUES 
(2, 19, 15, DATE_ADD(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL '1 8' DAY_HOUR), 350000),
(2, 15, 10, DATE_ADD(NOW(), INTERVAL '1 9' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '1 19' DAY_HOUR), 450000),
(2, 10, 1, DATE_ADD(NOW(), INTERVAL '1 20' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '2 10' DAY_HOUR), 850000);

-- Short trips (Next 3 days)
INSERT INTO schedules (train_id, departure_station_id, arrival_station_id, departure_time, arrival_time, price) VALUES 
-- Hanoi -> Ninh Binh
(5, 1, 4, DATE_ADD(NOW(), INTERVAL '1 8' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '1 10' DAY_HOUR), 120000),
(7, 1, 4, DATE_ADD(NOW(), INTERVAL '2 9' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '2 11' DAY_HOUR), 115000),

-- Saigon -> Nha Trang (Weekend Trip)
(11, 19, 15, DATE_ADD(NOW(), INTERVAL '5 20' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '6 5' DAY_HOUR), 550000),
(12, 15, 19, DATE_ADD(NOW(), INTERVAL '7 16' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '8 0' DAY_HOUR), 550000),

-- Da Nang -> Hue
(3, 10, 9, DATE_ADD(NOW(), INTERVAL '1 7' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '1 10' DAY_HOUR), 90000),
(3, 9, 10, DATE_ADD(NOW(), INTERVAL '1 14' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '1 17' DAY_HOUR), 90000),

-- Vinh -> Hanoi
(9, 6, 1, DATE_ADD(NOW(), INTERVAL '1 22' DAY_HOUR), DATE_ADD(NOW(), INTERVAL '2 5' DAY_HOUR), 250000);

-- 6. Bookings (Sample data)
DELETE FROM bookings WHERE id > 0;
ALTER TABLE bookings AUTO_INCREMENT = 1;
INSERT INTO bookings (user_id, schedule_id, booking_time, status, full_name, id_card, phone, email, quantity, total_price, payment_method) VALUES 
(3, 1, NOW(), 'BOOKED', 'Nguyen Van A', '123456789', '0901234567', 'nguyenvana@example.com', 1, 850000, 'momo'),
(3, 5, NOW(), 'CANCELLED', 'Nguyen Van A', '123456789', '0901234567', 'nguyenvana@example.com', 2, 240000, 'card'),
(4, 2, NOW(), 'BOOKED', 'Tran Thi B', '987654321', '0909876543', 'tranthib@example.com', 1, 450000, 'pay_later');
