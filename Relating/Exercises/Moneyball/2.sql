-- player name =  'Cal Ripken Jr.'
-- SQL query to find Cal Ripken Jr.’s salary history.
-- Sort by year in descending order
-- return a table with two columns, one for year and one for salary.

SELECT "year", "salary" FROM "salaries"
WHERE "player_id" = (
    SELECT "id" FROM "players"
    WHERE "first_name" = 'Cal'
    AND "last_name" = 'Ripken'
)
ORDER BY "year" DESC;
