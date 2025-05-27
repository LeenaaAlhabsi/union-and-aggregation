use union_task 

-- Trainees Table 
CREATE TABLE Trainees ( 
TraineeID INT PRIMARY KEY, 
FullName VARCHAR(100), 
Email VARCHAR(100), 
Program VARCHAR(50), 
GraduationDate DATE 
);

-- Job Applicants Table 
CREATE TABLE Applicants ( 
ApplicantID INT PRIMARY KEY, 
FullName VARCHAR(100), 
Email VARCHAR(100), 
Source VARCHAR(20), -- e.g., "Website", "Referral" 
AppliedDate DATE 
);

-- Insert into Trainees 
INSERT INTO Trainees VALUES 
(1, 'Layla Al Riyami', 'layla.r@example.com', 'Full Stack .NET', '2025-04-30'), 
(2, 'Salim Al Hinai', 'salim.h@example.com', 'Outsystems', '2025-03-15'), 
(3, 'Fatma Al Amri', 'fatma.a@example.com', 'Database Admin', '2025-05-01'); 

-- Insert into Applicants 
INSERT INTO Applicants VALUES 
(101, 'Hassan Al Lawati', 'hassan.l@example.com', 'Website', '2025-05-02'), 
(102, 'Layla Al Riyami', 'layla.r@example.com', 'Referral', '2025-05-05'), -- same person as trainee 
(103, 'Aisha Al Farsi', 'aisha.f@example.com', 'Website', '2025-04-28'); 

-- List all unique people who either trained or applied for a job
select FullName, Email
from Trainees
union
select FullName, Email
from Applicants

-- Now use UNION ALL. What changes in the result? 
-- the doublicated will shown 
-- (All) will git all the 
select FullName, Email
from Trainees
union all
select FullName, Email
from Applicants

-- Find people who are in both tables
select FullName, Email
from Trainees
intersect
select FullName, Email
from Applicants

-- Try DELETE FROM Trainees WHERE Program = 'Outsystems'
-- the rows that match Program = 'Outsystems' wil be deleted
-- we can rollback only if we use transaction
delete from Trainees
WHERE Program = 'Outsystems'
-- the table structure still exists.
select * from Trainees

-- Try TRUNCATE TABLE Applicants
-- All rows in the Applicants table are deleted
-- cannot rollback in most cases
TRUNCATE TABLE Applicants
-- The table structure remains
select * from Applicants

-- Try DROP TABLE Applicants
--The entire table is removed from the database, including structure
-- cannot rollback
DROP TABLE Applicants
-- get an error / structuer removed
SELECT * FROM Applicants


--A transaction in SQL is a sequence of one or more SQL operations executed as a single unit. If any part of the transaction fails, the entire transaction can be rolled back, leaving the database unchanged.
--Key Commands:
--BEGIN TRANSACTION – Starts a transaction block.
--COMMIT – Saves all changes made in the transaction.
--ROLLBACK – Undoes all changes if any statement fails.
BEGIN TRY
    BEGIN TRANSACTION

    INSERT INTO Applicants 
    VALUES (104, 'Zahra Al Amri', 'zahra.a@example.com', 'Referral', '2025-05-10')
    INSERT INTO Applicants 
    VALUES (104, 'Error User', 'error@example.com', 'Website', '2025-05-11')

    COMMIT
END TRY
BEGIN CATCH
    ROLLBACK
    PRINT 'Transaction failed and was rolled back: ' + ERROR_MESSAGE()
END CATCH



