CREATE TABLE IF NOT EXISTS asset_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(80) NOT NULL UNIQUE,
    icon_class VARCHAR(80),
    color_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
