-- find the 5 lowest paying teams (by average salary) in 2001.
-- Round the average salary column to two decimal places and call it “average salary”.
-- return a table with two columns; teams’ names and  average salary.

SELECT "teams"."name", ROUND(AVG("salaries"."salary"), 2)
AS "average salary" FROM "salaries"
JOIN "teams"
ON "teams"."id" = "salaries"."team_id"
WHERE "salaries"."year" = 2001
GROUP BY "teams"."name"
ORDER BY "average salary", "teams"."name"
ASC LIMIT 5;
