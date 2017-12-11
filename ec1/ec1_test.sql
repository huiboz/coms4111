SET SQL_SAFE_UPDATES = 0;
### test 1 ####################################################

/*
INSERT INTO employee (first_name,last_name,email)
	VALUES ('Candie','MacPake','cmacpake6@spiegel.de');
   
INSERT INTO employee (first_name,last_name,email)
	VALUES ('Carling','Bockman','cbockman5@cam.ac.uk');
    
INSERT INTO employee (first_name,last_name,email)
	VALUES ('Chrissy','Weatherup','cweatherup2@theguardian.com');

INSERT INTO employee (first_name,last_name,email)
	VALUES ('Cloris','Edards','cedards4@springer.com');
    
INSERT INTO employee (first_name,last_name,email)
	VALUES ('Diannne','Aickin','daickin9@domainmarket.com');
    
INSERT INTO employee (first_name,last_name,email)
	VALUES ('Dougy','Snoxill','dsnoxill1@scribd.com');
   
INSERT INTO employee (first_name,last_name,email)
	VALUES ('Dulciana','Cambell','dcambell8@i2i.jp');
    
INSERT INTO employee (first_name,last_name,email)
	VALUES ('Jared','Melarkey','jmelarkey3@google.co.jp');

INSERT INTO employee (first_name,last_name,email)
	VALUES ('Joice','Tomsen','jtomsen7@slideshare.net');
    
INSERT INTO employee (first_name,last_name,email)
	VALUES ('Juana','Gatesman','jgatesman0@chron.com');
*/
#####################################################################

### test 2 ####################################################
/*
UPDATE employee  SET first_name = 'Douglas', `created` = CURRENT_TIMESTAMP 
	where employee.first_name = 'Dougy' and employee.last_name = 'Snoxill';
*/
#####################################################################

### test 3 ####################################################
/*
INSERT INTO employee (first_name,last_name,email)
	VALUES ('Jared','Melarkey','jmelarkey3@google.co.jp');
*/
#####################################################################

### test 4 ####################################################
# UPDATE employee SET user_id = 'foo' where employee.email = 'dsnoxill1@scribd.com';
#####################################################################


### test 5 ####################################################
/*
INSERT INTO employee (first_name,last_name,email)
	VALUES ('John','Smith','js1@statcounter.com');
    
INSERT INTO employee (first_name,last_name,email)
	VALUES ('John','Smith','js2@statcounter.com');
    
INSERT INTO employee (first_name,last_name,email)
	VALUES ('John','Smith','js3@statcounter.com');
    
INSERT INTO employee (first_name,last_name,email)
	VALUES ('John','Smith','js4@statcounter.com');
    
INSERT INTO employee (first_name,last_name,email)
	VALUES ('John','Smith','js5@statcounter.com');
*/

/*
DELETE FROM employee WHERE `email`='js2@statcounter.com';
DELETE FROM employee WHERE `email`='js4@statcounter.com';
*/

/*
INSERT INTO employee (first_name,last_name,email)
	VALUES ('John','Smith','js@myemail.com');


select * from employee where last_name = 'Smith';
*/
#####################################################################

select * from employee;
select * from user_prefix_count;

#CREATE TABLE temp_test AS
#    SELECT prefix from user_prefix_count where max_value = 6;

select * from temp_test;
