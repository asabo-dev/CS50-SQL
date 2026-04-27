-- Query 1
-- Net performance against opponents.

QUERY PLAN
|--SCAN sparring_event
|--SEARCH sparring_round USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH opp USING INTEGER PRIMARY KEY (rowid=?)
|--USE TEMP B-TREE FOR GROUP BY
-- `--USE TEMP B-TREE FOR ORDER BY
-- sqlite>


-- Query 2
-- Net Performance overtime (by training session).

QUERY PLAN
|--SCAN sparring_event
|--SEARCH sparring_round USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH training_session USING INTEGER PRIMARY KEY (rowid=?)
|--USE TEMP B-TREE FOR GROUP BY
-- `--USE TEMP B-TREE FOR ORDER BY
-- sqlite> 


-- Query 3
-- Determine technique effectiveness (including submissions).

QUERY PLAN
|--SCAN sparring_event
|--SEARCH event_type USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH technique USING INTEGER PRIMARY KEY (rowid=?) LEFT-JOIN
|--USE TEMP B-TREE FOR GROUP BY
-- `--USE TEMP B-TREE FOR ORDER BY
-- sqlite> 


-- Query 4
-- Determine techniques frequently used against Athlete A.

QUERY PLAN
|--SCAN sparring_event
|--SEARCH event_type USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH technique USING INTEGER PRIMARY KEY (rowid=?) LEFT-JOIN
|--USE TEMP B-TREE FOR GROUP BY
-- `--USE TEMP B-TREE FOR ORDER BY
-- sqlite> 

-- Query 5
-- Determine Athlete A's performance against opponents in his (competition) category.

QUERY PLAN
|--SEARCH ath USING INTEGER PRIMARY KEY (rowid=?)
|--SCAN sparring_event
|--SEARCH sparring_round USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH opp USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH event_type USING INTEGER PRIMARY KEY (rowid=?)
|--USE TEMP B-TREE FOR GROUP BY
-- `--USE TEMP B-TREE FOR ORDER BY
-- sqlite> 

-- Optimize search where "sparring_event"."actor_id" = 1.
CREATE INDEX "search_performance_by_actor_id"
ON "sparring_event"("actor_id");

-- Optimize search where "sparring_event"."target_id" = 1.
CREATE INDEX "search_performance_by_target_id"
ON "sparring_event"("target_id");

-- Optimize search by filtering "sparring_event"."round_id"
CREATE INDEX "filter_performance_by_round_id"
ON "sparring_event"("round_id");
