-- ============================================
-- WealthTrack Seed Data
-- Sample data for testing and development
-- ============================================

-- Connect to wealthtrack_db before running:
--   psql -U postgres -d wealthtrack_db -f seed-data.sql

-- ============================================
-- Insert Asset Categories
-- ============================================
INSERT INTO asset_categories (category_name, icon_class, color_code) VALUES
('Equities', 'fas fa-chart-line', '#2563EB'),
('ETF', 'fas fa-layer-group', '#7C3AED'),
('Crypto', 'fab fa-bitcoin', '#F59E0B'),
('Real Estate', 'fas fa-home', '#10B981'),
('Cash', 'fas fa-wallet', '#3B82F6'),
('Bonds', 'fas fa-file-invoice-dollar', '#6366F1');

-- ============================================
-- Insert Sample User (password: Test@1234)
-- BCrypt hash of 'Test@1234'
-- ============================================
INSERT INTO users (name, email, phone, password_hash, currency_preference) VALUES
('Alex Morgan', 'alex@wealthtrack.com', '+1-555-0100', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'USD');

-- ============================================
-- Insert Sample Assets
-- ============================================
INSERT INTO assets (user_id, name, ticker_symbol, category_id, current_price, purchase_price, quantity, purchase_date, commission) VALUES
(1, 'Apple Inc.', 'AAPL', 1, 173.50, 145.20, 150.000000, '2023-01-22', 9.99),
(1, 'Vanguard S&P 500', 'VOO', 2, 481.20, 450.00, 100.000000, '2023-03-15', 0.00),
(1, 'Bitcoin', 'BTC', 3, 62250.00, 40000.00, 0.500000, '2023-06-10', 25.00),
(1, 'Chase Checking', NULL, 5, 1.00, 1.00, 8500.000000, '2023-01-01', 0.00),
(1, 'Rental Property', NULL, 4, 420000.00, 350000.00, 1.000000, '2022-05-20', 8500.00),
(1, 'Tesla Inc.', 'TSLA', 1, 248.50, 220.00, 50.000000, '2023-04-12', 9.99),
(1, 'Microsoft Corp.', 'MSFT', 1, 378.90, 310.00, 75.000000, '2023-02-28', 9.99),
(1, 'Ethereum', 'ETH', 3, 3450.00, 2800.00, 2.000000, '2023-07-15', 15.00),
(1, 'iShares Core Bond', 'AGG', 6, 98.50, 102.00, 200.000000, '2023-05-01', 0.00),
(1, 'Savings Account', NULL, 5, 1.00, 1.00, 25000.000000, '2023-01-01', 0.00),
(1, 'Amazon.com Inc.', 'AMZN', 1, 178.25, 145.00, 40.000000, '2023-08-20', 9.99),
(1, 'Google (Alphabet)', 'GOOGL', 1, 141.80, 120.00, 60.000000, '2023-03-10', 9.99),
(1, 'Solana', 'SOL', 3, 125.00, 95.00, 50.000000, '2023-09-05', 10.00),
(1, 'Home Mortgage', NULL, 5, 1.00, 1.00, -350069.000000, '2022-05-20', 0.00);

-- ============================================
-- Insert Portfolio Summary
-- ============================================
INSERT INTO portfolio_summary (user_id, total_net_worth, total_investments, liquid_cash, liabilities) VALUES
(1, 1245300.00, 850230.50, 45000.00, -350069.00);

-- ============================================
-- Insert Sample Transactions
-- ============================================
INSERT INTO transactions (asset_id, user_id, type, quantity, price_per_unit, total_amount, commission, transaction_date, status) VALUES
(1, 1, 'Buy', 50.000000, 135.00, 6750.00, 9.99, '2023-01-22', 'Completed'),
(1, 1, 'Dividend', 0.000000, 0.24, 34.80, 0.00, '2023-05-15', 'Completed'),
(1, 1, 'Buy', 25.000000, 165.40, 4135.00, 9.99, '2023-08-05', 'Completed'),
(1, 1, 'Buy', 10.000000, 172.00, 1720.00, 9.99, '2023-10-12', 'Completed'),
(1, 1, 'Dividend', 0.000000, 0.24, 45.00, 0.00, '2023-11-15', 'Completed'),
(2, 1, 'Buy', 100.000000, 450.00, 45000.00, 0.00, '2023-03-15', 'Completed'),
(3, 1, 'Buy', 0.500000, 40000.00, 20000.00, 25.00, '2023-06-10', 'Completed'),
(6, 1, 'Buy', 50.000000, 220.00, 11000.00, 9.99, '2023-04-12', 'Completed'),
(7, 1, 'Buy', 75.000000, 310.00, 23250.00, 9.99, '2023-02-28', 'Completed');

-- ============================================
-- Insert Sample Activity Logs
-- ============================================
INSERT INTO activity_log (user_id, action_type, description, amount) VALUES
(1, 'Dividend Payout', 'Apple Inc. (AAPL) — Quarterly dividend received', 450.00),
(1, 'Asset Rebalancing', 'Sold $2k Bond ETF, Bought VOO', NULL),
(1, 'Wire Transfer', 'To Chase Checking (...8849)', -1200.00),
(1, 'Purchase', 'Bought 10 shares of AAPL at $172.00', -1720.00),
(1, 'Dividend Payout', 'Vanguard S&P 500 (VOO) — Distribution', 320.00),
(1, 'Sale', 'Sold 5 shares of TSLA at $260.00', 1300.00);

-- ============================================
-- Insert Sample Documents
-- ============================================
INSERT INTO documents (asset_id, user_id, file_name, file_path, file_size) VALUES
(1, 1, 'Trade_Confirm_Oct23.pdf', '/uploads/docs/trade_confirm_oct23.pdf', 148480),
(1, 1, 'Dividend_Stmt_Q3.pdf', '/uploads/docs/dividend_stmt_q3.pdf', 91136),
(1, 1, 'Trade_Confirm_Jan23.pdf', '/uploads/docs/trade_confirm_jan23.pdf', 145408);
