-- Query to display the names of all school districts and the number of pupils enrolled in each.
-- Use JOIN to link "districts" table and "expenditures" table.

SELECT
    "districts"."name" AS "School District",
    "expenditures"."pupils" AS "Number of Pupils"
FROM "districts"
JOIN "expenditures"
ON "districts"."id" = "expenditures"."district_id"
ORDER BY "expenditures"."pupils" DESC, "districts"."name";


