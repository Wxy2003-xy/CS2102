SELECT DISTINCT department FROM student;

SELECT department, COUNT(*) FROM student GROUP BY department;

-- SELECT b.ISBN13 FROM loan l JOIN book b ON l.book = b.ISBN13 WHERE l.returned IS NOT NULL;
SELECT l.book, l.returned - l.borrowed AS duration 
FROM loan l WHERE l.returned IS NOT NULL ORDER BY l.book ASC, duration DESC;

SELECT b.title, so.name, so.faculty, sb.name, sb.faculty FROM loan l 
JOIN book b ON l.book = b.ISBN13 
JOIN student so ON l.owner = so.email 
JOIN student sb ON l.borrower = sb.email 
WHERE l.returned IS NULL AND b.publisher = 'Wiley';


SELECT DISTINCT borrower AS email
FROM loan l
JOIN student s ON s.email = l.borrower
WHERE l.borrowed < s.year
UNION
SELECT DISTINCT owner AS email
FROM loan l
JOIN student s ON s.email = l.owner
WHERE l.borrowed < s.year;

SELECT s.email FROM loan l JOIN student s ON l.owner = s.email WHERE l.borrowed = s.year
UNION
SELECT s.email FROM loan l JOIN student s ON l.borrower = s.email WHERE l.borrowed = s.year;


SELECT s.email FROM loan l JOIN student s ON l.owner = s.email WHERE l.borrowed = s.year
INTERSECT
SELECT s.email FROM loan l JOIN student s ON l.borrower = s.email WHERE l.borrowed = s.year;

SELECT s.email FROM loan l JOIN student s ON l.borrower = s.email WHERE l.borrowed = s.year
EXCEPT
SELECT s.email FROM loan l JOIN student s ON l.owner = s.email WHERE l.borrowed = s.year;

SELECT b.ISBN13
FROM book AS b
EXCEPT
SELECT l.book
FROM loan AS l;