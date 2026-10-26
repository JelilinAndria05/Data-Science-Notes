CREATE DATABASE college_join_demo_final;
USE college_join_demo_final;

-- Mentors table
CREATE TABLE mentors (
    mentor_id INT PRIMARY KEY,
    mentor_name VARCHAR(100) NOT NULL,
    senior_mentor_id INT NULL,
    FOREIGN KEY (senior_mentor_id) REFERENCES mentors(mentor_id)
);

-- Students table: student names only
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    mentor_id INT NOT NULL,
    FOREIGN KEY (mentor_id) REFERENCES mentors(mentor_id)
);

-- Courses table
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL
);

-- Enrollments table
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insert mentors
INSERT INTO mentors (mentor_id, mentor_name, senior_mentor_id) 
VALUES
(1, 'Gokul', NULL),
(2, 'Meera', NULL),
(3, 'Ravi', 1),
(4, 'Sara', 1),
(5, 'Kiran', 2);

-- Insert students
INSERT INTO students (student_id, student_name, mentor_id) 
VALUES
(1, 'Anu', 1),
(2, 'Bala', 3),
(3, 'Chitra', 3),
(4, 'Deepak', 4),
(5, 'Farah', 5);

-- Insert courses
INSERT INTO courses (course_id, course_name) 
VALUES
(101, 'SQL Basics'),
(102, 'Python Programming'),
(103, 'Web Development'),
(104, 'Data Analytics'),
(105, 'Full Stack Development');

-- Insert enrollments
INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date) 
VALUES
(1001, 1, 101, '2026-01-10'),
(1002, 2, 102, '2026-01-11'),
(1003, 3, 101, '2026-01-12'),
(1004, 4, 104, '2026-01-13'),
(1005, 1, 103, '2026-01-14');

-- 1. INNER JOIN
SELECT 
	s.student_name, 
	c.course_name
FROM 
	students s
INNER JOIN enrollments e 
	ON s.student_id = e.student_id
INNER JOIN courses c 
	ON e.course_id = c.course_id;

-- 2. LEFT JOIN
SELECT 
	s.student_name, 
    e.course_id
FROM 
	students s
LEFT JOIN enrollments e 
	ON s.student_id = e.student_id;

-- 3. RIGHT JOIN
SELECT 
	c.course_name, 
    e.student_id
FROM 
	enrollments e
RIGHT JOIN courses c 
	ON e.course_id = c.course_id;

-- 4. FULL OUTER JOIN equivalent in MySQL
SELECT 
	c.course_id, 
	c.course_name, 
    e.enrollment_id, 
    e.student_id
FROM 
	courses c
LEFT JOIN enrollments e 
	ON c.course_id = e.course_id

UNION

SELECT 
	c.course_id, 
	c.course_name, 
    e.enrollment_id, 
    e.student_id
FROM 
	courses c
RIGHT JOIN enrollments e 
	ON c.course_id = e.course_id
WHERE c.course_id IS NULL;

-- 5. CROSS JOIN
SELECT 
	s.student_name, 
	c.course_name
FROM 
	students s
CROSS JOIN courses c;

-- 6. SELF JOIN: each mentor and their senior mentor
SELECT
    m.mentor_name AS mentor,
    sm.mentor_name AS senior_mentor
FROM 
	mentors m
LEFT JOIN mentors sm 
	ON m.senior_mentor_id = sm.mentor_id;