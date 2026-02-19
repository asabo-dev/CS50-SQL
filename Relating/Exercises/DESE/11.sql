-- Query to display the names of schools, their per-pupil expenditure, and their graduation rate. 
-- Sort the schools from greatest per-pupil expenditure to least.
-- If two schools have the same per-pupil expenditure, sort by school name.
-- Assume a school spends the same amount per-pupil their district as a whole spends.
-- Use INNER JOIN to determine the relationship between three tables.

SELECT "schools"."name", "expenditures"."per_pupil_expenditure",
"graduation_rates"."graduated"
FROM "graduation_rates"
JOIN "schools"
ON "graduation_rates"."school_id" = "schools"."id"
JOIN "expenditures"
ON "expenditures"."district_id" = "schools"."district_id"
ORDER BY
"expenditures"."per_pupil_expenditure" DESC, "schools"."name"
ASC;
