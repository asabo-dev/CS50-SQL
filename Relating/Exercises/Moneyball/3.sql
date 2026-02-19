-- player name = Ken Griffey Jr.
-- SQL query to find Ken Griffey Jr.’s home run history.
-- Sort by year in descending order.
-- This Ken Griffey was born in 1969.
-- return a table with two columns, one for year and one for home runs.

SELECT "year", "HR" FROM "performances"
WHERE "player_id" = (
    SELECT "id" FROM "players"
    WHERE "first_name" = 'Ken'
    AND "last_name" = 'Griffey'
    AND "birth_year" = 1969
)
ORDER BY "year" DESC;
