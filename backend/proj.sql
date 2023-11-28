-- Set SQL mode and time zone
SET GLOBAL sql_mode = 'NO_AUTO_VALUE_ON_ZERO';
SET GLOBAL time_zone = '+00:00';

-- Create the proj database if it doesn't exist
CREATE DATABASE IF NOT EXISTS proj;
USE proj;

-- Create a webuser account for accessing the database from Apache/PHP with limited permissions
-- Note: This is different from the website's 'user' account
CREATE USER IF NOT EXISTS 'webuser'@'mysql-db' IDENTIFIED BY 'P@ssw0rd';
CREATE USER IF NOT EXISTS 'webuser'@'%' IDENTIFIED BY 'P@ssw0rd';
GRANT INSERT, UPDATE, DELETE, SELECT ON proj.* TO 'webuser'@'mysql-db';
GRANT INSERT, UPDATE, DELETE, SELECT ON proj.* TO 'webuser'@'%';

-- Flush privileges
FLUSH PRIVILEGES;

-- Define the table structure
-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  fullname VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  bio VARCHAR(255),
  phone VARCHAR(255),
  registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_login DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- User Location Data table (for tracking user locations)
CREATE TABLE IF NOT EXISTS user_location_data (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  timestamp DATETIME,
  latitude DECIMAL(10, 6),
  longitude DECIMAL(10, 6),
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Refresh Tokens table
CREATE TABLE IF NOT EXISTS refresh_tokens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  token VARCHAR(500) NOT NULL,
  expiry DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
