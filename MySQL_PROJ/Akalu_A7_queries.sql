USE ischool_v2;

/* Drop Table IF exists */

DROP VIEW IF EXISTS students_per_course_section;

/* Creating the view */
CREATE VIEW students_per_course_section AS
SELECT 
    CONCAT(c.course_code, c.course_number) AS Course,
    cs.section_number AS Section_Number,
    cs.semester AS Semester,
    COUNT(e.person_id) AS Number_of_Students
FROM
    enrollments e
JOIN
    course_sections cs ON e.section_id = cs.section_id
JOIN
    courses c ON cs.course_id = c.course_id
GROUP BY
    Course, Section_Number, cs.semester
HAVING
    COUNT(e.person_id) > 2;

/* Querying the results */

SELECT * 
FROM students_per_course_section
ORDER BY 
    Semester DESC,      
    Number_of_Students DESC,  
    Section_Number ASC;


/* non-updatable */

/*
The view students_per_course_section is non-updatable because it uses aggregation,
 specifically the COUNT() function, to summarize data. 
Since the view combines information from multiple columns and tables,
 it’s not possible to update the individual records in the original tables directly through this view.*/
