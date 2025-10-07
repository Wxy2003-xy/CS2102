-- For each faculty, print the number of loans that involve an owner and a borrower from
-- this faculty?

SELECT d.faculty, count(*)
FROM department d, loan l, student s1, student s2
WHERE l.owner