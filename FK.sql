-- Orders ------------- Users

ALTER TABLE orders
ADD CONSTRAINT fk_orders_users
FOREIGN KEY (user_id)
REFERENCES users(user_id);


-- Order Items ------------ Orders

ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- Order Items ---------- Products

ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);


-- Payments ----------- Orders

ALTER TABLE payments
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- Payments -------------- Users

ALTER TABLE payments
ADD CONSTRAINT fk_payments_users
FOREIGN KEY (user_id)
REFERENCES users(user_id);


-- Reviews ------------ Users

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_users
FOREIGN KEY (user_id)
REFERENCES users(user_id);


-- Reviews ----------- Products

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);


-- Shipments ----------- Orders

ALTER TABLE shipments
ADD CONSTRAINT fk_shipments_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);


-- Inventory Logs ----------- Products

ALTER TABLE inventory_logs
ADD CONSTRAINT fk_inventorylogs_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);


-- Users ----------- Payments

ALTER TABLE users
ADD CONSTRAINT fk_users_payments
FOREIGN KEY (payment_id)
REFERENCES payments(payment_id);