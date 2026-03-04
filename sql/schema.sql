-- ============================================
-- WealthTrack Database Schema
-- Asset Management & Portfolio Tracking System
-- PostgreSQL Compatible
-- ============================================
-- Run against the wealthtrack_db database:
--   psql -U postgres -d wealthtrack_db -f schema.sql

-- ============================================
-- 1. Users Table
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    user_id             SERIAL PRIMARY KEY,
    name                VARCHAR(100) NOT NULL,
    email               VARCHAR(150) NOT NULL UNIQUE,
    phone               VARCHAR(20),
    password_hash       VARCHAR(255) NOT NULL,
    profile_picture     VARCHAR(500) DEFAULT NULL,
    currency_preference VARCHAR(10) DEFAULT 'USD',
    notification_enabled BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_email ON users (email);

-- ============================================
-- 2. Asset Categories Lookup Table
-- ============================================
CREATE TABLE IF NOT EXISTS asset_categories (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    icon_class    VARCHAR(50),
    color_code    VARCHAR(20)
);

-- ============================================
-- 3. Assets Table
-- ============================================
CREATE TABLE IF NOT EXISTS assets (
    asset_id       SERIAL PRIMARY KEY,
    user_id        INT NOT NULL,
    name           VARCHAR(200) NOT NULL,
    ticker_symbol  VARCHAR(20),
    category_id    INT NOT NULL,
    current_price  DECIMAL(18,2) DEFAULT 0.00,
    purchase_price DECIMAL(18,2) DEFAULT 0.00,
    quantity       DECIMAL(18,6) DEFAULT 0.000000,
    purchase_date  DATE,
    commission     DECIMAL(10,2) DEFAULT 0.00,
    notes          TEXT,
    added_date     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_assets_user     FOREIGN KEY (user_id)     REFERENCES users(user_id)            ON DELETE CASCADE,
    CONSTRAINT fk_assets_category FOREIGN KEY (category_id) REFERENCES asset_categories(category_id)
);

CREATE INDEX IF NOT EXISTS idx_user_id   ON assets (user_id);
CREATE INDEX IF NOT EXISTS idx_category  ON assets (category_id);
CREATE INDEX IF NOT EXISTS idx_ticker    ON assets (ticker_symbol);

-- ============================================
-- 4. Transactions Table
-- ============================================
CREATE TABLE IF NOT EXISTS transactions (
    txn_id           SERIAL PRIMARY KEY,
    asset_id         INT NOT NULL,
    user_id          INT NOT NULL,
    type             VARCHAR(20) NOT NULL CHECK (type IN ('Buy','Sell','Dividend','Transfer','Fee')),
    quantity         DECIMAL(18,6) DEFAULT 0.000000,
    price_per_unit   DECIMAL(18,2) DEFAULT 0.00,
    total_amount     DECIMAL(18,2) DEFAULT 0.00,
    commission       DECIMAL(10,2) DEFAULT 0.00,
    transaction_date DATE NOT NULL,
    status           VARCHAR(20) DEFAULT 'Completed' CHECK (status IN ('Completed','Pending','Cancelled')),
    notes            TEXT,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_txn_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE,
    CONSTRAINT fk_txn_user  FOREIGN KEY (user_id)  REFERENCES users(user_id)   ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_asset_txn ON transactions (asset_id);
CREATE INDEX IF NOT EXISTS idx_user_txn  ON transactions (user_id);
CREATE INDEX IF NOT EXISTS idx_txn_date  ON transactions (transaction_date);

-- ============================================
-- 5. Portfolio Summary Table
-- ============================================
CREATE TABLE IF NOT EXISTS portfolio_summary (
    summary_id        SERIAL PRIMARY KEY,
    user_id           INT NOT NULL UNIQUE,
    total_net_worth   DECIMAL(18,2) DEFAULT 0.00,
    total_investments DECIMAL(18,2) DEFAULT 0.00,
    liquid_cash       DECIMAL(18,2) DEFAULT 0.00,
    liabilities       DECIMAL(18,2) DEFAULT 0.00,
    last_updated      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_portfolio_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================
-- 6. Documents Table
-- ============================================
CREATE TABLE IF NOT EXISTS documents (
    doc_id      SERIAL PRIMARY KEY,
    asset_id    INT,
    user_id     INT NOT NULL,
    file_name   VARCHAR(255) NOT NULL,
    file_path   VARCHAR(500) NOT NULL,
    file_size   BIGINT DEFAULT 0,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_doc_asset FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE SET NULL,
    CONSTRAINT fk_doc_user  FOREIGN KEY (user_id)  REFERENCES users(user_id)   ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_user_doc ON documents (user_id);

-- ============================================
-- 7. Activity Log Table
-- ============================================
CREATE TABLE IF NOT EXISTS activity_log (
    log_id      SERIAL PRIMARY KEY,
    user_id     INT NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    description VARCHAR(500),
    amount      DECIMAL(18,2) DEFAULT NULL,
    timestamp   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_log_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_user_log ON activity_log (user_id);
CREATE INDEX IF NOT EXISTS idx_log_time ON activity_log (timestamp);

-- ============================================
-- 8. Triggers: auto-update updated_at columns
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE TRIGGER trg_assets_updated_at
    BEFORE UPDATE ON assets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- 9. Trigger: auto-update portfolio last_updated
-- ============================================
CREATE OR REPLACE FUNCTION update_portfolio_last_updated()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_portfolio_last_updated
    BEFORE UPDATE ON portfolio_summary
    FOR EACH ROW EXECUTE FUNCTION update_portfolio_last_updated();
