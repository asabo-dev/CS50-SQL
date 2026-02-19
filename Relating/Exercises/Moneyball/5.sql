-- player name = 'Satchel Paige'
-- SQL query to find all teams that Satchel Paige played for.
-- return a table with a single column (name of the teams)

SELECT DISTINCT "teams"."name" FROM "teams"
JOIN "performances"
ON "teams"."id" = "performances"."team_id"
JOIN "players"
ON "performances"."player_id" = "players"."id"
WHERE "first_name" = 'Satchel'
AND "last_name" = 'Paige';
