-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: localhost    Database: HW3
-- ------------------------------------------------------
-- Server version	5.7.18

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Person`
--
DROP TABLE IF EXISTS `Person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Person` (
  `UNI` varchar(12) NOT NULL,
  `last_name` varchar(32) NOT NULL,
  `first_name` varchar(32) NOT NULL,
  `type` varchar(12) NOT NULL,
  PRIMARY KEY (`UNI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- insert and update trigger for table `Person`
--

DROP TRIGGER IF EXISTS `trigger_insert_person`;
DELIMITER $$
CREATE TRIGGER `trigger_insert_person`
   BEFORE INSERT ON `Person` FOR EACH ROW
BEGIN
	SET New.uni = generate_uni(New.last_name,New.first_name);
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS `trigger_update_person`;
DELIMITER $$
CREATE TRIGGER `trigger_update_person`
   BEFORE UPDATE ON `Person` FOR EACH ROW
BEGIN
	IF NOT NEW.uni = Old.uni THEN
		SIGNAL SQLSTATE '45001'
			SET MESSAGE_TEXT = 'Cannot change uni';
	end if;
END $$
DELIMITER ;

--
-- Dumping data for table `Person`
--

LOCK TABLES `Person` WRITE;
/*!40000 ALTER TABLE `Person` DISABLE KEYS */;
/*!40000 ALTER TABLE `Person` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `Student`
--
DROP TABLE IF EXISTS `Student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Student` (
   `UNI` varchar(12) NOT NULL,
   `school` varchar(12) NOT NULL,
   `year` int(12) NOT NULL,
   PRIMARY KEY (`UNI`),
   CONSTRAINT `student_uni_fk` FOREIGN KEY (`UNI`) REFERENCES `Person` (`UNI`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- insert and update trigger for table `Student`
--

DROP TRIGGER IF EXISTS `trigger_insert_student`;
DELIMITER $$
CREATE TRIGGER `trigger_insert_student`
   BEFORE INSERT ON `Student` FOR EACH ROW
BEGIN
	IF NOT EXISTS (select uni from `Person` where uni = New.uni) THEN
		SIGNAL SQLSTATE '45002'
			SET MESSAGE_TEXT = 'uni not found in person table';
	end if;
    
	IF New.year > 2020 or New.year < 2000 THEN
		SIGNAL SQLSTATE '45002'
			SET MESSAGE_TEXT = 'not a valid year';
	end if;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS `trigger_update_student`;
DELIMITER $$
CREATE TRIGGER `trigger_update_student`
   BEFORE UPDATE ON `Student` FOR EACH ROW
BEGIN
	IF NOT NEW.uni = Old.uni THEN
		SIGNAL SQLSTATE '45001'
			SET MESSAGE_TEXT = 'Cannot change uni';
	end if;
    
	IF New.year > 2020 or New.year < 2000 THEN
		SIGNAL SQLSTATE '45002'
			SET MESSAGE_TEXT = 'not a valid year';
	end if;
END $$
DELIMITER ;



--
-- Dumping data for table `Student`
--

LOCK TABLES `Student` WRITE;
/*!40000 ALTER TABLE `Student` DISABLE KEYS */;
/*!40000 ALTER TABLE `Student` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `Faculty`
--
DROP TABLE IF EXISTS `Faculty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Faculty` (
   `UNI` varchar(12) NOT NULL,
   `pay_grade` int(12) NOT NULL,
   `title` varchar(12) NOT NULL,
   `department` varchar(12) NOT NULL,
   PRIMARY KEY (`UNI`),
   CONSTRAINT `faculty_uni_fk` FOREIGN KEY (`UNI`) REFERENCES `Person` (`UNI`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;



--
-- insert and update trigger for table `Faculty`
--

DROP TRIGGER IF EXISTS `trigger_insert_faculty`;
DELIMITER $$
CREATE TRIGGER `trigger_insert_faculty`
   BEFORE INSERT ON `Faculty` FOR EACH ROW
BEGIN
	IF NOT EXISTS (select uni from `Person` where uni = New.uni) THEN
		SIGNAL SQLSTATE '45002'
			SET MESSAGE_TEXT = 'uni not found in person table';
	end if;
    
	IF New.pay_grade NOT IN (1,2,3,4,5) THEN
		SIGNAL SQLSTATE '45002'
			SET MESSAGE_TEXT = 'not a valid pay grade';
	end if;
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS `trigger_update_faculty`;
DELIMITER $$
CREATE TRIGGER `trigger_update_faculty`
   BEFORE UPDATE ON `Faculty` FOR EACH ROW
BEGIN
	IF NOT NEW.uni = Old.uni THEN
		SIGNAL SQLSTATE '45001'
			SET MESSAGE_TEXT = 'Cannot change uni';
	end if;
    
	IF New.pay_grade NOT IN (1,2,3,4,5) THEN
		SIGNAL SQLSTATE '45002'
			SET MESSAGE_TEXT = 'not a valid year';
	end if;
END $$
DELIMITER ;


--
-- Dumping data for table `Faculty`
--

LOCK TABLES `Faculty` WRITE;
/*!40000 ALTER TABLE `Faculty` DISABLE KEYS */;
/*!40000 ALTER TABLE `Faculty` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Student View
--

DROP VIEW IF EXISTS `student_view`;
CREATE VIEW Student_view AS
    SELECT 
        `Student`.`UNI` AS `UNI`,
        `Person`.`last_name` AS `LastName`,
        `Person`.`first_name` AS `FirstName`,
        `Student`.`school` AS `school`,
        `Student`.`year` AS `year`
    FROM
        `Student`
            JOIN
        `Person` ON (`Person`.`UNI` = `Student`.`UNI`);
        
        
--
-- Faculty View
--
  
DROP VIEW IF EXISTS `faculty_view`;
CREATE VIEW faculty_view AS
    SELECT 
        `Faculty`.`UNI` AS `UNI`,
        `Person`.`last_name` AS `LastName`,
        `Person`.`first_name` AS `FirstName`,
        `Faculty`.`pay_grade` AS `pay_grade`,
        `Faculty`.`title` AS `title`,
        `Faculty`.`department` AS `department`
    FROM
        `Faculty`
            JOIN
        `Person` ON (`Person`.`UNI` = `Faculty`.`UNI`);



--
-- Table structure for table `course_participant`
--

DROP TABLE IF EXISTS `course_participant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_participant` (
  `UNI` varchar(12) NOT NULL,
  `section_call_no` char(5) NOT NULL,
  PRIMARY KEY (`UNI`,`section_call_no`),
  KEY `cp_section_fk` (`section_call_no`),
  CONSTRAINT `cp_participant_fk` FOREIGN KEY (`UNI`) REFERENCES `Person` (`UNI`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `cp_section_fk` FOREIGN KEY (`section_call_no`) REFERENCES `sections` (`call_no`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_participant`
--

LOCK TABLES `course_participant` WRITE;
/*!40000 ALTER TABLE `course_participant` DISABLE KEYS */;
/*!40000 ALTER TABLE `course_participant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course_prereqs`
--

DROP TABLE IF EXISTS `course_prereqs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `course_prereqs` (
  `course_id` varchar(12) NOT NULL,
  `prereq_id` varchar(12) NOT NULL,
  PRIMARY KEY (`course_id`,`prereq_id`),
  KEY `prereq_prereq_fk` (`prereq_id`),
  CONSTRAINT `prereq_course_fk` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `prereq_prereq_fk` FOREIGN KEY (`prereq_id`) REFERENCES `courses` (`course_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course_prereqs`
--

LOCK TABLES `course_prereqs` WRITE;
/*!40000 ALTER TABLE `course_prereqs` DISABLE KEYS */;
INSERT INTO `course_prereqs` VALUES ('COMSW4111','COMSE1006'),('COMSW4111','COMSW3270');
/*!40000 ALTER TABLE `course_prereqs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `courses`
--

DROP TABLE IF EXISTS `courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `courses` (
  `dept_code` char(4) NOT NULL,
  `faculty_code` enum('BC','C','E','F','G','V','W','X') NOT NULL,
  `level` enum('0','1','2','3','4','6','8','9') NOT NULL,
  `number` char(3) NOT NULL,
  `title` varchar(32) NOT NULL,
  `description` varchar(128) NOT NULL,
  `course_id` varchar(12) GENERATED ALWAYS AS (concat(`dept_code`,`faculty_code`,`level`,`number`)) STORED,
  `full_number` char(4) GENERATED ALWAYS AS (concat(`level`,`number`)) VIRTUAL,
  PRIMARY KEY (`dept_code`,`faculty_code`,`level`,`number`),
  UNIQUE KEY `course_id` (`course_id`),
  FULLTEXT KEY `keywords` (`title`,`description`),
  CONSTRAINT `course2_dept_fk` FOREIGN KEY (`dept_code`) REFERENCES `department` (`code`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `courses`
--

LOCK TABLES `courses` WRITE;
/*!40000 ALTER TABLE `courses` DISABLE KEYS */;
INSERT INTO `courses` (`dept_code`, `faculty_code`, `level`, `number`, `title`, `description`) VALUES ('COMS','E','1','006','Intro. to Program for Eng.','Darth Don teaching in Spring.'),('COMS','W','3','270','Data Structures','Seems safe to take.'),('COMS','W','4','111','Intro. to Databases','Possibly the worst experience of your life.');
/*!40000 ALTER TABLE `courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `department` (
  `code` char(4) NOT NULL,
  `name` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`code`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES ('COMS','Computer Science'),('EENG','Electrical Engineering');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sections` (
  `call_no` char(5) NOT NULL,
  `course_id` varchar(12) NOT NULL,
  `section_no` varchar(45) NOT NULL,
  `year` int(11) NOT NULL,
  `semester` varchar(45) NOT NULL,
  `enrollment_limit` int(11) default 3,
  `section_key` varchar(45) GENERATED ALWAYS AS (concat(`year`,`semester`,`course_id`,`section_no`)) STORED,
  PRIMARY KEY (`call_no`),
  UNIQUE KEY `unique` (`course_id`,`section_no`,`year`,`semester`),
  CONSTRAINT `section_course_fk` FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sections`
--

LOCK TABLES `sections` WRITE;
/*!40000 ALTER TABLE `sections` DISABLE KEYS */;
INSERT INTO `sections` (`call_no`, `course_id`, `section_no`, `year`, `semester`) VALUES ('00001','COMSW4111','3',2017,'1');
/*!40000 ALTER TABLE `sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'HW3'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-10-23 18:14:26
