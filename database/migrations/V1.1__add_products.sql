-- Add indexes for better query performance
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_category ON products(category);

-- Add product categories
ALTER TABLE products ADD COLUMN IF NOT EXISTS category VARCHAR(100);

-- Insert sample data
INSERT INTO products (name, description, price, stock_quantity, category) VALUES
('Laptop Pro', 'High-performance laptop', 1299.99, 50, 'Electronics'),
('Wireless Mouse', 'Ergonomic wireless mouse', 29.99, 200, 'Electronics'),
('Office Chair', 'Comfortable office chair', 249.99, 30, 'Furniture'),
('Desk Lamp', 'LED desk lamp', 39.99, 100, 'Furniture')
ON CONFLICT DO NOTHING;
