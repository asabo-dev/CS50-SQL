-- Find the 10 public school districts with the highest per-pupil expenditures.
-- Return the names of the districts and the per-pupil expenditure for each.
-- Use JOIN to sort rows that have "per_pupil_expenditure" data in "expenditures"

SELECT "districts"."name",
"expenditures"."per_pupil_expenditure"
FROM "districts"
JOIN "expenditures"
ON "districts"."id" = "expenditures"."district_id"
WHERE "districts"."type" = 'Public School District'
ORDER BY "expenditures"."per_pupil_expenditure"
DESC LIMIT 10;



