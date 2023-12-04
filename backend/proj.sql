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

-- Addresses table (for physical addresses)
CREATE TABLE IF NOT EXISTS addresses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  address VARCHAR(255),
  postalCode VARCHAR(20),
  city VARCHAR(255),
  state VARCHAR(255),
  country VARCHAR(255),
  latitude DECIMAL(10, 6),
  longitude DECIMAL(10, 6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  fullname VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  profile_image JSON,
  bio VARCHAR(255),
  phone VARCHAR(255),
  user_location_data_id INT,
  address_id INT,
  registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  last_login DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  verified BOOLEAN DEFAULT FALSE
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

-- Subcategories table
CREATE TABLE IF NOT EXISTS subcategories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  parent_category_id INT,
  FOREIGN KEY (parent_category_id) REFERENCES categories (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Refresh Tokens table
CREATE TABLE IF NOT EXISTS refresh_tokens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  token VARCHAR(500) NOT NULL,
  expiry DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reviews table
CREATE TABLE IF NOT EXISTS reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  rating INT NOT NULL,
  comment TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  message_id INT NOT NULL,
  is_viewed BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

