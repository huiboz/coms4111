SET SQL_SAFE_UPDATES = 0;

DROP FUNCTION IF EXISTS `generate_uni`;
DELIMITER $$
CREATE FUNCTION `generate_uni` (last_name VARCHAR(32),first_name VARCHAR(32))
RETURNS VARCHAR(16) CHARSET utf8
BEGIN
	DECLARE		c1				CHAR(2);
    DECLARE		c2				CHAR(2);
    DECLARE		prefix			CHAR(5);
    DECLARE		uniCount		INT;
    DECLARE		newUni		VARCHAR(16);
    
    SET c1 		=		UPPER(SUBSTR(last_name, 1, 2));
    SET c2		=		UPPER(SUBSTR(first_name, 1, 2));
    SET prefix	=		CONCAT(c1, c2, "%");
    
    SET uniCount = 0;
    
	SET uniCount=(SELECT COUNT(uni) FROM person WHERE uni LIKE prefix);

	SET newUni = CONCAT(c1, c2,uniCount+1);
RETURN  newUni;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS `insert_student`;
DELIMITER $$
CREATE PROCEDURE `insert_student` (last_name VARCHAR(32),first_name VARCHAR(32),
school VARCHAR(12),`year` VARCHAR(12))

BEGIN
	DECLARE Newuni  VARCHAR(16);
    SET Newuni = generate_uni(last_name,first_name);
    
    INSERT INTO Person (uni,last_name,first_name,type)
		VALUES (Newuni,last_name,first_name,"Student");
        
	INSERT INTO Student (uni,school,`year`)
		VALUES (Newuni,school,`year`);
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS `update_student`;
DELIMITER $$
CREATE PROCEDURE `update_student` (uni VARCHAR(16),last_name VARCHAR(32),first_name VARCHAR(32),
school VARCHAR(12),`year` VARCHAR(12))

BEGIN

	if not exists (select * from person where person.uni = uni)
    then
		SIGNAL SQLSTATE '04001'
			SET MESSAGE_TEXT = `student uni not exists, update fail`;
    end if;

	UPDATE PERSON
    SET last_name = last_name, first_name = first_name
    where PERSON.uni = uni;
    
	UPDATE Student
    SET school = school, `year` = `year`
    where Student.uni = uni;
    
    
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS `delete_student`;
DELIMITER $$
CREATE PROCEDURE `delete_student` (uni VARCHAR(16))

BEGIN

	if not exists (select * from person where person.uni = uni)
    then
		SIGNAL SQLSTATE '04001'
			SET MESSAGE_TEXT = `student uni not exists, delete fail`;
    end if;
    
	DELETE FROM Student
    where Student.uni = uni;

	DELETE FROM PERSON
    where PERSON.uni = uni;
    
    
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS `insert_faculty`;
DELIMITER $$
CREATE PROCEDURE `insert_faculty` (last_name VARCHAR(32),first_name VARCHAR(32),
pay_grade VARCHAR(12),title VARCHAR(12), department VARCHAR(12))

BEGIN
	DECLARE Newuni  VARCHAR(16);
    SET Newuni = generate_uni(last_name,first_name);
    
    INSERT INTO Person (uni,last_name,first_name,type)
		VALUES (Newuni,last_name,first_name,"Faculty");
        
	INSERT INTO Faculty (uni,pay_grade,title,department)
		VALUES (Newuni,pay_grade,title,department);
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS `update_faculty`;
DELIMITER $$
CREATE PROCEDURE `update_faculty` (uni VARCHAR(16),last_name VARCHAR(32),first_name VARCHAR(32),
pay_grade VARCHAR(12),title VARCHAR(12), department VARCHAR(12))

BEGIN

	if not exists (select * from person where person.uni = uni)
    then
		SIGNAL SQLSTATE '04001'
			SET MESSAGE_TEXT = `faculty uni not exists, update fail`;
    end if;

	UPDATE PERSON
    SET last_name = last_name, first_name = first_name
    where PERSON.uni = uni;
    
	UPDATE Faculty
    SET pay_grade = pay_grade, title = title, department = department
    where Faculty.uni = uni;
    
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS `delete_faculty`;
DELIMITER $$
CREATE PROCEDURE `delete_faculty` (uni VARCHAR(16))

BEGIN

	if not exists (select * from person where person.uni = uni)
    then
		SIGNAL SQLSTATE '04001'
			SET MESSAGE_TEXT = `faculty uni not exists, delete fail`;
    end if;
    
	DELETE FROM Faculty
    where Faculty.uni = uni;

	DELETE FROM PERSON
    where PERSON.uni = uni;
    
    
END $$
DELIMITER ;






