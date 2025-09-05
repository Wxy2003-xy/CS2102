-- ====== CONFIG ======
\set ON_ERROR_STOP on
\set csv_path /Users/wxy/Desktop/CS2102/project/menu.csv

-- ====== 1) STAGING (matches your CSV header) ======
DROP TABLE IF EXISTS stage_menu;
CREATE TEMP TABLE stage_menu (
  item    text,
  price   numeric(10,2),
  cuisine text
);

\echo Loading CSV from :csv_path
\copy stage_menu(item,price,cuisine) FROM :csv_path WITH (format csv, header true)

-- Optional hygiene: trim whitespace (safe even if none present)
UPDATE stage_menu
SET item = btrim(item),
    cuisine = btrim(cuisine);

-- ====== 2) DIMENSION: CUISINES ======
INSERT INTO Cuisines (Cuisine)
SELECT DISTINCT cuisine
FROM stage_menu
WHERE cuisine IS NOT NULL AND cuisine <> ''
ON CONFLICT DO NOTHING;

-- ====== 3) FACT: MENU ======
-- If the item already exists, update its price/cuisine.
INSERT INTO Menu (Item, Price, Cuisine)
SELECT item, price, cuisine
FROM stage_menu
WHERE item IS NOT NULL AND item <> ''
ON CONFLICT (Item) DO UPDATE
SET Price   = EXCLUDED.Price,
    Cuisine = EXCLUDED.Cuisine;

-- ====== 4) QUICK CHECKS ======
-- Items that failed FK (should be none):
SELECT sm.*
FROM stage_menu sm
LEFT JOIN Cuisines c ON c.Cuisine = sm.cuisine
WHERE c.Cuisine IS NULL;

-- Current menu snapshot:
TABLE Menu;
