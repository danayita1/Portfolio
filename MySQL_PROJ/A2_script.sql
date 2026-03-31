/* Answer */

USE ischool;

SELECT
	cs.section_number AS 'Section Number',
	CONCAT(c.course_code, ' ', c.course_number) AS 'Course',
	CONCAT('Standard number of credits: ', c.credits) AS 'Credits',
	CONCAT(cs.start_time, ' to ', cs.end_time) AS 'Time Interval',
	CONCAT(p.fname, ' ', p.lname) AS 'Instructor Name',
	CONCAT(l.building_code, ', Room ', l.room_number) AS 'Location'
FROM
	course_sections cs
JOIN courses c ON cs.course_id = c.course_id
JOIN locations l ON cs.location_id = l.location_id
JOIN people p ON cs.instructor_id = p.person_id
WHERE
	c.credits > 2 AND
	l.room_number > 100
UNION

SELECT
	cs.section_number AS 'Section Number',
	CONCAT(c.course_code, ' ', c.course_number) AS 'Course',
	CONCAT('Non-standard number of credits: ', c.credits) AS 'Credits',
	CONCAT(cs.start_time, ' to ', cs.end_time) AS 'Time Intervals',
	CONCAT(p.fname, ' ', p.lname) AS 'Instructor Name',
	CONCAT(l.building_code, ', Room ', l.room_number) AS 'Location'
FROM
	course_sections cs
JOIN courses c ON cs.course_id = c.course_id
JOIN locations l ON cs.location_id = l.location_id
JOIN people p ON cs.instructor_id = p.person_id
WHERE
	c.credits < 2 AND
	l.room_number > 100;
    
    
    
/* Answer 2 */

USE ischool;

SELECT
	CONCAT(p.lname, ' ', p.fname) AS 'Full Name',
	p.title AS 'title',
	p.department AS 'department',
	CONCAT(c.course_code, ' ', c.course_number) AS 'Course Name',
	c.course_prereq AS 'Course Prerequisite'
FROM
	people p
LEFT JOIN
	course_sections cs ON p.person_id = cs.instructor_id
LEFT JOIN
	courses c ON cs.course_id = c.course_id
WHERE
	p.title IS NOT NULL
AND (c.course_number IS NULL OR c.course_number > 400)
ORDER BY
	p.department DESC; 
    
    /* In Question 2, the affected column is Department.
    Indeterminate sorting can cause the order of instructors within 
    the same department to change, leading to variations in how their 
    rows are displayed each time the query is run.
    */