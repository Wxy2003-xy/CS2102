/* Matric Number: A0282500R */
/* Q01 */
WITH w AS (
  SELECT ra.season, COUNT(r.race) AS count
  FROM races ra
  LEFT JOIN results r ON r.race = ra.date AND r.position_text = 'W'
  GROUP BY ra.season
),
m AS (SELECT MIN(count) AS zero FROM w)
SELECT season, count
FROM w, m
WHERE count = zero
ORDER BY season ASC;

/* Q02 */
SELECT
  r.constructor AS constructor,
  MIN(ra.season) AS first,
  MAX(ra.season) AS last
FROM results r
JOIN races ra ON ra.date = r.race
GROUP BY r.constructor
HAVING MAX(CASE WHEN r.position BETWEEN 1 AND 3 THEN 1 ELSE 0 END) = 0
ORDER BY constructor;


/* Q03 */

SELECT d.forename, d.surname, COUNT(*) FILTER (WHERE q.position = 1)
FROM drivers d 
LEFT JOIN qualifyings q ON q.driver_forename = d.forename AND q.driver_surname = d.surname
GROUP BY d.forename, d.surname
ORDER BY count DESC, d.surname ASC, d.forename ASC;


/* Q04 */
SELECT ra.date AS race, r.driver_forename AS forename, r.driver_surname AS surname, q.position
FROM results r
JOIN qualifyings q ON q.race = r.race AND q.driver_forename = r.driver_forename AND q.driver_surname = r.driver_surname
JOIN races ra ON r.race = ra.date 
WHERE q.position <> 1 AND r.position = 1
ORDER BY ra.date 

/* Q05 */
WITH per_driver AS (
  SELECT
    ra.season,
    r.driver_forename,
    r.driver_surname,
    SUM(r.points) AS total_points,
    SUM(CASE WHEN r.position = 1 THEN 1 ELSE 0 END) AS wins
  FROM results r
  JOIN races ra ON ra.date = r.race
  GROUP BY ra.season, r.driver_forename, r.driver_surname
),
champ AS (
  SELECT *,
         RANK() OVER (PARTITION BY season ORDER BY total_points DESC) AS rk
  FROM per_driver
)
SELECT
  season,
  driver_forename AS forename,
  driver_surname  AS surname,
  wins
FROM champ
WHERE rk = 1
ORDER BY season;
