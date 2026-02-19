-- find the name of the player who’s been paid the highest salary, of all time
-- return a table with two columns, player’s first name, and  last name.

SELECT "players"."first_name", "players"."last_name"
FROM "players"
JOIN "salaries"
ON "players"."id" = "salaries"."player_id"
WHERE "salaries"."salary" = (
    SELECT  MAX("salary")
    FROM "salaries"
);

