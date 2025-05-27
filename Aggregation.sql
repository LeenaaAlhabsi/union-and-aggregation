use Aggregation_task

CREATE TABLE Instructors ( 
    InstructorID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 
CREATE TABLE Categories ( 
    CategoryID INT PRIMARY KEY, 
    CategoryName VARCHAR(50) 
); 
CREATE TABLE Courses ( 
    CourseID INT PRIMARY KEY, 
    Title VARCHAR(100), 
    InstructorID INT, 
    CategoryID INT, 
    Price DECIMAL(6,2), 
    PublishDate DATE, 
    FOREIGN KEY (InstructorID) REFERENCES Instructors(InstructorID), 
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) 
); 
 
CREATE TABLE Students ( 
    StudentID INT PRIMARY KEY, 
    FullName VARCHAR(100), 
    Email VARCHAR(100), 
    JoinDate DATE 
); 
 
CREATE TABLE Enrollments ( 
    EnrollmentID INT PRIMARY KEY, 
    StudentID INT, 
    CourseID INT, 
    EnrollDate DATE, 
    CompletionPercent INT, 
    Rating INT CHECK (Rating BETWEEN 1 AND 5), 
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID), 
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) 
);

----- sample data

INSERT INTO Instructors VALUES 
(1, 'Sarah Ahmed', 'sarah@learnhub.com', '2023-01-10'), 
(2, 'Mohammed Al-Busaidi', 'mo@learnhub.com', '2023-05-21'); 

INSERT INTO Categories VALUES 
(1, 'Web Development'), 
(2, 'Data Science'), 
(3, 'Business'); 

INSERT INTO Courses VALUES 
(101, 'HTML & CSS Basics', 1, 1, 29.99, '2023-02-01'), 
(102, 'Python for Data Analysis', 2, 2, 49.99, '2023-03-15'), 
(103, 'Excel for Business', 2, 3, 19.99, '2023-04-10'), 
(104, 'JavaScript Advanced', 1, 1, 39.99, '2023-05-01'); 

INSERT INTO Students VALUES 
(201, 'Ali Salim', 'ali@student.com', '2023-04-01'), 
(202, 'Layla Nasser', 'layla@student.com', '2023-04-05'), 
(203, 'Ahmed Said', 'ahmed@student.com', '2023-04-10'); 

INSERT INTO Enrollments VALUES 
(1, 201, 101, '2023-04-10', 100, 5), 
(2, 202, 102, '2023-04-15', 80, 4), 
(3, 203, 101, '2023-04-20', 90, 4), 
(4, 201, 102, '2023-04-22', 50, 3), 
(5, 202, 103, '2023-04-25', 70, 4), 
(6, 203, 104, '2023-04-28', 30, 2), 
(7, 201, 104, '2023-05-01', 60, 3); 

-- Beginner Level

-- Count total number of students 
-- TotalStudents = 3
SELECT COUNT(StudentID) AS TotalStudents
FROM Students;

-- Count total number of enrollments 
-- TotalStudents = 7
SELECT COUNT(EnrollmentID) AS TotalEnrollments
FROM Enrollments;

-- Find average rating of each course
-- averagerating ([Excel for Business,4],[HTML & CSS Basics,4],
--[JavaScript Advanced,2],[Python for Data Analysis,3])
SELECT C.Title as CourseTitle, AVG(Rating) AS AverageRating
FROM Enrollments E join Courses C ON C.CourseID = E.CourseID
GROUP BY C.Title

-- Total number of courses per instructor
-- NumberOfCourses([Mohammed Al-Busaidi,2],[Sarah Ahmed,2])
SELECT I.FullName as InstructorName, COUNT(C.CourseID) as NumberOfCourses
FROM Instructors I JOIN Courses C ON I.InstructorID = C.InstructorID
GROUP BY I.FullName

-- Number of courses in each category
-- NumberOfCourses([Business,1],[Data Science,1],[Web Development,2])
SELECT Cs.CategoryName as CategoryName, COUNT(C.CourseID) as NumberOfCourses
FROM Courses C JOIN Categories Cs ON C.CategoryID = Cs.CategoryID
GROUP BY Cs.CategoryName

-- Number of students enrolled in each course. 
-- NumberOfStudents([HTML & CSS Basics,2], [Python for Data Analysis,2], [Excel for Business,1], [JavaScript Advanced,2])
SELECT C.Title as  CourseTitle, COUNT(E.StudentID) as NumberOfStudents
FROM  Enrollments E JOIN Courses C ON E.CourseID = C.CourseID
GROUP BY C.Title

-- Average course price per category
-- AvgPrice([Business,19.99], [Data Science,49.99], [Web Development,34.99])
SELECT Cs.CategoryName AS Category, AVG(C.Price) AS AvgPrice
FROM Courses C JOIN Categories Cs ON C.CategoryID = Cs.CategoryID
GROUP BY Cs.CategoryName

-- Maximum course price
-- MaxCoursePrice([49.99])
SELECT MAX(Price) AS MaxCoursePrice
FROM Courses

-- Min, Max, and Avg rating per course
-- CourseRatings([HTML & CSS Basics,4,5,4.5], [Python for Data Analysis,3,4,3.5], [Excel for Business,4,4,4.0], [JavaScript Advanced,2,3,2.5])
SELECT C.Title AS CourseTitle, MIN(E.Rating) AS MinRating, MAX(E.Rating) AS MaxRating, AVG(E.Rating) AS AvgRating
FROM Enrollments E JOIN Courses C ON E.CourseID = C.CourseID
GROUP BY C.Title

-- Count how many students gave rating = 5
-- FiveStarRatings([1])
SELECT COUNT(Rating) AS FiveStarRatings
FROM Enrollments
WHERE Rating = 5

-- Intermediate Level  

-- Average Completion per Course
-- AvgCompletionPerCourse([HTML & CSS Basics, 95], [Python for Data Analysis, 65], [Excel for Business, 70], [JavaScript Advanced, 45])
SELECT C.Title AS CourseTitle, AVG(E.CompletionPercent) AS AvgCompletion
FROM Enrollments E JOIN Courses C ON E.CourseID = C.CourseID
GROUP BY C.Title

-- Students Enrolled in More Than 1 Course
-- StudentsWithMultipleCourses([Ali Salim, 3], [Layla Nasser, 2], [Ahmed Said, 2])
SELECT S.FullName AS StudentName, COUNT(E.CourseID) AS CoursesEnrolled
FROM Enrollments E JOIN Students S ON E.StudentID = S.StudentID
GROUP BY S.FullName
HAVING COUNT(E.CourseID) > 1

-- Revenue per Course
-- RevenuePerCourse([HTML & CSS Basics, 59.98], [Python for Data Analysis, 99.98], [Excel for Business, 19.99], [JavaScript Advanced, 79.98])
SELECT C.Title AS CourseTitle, COUNT(E.EnrollmentID) * C.Price AS Revenue
FROM Courses C JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY C.Title, C.Price

-- Instructor Name + Distinct Students
-- InstructorStudents([Sarah Ahmed, 2], [Mohammed Al-Busaidi, 2])
SELECT I.FullName AS InstructorName, COUNT(DISTINCT E.StudentID) AS DistinctStudents
FROM Instructors I JOIN  Courses C ON I.InstructorID = C.InstructorID
JOIN  Enrollments E ON C.CourseID = E.CourseID
GROUP BY I.FullName

-- Average enrollments per category
-- AvgEnrollmentsPerCategory([Business, 1], [Data Science, 2], [Web Development, 2])
SELECT Cs.CategoryName, SUM(EnrollCount) / COUNT(C.CourseID) AS AvgEnrollments
FROM Categories Cs JOIN Courses C ON Cs.CategoryID = C.CategoryID
LEFT JOIN(
        SELECT CourseID, COUNT(*) AS EnrollCount
        FROM Enrollments
        GROUP BY CourseID) E ON C.CourseID = E.CourseID
GROUP BY Cs.CategoryName;

-- Average Course Rating by Instructor
-- InstructorRatings([Sarah Ahmed, 3], [Mohammed Al-Busaidi, 3]) - the  result in int 
SELECT I.FullName AS InstructorName, AVG(E.Rating) AS AvgRating
FROM Instructors I JOIN Courses C ON I.InstructorID = C.InstructorID
JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY I.FullName

-- Top 3 Courses by Enrollments
-- TopCourses([HTML & CSS Basics, 2], [Python for Data Analysis, 2], [JavaScript Advanced, 2])
SELECT TOP 3 C.Title AS CourseTitle, COUNT(E.EnrollmentID) AS EnrollmentCount
FROM Courses C JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY C.Title
ORDER BY EnrollmentCount

-- Average days to complete 100% (mock logic)
--
SELECT 
    C.Title AS CourseTitle,
    AVG(CAST(DATEDIFF(DAY, E.EnrollDate, GETDATE()) AS FLOAT)) AS AvgDays
FROM 
    Enrollments E
JOIN 
    Courses C ON E.CourseID = C.CourseID
WHERE 
    E.CompletionPercent = 100
GROUP BY 
    C.Title

-- % students who completed each course
-- CourseCompletionRate([HTML & CSS Basics, 50.00], [Python for Data Analysis, 0.00], [Excel for Business, 0.00], [JavaScript Advanced, 0.00])
SELECT C.Title AS CourseTitle, CAST(SUM(CASE WHEN E.CompletionPercent = 100 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS CompletionRate
FROM Enrollments E JOIN Courses C ON E.CourseID = C.CourseID
GROUP BY C.Title

-- Courses published per year
-- CoursesPerYear([2023, 4])
SELECT YEAR(PublishDate) AS PublishYear, COUNT(*) AS CoursesCount
FROM Courses
GROUP BY YEAR(PublishDate)


-- Advanced Level

-- Student with most completed courses
-- MostCompletedCourses([Ali Salim, 1])
SELECT TOP 1 S.FullName, COUNT(*) AS CompletedCourses
FROM Enrollments E JOIN Students S ON E.StudentID = S.StudentID
WHERE E.CompletionPercent = 100
GROUP BY S.FullName
ORDER BY CompletedCourses DESC

-- Instructor earnings from enrollments
-- InstructorEarnings([Sarah Ahmed, 139.96], [Mohammed Al-Busaidi, 119.97])
SELECT I.FullName, SUM(C.Price) AS TotalEarnings
FROM Instructors I JOIN Courses C ON I.InstructorID = C.InstructorID
JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY I.FullName;

-- Category avg rating (≥ 4)
-- HighRatedCategories([Business, 4])
SELECT Ca.CategoryName, AVG(E.Rating) AS AvgRating
FROM Categories Ca JOIN Courses C ON Ca.CategoryID = C.CategoryID
JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY Ca.CategoryName
HAVING AVG(E.Rating) >= 4

-- Students rated below 3 more than once
-- LowRaters([])
SELECT S.FullName
FROM Enrollments E JOIN Students S ON E.StudentID = S.StudentID
WHERE E.Rating < 3
GROUP BY S.FullName
HAVING COUNT(*) > 1

-- Course with lowest average completion
-- LowestAvgCompletion([JavaScript Advanced, 45])
SELECT TOP 1 C.Title, ROUND(AVG(E.CompletionPercent), 0) AS AvgCompletion
FROM Courses C
JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY C.Title
ORDER BY AvgCompletion ASC

-- Students enrolled in all courses by instructor 1
-- FullyEnrolledByInstructor([Ali, Salim])
SELECT S.FullName
FROM Students S
WHERE NOT EXISTS (
    SELECT C.CourseID
    FROM Courses C
    WHERE C.InstructorID = 1
    EXCEPT
    SELECT E.CourseID
    FROM Enrollments E
    WHERE E.StudentID = S.StudentID
)

-- Duplicate ratings check
-- DuplicateRatings([])
SELECT S.FullName, C.Title
FROM Enrollments E JOIN Students S ON E.StudentID = S.StudentID
JOIN Courses C ON E.CourseID = C.CourseID
GROUP BY S.FullName, C.Title
HAVING COUNT(*) > 1

-- Category with highest avg rating
-- TopRatedCategory([Business, 4])
SELECT TOP 1 Ca.CategoryName, AVG(E.Rating) AS AvgRating
FROM Categories Ca
JOIN Courses C ON Ca.CategoryID = C.CategoryID
JOIN Enrollments E ON C.CourseID = E.CourseID
GROUP BY Ca.CategoryName
ORDER BY AvgRating DESC