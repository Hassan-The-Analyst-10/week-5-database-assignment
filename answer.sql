-- =========================================================
-- STEP 1: CREATE AND POPULATE A 2-MILLION-ROW ORDERS TABLE
-- =========================================================

CREATE TABLE orders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INT,
    amount NUMERIC(10,2),
    status TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO orders (customer_id, amount, status, created_at)
SELECT
    (random() * 50000)::int,
    (random() * 500)::numeric(10,2),
    (ARRAY['pending','shipped','delivered'])[ceil(random() * 3)],
    now() - (random() * 365)::int * interval '1 day'
FROM generate_series(1, 2000000);

ANALYZE orders;


-- =========================================================
-- STEP 2: MEASURE THE SLOW QUERY
-- =========================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT customer_id, SUM(amount)
FROM orders
WHERE status = 'pending'
  AND created_at > now() - interval '30 days'
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 10;


-- =========================================================
-- STEP 3: CREATE A TARGETED PARTIAL COMPOSITE INDEX
-- =========================================================

CREATE INDEX idx_pending_recent
ON orders (created_at DESC, customer_id)
WHERE status = 'pending';

-- Run ANALYZE again so PostgreSQL has updated statistics
ANALYZE orders;

-- Run the same query again
EXPLAIN (ANALYZE, BUFFERS)
SELECT customer_id, SUM(amount)
FROM orders
WHERE status = 'pending'
  AND created_at > now() - interval '30 days'
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 10;


-- =========================================================
-- STEP 4: TRANSACTION ISOLATION
-- =========================================================

-- SESSION 1
BEGIN;

SELECT amount
FROM orders
WHERE id = 1;

-- Keep this transaction open.


-- SESSION 2
-- Open another psql terminal/session and run:

BEGIN;

UPDATE orders
SET amount = 9999
WHERE id = 1;

COMMIT;


-- SESSION 1 AGAIN
-- Return to Session 1 and run:

SELECT amount
FROM orders
WHERE id = 1;

COMMIT;


-- =========================================================
-- OPTIONAL: TEST REPEATABLE READ
-- =========================================================

-- SESSION 1
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT amount
FROM orders
WHERE id = 1;

-- Now update the same row and COMMIT in SESSION 2.

-- Then run again in SESSION 1:
SELECT amount
FROM orders
WHERE id = 1;

COMMIT;
