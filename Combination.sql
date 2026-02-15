USE master
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CombinationDB')
BEGIN
ALTER DATABASE CombinationDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE
DROP DATABASE CombinationDB
END
GO
CREATE DATABASE CombinationDB
GO 
USE CombinationDB
GO
CREATE TABLE Curators (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR(MAX) NOT NULL DEFAULT 'NO NAME',
[Surname] NVARCHAR(MAX) NOT NULL DEFAULT 'NO SURNAME'
)
GO
CREATE TABLE Teachers ( 
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR(MAX) NOT NULL DEFAULT 'NO NAME',
[Salary] MONEY NOT NULL,
[Surname] NVARCHAR(MAX) NOT NULL DEFAULT 'NO SURNAME',
CONSTRAINT CK_Salary CHECK ([Salary] > 0)
)
GO
CREATE TABLE Faculties (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Financing] MONEY NOT NULL DEFAULT 0,
[Name] NVARCHAR(100) UNIQUE NOT NULL DEFAULT 'NO NAME',
CONSTRAINT CK_Faculties_Financing CHECK ([Financing] >= 0)
)
GO 
CREATE TABLE Subjects (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR(100) UNIQUE NOT NULL DEFAULT 'NO NAME'
)
GO 
CREATE TABLE Departments (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Financing] MONEY NOT NULL DEFAULT 0,
[Name] NVARCHAR(100) UNIQUE NOT NULL DEFAULT 'NO NAME',
[FacultyId] INT NOT NULL,
CONSTRAINT CK_Departments_Financing CHECK ([Financing] >= 0),
CONSTRAINT department_fk FOREIGN KEY ([FacultyId]) REFERENCES Faculties([Id]) ON UPDATE CASCADE ON DELETE CASCADE
)
GO
CREATE TABLE Groups (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR(10) UNIQUE NOT NULL DEFAULT 'NO NAME',
[Year] INT NOT NULL,
[DepartmentId] INT NOT NULL,
CONSTRAINT year_ck CHECK([Year] >= 1 AND [Year] <= 5),
CONSTRAINT departmentId_fk FOREIGN KEY ([DepartmentId]) REFERENCES Departments([Id]) ON UPDATE CASCADE ON DELETE CASCADE
)
GO
CREATE TABLE Lectures (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[LectureRoom] NVARCHAR(MAX) NOT NULL DEFAULT 'NO NAME',
[SubjectId] INT NOT NULL,
[TeacherId] INT NOT NULL,
CONSTRAINT FK_Lectures_Subjects FOREIGN KEY ([SubjectId]) REFERENCES Subjects([Id]) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT FK_Lectures_Teachers FOREIGN KEY ([TeacherId]) REFERENCES Teachers([Id]) ON UPDATE CASCADE ON DELETE CASCADE
)
GO 
CREATE TABLE GroupsLectures (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[GroupId] INT NOT NULL,
[LectureId] INT NOT NULL,
CONSTRAINT goupId_fk FOREIGN KEY ([GroupId]) REFERENCES Groups([Id]) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT lectureId_fk FOREIGN KEY ([LectureId]) REFERENCES Lectures([Id]) ON UPDATE CASCADE ON DELETE CASCADE
)
GO 
CREATE TABLE GroupsCurators (
[Id] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[GroupId] INT NOT NULL,
[CuratorId] INT NOT NULL,
CONSTRAINT FK_Groups_Id FOREIGN KEY ([GroupId]) REFERENCES Groups([Id]) ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT curatorId_fk FOREIGN KEY ([CuratorId]) REFERENCES Curators([Id]) ON UPDATE CASCADE ON DELETE CASCADE
)
GO
INSERT INTO Curators ([Name], [Surname]) 
VALUES ('Ali', 'Huseynov')
INSERT INTO Curators ([Name], [Surname]) 
VALUES ('Aysel', 'Mammadova')
INSERT INTO Curators ([Name], [Surname]) 
VALUES ('Samantha', 'Adams')
GO
INSERT INTO Teachers ([Name], [Salary], [Surname]) 
VALUES ('John', 1500, 'Doe')
INSERT INTO Teachers ([Name], [Salary], [Surname]) 
VALUES ('Mary', 2000, 'Smith')
INSERT INTO Teachers ([Name], [Salary], [Surname]) 
VALUES ('Samantha', 1800, 'Adams')
GO
INSERT INTO Faculties ([Financing], [Name]) 
VALUES (50000, 'Computer Science')
INSERT INTO Faculties ([Financing], [Name]) 
VALUES (30000, 'Mathematics')
INSERT INTO Faculties ([Financing], [Name]) 
VALUES (40000, 'Physics')
GO
INSERT INTO Subjects ([Name]) 
VALUES ('Database Theory')
INSERT INTO Subjects ([Name]) 
VALUES ('Algorithms')
INSERT INTO Subjects ([Name]) 
VALUES ('Calculus')
INSERT INTO Subjects ([Name]) 
VALUES ('Physics')
GO
INSERT INTO Departments ([Financing], [Name], [FacultyId]) 
VALUES (60000, 'Software Engineering', 1)
INSERT INTO Departments ([Financing], [Name], [FacultyId]) 
VALUES (15000, 'Applied Math', 2)
INSERT INTO Departments ([Financing], [Name], [FacultyId]) 
VALUES (18000, 'Theoretical Physics', 3)
GO
INSERT INTO Groups ([Name], [Year], [DepartmentId]) 
VALUES ('P101', 1, 1)
INSERT INTO Groups ([Name], [Year], [DepartmentId]) 
VALUES ('P102', 2, 1)
INSERT INTO Groups ([Name], [Year], [DepartmentId]) 
VALUES ('P107', 4, 1)
INSERT INTO Groups ([Name], [Year], [DepartmentId]) 
VALUES ('M201', 5, 2)
INSERT INTO Groups ([Name], [Year], [DepartmentId]) 
VALUES ('P301', 5, 3)
GO
INSERT INTO Lectures ([LectureRoom], [SubjectId], [TeacherId]) 
VALUES ('B101', 2, 3)
INSERT INTO Lectures ([LectureRoom], [SubjectId], [TeacherId]) 
VALUES ('B102', 2, 1)
INSERT INTO Lectures ([LectureRoom], [SubjectId], [TeacherId]) 
VALUES ('B103', 1, 2)
INSERT INTO Lectures ([LectureRoom], [SubjectId], [TeacherId]) 
VALUES ('C201', 3, 2)
INSERT INTO Lectures ([LectureRoom], [SubjectId], [TeacherId]) 
VALUES ('C202', 4, 1)
GO
INSERT INTO GroupsLectures ([GroupId], [LectureId]) 
VALUES (1, 1)
INSERT INTO GroupsLectures ([GroupId], [LectureId]) 
VALUES (3, 3)
INSERT INTO GroupsLectures ([GroupId], [LectureId]) 
VALUES (4, 4)
INSERT INTO GroupsLectures ([GroupId], [LectureId]) 
VALUES (5, 5)
GO
INSERT INTO GroupsCurators ([GroupId], [CuratorId]) 
VALUES (1, 1)
INSERT INTO GroupsCurators ([GroupId], [CuratorId]) 
VALUES (2, 2)
INSERT INTO GroupsCurators ([GroupId], [CuratorId]) 
VALUES (3, 3)
GO



--1. Print all possible pairs of lines of teachers and groups.
SELECT 
    T.*, 
    G.* 
FROM Teachers AS T
CROSS JOIN  Groups AS G
GO



--2. Print names of faculties, where financing fund of departments exceeds financing fund of the faculty.
SELECT 
    F.[Name] 
FROM Faculties AS F
INNER JOIN Departments AS D 
    ON D.[FacultyId] = F.[Id] 
AND D.[Financing] > F.[Financing]
GO



--3. Print names of the group curators and groups names they are supervising.
SELECT 
    C.[Name],
    G.[Name] 
FROM Curators AS C 
INNER JOIN GroupsCurators AS GC
    ON C.[Id] = GC.[CuratorId] 
INNER JOIN  Groups AS G 
    ON G.[Id] = GC.[GroupId]
GO



--4. Print names of the teachers who deliver lectures in the group "P107".
SELECT
    T.[Name] 
FROM Teachers AS T
INNER JOIN Lectures AS L 
    ON T.[Id] = L.[TeacherId] 
INNER JOIN GroupsLectures AS GL
    ON L.[Id] = GL.[LectureId] 
INNER JOIN Groups AS G 
    ON GL.[GroupId] = G.[Id] 
WHERE G.[Name] = 'P107'
GO


--5. Print names of the teachers and names of the faculties where they are lecturing.
SELECT 
    T.[Surname], 
    F.[Name] 
FROM Teachers AS T
INNER JOIN Lectures AS L
    ON T.[Id] = L.[TeacherId] 
INNER JOIN GroupsLectures AS GL
    ON L.[Id] = GL.[LectureId] 
INNER JOIN Groups AS G
    ON GL.[GroupId] = G.[Id] 
INNER JOIN Departments AS D
    ON G.[DepartmentId] = D.[Id] 
INNER JOIN Faculties AS F 
    ON D.[FacultyId] = F.[Id]
GO



--6. Print names of the departments and names of the groups that relate to them.
SELECT
    D.[Name],
    G.[Name] 
FROM Departments AS D
INNER JOIN Groups AS G 
    ON D.[Id] = G.[DepartmentId]
GO

--7. Print names of the subjects that the teacher "Samantha Adams" teaches.
SELECT S.[Name] 
FROM Subjects AS S
INNER JOIN Lectures AS L
    ON S.[Id] = L.[SubjectId] 
INNER JOIN Teachers AS T 
    ON L.[TeacherId] = T.[Id] 
WHERE  
    T.[Name] = 'Samantha' 
    AND T.[Surname] = 'Adams'
GO


--8. Print names of the departments, where "Database Theory" is taught.
SELECT DISTINCT 
    D.[Name] 
FROM Departments AS D
INNER JOIN Groups AS G
    ON D.[Id] = G.[DepartmentId]
INNER JOIN GroupsLectures AS GL
    ON G.[Id] = GL.[GroupId]  
INNER JOIN Lectures AS L
    ON GL.[LectureId] = L.[Id]
INNER JOIN Subjects AS S
    ON L.[SubjectId] = S.[Id] 
WHERE 
    S.[Name] = 'Database Theory'; 


--9. Print names of the groups that belong to the "Computer Science" faculty.
SELECT 
    G.[Name] 
FROM Groups AS G
INNER JOIN Departments AS D
    ON G.[DepartmentId] = D.[Id] 
INNER JOIN Faculties AS F 
    ON D.[FacultyId] = F.[Id] 
WHERE 
    F.[Name] = 'Computer Science'
GO



--10. Print names of the 5th year groups, as well as names of the faculties to which they relate.
SELECT 
    G.[Name],
    F.[Name] 
FROM Groups AS G
INNER JOIN Departments AS D
    ON G.[DepartmentId] = D.[Id] 
INNER JOIN Faculties AS F 
    ON D.[FacultyId] = F.[Id]
WHERE 
    G.[Year] = 5 
GO



--11. Print full names of the teachers and lectures they deliver (names of subjects and groups), and select only those lectures that are delivered in the classroom "B103".
SELECT 
    T.[Name],
    S.[Name],
    G.[Name] 
FROM Teachers AS T
INNER JOIN Lectures AS L
    ON T.[Id] = L.[TeacherId] 
INNER JOIN Subjects AS S
    ON S.[Id] = L.[SubjectId] 
INNER JOIN GroupsLectures AS GL
    ON L.[Id] = GL.[LectureId] 
INNER JOIN Groups AS G 
    ON GL.[GroupId] = G.[Id] 
WHERE 
    L.[LectureRoom] = 'B103'
GO
