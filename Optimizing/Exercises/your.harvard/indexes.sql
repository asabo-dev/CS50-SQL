-- EXPLAIN QUERY PLAN shows a SCAN on "enrollments" table.
-- Optimize search where enrollments.student_id = students.id
CREATE INDEX "search_enrollments_by_student_id"
ON "enrollments"("student_id");

-- EXPLAIN QUERY PLAN shows a SCAN on "satisfies" table
-- Select the "course_id" column because WHERE clause depends on it.
CREATE INDEX "search_requirements_by_course_id"
ON "satisfies"("course_id");

-- EXPLAIN QUERY PLAN shows a SCAN on "courses" and "enrollments" table.
-- Create a composite INDEX to filter many columns.
-- Prioritize "semester" column since "semester" is frequently queried.
CREATE INDEX "filter_courses"
ON "courses"("semester", "department", "number");

-- EXPLAIN QUERY PLAN shows a SCAN on "enrollments" and "courses" table.
-- Select the "course_id" column because WHERE clause depends on it.
CREATE INDEX "search_enrollments_by_course_id"
ON "enrollments"("course_id");
