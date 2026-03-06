-- sqlite> .schema harvard.db
CREATE TABLE IF NOT EXISTS "students" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "enrollments" (
    "id" INTEGER,
    "student_id" INTEGER,
    "course_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("student_id") REFERENCES "students"("id"),
    FOREIGN KEY("course_id") REFERENCES "courses"("id")
);
CREATE TABLE IF NOT EXISTS "courses" (
    "id" INTEGER,
    "department" TEXT NOT NULL,
    "number" INTEGER NOT NULL,
    "semester" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "satisfies" (
    "id" INTEGER,
    "course_id" INTEGER,
    "requirement_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("course_id") REFERENCES "courses"("id"),
    FOREIGN KEY("requirement_id") REFERENCES "requirements"("id")
);
CREATE TABLE IF NOT EXISTS "requirements" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- TEST THE GIVEN QUERIES USING EXPLAIN QUERY PLAN

-- Find a student’s historical course enrollments, based on their ID:
sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "courses"."title", "courses"."semester"
   ...> FROM "enrollments"
   ...> JOIN "courses" ON "enrollments"."course_id" = "courses"."id"
   ...> JOIN "students" ON "enrollments"."student_id" = "students"."id"
   ...> WHERE "students"."id" = 3;
QUERY PLAN
|--SEARCH students USING INTEGER PRIMARY KEY (rowid=?)
|--SCAN enrollments
--SEARCH courses USING INTEGER PRIMARY KEY (rowid=?)


-- Find all students who enrolled in Computer Science 50 in Fall 2023:
sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "id", "name"
   ...> FROM "students"
   ...> WHERE "id" IN (
   ...>     SELECT "student_id"
   ...>     FROM "enrollments"
   ...>     WHERE "course_id" = (
   ...>         SELECT "id"
   ...>         FROM "courses"
   ...>         WHERE "courses"."department" = 'Computer Science'
   ...>         AND "courses"."number" = 50
   ...>         AND "courses"."semester" = 'Fall 2023'
   ...>     )
   ...> );
QUERY PLAN
|--SEARCH students USING INTEGER PRIMARY KEY (rowid=?)
`--LIST SUBQUERY 2
   |--SCAN enrollments
   |--SCALAR SUBQUERY 1
   |  `--SCAN courses
   --CREATE BLOOM FILTER


-- Sort courses by most- to least-enrolled in Fall 2023:
sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "courses"."id", "courses"."department", "courses"."number", "courses"."title", COUNT(*) AS "enrollment"
   ...> FROM "courses"
   ...> JOIN "enrollments" ON "enrollments"."course_id" = "courses"."id"
   ...> WHERE "courses"."semester" = 'Fall 2023'
   ...> GROUP BY "courses"."id"
   ...> ORDER BY "enrollment" DESC;
QUERY PLAN
|--SCAN enrollments
|--SEARCH courses USING INTEGER PRIMARY KEY (rowid=?)
|--USE TEMP B-TREE FOR GROUP BY
 --USE TEMP B-TREE FOR ORDER BY


-- Find all computer science courses taught in Spring 2024:
sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "courses"."id", "courses"."department", "courses"."number", "courses"."title"
   ...> FROM "courses"
   ...> WHERE "courses"."department" = 'Computer Science'
   ...> AND "courses"."semester" = 'Spring 2024';
QUERY PLAN
 --SCAN courses


-- Find the requirement satisfied by “Advanced Databases” in Fall 2023:
sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "requirements"."name"
   ...> FROM "requirements"
   ...> WHERE "requirements"."id" = (
   ...>     SELECT "requirement_id"
   ...>     FROM "satisfies"
   ...>     WHERE "course_id" = (
   ...>         SELECT "id"
   ...>         FROM "courses"
   ...>         WHERE "title" = 'Advanced Databases'
   ...>         AND "semester" = 'Fall 2023'
   ...>     )
   ...> );
QUERY PLAN
|--SEARCH requirements USING INTEGER PRIMARY KEY (rowid=?)
`--SCALAR SUBQUERY 2
   |--SCAN satisfies
   `--SCALAR SUBQUERY 1
       --SCAN courses


-- Find how many courses in each requirement a student has satisfied:
sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "requirements"."name", COUNT(*) AS "courses"
   ...> FROM "requirements"
   ...> JOIN "satisfies" ON "requirements"."id" = "satisfies"."requirement_id"
   ...> WHERE "satisfies"."course_id" IN (
   ...>     SELECT "course_id"
   ...>     FROM "enrollments"
   ...>     WHERE "enrollments"."student_id" = 8
   ...> )
   ...> GROUP BY "requirements"."name";
QUERY PLAN
|--SCAN satisfies
|--LIST SUBQUERY 1
|  |--SCAN enrollments
|  `--CREATE BLOOM FILTER
|--SEARCH requirements USING INTEGER PRIMARY KEY (rowid=?)
`--USE TEMP B-TREE FOR GROUP BY


-- Search for a course by title and semester:
sqlite> EXPLAIN QUERY PLAN
   ...> SELECT "department", "number", "title"
   ...> FROM "courses"
   ...> WHERE "title" LIKE "History%"
   ...> AND "semester" = 'Fall 2023';
QUERY PLAN
 --SCAN courses


-- EXPLAIN QUERY PLAN shows a SCAN on "enrollments"
-- Optimize search where enrollments.student_id = students.id
CREATE INDEX "search_enrollments_by_student_id"
ON "enrollments"("student_id");

CREATE INDEX "search_courses_by_course_id"
ON "enrollments"("course_id");
-- Create a composite index to cover multiple columns
CREATE INDEX "filter_courses"
ON "courses"("department", "number", "semester");

-- Select the "semester" column because the query depends on "courses"."semester" = 'Fall 2023'
CREATE INDEX "filter_courses_by_semester"
ON "courses"("semester");

-- Select the "course_id" because WHERE clause depends on it.
CREATE INDEX "search_requirements_by_course_id"
ON "satisfies"("course_id");

-- Create a second index to remove SCAN on "courses" table
CREATE INDEX "search_courses_by_title"
ON "courses"("title", "semester");


-- STEP 2, REDESIGN INDEXES by prioritizing most used columns
DROP INDEX "filter_courses"

CREATE INDEX "filter_courses"
ON "courses"("semester", "department", "number");

DROP INDEX "filter_courses_by_semester"

DROP INDEX "search_courses_by_title"

-- Remaining Indexex are:
CREATE INDEX "search_enrollments_by_student_id"
ON "enrollments"("student_id");
CREATE INDEX "search_requirements_by_course_id"
ON "satisfies"("course_id");
CREATE INDEX "filter_courses"
ON "courses"("semester", "department", "number");
CREATE INDEX "search_enrollments_by_course_id" -- renamed Index
ON "enrollments"("course_id");

