-- Drop existing tables (if they exist)
DROP TABLE IF EXISTS orderitem CASCADE;
DROP TABLE IF EXISTS "order" CASCADE;
DROP TABLE IF EXISTS menuitem CASCADE;

-- Create MenuItem table
CREATE TABLE menuitem (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    available BOOLEAN DEFAULT TRUE
);

-- Create Order table
CREATE TABLE "order" (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    total_price NUMERIC(10,2) DEFAULT 0.0,
    status VARCHAR(50) DEFAULT 'pending'
);

-- Create OrderItem table
CREATE TABLE orderitem (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES "order"(id) ON DELETE CASCADE,
    menu_item_id INTEGER NOT NULL REFERENCES menuitem(id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1
);

-- =============================
-- Insert sample Menu Items
-- =============================
INSERT INTO menuitem (name, description, price, available) VALUES
('Margherita Pizza', 'Classic cheese pizza with tomato sauce', 8.99, TRUE),
('Pepperoni Pizza', 'Spicy pepperoni and mozzarella cheese', 10.49, TRUE),
('Veggie Burger', 'Grilled veggie patty with lettuce and tomato', 7.99, TRUE),
('Chicken Wings', 'Spicy BBQ chicken wings', 6.50, TRUE),
('Pasta Alfredo', 'Creamy Alfredo sauce with fettuccine', 9.75, TRUE);

-- =============================
-- Insert sample Orders
-- =============================
INSERT INTO "order" (customer_name, phone, total_price, status) VALUES
('Alice Johnson', '555-1234', 27.47, 'completed'),
('Bob Smith', '555-5678', 14.49, 'pending'),
('Charlie Brown', '555-9012', 16.99, 'in_progress');

-- =============================
-- Insert sample Order Items
-- =============================
INSERT INTO orderitem (order_id, menu_item_id, quantity) VALUES
(1, 1, 1),  -- Alice ordered 1 Margherita Pizza
(1, 2, 1),  -- Alice ordered 1 Pepperoni Pizza
(1, 4, 2),  -- Alice ordered 2 Chicken Wings
(2, 3, 2),  -- Bob ordered 2 Veggie Burgers
(3, 5, 1),  -- Charlie ordered 1 Pasta Alfredo
(3, 1, 1);  -- Charlie ordered 1 Margherita Pizza

-- =============================
-- Verify inserted data
-- =============================
-- Show all menu items
SELECT * FROM menuitem;

-- Show all orders
SELECT * FROM "order";

-- Show all order items with joined menu names
SELECT 
    oi.id AS order_item_id,
    o.customer_name,
    m.name AS menu_item,
    oi.quantity,
    m.price,
    (oi.quantity * m.price) AS total_item_price
FROM orderitem oi
JOIN "order" o ON oi.order_id = o.id
JOIN menuitem m ON oi.menu_item_id = m.id;
