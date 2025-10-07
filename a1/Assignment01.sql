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



/* Matric Number: <write your matric number here> */
/* Q01 */
WITH w AS (
  SELECT ra.season,
         COUNT(*) FILTER (WHERE r.position_text = 'W') AS wcnt
  FROM races ra
  LEFT JOIN results r ON r.race = ra.date
  GROUP BY ra.season
)
SELECT season, wcnt AS count
FROM w
WHERE wcnt = (SELECT MIN(wcnt) FROM w)
ORDER BY season;

/* Q02 */
SELECT
  res.constructor AS constructor,
  MIN(r.season)   AS first,
  MAX(r.season)   AS last
FROM results res
JOIN races r
  ON r.date = res.race
GROUP BY res.constructor
HAVING SUM(CASE WHEN res.position BETWEEN 1 AND 3 THEN 1 ELSE 0 END) = 0
ORDER BY constructor;

/* Q03 */
SELECT
  d.forename,
  d.surname,
  COUNT(*) FILTER (WHERE q.position = 1) AS count
FROM drivers d 
LEFT JOIN qualifyings q
  ON q.driver_forename = d.forename
 AND q.driver_surname  = d.surname
GROUP BY d.forename, d.surname
ORDER BY count DESC, d.surname ASC, d.forename ASC;

/* Q04 */
SELECT
  r.date     AS race,
  d.forename AS forename,
  d.surname  AS surname,
  q.position AS pole
FROM races r
JOIN results res
  ON res.race = r.date
 AND res.position = 1
JOIN drivers d
  ON d.forename = res.driver_forename
 AND d.surname  = res.driver_surname
JOIN qualifyings q
  ON q.race = r.date
 AND q.driver_forename = d.forename
 AND q.driver_surname  = d.surname
WHERE q.position > 1
ORDER BY race;

/* Q05 */
WITH season_stats AS (
  SELECT
    r.season,
    res.driver_forename,
    res.driver_surname,
    SUM(res.points) AS pts,   
    COUNT(*) FILTER (WHERE res.position = 1) AS wins  
  FROM results res
  JOIN races r ON r.date = res.race
  GROUP BY r.season, res.driver_forename, res.driver_surname
),
max_pts AS (
  SELECT season, MAX(pts) AS max_pts
  FROM season_stats
  GROUP BY season
)
SELECT
  s.season,
  s.driver_forename AS forename,
  s.driver_surname  AS surname,
  s.wins
FROM season_stats s
JOIN max_pts m
  ON m.season = s.season
 AND m.max_pts = s.pts
ORDER BY s.season ASC, surname ASC, forename ASC;


-- 4
SELECT ra.date, r.driver_forename, r.driver_surname, q.position
FROM races ra 
JOIN results r ON ra.date = r.race
JOIN qualifyings q ON q.race = ra.date AND q.driver_forename = r.driver_forename AND q.driver_surname = r.driver_surname
WHERE q.position <> 1 AND r.position = 1;

--5 


WITH pt AS (
  SELECT ra.season, r.driver_forename, r.driver_surname, SUM(r.points) AS psum, COUNT(*) FILTER(WHERE r.position = 1) AS wins
  FROM races ra 
  JOIN results r ON r.race = ra.date
  GROUP BY ra.season, r.driver_forename, r.driver_surname
),
max_pt AS (
  SELECT pt.season, MAX(pt.psum) AS pmax
  FROM pt 
  GROUP BY pt.season
)

SELECT pt.season, pt.driver_forename, pt.driver_surname, pt.wins FROM pt
JOIN max_pt ON pt.season = max_pt.season AND pt.psum = max_pt.pmax
-- GROUP BY pt.season, pt.driver_forename, pt.driver_surname, pt.wins
ORDER BY pt.season;