-- -- WITH w AS (
-- --     SELECT ra.season AS season, COUNT(*) FILTER (WHERE re.position_text = 'W') AS count
-- --     FROM races ra JOIN results re ON re.race = ra.date 
-- --     GROUP BY ra.season
-- --     ORDER BY ra.season
-- -- )

-- -- SELECT * FROM w WHERE w.count = (SELECT MIN(count) FROM w);


-- -- SELECT d.forename, d.surname, COUNT(*) FILTER (WHERE q.position = 1)
-- -- FROM drivers d 
-- -- JOIN qualifyings q ON q.driver_forename = d.forename AND q.driver_surname = d.surname
-- -- GROUP BY d.forename, d.surname
-- -- ORDER BY COUNT(*) FILTER (WHERE q.position = 1) DESC, d.forename ASC, d.surname ASC;

-- WITH w AS (
--     SELECT ra.season AS season, COUNT(*) FILTER (WHERE re.position = 1) AS win, 
--     re.driver_forename AS forename, re.driver_surname AS surname, re.position AS position
--     FROM races ra JOIN results re ON re.race = ra.date 
--     GROUP BY re.driver_forename, re.driver_surname, ra.season, re.position
-- ), champ AS (
--     SELECT w.season, d.forename AS forename, d.surname AS surname, w.win
--     FROM drivers d 
--     JOIN w ON w.forename = d.forename AND w.surname = d.surname
--     GROUP BY d.forename, d.surname, w.season, w.win
--     ORDER BY w.season
-- ), wins AS (
--     SELECT DISTINCT c1.* FROM champ c1 JOIN champ c2 
--     ON c1.season = c2.season AND c1.win > c2.win
-- )
-- SELECT ww.season, MAX(ww.win) FROM wins ww GROUP BY ww.season;
-- -- 
-- -- SELECT COUNT(*) FROM results;    
-- -- SELECT COUNT(*) FROM seasons;

-- SELECT * FROM champ WHERE champ.season = 2016;

WITH s AS (
  SELECT year FROM seasons WHERE year = 2015
)
SELECT r.date, r.name AS grand_prix, c.name AS circuit, c.location, c.country
FROM races r
JOIN s ON r.season = s.year
JOIN circuits c ON c.name = r.circuit
ORDER BY r.date;
