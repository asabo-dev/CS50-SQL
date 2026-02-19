-- find the 2001 salary of the player who hit the most home runs in 2001
-- return a table with one column, the salary of the player

SELECT "salaries"."salary" FROM "salaries"
JOIN "performances"
ON "salaries"."player_id" = "performances"."player_id"
WHERE "performances"."year" = 2001
AND "performances"."HR" = (
    SELECT MAX("HR") FROM "performances"
    WHERE "year" = 2001
)
AND "salaries"."year" = 2001;
