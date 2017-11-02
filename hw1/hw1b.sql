#use 4111_hw1;
SELECT 
    ContactName, City
FROM
    customer
WHERE
    City = 'London';
    
SELECT 
    City, COUNT(*)
FROM
    customer
GROUP BY City
Order by Count(*) DESC;

SELECT 
    contactname,
    SUBSTR(contactname,
        LOCATE(' ', contactname)) AS lastname,
    SUBSTR(contactname,
        1,
        LOCATE(' ', contactname)) AS firstname
FROM
    customer
ORDER BY lastname , firstname;



CREATE TABLE IF NOT EXISTS Test (
	ID1 int(10) NOT NULL,
    ID2 int(10) NOT NULL,
    PRIMARY KEY (ID1,ID2)
);

select * from Test;