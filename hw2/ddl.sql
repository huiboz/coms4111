#drop table faculty;

CREATE TABLE IF NOT EXISTS Faculty (
	FacultyID int(11) NOT NULL,
    LastName  varchar(20) NOT NULL,
    FirstName varchar(20) NOT NULL,
    Department varchar(20) DEFAULT NULL,
    PRIMARY KEY (FacultyID)
);


select * from faculty;


#drop table Student;

CREATE TABLE IF NOT EXISTS Student (
	StudentID varchar(6) NOT NULL,
    LastName  varchar(20) NOT NULL,
    FirstName varchar(20) NOT NULL,
    Major varchar(20) DEFAULT NULL,
    PRIMARY KEY (StudentID)
);



select * from Student;


#drop table Course;

CREATE TABLE IF NOT EXISTS Course (
	CourseID int(11) NOT NULL,
    Department  varchar(20) NOT NULL,
    CourseNumber varchar(20) NOT NULL,
    AcademicYear int(4) NOT NULL,
    Semester varchar(6) NOT NULL,
    PRIMARY KEY (CourseID)
);


select * from Course;



#drop table Section;

CREATE TABLE IF NOT EXISTS Section (
	CallerID int(11) NOT NULL,
    CourseID  int(11) NOT NULL,
    FacultyID int(11),
    SectionNumber int(3) NOT NULL,
    PRIMARY KEY (CallerID),
    CONSTRAINT FK_Section_CourseID FOREIGN KEY (CourseID)
    REFERENCES Course(CourseID),
    CONSTRAINT FK_Section_FacultyID FOREIGN KEY (FacultyID)
    REFERENCES Faculty(FacultyID)
    
);


select * from Section;



#drop table Enrollment;

CREATE TABLE IF NOT EXISTS Enrollment (
	StudentID varchar(6) NOT NULL,
    CallerID  int(11) NOT NULL,
    Grade int(11),
    RegisterStatus varchar(10) NOT NULL,
    CONSTRAINT FK_Enroll_StudentID FOREIGN KEY (StudentID)
    REFERENCES Student(StudentID),
    CONSTRAINT FK_Enroll_CallerID FOREIGN KEY (CallerID)
    REFERENCES Section(CallerID)
);


select * from Enrollment;