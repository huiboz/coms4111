DROP TABLE IF EXISTS `ec3_checking`;
CREATE TABLE `ec3_checking` (
`id_count` int(11) NOT NULL AUTO_INCREMENT,
`account_id` varchar(12) DEFAULT NULL,
`balance` float NOT NULL,
`overdraft_limit` float NOT NULL,
PRIMARY KEY (`id_count`),
UNIQUE KEY `id_count_UNIQUE` (`id_count`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `ec3_savings`;
CREATE TABLE `ec3_savings` (
`id_count` int(11) NOT NULL AUTO_INCREMENT,
`account_id` varchar(12) DEFAULT NULL,
`balance` float NOT NULL,
`minimum_balance` float NOT NULL,
PRIMARY KEY (`id_count`),
UNIQUE KEY `id_count_UNIQUE` (`id_count`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `ec3_log`;
CREATE TABLE `ec3_log` (
`sequence_number` int(11) NOT NULL AUTO_INCREMENT,
`source_id` varchar(12) DEFAULT NULL,
`target_id` varchar(12) DEFAULT NULL,
`amount` float DEFAULT NULL,
`result_code` int DEFAULT NULL,
`transfer_time` timestamp,
PRIMARY KEY (`sequence_number`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;


DROP TRIGGER IF EXISTS `trigger_insert_checking`;
DELIMITER $$
CREATE TRIGGER `trigger_insert_checking`
   BEFORE INSERT ON `ec3_checking` FOR EACH ROW
BEGIN

	IF NOT EXISTS (select * from `ec3_checking`) THEN
		SET New.account_id = "CH-14";
	ELSE
		SET New.account_id = CONCAT("CH-",(select max(id_count) from `ec3_checking`)+1);
	end if;
    
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS `trigger_insert_saving`;
DELIMITER $$
CREATE TRIGGER `trigger_insert_saving`
   BEFORE INSERT ON `ec3_savings` FOR EACH ROW
BEGIN

	IF NOT EXISTS (select * from `ec3_savings`) THEN
		SET New.account_id = "SV-1";
	ELSE
		SET New.account_id = CONCAT("SV-",(select max(id_count) from `ec3_savings`)+1);
	end if;
    
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS `transfer_commit`;
DELIMITER $$
CREATE PROCEDURE `transfer_commit` (source_id VARCHAR(12),target_id VARCHAR(12),
amount float,OUT rc int)

BEGIN
	DECLARE temp_balance  float;
	IF source_id LIKE "CH-%" THEN
		IF ((select balance from `ec3_checking` where `account_id` = source_id) - amount) > 
            (-1.0 * (select overdraft_limit from `ec3_checking` where `account_id` = source_id)) THEN
            
            # Debit the balance in the source account
            SET temp_balance = (select balance from `ec3_checking` where `account_id` = source_id);
			update `ec3_checking` set balance = temp_balance - amount where account_id = source_id;
            
			# Increase the balance in the target account
            IF target_id LIKE "CH-%" THEN
				SET temp_balance = (select balance from `ec3_checking` where `account_id` = target_id);
				update `ec3_checking` set balance = temp_balance + amount where account_id = target_id;
            END IF;
            
			IF target_id LIKE "SV-%" THEN
				SET temp_balance = (select balance from `ec3_savings` where `account_id` = target_id);
				update `ec3_savings` set balance = temp_balance + amount where account_id = target_id;
            END IF;
            
            # Write a log record containing the source account id, 
            # target account id, amount and an rc=1 to the log table
            INSERT INTO `ec3_log` (`source_id`, `target_id`, `amount`, `result_code`) 
				VALUES (source_id,target_id,amount,1);
                
			SET rc = 1;
		ELSE
            INSERT INTO `ec3_log` (`source_id`, `target_id`, `amount`, `result_code`) 
				VALUES (source_id,target_id,amount,-1);
                
			SET rc = -1;
		END IF;
	ELSEIF source_id LIKE "SV-%" THEN
		IF ((select balance from `ec3_savings` where `account_id` = source_id) - amount) > 
            (1.0 * (select minimum_balance from `ec3_savings` where `account_id` = source_id)) THEN
            
            # Debit the balance in the source account
            SET temp_balance = (select balance from `ec3_savings` where `account_id` = source_id);
			update `ec3_savings` set balance = temp_balance - amount where account_id = source_id;
            
			# Increase the balance in the target account
            IF target_id LIKE "CH-%" THEN
				SET temp_balance = (select balance from `ec3_checking` where `account_id` = target_id);
				update `ec3_checking` set balance = temp_balance + amount where account_id = target_id;
            END IF;
            
			IF target_id LIKE "SV-%" THEN
				SET temp_balance = (select balance from `ec3_savings` where `account_id` = target_id);
				update `ec3_savings` set balance = temp_balance + amount where account_id = target_id;
            END IF;
            
            # Write a log record containing the source account id, 
            # target account id, amount and an rc=1 to the log table
            INSERT INTO `ec3_log` (`source_id`, `target_id`, `amount`, `result_code`) 
				VALUES (source_id,target_id,amount,1);
                
			SET rc = 1;
		ELSE
            INSERT INTO `ec3_log` (`source_id`, `target_id`, `amount`, `result_code`) 
				VALUES (source_id,target_id,amount,-1);
                
			SET rc = -1;
		END IF;

	END IF;
END $$
DELIMITER ;



# load initial data
INSERT INTO `ec3_checking` (balance,overdraft_limit) VALUES (0,0);
INSERT INTO `ec3_checking` (balance,overdraft_limit) VALUES (100,50);
INSERT INTO `ec3_checking` (balance,overdraft_limit) VALUES (200,50);
INSERT INTO `ec3_checking` (balance,overdraft_limit) VALUES (300,100);
INSERT INTO `ec3_checking` (balance,overdraft_limit) VALUES (400,0);
DELETE FROM `ec3_checking` where id_count = 14;
INSERT INTO `ec3_savings` (balance,minimum_balance) VALUES (760,50);
INSERT INTO `ec3_savings` (balance,minimum_balance) VALUES (200,200);
INSERT INTO `ec3_savings` (balance,minimum_balance) VALUES (150,0);
INSERT INTO `ec3_savings` (balance,minimum_balance) VALUES (900,70);


# test 1
INSERT INTO `ec3_checking` (balance,overdraft_limit) VALUES (750,100);

# test 2
INSERT INTO `ec3_savings` (balance, minimum_balance) values(500, 250);

# test 3
call transfer_commit("CH-15", "SV-1",100,@rc);
select @rc;




/*
INSERT INTO `ec3_savings` (balance,minimum_balance) VALUES (300,500);
INSERT INTO `ec3_savings` (balance,minimum_balance) VALUES (300,500);
INSERT INTO `ec3_log` (sequence_number) VALUES (3);
INSERT INTO `ec3_log` (sequence_number) VALUES (9);
*/


#call transfer_commit("V-15", "SV-1",100,@rc);
#select @rc;


select * from `ec3_checking`;
select * from `ec3_savings`;
select * from `ec3_log`;

