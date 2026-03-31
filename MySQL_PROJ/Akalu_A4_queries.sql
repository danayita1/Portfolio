
/* Answer Q1,  CREATE AND INSERT*/

/* PART 1
    Drops any existing copy tables and creates new ones based on the original tables.
*/
USE ischool;

DROP TABLE IF EXISTS people_copy;
DROP TABLE IF EXISTS addresses_copy;
DROP TABLE IF EXISTS locations_copy;
DROP TABLE IF EXISTS person_addresses_copy;

CREATE TABLE people_copy LIKE people;
CREATE TABLE addresses_copy LIKE addresses;
CREATE TABLE locations_copy LIKE locations;
CREATE TABLE person_addresses_copy LIKE person_addresses; 


INSERT INTO people_copy
SELECT*
FROM people;

INSERT INTO addresses_copy
SELECT*
FROM addresses;

INSERT INTO locations_copy
SELECT*
FROM locations;

INSERT INTO person_addresses_copy
SELECT*
FROM person_addresses;



/*  Part 2: Insert New Record
    Insert a new person (Sofia Vergara) into the people_copy table.
    */

INSERT INTO people_copy (fname, lname, email, college, department, title, start_date)
VALUES ('Sofia','Vergara','svergara@umd.edu' ,'Behavioral and Social Sciences' ,'PSYC','Actress' ,'1997-08-17');

/* 
    Part 3: Insert Address
    Insert a new address into the addresses_copy table.
*/

INSERT INTO addresses_copy (address_id, street, city, state, zipcode, country, main_phone)
VALUES (146, '555 Modern Family Terrance' , 'Los Angeles', 'CA' , '09076', 'United States', '503-555-1234');

/* 
    Part 4: Insert Location
    Insert a new location into the locations_copy table.
*/

INSERT INTO locations_copy (location_id, building_code, building_name, room_number)

VALUES (64, 'BYE' , 'Bill Nye Psychology Learning Center', '1155'); 

/* 
    Part 5
*/

INSERT INTO person_addresses_copy (Person_id, address_id)
VALUES (132466128, 146);

/* 
    Part 6: Count Rows
    Count the number of rows in each copy table for verification.
*/

SELECT COUNT(*) AS Total_rows FROM people_copy; 
SELECT COUNT(*) AS Total_rows FROM addresses_copy;
SELECT COUNT(*) AS Total_rows FROM locations_copy;
SELECT COUNT(*) AS Total_rows FROM person_addresses_copy;


/* Answer 2, UPDATE */ 

SET SQL_SAFE_UPDATES = 0;

/* Part 1: Update Sofia's address information in the addresses_copy table. */

UPDATE addresses_copy
SET street = '222 Warbler Avenue', 
    city = 'Bandung',
    country = 'Indonesia',
    main_phone = '510-555-1219',
    local_phone = '867-555-8428'
WHERE address_id = 146;  

UPDATE person_addresses_copy
SET address_id = 9
WHERE person_id = '132466128';  


/* Part 2: Retrieve Updated Data */

SELECT 
    pa.person_id, 
    a.address_id, 
    CONCAT(p.fname, ' ', p.lname) AS full_name,
    a.street, 
    CONCAT(a.city, ', ', a.country) AS location_name, 
    p.email, 
    a.main_phone, 
    a.local_phone
FROM addresses_copy a
JOIN person_addresses_copy pa ON a.address_id = pa.address_id
JOIN people_copy p ON pa.person_id = p.person_id
WHERE 
    (a.main_phone LIKE '5%' OR a.main_phone LIKE '6%')  
    AND a.address_id <= 41 
    AND pa.person_id != '132466020'
ORDER BY 
    
    a.country,
	full_name = 'Sofia Vergara' DESC,  
    full_name = 'Dustin Nguyen' DESC; 



/* Answer Q3, DELETE*/

/* Part 1: Delete Sofia's information from the tables.

*/

DELETE FROM person_addresses_copy
WHERE person_id = '132466128'; 

DELETE FROM people_copy
WHERE person_id = '132466128'; 

SET SQL_SAFE_UPDATES = 1;

/* Part 2: Retrieve and display records after deletions. */

SELECT 
    pa.person_id, 
    ac.address_id, 
    CONCAT(p.fname, ' ', p.lname) AS full_name,
    ac.street, 
    CONCAT(ac.city, ', ', ac.country) AS location_name, 
    p.email, 
    ac.main_phone, 
    ac.local_phone
FROM addresses_copy ac
JOIN person_addresses_copy pa ON ac.address_id = pa.address_id
JOIN people_copy p ON pa.person_id = p.person_id
WHERE 
    (ac.main_phone LIKE '5%' OR ac.main_phone LIKE '6%')
    AND ac.address_id <= 41 
    AND pa.person_id != '132466020'
ORDER BY 
    ac.country;


