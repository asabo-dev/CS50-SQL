-- find the players among the 10 least expensive players per hit and 10 least expensive players per RBI in 2001
-- return a table with two columns: players’ first names and last names.
-- player’s salary per RBI = (2001 salary)/(number of RBIs in 2001)
-- player’s salary per HIT = (player’s 2001 salary)/(number of hits in 2001)
-- Assume that a player will only have one salary and one performance in 2001.
-- Order by player ID ASC, or by last name ASC

SELECT DISTINCT "players"."first_name", "players"."last_name"
FROM "players"
WHERE "players"."id" IN (
    -- 10 least expensive players per HIT in 2001
    SELECT "players"."id" FROM "players"
    JOIN "performances"
    ON "players"."id" = "performances"."player_id"
    JOIN "salaries"
    ON "performances"."player_id" = "salaries"."player_id"
    AND "performances"."year" = "salaries"."year"
    WHERE "performances"."year" = 2001
    AND "performances"."H" <> 0
    ORDER BY ("salaries"."salary")/("performances"."H")
    ASC LIMIT 10
)
AND "players"."id" IN (
    -- 10 least expensive players per RBI in 2001
    SELECT "players"."id" FROM "players"
    JOIN "performances"
    ON "players"."id" = "performances"."player_id"
    JOIN "salaries"
    ON "performances"."player_id" = "salaries"."player_id"
    AND "performances"."year" = "salaries"."year"
    WHERE "performances"."year" = 2001
    AND "performances"."RBI" <> 0
    ORDER BY ("salaries"."salary")/("performances"."RBI")
    ASC LIMIT 10
)
ORDER BY "players"."last_name" ASC;
