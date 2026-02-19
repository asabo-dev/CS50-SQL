-- Write a SQL query to explore a question of your choice. 
-- This query should:
-- Involve at least one condition, using WHERE with AND or OR

SELECT "topic", "air_date" FROM "episodes"
WHERE "topic" LIKE '%Math%';
