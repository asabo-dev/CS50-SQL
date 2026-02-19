-- Query to find the name (or names) of the school district(s) with the single least number of pupils.
-- Report only the name(s).
-- Use JOIN to exclude districts without an "expenditures" row
-- Use MIN function to determine "single least number of pupils"

SELECT "districts"."name" AS "School District"
FROM "districts"
JOIN "expenditures"
ON "districts"."id" = "expenditures"."district_id"
WHERE "expenditures"."pupils" = (
    SELECT MIN("pupils") FROM "expenditures"
);
