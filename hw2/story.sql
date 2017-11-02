# turn off the safe update mode so that we can test foreign
# key constraint while doing some delete operations
SET SQL_SAFE_UPDATES = 0; 



# Story 1: Try to delete an 
# This fails because Section entity has a foreign key
# points to Faculty entity's FacultyID so we cannot
# delete this faculty

#Delete From Faculty where Faculty.LastName="Jett";




        
# Story 2: Which faculties have taught COMS4111? Give detail information
# on which year,semester and section does this faculty teach it
SELECT 
    Faculty.LastName,
    Faculty.FirstName,
    a.CallerID,
    a.Department,
    a.CourseNumber,
    a.Semester,
    a.AcademicYear
FROM
    Faculty
        JOIN
    (SELECT 
        Course.Department,
            Course.CourseNumber,
            Course.AcademicYear,
            Course.Semester,
            Section.CallerID,
            Section.FacultyID
    FROM
        Course
    JOIN Section ON Course.CourseID = Section.CourseID) AS a ON a.FacultyID = Faculty.FacultyID
WHERE
    a.CourseNumber = 4111 and a.Department = "COMS";
    
    
# Story 3: We want to select a TA for COMS4111
# We want to know the students who took COMS4111 before and
# obtain a good grade. We also wants to know when that student
# took the course and who was his/her professor at that time
SELECT 
    b.LastName as s_lastname,
    b.FirstName as s_firstname,
    a.Department,
    a.CourseNumber,
    a.AcademicYear,
    a.Semester,
    a.CallerID,
    b.Grade,
    Faculty.LastName as f_lastname,
    Faculty.FirstName as f_firstname
FROM
    (SELECT 
		Course.Department,
            Course.CourseNumber,
            Course.AcademicYear,
            Course.Semester,
            Section.CallerID,
            Section.FacultyID
    FROM
        Course
    JOIN SECTION ON Course.CourseID = Section.CourseID) AS a
        JOIN
    (SELECT 
        Student.LastName,
            Student.Firstname,
            Student.StudentID,
            Enrollment.CallerID,
            Enrollment.Grade
    FROM
        Student
    JOIN Enrollment ON Student.StudentID = Enrollment.StudentID) AS b ON a.CallerID = b.CallerID
    JOIN Faculty on Faculty.FacultyID = a.FacultyID
WHERE
    a.CourseNumber = 4111
        AND a.Department = 'COMS'
        AND a.AcademicYear < 2017
        AND b.Grade > 95;



# Story 4: A student named Rutz Merry wants to know 
#all her professors' names for her enrolled class
SELECT 
    Distinct a.LastName,
    a.FirstName
FROM
    (SELECT 
        Faculty.LastName,
            Faculty.FirstName,
            Section.CallerID,
            Section.FacultyID
    FROM
        Faculty
    JOIN Section ON Faculty.FacultyID = Section.FacultyID) AS a
        JOIN
    (SELECT 
        Student.LastName,
            Student.FirstName,
            Enrollment.CallerID,
            Enrollment.RegisterStatus
    FROM
        Student
    JOIN Enrollment ON Student.StudentID = Enrollment.StudentID) AS b ON a.CallerID = b.CallerID
    where b.LastName = "Merry" and b.FirstName = "Rutz" and RegisterStatus = "enrolled";



    