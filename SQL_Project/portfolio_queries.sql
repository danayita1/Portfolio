USE PortfolioDB;

-- View all tables
SELECT * FROM Students;
SELECT * FROM Courses;
SELECT * FROM Enrollments;

SELECT * FROM Students;

SELECT s.first_name, s.last_name, c.course_name, e.grade
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;
SELECT c.course_name, AVG(
    CASE 
        WHEN e.grade='A' THEN 4
        WHEN e.grade='B' THEN 3
        WHEN e.grade='C' THEN 2
        WHEN e.grade='D' THEN 1
        ELSE 0
    END
) AS avg_grade
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;
SELECT s.first_name, s.last_name, c.course_name
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE e.grade='A';
SELECT c.course_name, COUNT(e.student_id) AS num_students
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;