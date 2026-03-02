sqlite> SELECT "id" FROM "users"
   ...> WHERE "username"
   ...> = 'lovelytrust487';
+-----+
| id  |
+-----+
| 284 |
+-----+
sqlite> 

sqlite> SELECT friend_id FROM friends
   ...> WHERE user_id = 284;
+-----------+
| friend_id |
+-----------+
| 414       |
| 647       |
| 962       |
| 1218      |
| 1603      |
| 1709      |
| 1939      |
| 2142      |
| 2361      |
| 2381      |
| 2438      |
+-----------+
sqlite> 

sqlite> SELECT "id" FROM "users"
   ...> WHERE "username" = 'exceptionalinspiration482';
+-----+
| id  |
+-----+
| 440 |
+-----+
sqlite>

sqlite> SELECT friend_id FROM friends
   ...> WHERE user_id = 440;
+-----------+
| friend_id |
+-----------+
| 365       |
| 1270      |
| 1603      |
| 1719      |
| 2142      |
| 2438      |
+-----------+


SELECT friend_id FROM friends
WHERE user_id = (
    SELECT "id" 
    FROM "users"
    WHERE "username" = 'lovelytrust487'
)
INTERSECT 
SELECT friend_id FROM friends
WHERE user_id = (
    SELECT "id" 
    FROM "users"
    WHERE "username" = 'exceptionalinspiration482'
);

-- TERMINAL OUTPUT
sqlite> EXPLAIN QUERY PLAN
   ...> SELECT friend_id FROM friends
   ...> WHERE user_id = (
   ...>     SELECT "id" 
   ...>     FROM "users"
   ...>     WHERE "username" = 'lovelytrust487'
   ...> )
   ...> INTERSECT 
   ...> SELECT friend_id FROM friends
   ...> WHERE user_id = (
   ...>     SELECT "id" 
   ...>     FROM "users"
   ...>     WHERE "username" = 'exceptionalinspiration482'
   ...> );
QUERY PLAN
`--COMPOUND QUERY
   |--LEFT-MOST SUBQUERY
   |  |--SEARCH friends USING COVERING INDEX sqlite_autoindex_friends_1 (user_id=?)
   |  `--SCALAR SUBQUERY 1
   |     `--SEARCH users USING COVERING INDEX sqlite_autoindex_users_1 (username=?)
   `--INTERSECT USING TEMP B-TREE
      |--SEARCH friends USING COVERING INDEX sqlite_autoindex_friends_1 (user_id=?)
      `--SCALAR SUBQUERY 3
         `--SEARCH users USING COVERING INDEX sqlite_autoindex_users_1 (username=?)