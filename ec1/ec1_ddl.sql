--
-- Table structure for table `Employee`
--
DROP TABLE IF EXISTS `Employee`;

CREATE TABLE `Employee` (
  `user_id` varchar(32) NOT NULL,
  `first_name` varchar(32) NOT NULL,
  `last_name` varchar(32) NOT NULL,
  `email` varchar(32) NOT NULL,
  `created` datetime,
  PRIMARY KEY (`user_id`),
  UNIQUE (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



--
-- Table structure for table `user_prefix_count`
--
DROP TABLE IF EXISTS `user_prefix_count`;

CREATE TABLE `user_prefix_count` (
  `prefix` varchar(32) NOT NULL,
  `max_value` int(12) NOT NULL,
  PRIMARY KEY (`prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


# trigger before insert into `employee`
DROP TRIGGER IF EXISTS `trigger_insert_employee`;
DELIMITER $$
CREATE TRIGGER `trigger_insert_employee`
   BEFORE INSERT ON `employee` FOR EACH ROW
BEGIN
	DECLARE		`prefix_name`				VARCHAR(32);
    DECLARE     `existed`                   int(1);
    DECLARE     `count`                     int(12);
   
    SET `prefix_name`	=	CONCAT(New.`first_name`, '.', New.`last_name`);
    
    # check if `prefix_name` existed or not
    SET `existed` = (select exists (select * from `user_prefix_count` where `prefix` = `prefix_name`));
    
    # if existed, we increment its max_value field
    # if not existed, we insert a new tuple to the `user_prefix_count` table
	IF `existed` = 1 THEN
		SET `count` = (select `max_value` from `user_prefix_count` where `prefix` = `prefix_name`) + 1;
        UPDATE `user_prefix_count` SET `max_value` = `count` where `user_prefix_count`.`prefix` = `prefix_name`;
	ELSE 
		SET `count` = 1;
		INSERT INTO `user_prefix_count` (prefix,max_value) VALUES (`prefix_name`,1);
	END IF;
    
    SET New.`user_id`	=	CONCAT(New.`first_name`, '.', New.`last_name`,'.',`count`);

	SET New.`created` = CURRENT_TIMESTAMP;
END $$
DELIMITER ;

# trigger before update on 'employee'
DROP TRIGGER IF EXISTS `trigger_update_employee`;
DELIMITER $$
CREATE TRIGGER `trigger_update_employee`
   BEFORE UPDATE ON `employee` FOR EACH ROW
BEGIN

	SET NEW.`created` = Old.`created`;

	IF NOT NEW.`user_id` = Old.`user_id` THEN
		SIGNAL SQLSTATE '45001'
			SET MESSAGE_TEXT = 'Cannot change user_id';
	end if;
    
END $$
DELIMITER ;