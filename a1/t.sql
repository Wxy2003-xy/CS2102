WITH w AS (
    SELECT ra.season AS season, COUNT(*) FILTER (WHERE re.position_text = 'W') AS count
    FROM races ra JOIN results re ON re.race = ra.date 
    GROUP BY ra.season
    ORDER BY ra.season
)

SELECT * FROM w WHERE w.count = (SELECT MIN(count) FROM w);


SELECT d.forename, d.surname, COUNT(*) FILTER (WHERE q.position = 1)
FROM drivers d 
JOIN qualifyings q ON q.driver_forename = d.forename AND q.driver_surname = d.surname
GROUP BY d.forename, d.surname
ORDER BY COUNT(*) FILTER (WHERE q.position = 1) DESC, d.forename ASC, d.surname ASC;

