-- Find the username of the most popular user.
-- Most popular user = user who has had the most messages sent to them.
-- Ensure the query uses the search_messages_by_to_user_id index.

-- EXPLAIN QUERY PLAN
SELECT "username"
FROM "users"
WHERE "id" = (
    SELECT "to_user_id"
    FROM "messages"
    GROUP BY "to_user_id"
    ORDER BY COUNT("id")
    DESC LIMIT 1
);

-- TERMINAL OUTPUT
--sqlite> EXPLAIN QUERY PLAN
--   ...> SELECT "username"
--   ...> FROM "users"
--   ...> WHERE "id" = (
--   ...>     SELECT "to_user_id"
--   ...>     FROM "messages"
--   ...>     GROUP BY "to_user_id"
--   ...>     ORDER BY COUNT("id")
--   ...>     DESC LIMIT 1
--   ...> );
--QUERY PLAN
--|--SEARCH users USING INTEGER PRIMARY KEY (rowid=?)
--`--SCALAR SUBQUERY 1
--   |--SCAN messages USING COVERING INDEX search_messages_by_to_user_id
--   `--USE TEMP B-TREE FOR ORDER BY
--sqlite> 