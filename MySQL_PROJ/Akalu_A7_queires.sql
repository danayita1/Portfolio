USE ischool_v2;

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
    COUNT(e.person_id) > 2
ORDER BY 
Number_of_Students DESC,
    Course ASC, 
    Section_Number ASC;
    
SELECT * 
FROM students_per_course_section_v2;

/*

The view students_per_course_section is non-updatable because it uses aggregation, specifically the COUNT() function, to summarize data. 
Since the view combines information from multiple columns and tables, it’s not possible to update the individual records in the original tables directly through this view.*/
