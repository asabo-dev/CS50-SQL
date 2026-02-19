-- SQL query to answer a question of your choice about the prints. The query should:
-- Make use of AS to rename a column.
-- Involve at least one condition, using WHERE.
-- Sort by at least one column, using ORDER BY.

SELECT "english_title" AS 'LIST OF HOKUSAI VIEWS' 
FROM "views" WHERE "artist" = 'Hokusai'
ORDER BY "print_number";
