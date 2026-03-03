-- ============================================
-- WealthTrack Database Schema
-- Asset Management & Portfolio Tracking System
-- ============================================

CREATE DATABASE IF NOT EXISTS wealthtrack_db;
USE wealthtrack_db;

-- ============================================
-- 1. Users Table
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(500) DEFAULT NULL,
    currency_preference VARCHAR(10) DEFAULT 'USD',
    notification_enabled TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 2. Asset Categories Lookup Table
-- ============================================
CREATE TABLE IF NOT EXISTS asset_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    icon_class VARCHAR(50),
    color_code VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 3. Assets Table
-- ============================================
CREATE TABLE IF NOT EXISTS assets (
    asset_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    ticker_symbol VARCHAR(20),
    category_id INT NOT NULL,
    current_price DECIMAL(18,2) DEFAULT 0.00,
    purchase_price DECIMAL(18,2) DEFAULT 0.00,
    quantity DECIMAL(18,6) DEFAULT 0.000000,
    purchase_date DATE,
    commission DECIMAL(10,2) DEFAULT 0.00,
    notes TEXT,
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES asset_categories(category_id),
    INDEX idx_user_id (user_id),
    INDEX idx_category (category_id),
    INDEX idx_ticker (ticker_symbol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 4. Transactions Table
-- ============================================
CREATE TABLE IF NOT EXISTS transactions (
    txn_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT NOT NULL,
    user_id INT NOT NULL,
    type ENUM('Buy', 'Sell', 'Dividend', 'Transfer', 'Fee') NOT NULL,
    quantity DECIMAL(18,6) DEFAULT 0.000000,
    price_per_unit DECIMAL(18,2) DEFAULT 0.00,
    total_amount DECIMAL(18,2) DEFAULT 0.00,
    commission DECIMAL(10,2) DEFAULT 0.00,
    transaction_date DATE NOT NULL,
    status ENUM('Completed', 'Pending', 'Cancelled') DEFAULT 'Completed',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_asset_txn (asset_id),
    INDEX idx_user_txn (user_id),
    INDEX idx_txn_date (transaction_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 5. Portfolio Summary Table
-- ============================================
CREATE TABLE IF NOT EXISTS portfolio_summary (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    total_net_worth DECIMAL(18,2) DEFAULT 0.00,
    total_investments DECIMAL(18,2) DEFAULT 0.00,
    liquid_cash DECIMAL(18,2) DEFAULT 0.00,
    liabilities DECIMAL(18,2) DEFAULT 0.00,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 6. Documents Table
-- ============================================
CREATE TABLE IF NOT EXISTS documents (
    doc_id INT AUTO_INCREMENT PRIMARY KEY,
    asset_id INT,
    user_id INT NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT DEFAULT 0,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_doc (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- 7. Activity Log Table
-- ============================================
CREATE TABLE IF NOT EXISTS activity_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    description VARCHAR(500),
    amount DECIMAL(18,2) DEFAULT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_log (user_id),
    INDEX idx_log_time (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
