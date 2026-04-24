INSERT INTO asset_categories (category_name, icon_class, color_code) VALUES
('Equities', 'fas fa-chart-line', '#2563EB'),
('ETF', 'fas fa-layer-group', '#14B8A6'),
('Crypto', 'fab fa-bitcoin', '#F59E0B')
ON CONFLICT (category_name) DO NOTHING;
