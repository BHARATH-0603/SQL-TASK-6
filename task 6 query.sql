
-- Scalar Subquery in SELECT
SELECT name,
       (SELECT COUNT(*) FROM orderss WHERE customer_id = 1) AS total_orders
FROM customer;

-- Customers Who Ordered the Cheapest Product
SELECT c.customer_id, c.name
FROM customer c
WHERE c.customer_id IN (
  SELECT o.customer_id
  FROM orderss o
  JOIN orders oi ON o.order_id = oi.order_id
  WHERE oi.order_id = (
    SELECT product_id
    FROM products
    WHERE price = (SELECT MIN(price) FROM products)
  )
);


--  Products Ordered More Than Average Quantity
SELECT p.product_id, p.product_name
FROM products p
WHERE p.product_id IN (
  SELECT oi.product_id
  FROM order_items oi
  GROUP BY oi.product_id
  HAVING SUM(oi.quantity) > (
    SELECT AVG(total_qty)
    FROM (
      SELECT SUM(quantity) AS total_qty
      FROM order_items
      GROUP BY product_id
    ) AS avg_sub
  )
);


-- Top 1 Highest Spending Customer (Correlated)
SELECT c.customer_id, c.customer_name
FROM customers c
WHERE (
  SELECT SUM(oi.quantity * oi.unit_price)
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.customer_id = c.customer_id
) = (
  SELECT MAX(total_spent)
  FROM (
    SELECT o.customer_id, SUM(oi.quantity * oi.unit_price) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
  ) AS spending
);


-- Filter Products with MIN Price using Subquery
SELECT name, price
FROM products
WHERE price = (SELECT MIN(price) FROM products);


--  Subquery with EXISTS
SELECT name
FROM customer c
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
);



