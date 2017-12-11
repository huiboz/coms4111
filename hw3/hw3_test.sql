/*
call insert_student("peters", "justin", "cs", 2016);
call insert_student("welch", "Alexander", "ee", 2017);
call insert_student("ross", "gordon", "cs", 2017);
call insert_student("howard", "piers", "math", 2015);
call insert_student("edmunds", "felicity", "cs", 2017);
call insert_student("kelly", "lucas", "cs", 2017);
call insert_student("butler", "steven", "cs", 2017);
call insert_student("murray", "dylan", "ee", 2016);
call insert_student("johnston", "mike", "cs", 2017);
call insert_student("davidson", "josh", "cs", 2017);


call insert_faculty("Lewis","Deirdre","1","professor","cs");
call insert_faculty("Langdon","Felicity","1","professor","ee");
call insert_faculty("Lee","Benjamin","2","professor","cs");
call insert_faculty("Young","Gabrielle","1","instructor","math");
call insert_faculty("Quinn","Theresa","5","professor","cs");



INSERT INTO `courses` 
(`dept_code`, `faculty_code`, `level`, `number`, `title`, `description`) 
VALUES ('COMS','W','4','112','Advanced Database','learn more database!');

INSERT INTO `courses` 
(`dept_code`, `faculty_code`, `level`, `number`, `title`, `description`) 
VALUES ('COMS','W','3','271','Advanced Data Structures','learn more data structures');


INSERT INTO `sections` 
(`call_no`, `course_id`, `section_no`, `year`, `semester`,`enrollment_limit`) 
VALUES ('00002','COMSW4111','1',2016,'4','5');

INSERT INTO `sections` 
(`call_no`, `course_id`, `section_no`, `year`, `semester`) 
VALUES ('00003','COMSE1006','1',2017,'1');

INSERT INTO `sections` 
(`call_no`, `course_id`, `section_no`, `year`, `semester`,`enrollment_limit`) 
VALUES ('00004','COMSE1006','2',2016,'2','10');

INSERT INTO `sections` 
(`call_no`, `course_id`, `section_no`, `year`, `semester`) 
VALUES ('00005','COMSW3270','1',2017,'1');

INSERT INTO `sections` 
(`call_no`, `course_id`, `section_no`, `year`, `semester`) 
VALUES ('00006','COMSW3270','2',2016,'3');

INSERT INTO `sections` 
(`call_no`, `course_id`, `section_no`, `year`, `semester`) 
VALUES ('00007','COMSW3271','1',2017,'1');

INSERT INTO `sections` 
(`call_no`, `course_id`, `section_no`, `year`, `semester`) 
VALUES ('00008','COMSW3271','2',2016,'2');

INSERT INTO `sections` 
(`call_no`, `course_id`, `section_no`, `year`, `semester`) 
VALUES ('00009','COMSW4112','1',2017,'1');

INSERT INTO `sections` 
(`call_no`, `course_id`, `section_no`, `year`, `semester`) 
VALUES ('00010','COMSW4112','2',2016,'1');



INSERT INTO `course_prereqs` VALUES ('COMSW3271','COMSW3270');
INSERT INTO `course_prereqs` VALUES ('COMSW4112','COMSW4111');
*/

#INSERT INTO `course_participant` VALUES ('BUST1','00001');
#INSERT INTO `course_participant` VALUES ('BUST1','00002');
#INSERT INTO `course_participant` VALUES ('DAJO1','00003');
#INSERT INTO `course_participant` VALUES ('DAJO1','00004');


#INSERT INTO Person (uni, last_name, first_name, type) VALUES ('s','zhao','huibo',"ss");
#INSERT INTO Person VALUES ("1222",'a',"b","ss");
#call insert_student("zhao", "huibo", "cs", 2016);
#insert into student values("AB2","cs","2022");
#update student set school = "cs", year = 2022 where uni = "AB1";
#insert into faculty values("AB1",4,"cs","a");

SELECT 
    *
FROM
    person;
#select * from student;
#select * from faculty;


#select now(),date(now()),EXTRACT(YEAR FROM date(now())),EXTRACT(MONTH FROM date(now())),uni from faculty_view;
select * from student_view;
select * from faculty_view;
select * from courses;
select * from sections;
select * from course_prereqs;

select * from course_participant;

