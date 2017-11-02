# Given a month, return what semester that month corresponds to
DROP FUNCTION IF EXISTS `convert_semester`;
DELIMITER $$
CREATE FUNCTION `convert_semester` (`month` int(16))
RETURNS int(16)
BEGIN
    DECLARE    semester INT;
    
    if `month` in (9,10,11,12) then
		SET semester = 1;
    end if;
    
	if `month` in (1,2,3,4) then
		SET semester = 2;
    end if;
    
	if `month` in (5,6) then
		SET semester = 3;
    end if;
    
	if `month` in (7,8) then
		SET semester = 4;
    end if;
    
RETURN  semester;
END $$
DELIMITER ;

# a view that contains what courses students have taken in what time
DROP VIEW IF EXISTS `completed_course`;
CREATE VIEW completed_course AS
    SELECT 
        `course_participant`.`uni` AS `uni`,
        `sections`.`course_id` AS `courseid`,
        `sections`.`year` AS `year`,
        `sections`.`semester` AS `semester`
    FROM
        `course_participant`
            JOIN
        `sections` ON (`course_participant`.`section_call_no` = `sections`.`call_no`)
	where
		EXTRACT(YEAR FROM date(now())) > `sections`.`year`
        OR 
        (EXTRACT(YEAR FROM date(now())) = `sections`.`year` AND 
        convert_semester(EXTRACT(MONTH FROM date(now()))) > `sections`.`semester`);

# a view that contains what courses faculties have taught
DROP VIEW IF EXISTS `faculty_course`;
CREATE VIEW faculty_course AS
    SELECT 
        `course_participant`.`uni` AS `uni`,
        `sections`.`course_id` AS `courseid`,
        `sections`.`year` AS `year`,
        `sections`.`semester` AS `semester`
    FROM
        `course_participant`
            JOIN
        `sections` ON (`course_participant`.`section_call_no` = `sections`.`call_no`)
	where
		`course_participant`.`uni` in (select `uni` from `faculty_view`);
        
        
# Given a student uni and section call number, it checks
# if this student satisfies the prereq for that course
DROP FUNCTION IF EXISTS `prereq_valid`;
DELIMITER $$
CREATE FUNCTION `prereq_valid` (this_uni VARCHAR(12),call_no VARCHAR(5))
RETURNS tinyint(1) 
BEGIN

    DECLARE     valid          int(1);
    
    SET valid = (select exists 
		(select a.prereq_id from
			((select prereq_id from `course_prereqs` where `course_prereqs`.`course_id` = 
            (select course_id from `sections` where `sections`.`call_no` = call_no)) as a)
		where a.prereq_id not in
		(select `courseid` from `completed_course` where `completed_course`.`uni` = `this_uni`)));
             
	IF valid = 1 THEN
		RETURN FALSE;
	ELSE 
		RETURN TRUE;
	END IF;
END $$
DELIMITER ;

# Given a section call number, check if that section still has spots
DROP FUNCTION IF EXISTS `student_limit`;
DELIMITER $$
CREATE FUNCTION `student_limit` (this_call_no VARCHAR(5))
RETURNS tinyint(1) 
BEGIN

    DECLARE     currentsize          int(10);
    DECLARE     sizelimit                int(10);
    
    SET sizelimit = (select enrollment_limit from `sections` where call_no = this_call_no);
    
    SET currentsize = (select count(*) from `course_participant` 
	where `section_call_no` = `this_call_no` and `course_participant`.`uni` in (select uni from student_view));
             
	IF currentsize < sizelimit THEN
		RETURN TRUE;
	ELSE 
		RETURN FALSE;
	END IF;
END $$
DELIMITER ;

# given a faculty uni and section call number, check if that faculty
# can still teach for the semester of that section
DROP FUNCTION IF EXISTS `faculty_limit`;
DELIMITER $$
CREATE FUNCTION `faculty_limit` (this_uni VARCHAR(11),this_call_no VARCHAR(5))
RETURNS tinyint(1) 
BEGIN

    DECLARE     this_year          int(11);
    DECLARE     this_semester      varchar(45);
    DECLARE     total_count        int(11);
    
	SET this_year = (select `year` from `sections` where call_no = this_call_no);
    SET this_semester = (select `semester` from `sections` where call_no = this_call_no);
    
    SET total_count = (select count(*) from `course_participant`
		where (`uni` = this_uni)
        and 
        ((select `year` from `sections` where `sections`.`call_no` = `course_participant`.section_call_no) = this_year)
        and
        ((select `semester` from `sections` where `sections`.`call_no` = `course_participant`.section_call_no) = this_semester));
    
             
	IF total_count < 3 THEN
		RETURN TRUE;
	ELSE 
		RETURN FALSE;
	END IF;
END $$
DELIMITER ;

# trigger before insert into `course_participant`
# Different constraints apply according to the uni (faculty or student)
DROP TRIGGER IF EXISTS `trigger_insert_participant`;
DELIMITER $$
CREATE TRIGGER `trigger_insert_participant`
   BEFORE INSERT ON `course_participant` FOR EACH ROW
BEGIN
    DECLARE uni_type  varchar(12);
   
	IF NOT EXISTS (select uni from `Person` where `Person`.uni = New.uni) Then
		SIGNAL SQLSTATE '45002'
			SET MESSAGE_TEXT = 'uni not found in person table';
	END IF;
    
    SET uni_type = (select `type` from `Person` where `Person`.uni = New.uni);
    
    IF NOT (uni_type = "Student" or uni_type = "Faculty") THEN
		SIGNAL SQLSTATE '45003'
			SET MESSAGE_TEXT = 'not valid type';
	END IF;		
    
    IF uni_type = "Student" then
		IF NOT prereq_valid(New.uni,New.section_call_no) THEN
        		SIGNAL SQLSTATE '45004'
					SET MESSAGE_TEXT = 'prereq course not satisfied';
		END IF;	
		IF NOT student_limit(New.section_call_no) THEN
        		SIGNAL SQLSTATE '45005'
					SET MESSAGE_TEXT = 'exceed section limit size';
		END IF;	
	END IF;
    
	IF uni_type = "Faculty" then
		IF NOT faculty_limit(New.uni,New.section_call_no) THEN
        		SIGNAL SQLSTATE '45004'
					SET MESSAGE_TEXT = 'faculty can not teach more than 3 sections';
		END IF;	
	END IF;

END $$
DELIMITER ;

 #(select `type` from `Person` where `Person`.uni = "BUST1");

#select * from completed_course;  

#INSERT INTO `course_participant` VALUES ('BUST1','00006');
#select faculty_limit('lafe1','00002') as test, courseid,`year`,semester from completed_course where semester = 4;      

#(select `courseid` from `completed_course` where `completed_course`.`uni` = 'BUST1');
#INSERT INTO `course_participant` VALUES ('BUST1','00006');
#INSERT INTO `course_participant` VALUES ('BUST1','00001');


#INSERT INTO `course_participant` VALUES ('dajo1','00003');     
#INSERT INTO `course_participant` VALUES ('rogo1','00003');   
#INSERT INTO `course_participant` VALUES ('edfe1','00003'); 
#INSERT INTO `course_participant` VALUES ('kelu1','00003');   

#INSERT INTO `course_participant` VALUES ('lafe1','00001'); 
#INSERT INTO `course_participant` VALUES ('lafe1','00003'); 
#INSERT INTO `course_participant` VALUES ('lafe1','00005'); 
#INSERT INTO `course_participant` VALUES ('lafe1','00009'); 
select * from `faculty_course`;
