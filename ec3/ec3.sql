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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;



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
		SET New.account_id = "SV-5";
	ELSE
		SET New.account_id = CONCAT("SV-",(select max(id_count) from `ec3_savings`)+1);
	end if;
    
END $$
DELIMITER ;


INSERT INTO `ec3_checking` (balance,overdraft_limit) VALUES (300,500);
INSERT INTO `ec3_checking` (balance,overdraft_limit) VALUES (300,500);
INSERT INTO `ec3_savings` (balance,minimum_balance) VALUES (300,500);
INSERT INTO `ec3_savings` (balance,minimum_balance) VALUES (300,500);
        
select * from `ec3_checking`;
select * from `ec3_savings`;

