-- Assumptions:
--  - OrderLines has PK ("Order", LineID) and UNIQUE ("Order", Item, Staff)
--  - staging(order_id, item, staff) holds new rows (duplicates allowed)
--  - Menu(Item PRIMARY KEY, Cuisine …) exists so we can derive Cuisine
--  - Orders have been inserted already (else FK will fail)

BEGIN;
LOCK TABLE OrderLines IN SHARE ROW EXCLUSIVE MODE;  -- optional, for concurrency safety

WITH agg AS (                      -- collapse duplicates → qty
  SELECT order_id, item, staff, COUNT(*)::int AS qty
  FROM staging
  GROUP BY order_id, item, staff
),
max_line AS (                      -- current max LineID per order we’re about to touch
  SELECT "Order", COALESCE(MAX(LineID), 0) AS max_id
  FROM OrderLines
  WHERE "Order" IN (SELECT DISTINCT order_id FROM agg)
  GROUP BY "Order"
),
numbered AS (                      -- assign LineID deterministically after the max
  SELECT
    a.order_id,
    a.item,
    a.staff,
    a.qty,
    m.cuisine,
    (COALESCE(ml.max_id, 0)
     + ROW_NUMBER() OVER (PARTITION BY a.order_id ORDER BY a.item, a.staff)
    ) AS line_id
  FROM agg a
  JOIN Menu m ON m.Item = a.item
  LEFT JOIN max_line ml ON ml."Order" = a.order_id
)
INSERT INTO OrderLines ("Order", LineID, Item, Cuisine, Staff, Quantity)
SELECT order_id, line_id, item, cuisine, staff, qty
FROM numbered
ON CONFLICT ("Order", Item, Staff)
DO UPDATE SET Quantity = OrderLines.Quantity + EXCLUDED.Quantity;

COMMIT;
