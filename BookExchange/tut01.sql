-- Q2a INSERT INTO
INSERT INTO book VALUES (
  'An Introduction to Database Systems',
  'paperback',
  640,
  'English',
  'C. J. Date',
  'Pearson',
  '2003-01-01',
  '0321197844',
  '978-0321197849'
);

-- cs2102tut=# INSERT INTO book VALUES (
-- cs2102tut(#   'An Introduction to Database Systems',
-- cs2102tut(#   'paperback',
-- cs2102tut(#   640,
-- cs2102tut(#   'English',
-- cs2102tut(#   'C. J. Date',
-- cs2102tut(#   'Pearson',
-- cs2102tut(#   '2003-01-01',
-- cs2102tut(#   '0321197844',
-- cs2102tut(#   '978-0321197849'
-- cs2102tut(# );
-- INSERT 0 1

INSERT INTO book VALUES (
  'An Introduction to Database Systems',
  'paperback',
  640,
  'English',
  'C. J. Date',
  'Pearson',
  '2003-01-01',
  '0321197844',
  '978-0321197850' -- different ISBN13
);

-- ERROR:  duplicate key value violates unique constraint "book_isbn10_key"
-- DETAIL:  Key (isbn10)=(0321197844) already exists.

INSERT INTO book VALUES (
  'An Introduction to Database Systems',
  'paperback',
  640,
  'English',
  'C. J. Date',
  'Pearson',
  '2003-01-01',
  '0321197845', -- different ISBN10
  '978-0321197849'
);

-- ERROR:  duplicate key value violates unique constraint "book_pkey"
-- DETAIL:  Key (isbn13)=(978-0321197849) already exists.

-- Q2d INSERT INTO
INSERT INTO student VALUES (
  'TIKKI TAVI',
  'tikki@gmail.com',
  '2024-08-15',
  'School of Computing',
  'CS',
  NULL
);

-- cs2102tut=# INSERT INTO student VALUES (
-- cs2102tut(#   'TIKKI TAVI',
-- cs2102tut(#   'tikki@gmail.com',
-- cs2102tut(#   '2024-08-15',
-- cs2102tut(#   'School of Computing',
-- cs2102tut(#   'CS',
-- cs2102tut(#   NULL
-- cs2102tut(# );
-- INSERT 0 1


-- Q2e INSERT INTO
INSERT INTO student (email, name, year, faculty, department) VALUES (
  'rikki@gmail.com',
  'RIKKI TAVI',
  '2024-08-15',
  'School of Computing',
  'CS'
);

-- cs2102tut=# INSERT INTO student (email, name, year, faculty, department) VALUES (
-- cs2102tut(#   'rikki@gmail.com',
-- cs2102tut(#   'RIKKI TAVI',
-- cs2102tut(#   '2024-08-15',
-- cs2102tut(#   'School of Computing',
-- cs2102tut(#   'CS'
-- cs2102tut(# );
-- INSERT 0 1


-- Q2f UPDATE
UPDATE student
SET department = 'Computer Science'
WHERE department = 'CS';

-- cs2102tut=# UPDATE student
-- cs2102tut-# SET department = 'Computer Science'
-- cs2102tut-# WHERE department = 'CS';
-- UPDATE 2

-- cs2102tut=# DELETE FROM student WHERE department = 'chemistry'
-- cs2102tut-# ;
-- DELETE 0

-- cs2102tut=# DELETE FROM student WHERE department = 'Chemistry'                                                                                                                                                        ;
-- DELETE 0

-- Q3b INSERT INTO
INSERT INTO copy VALUES (
  'tikki@gmail.com',
  '978-0321197849',
  1,
  'TRUE'
);


-- Q3b Transaction 1
BEGIN TRANSACTION;
  SET CONSTRAINTS ALL IMMEDIATE;
  DELETE FROM book WHERE ISBN13 = '978-0321197849';
  DELETE FROM copy WHERE book = '978-0321197849';
END TRANSACTION;
-- cs2102tut=# BEGIN TRANSACTION;
-- BEGIN
-- cs2102tut=*#   SET CONSTRAINTS ALL IMMEDIATE;
-- SET CONSTRAINTS
-- cs2102tut=*#   DELETE FROM book WHERE ISBN13 = '978-0321197849';
-- ERROR:  update or delete on table "book" violates foreign key constraint "copy_book_fkey" on table "copy"
-- DETAIL:  Key (isbn13)=(978-0321197849) is still referenced from table "copy".
-- cs2102tut=!#   DELETE FROM copy WHERE book = '978-0321197849';
-- ERROR:  current transaction is aborted, commands ignored until end of transaction block
-- cs2102tut=!# END TRANSACTION;
-- ROLLBACK

-- Q3b Transaction 2
BEGIN TRANSACTION;
  SET CONSTRAINTS ALL DEFERRED;
  DELETE FROM book WHERE ISBN13 = '978-0321197849';
  DELETE FROM copy WHERE book = '978-0321197849';
END TRANSACTION;
-- cs2102tut=# BEGIN TRANSACTION;
-- BEGIN
-- cs2102tut=*#   SET CONSTRAINTS ALL DEFERRED;
-- SET CONSTRAINTS
-- cs2102tut=*#   DELETE FROM book WHERE ISBN13 = '978-0321197849';
-- DELETE 1
-- cs2102tut=*#   DELETE FROM copy WHERE book = '978-0321197849';
-- DELETE 1
-- cs2102tut=*# END TRANSACTION;
-- COMMIT 


