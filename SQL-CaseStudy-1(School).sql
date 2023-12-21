--Q1
CREATE DATABASE School_CaseStudy;
USE [School_CaseStudy];

CREATE TABLE CourseMaster 
(
CId INT PRIMARY KEY,
CourseName VARCHAR(40) NOT NULL,
Category CHAR(1) NULL CHECK (Category IN ('B', 'M', 'A')),
Fee SMALLMONEY NOT NULL CHECK (Fee>0)
);

CREATE TABLE StudentMaster
(
SId TINYINT PRIMARY KEY,
StudentName VARCHAR(40) NOT NULL,
Origin CHAR(1) NOT NULL CHECK (Origin IN ('L','F')),
Type CHAR(1) NOT NULL CHECK (Type IN ('U','G'))
);

CREATE TABLE EnrollmentMaster 
(
CId INT NOT NULL FOREIGN KEY (CId) REFERENCES CourseMaster (CId),
SId TINYINT NOT NULL FOREIGN KEY (SId) REFERENCES StudentMaster (SId),
DOE DATETIME NOT NULL,
FWF BIT NOT NULL,
Grade CHAR(1) CHECK (Grade IN ('O','A','B','C'))
);

INSERT INTO CourseMaster
VALUES(1,'PYTHON', 'B',8000),
(2,'AZURE', 'A',10000),
(3,'SALESFORCE', 'M',5000),
(4,'PYTHON', 'A',8000),
(5,'SQL', 'B',3000),
(6,'DEVOPS', 'B',15000),
(7,'SQL', 'M',8000),
(8,'AZURE', 'B',10000),
(9,'CLOUD', 'B',20000),
(10,'JAVA', 'M',10000);

INSERT INTO StudentMaster
VALUES(101,'Pavan','L','G'),
(102,'Kishore','L','U'),
(103,'Kalyan','F','G'),
(104,'Chaithu','L','U'),
(105,'Bhanu','F','U'),
(106,'Vishnu','F','G'),
(107,'Siva','F','U'),
(108,'Anjali','L','G'),
(109,'Jeeva','L','U'),
(110,'Karthik','L','G');

INSERT INTO EnrollmentMaster
VALUES(1,101, '2023-01-15 15:30:00',0,'A'),
(2,109, '2022-06-25 10:30:00',0,'B'),
(3,107, '2023-09-15 17:30:00',1,'C'),
(4,102, '2023-07-08 11:25:12',0,'A'),
(5,104, '2023-08-19 12:30:00',0,'O'),
(6,103, '2022-05-12 14:30:00',1,'A'),
(7,106, '2022-04-14 12:30:00',0,'B'),
(8,108, '2022-08-13 08:30:00',1,'C'),
(9,105, '2023-09-16 09:30:00',0,'C'),
(10,109, '2022-02-18 13:30:00',1,'O');



--Q1
SELECT CourseName, COUNT(E.SId) AS TotalStudentsEnrolled FROM CourseMaster C
JOIN EnrollmentMaster E ON C.CId = E.CId
JOIN StudentMaster S ON E.SId = S.SId
WHERE S.Origin='F'
GROUP BY CourseName
HAVING COUNT(E.SId)>10;

--Q2
SELECT StudentName FROM StudentMaster S
WHERE NOT EXISTS(
	SELECT 1 FROM EnrollmentMaster E
	INNER JOIN CourseMaster C ON E.CId = C.CId
	WHERE E.SId = S.SId AND C.CourseName = 'JAVA'
);

--Q3
SELECT C.CourseName AS AdvancedCourse, COUNT(E.SId) AS ForeignStudentCount FROM CourseMaster C
JOIN EnrollmentMaster E ON C.CId = E.CId
JOIN StudentMaster S ON E.SId = S.SId
WHERE C.Category = 'A' AND S.Origin <> 'L'
GROUP BY C.CourseName
ORDER BY ForeignStudentCount DESC;

--Q4
SELECT DISTINCT S.SId FROM StudentMaster  S
INNER JOIN EnrollmentMaster E ON S.SId = E.SId
INNER JOIN CourseMaster C ON E.CId = C.CId
WHERE C.Category = 'B' 
AND MONTH(E.DOE) = MONTH(GETDATE());

--Q5
SELECT StudentName FROM StudentMaster S
JOIN EnrollmentMaster E ON S.SId = E.SId
JOIN CourseMaster C on E.CId = C.CId
WHERE S.Origin = 'L' AND S.Type = 'U' AND E.Grade = 'C' AND C.Category = 'B'
GROUP BY StudentName;

--Q6
SELECT C.CourseName FROM CourseMaster C
WHERE NOT EXISTS (
	SELECT 1 FROM EnrollmentMaster E
	WHERE C.CID = E.CID
	AND MONTH(E.DOE) = 5
	AND YEAR(E.DOE) = 2020
);

--Q7
SELECT  C.CourseName AS course_name, COUNT(E.SId) AS number_of_enrollments,
    CASE
        WHEN COUNT(E.SId) > 50 THEN 'High'
        WHEN COUNT(E.SId) >= 20 AND COUNT(E.SId) <= 50 THEN 'Medium'
        ELSE 'Low'
    END AS popularity
FROM  CourseMaster C
LEFT JOIN  EnrollmentMaster E ON C.CId = E.CId
GROUP BY  C.CourseName;

--Q8
SELECT S.studentName AS 'Student Name', C.COURSENAME AS 'Course Name',
DATEDIFF(DAY, E.DOE, GETDATE()) AS 'Age of Enrollment'
FROM EnrollmentMaster E
INNER JOIN StudentMaster S ON E.SID = S.SID
INNER JOIN CourseMaster C ON E.CID = C.CID
WHERE E.DOE = (SELECT MAX(DOE) FROM EnrollmentMaster WHERE SID = EnrollmentMaster.SID)

--Q9
SELECT S.StudentName FROM StudentMaster S
JOIN EnrollmentMaster E ON S.SID = E.SID
JOIN CourseMaster C ON E.CID = C.CID
WHERE S.origin = 'L' AND C.Category = 'B'
GROUP BY S.SID, S.StudentName
HAVING COUNT(*) = 3;

--Q10
SELECT StudentName, CourseName From StudentMaster S
JOIN EnrollmentMaster E ON E.SId = S.SId
JOIN  CourseMaster C ON E.CId = C.CId;

--Q11
SELECT StudentName FROM StudentMaster S
JOIN EnrollmentMaster E ON S.SId = E.SId
WHERE E.FWF = 1 AND E.Grade = 'O';

--Q12
SELECT S.StudentName FROM StudentMaster S
INNER JOIN EnrollmentMaster E ON S.SID = E.SID
INNER JOIN CourseMaster  C ON E.CID = C.CID
WHERE S.origin = 'F' AND S.Type = 'U' AND C.Category = 'B' AND E.Grade = 'C';

--Q13
SELECT C.CourseName, COUNT(E.CID) AS TotalEnrollments FROM CourseMaster C
INNER JOIN EnrollmentMaster E ON C.CID = E.CID
WHERE MONTH(E.DOE) = MONTH(GETDATE()) AND YEAR(E.DOE) = YEAR(GETDATE())
GROUP BY C.CourseName;