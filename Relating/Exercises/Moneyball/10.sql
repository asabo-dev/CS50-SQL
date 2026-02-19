-- return a table with five columns
-- Order the results, first and foremost, by player’s IDs (least to greatest).
-- Order rows about the same player by year, in descending order.
-- Order by HR DESC, followed by salary DESC.
-- For a single row, the salary’s year and the performance’s year must match

SELECT "players"."first_name", "players"."last_name",
"salaries"."salary", "performances"."HR",
"performances"."year"
FROM "players"
JOIN "salaries"
ON "players"."id" = "salaries"."player_id"
JOIN "performances"
ON "salaries"."player_id" = "performances"."player_id"
AND "salaries"."year" = "performances"."year"
ORDER BY "players"."id" ASC,
"salaries"."year" DESC,
"performances"."HR" DESC,
"salaries"."salary" DESC;
