
DROP TABLE IF EXISTS `base_table`;

CREATE TABLE `base_table` (
  `word` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into base_table (word) values ('whale');
insert into base_table (word) values ('mouse');
insert into base_table (word) values ('fence');

select * from base_table;

DROP TABLE IF EXISTS `powerset`;

CREATE TABLE `powerset` (
  `word1` varchar(32),
  `word2` varchar(32),
  `word3` varchar(32)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `temp_table`;

CREATE TABLE temp_table
  AS select word1, word2, word3 from ((
	select A.word as word1, B.word as word2, C.word as word3
	from base_table as A ,base_table as B, base_table as C
    where A.word != B.word and A.word != C.word and B.word != C.word) as t)
    order by rand() limit 1;

select * from temp_table;

INSERT INTO powerset (word1,word2,word3) VALUES (NULL,NULL,NULL);

INSERT INTO powerset (word1,word2,word3)
	select A.word as word1, null as word2, null as word3
	from base_table as A left join base_table as B on A.word = B.word;
    
INSERT INTO powerset (word1,word2,word3)
	select word1,word2,null word3 from temp_table;
    
INSERT INTO powerset (word1,word2,word3)
	select word1,word3 as word2,null as word3 from temp_table;
    
INSERT INTO powerset (word1,word2,word3)
	select word2 as word1,word3 as word2,null as word3 from temp_table;
    
INSERT INTO powerset (word1,word2,word3)
	select word1,word2,word3 from temp_table;

select * from powerset;


/*
SELECT
word
FROM base_table a
UNION ALL
(
SELECT
a.word + ','+ b.word 
FROM base_table a
CROSS JOIN base_table b
)
UNION ALL
(
SELECT
a.word + ',' + b.word + ','+ c.word
FROM base_table a
CROSS JOIN base_table b
CROSS JOIN base_table c
);
*/
select null, null, null
union 
select a.word, null, null from base_table a
union

(
SELECT
a.word , b.word, null
FROM base_table a
CROSS JOIN base_table b where a.word > b.word
)
union
(
select a.word, b.word, c.word
from base_table a 
cross join base_table b 
cross join base_table c where a.word > b.word and b.word > c.word
)
