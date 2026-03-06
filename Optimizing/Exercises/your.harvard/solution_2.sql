-- Indexes created for harvard.db schema
CREATE INDEX "search_enrollments_by_student_id"
ON "enrollments"("student_id");

CREATE INDEX "search_courses_by_course_id"
ON "enrollments"("course_id");

CREATE INDEX "filter_courses"
ON "courses"("department", "number", "semester");

CREATE INDEX "filter_courses_by_semester"
ON "courses"("semester");

CREATE INDEX "search_requirements_by_course_id"
ON "satisfies"("course_id");

CREATE INDEX "search_courses_by_title"
ON "courses"("title", "semester");

-------------------------------------------------------

The Method To Reduce Indexes (Safely)
- Step 1️⃣ Pick ONE index to test
- Step 2️⃣ DROP it
- Step 3️⃣ Re-run EXPLAIN on ALL typical queries
    Look for:
    SCAN table_name
    - If no SCAN appears →
      that index was redundant.
    - If a SCAN appears →
      you needed it.
- Step 4️⃣ Keep it dropped or restore it
    That’s it. Repeat for each index.

--------  --------   --------
You currently have three indexes on courses.
Ask: Do any overlap?

Apply Left-Most Prefix Rule
- SQLite can use a composite index only from the left side forward.
If you create:
    ON table_name(department, number, semester)
    SQLite can use:
        department
        department + number
        department + number + semester
    But NOT:
        semester alone
        department + semester
        title + semester


-------- 
Important: Do NOT optimize for beauty
Optimize for:
- Minimum indexes
- Zero SCANs
- Composite indexes serving multiple queries

The Big Principle
You reduce indexes by asking:
Does another existing index already cover this query pattern?
- If yes → drop it.
- If no → keep it.

-- Drop INDEX "filter_courses"
CREATE INDEX "search_enrollments_by_student_id"
ON "enrollments"("student_id");
CREATE INDEX "search_courses_by_course_id"
ON "enrollments"("course_id");
CREATE INDEX "search_requirements_by_course_id"
ON "satisfies"("course_id");
CREATE INDEX "search_courses_by_title"
ON "courses"("title", "semester");
CREATE INDEX "filter_courses_by_semester"
ON "courses"("semester");

-- To optimize further, redesign "filter_courses" and eventually "search_courses_by_title"
CREATE INDEX "filter_courses"
ON "courses"("semester", "department", "number");

-- Remaining Indexex are:
CREATE INDEX "search_enrollments_by_student_id"
ON "enrollments"("student_id");
CREATE INDEX "search_requirements_by_course_id"
ON "satisfies"("course_id");
CREATE INDEX "filter_courses"
ON "courses"("semester", "department", "number");
CREATE INDEX "search_enrollments_by_course_id" -- renamed Index
ON "enrollments"("course_id");