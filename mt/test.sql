SELECT DISTINCT p.pname, p.cname
FROM PlaysAs p WHERE p.pname IS NOT NULL 
AND p.cname NOT LIKE '% %';

