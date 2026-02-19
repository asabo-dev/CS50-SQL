-- find the 10 least expensive players per hit in 2001.
-- return a table with three columns: players’ first names, last names, and “dollars per hit”
-- “dollars per hit” = (player’s 2001 salary)/(number of hits in 2001)
-- filter out players with 0 hits
-- Order by “dollars per hit” ASC, first name ASC, Last name ASC
-- salary’s year = performance’s year
-- Assume that a player will only have one salary and one performance in 2001.

SELECT "players"."first_name", "players"."last_name",
("salaries"."salary")/("performances"."H")
AS "dollars per hit"
FROM "players"
JOIN "performances"
ON "players"."id" = "performances"."player_id"
JOIN "salaries"
ON "performances"."player_id" = "salaries"."player_id"
AND "performances"."year" = "salaries"."year"
WHERE "performances"."year" = 2001
AND "performances"."H" <> 0
ORDER BY "dollars per hit" ASC,
"players"."first_name" ASC,
"players"."last_name" ASC
LIMIT 10;
