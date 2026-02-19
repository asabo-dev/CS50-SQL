-- Query to answer a question of your choice. This query should:
-- Make use of AS to rename a column
-- Involve at least condition, using WHERE
-- Sort by at least one column using ORDER BY

SELECT "first_name", "last_name", "final_game" AS 'Last Game' 
FROM "players" WHERE "birth_city" = 'Pittsburgh'
ORDER BY "final_game" DESC LIMIT 20;
