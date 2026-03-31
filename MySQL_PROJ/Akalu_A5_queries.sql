/*Answer 1*/

USE ischool_v2;

SELECT
	people.college AS College,
	delivery.delivery_type AS Learning_Style,
	COUNT(DISTINCT CONCAT(courses.course_code, courses.course_number)) AS
	Total_Unique_Courses,
	ROUND(AVG(courses.credits), 4) AS Avg_Credits
FROM
	course_sections
JOIN
	courses ON course_sections.course_id = courses.course_id
JOIN
	delivery ON course_sections.delivery_id = delivery.delivery_id
JOIN
	people ON course_sections.instructor_id = people.person_id
WHERE
	people.college = 'College of Information Studies'
AND delivery.delivery_type IN ('Face-to-Face', 'Blended Learning')
GROUP BY
	people.college,
	delivery.delivery_type
ORDER BY
	Total_Unique_Courses DESC;


/* Answer 2*/

USE ischool_v2;

SELECT
	cs.year AS Year,
	l.building_name AS Building_Name,
	COUNT(DISTINCT cs.instructor_id) AS Number_Of_Instructors,
	AVG(TIME_TO_SEC(TIMEDIFF(cs.end_time, cs.start_time))) AS Avg_Course_Duration
FROM
	course_sections cs
JOIN
	section_location sl ON cs.section_id = sl.section_id
JOIN
	locations l ON sl.location_id = l.location_id
JOIN
	courses c ON cs.course_id = c.course_id
GROUP BY
	cs.year, l.building_name
HAVING
	COUNT(DISTINCT cs.instructor_id) >= 2
	AND AVG(TIME_TO_SEC(TIMEDIFF(cs.end_time, cs.start_time))) < 5000
ORDER BY
	cs.year DESC,
	Number_Of_Instructors DESC,
	Avg_Course_Duration DESC;
