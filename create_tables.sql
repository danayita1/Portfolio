-- Create database and use it
CREATE DATABASE IF NOT EXISTS PortfolioDB;
USE PortfolioDB;

-- Drop tables if they already exist to avoid duplicate errors
DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Courses;

-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    major VARCHAR(50),
    year INT
);

-- Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    course_code VARCHAR(10),
    credits INT
);

-- Create Enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert Students
INSERT INTO Students VALUES (1, 'Alice', 'Smith', 'Information Science', 3);
INSERT INTO Students VALUES (2, 'Bob', 'Johnson', 'Computer Science', 2);
INSERT INTO Students VALUES (3, 'Charlie', 'Lee', 'Information Science', 1);
INSERT INTO Students VALUES (4, 'Diana', 'Garcia', 'Computer Science', 4);
INSERT INTO Students VALUES (5, 'Ethan', 'Brown', 'Information Science', 2);
INSERT INTO Students VALUES (6, 'Fiona', 'Davis', 'Computer Science', 3);
INSERT INTO Students VALUES (7, 'George', 'Miller', 'Information Science', 1);
INSERT INTO Students VALUES (8, 'Hannah', 'Wilson', 'Computer Science', 4);
INSERT INTO Students VALUES (9, 'Ian', 'Martinez', 'Information Science', 2);
INSERT INTO Students VALUES (10, 'Julia', 'Anderson', 'Computer Science', 3);
INSERT INTO Students VALUES (11, 'Kevin', 'Thomas', 'Information Science', 1);
INSERT INTO Students VALUES (12, 'Laura', 'Taylor', 'Computer Science', 4);
INSERT INTO Students VALUES (13, 'Michael', 'Harris', 'Information Science', 2);
INSERT INTO Students VALUES (14, 'Nina', 'Clark', 'Computer Science', 3);
INSERT INTO Students VALUES (15, 'Oscar', 'Lewis', 'Information Science', 1);
INSERT INTO Students VALUES (16, 'Paula', 'Robinson', 'Computer Science', 4);
INSERT INTO Students VALUES (17, 'Quentin', 'Walker', 'Information Science', 2);
INSERT INTO Students VALUES (18, 'Rachel', 'Hall', 'Computer Science', 3);
INSERT INTO Students VALUES (19, 'Steve', 'Young', 'Information Science', 1);
INSERT INTO Students VALUES (20, 'Tina', 'King', 'Computer Science', 4);

-- Insert Courses
INSERT INTO Courses VALUES (101, 'Database Systems', 'INFO132', 3);
INSERT INTO Courses VALUES (102, 'Data Science Basics', 'INFO220', 4);
INSERT INTO Courses VALUES (103, 'UX Design Fundamentals', 'UX101', 3);
INSERT INTO Courses VALUES (104, 'Data Visualization', 'INFO230', 3);
INSERT INTO Courses VALUES (105, 'Python for Data Science', 'INFO240', 4);
INSERT INTO Courses VALUES (106, 'Web Development', 'INFO250', 3);
INSERT INTO Courses VALUES (107, 'Machine Learning', 'INFO260', 4);
INSERT INTO Courses VALUES (108, 'Human-Computer Interaction', 'UX201', 3);
INSERT INTO Courses VALUES (109, 'Statistics for Data Science', 'INFO270', 3);
INSERT INTO Courses VALUES (110, 'Advanced SQL', 'INFO280', 3);

-- Insert Enrollments (30 entries)
INSERT INTO Enrollments VALUES (1, 1, 101, 'A');
INSERT INTO Enrollments VALUES (2, 2, 102, 'B');
INSERT INTO Enrollments VALUES (3, 3, 103, 'A');
INSERT INTO Enrollments VALUES (4, 4, 101, 'C');
INSERT INTO Enrollments VALUES (5, 5, 104, 'B');
INSERT INTO Enrollments VALUES (6, 6, 105, 'A');
INSERT INTO Enrollments VALUES (7, 7, 106, 'C');
INSERT INTO Enrollments VALUES (8, 8, 107, 'B');
INSERT INTO Enrollments VALUES (9, 9, 108, 'A');
INSERT INTO Enrollments VALUES (10, 10, 109, 'B');
INSERT INTO Enrollments VALUES (11, 11, 110, 'C');
INSERT INTO Enrollments VALUES (12, 12, 101, 'B');
INSERT INTO Enrollments VALUES (13, 13, 102, 'A');
INSERT INTO Enrollments VALUES (14, 14, 103, 'C');
INSERT INTO Enrollments VALUES (15, 15, 104, 'B');
INSERT INTO Enrollments VALUES (16, 16, 105, 'A');
INSERT INTO Enrollments VALUES (17, 17, 106, 'B');
INSERT INTO Enrollments VALUES (18, 18, 107, 'C');
INSERT INTO Enrollments VALUES (19, 19, 108, 'A');
INSERT INTO Enrollments VALUES (20, 20, 109, 'B');
INSERT INTO Enrollments VALUES (21, 1, 110, 'A');
INSERT INTO Enrollments VALUES (22, 2, 101, 'B');
INSERT INTO Enrollments VALUES (23, 3, 102, 'C');
INSERT INTO Enrollments VALUES (24, 4, 103, 'B');
INSERT INTO Enrollments VALUES (25, 5, 104, 'A');
INSERT INTO Enrollments VALUES (26, 6, 105, 'B');
INSERT INTO Enrollments VALUES (27, 7, 106, 'A');
INSERT INTO Enrollments VALUES (28, 8, 107, 'C');
INSERT INTO Enrollments VALUES (29, 9, 108, 'B');
INSERT INTO Enrollments VALUES (30, 10, 109, 'A');