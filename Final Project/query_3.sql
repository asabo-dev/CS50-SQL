-- This is a set of the original queries.
-- The queries are shortened to enable tests on terminal
-- Comments explaining the original queries were removed.
-- The bottom block displays output during EXPLAIN QUERY PLAN optimization.

Query 1
SELECT "opp"."name" AS "opponent_name", 
    SUM(
        CASE
            WHEN "sparring_event"."actor_id" = 1 THEN "sparring_event"."points_awarded"
            WHEN "sparring_event"."target_id" = 1 THEN - "sparring_event"."points_awarded"
            ELSE 0
        END
    ) AS "net_score",
    COUNT(*) AS "total_events" 
FROM "sparring_event" JOIN "sparring_round" ON "sparring_event"."round_id" = "sparring_round"."round_id"
JOIN "athlete" AS "opp" ON "sparring_round"."opponent_id" = "opp"."athlete_id" -- Opponent
WHERE "sparring_event"."actor_id" = 1 OR "sparring_event"."target_id" = 1
GROUP BY "sparring_round"."opponent_id", "opp"."name"   
ORDER BY "net_score" DESC;

-- Query 2
SELECT "training_session"."session_date",
    SUM(
        CASE
            WHEN "sparring_event"."actor_id" = 1 THEN "sparring_event"."points_awarded"
            ELSE 0
        END  
    ) AS "total_points_scored",
    SUM(
        CASE
            WHEN "sparring_event"."target_id" = 1 THEN "sparring_event"."points_awarded"
            ELSE 0
        END  
    ) AS "total_points_conceded",
    SUM( 
        CASE
            WHEN "sparring_event"."actor_id" = 1 THEN "sparring_event"."points_awarded"
            WHEN "sparring_event"."target_id" = 1 THEN - "sparring_event"."points_awarded"
            ELSE 0
        END
    ) AS "net_score"
FROM "training_session"
JOIN "sparring_round" ON "training_session"."session_id" = "sparring_round"."session_id"
JOIN "sparring_event" ON "sparring_round"."round_id" = "sparring_event"."round_id"
WHERE "sparring_event"."actor_id" = 1 OR "sparring_event"."target_id" = 1
GROUP BY "training_session"."session_id", "training_session"."session_date"
ORDER BY "training_session"."session_date";

Query 3
SELECT 
    COALESCE("technique"."name", "event_type"."name")
    AS "technique_name", 
    COUNT(*)
    AS "number_of_execution",
    SUM("sparring_event"."points_awarded")
    AS "total_points",
    SUM("event_type"."is_submission") 
    AS "submission_count"
FROM "sparring_event"
JOIN "event_type" ON "sparring_event"."event_type_id" = "event_type"."event_type_id"
LEFT JOIN "technique" ON "sparring_event"."technique_id" = "technique"."technique_id"
WHERE "sparring_event"."actor_id" = 1 
GROUP BY 
    COALESCE("technique"."technique_id", "event_type"."event_type_id"),
    COALESCE("technique"."name", "event_type"."name")
ORDER BY "submission_count" DESC, "number_of_execution" DESC, "total_points" DESC; 

Query 4
SELECT
    COALESCE("technique"."name", "event_type"."name")
    AS "technique_name",
    COUNT(*)
    AS "number_of_execution",
    SUM("sparring_event"."points_awarded")
    AS "points_conceded",
    SUM("event_type"."is_submission") 
    AS "submission_count"
FROM "sparring_event"
JOIN "event_type" ON "sparring_event"."event_type_id" = "event_type"."event_type_id"
LEFT JOIN "technique" ON "sparring_event"."technique_id" = "technique"."technique_id"
WHERE "sparring_event"."target_id" = 1 
GROUP BY 
    COALESCE("technique"."technique_id", "event_type"."event_type_id"),
    COALESCE("technique"."name", "event_type"."name")
ORDER BY "submission_count" DESC, "number_of_execution" DESC, "points_conceded" DESC; 

Query 5
SELECT "opp"."name" AS "opponent_name",
    SUM(
        CASE
            WHEN "sparring_event"."actor_id" = 1
            THEN "sparring_event"."points_awarded"
            ELSE 0
        END  
    ) AS "points_scored", 
    SUM(
        CASE
            WHEN "sparring_event"."target_id" = 1
            THEN "sparring_event"."points_awarded"
            ELSE 0
        END  
    ) AS "points_conceded",
    SUM( 
        CASE
            WHEN "sparring_event"."actor_id" = 1
            THEN "sparring_event"."points_awarded"
            WHEN "sparring_event"."target_id" = 1
            THEN -"sparring_event"."points_awarded"
            ELSE 0
        END
    ) AS "net_score",
    SUM(
        CASE
            WHEN "sparring_event"."actor_id" = 1
            THEN "event_type"."is_submission"
            ELSE 0
        END  
    ) AS "submission_by", 
    SUM(
        CASE
            WHEN "sparring_event"."target_id" = 1
            THEN "event_type"."is_submission"
            ELSE 0
        END  
    ) AS "submission_against" 
FROM "sparring_event"
JOIN "sparring_round" ON "sparring_event"."round_id" = "sparring_round"."round_id"
JOIN "athlete" AS "opp" ON "sparring_round"."opponent_id" = "opp"."athlete_id" 
JOIN "athlete" AS "ath" ON "ath"."athlete_id" = 1  
JOIN "event_type" ON "sparring_event"."event_type_id" = "event_type"."event_type_id"
WHERE ("sparring_event"."actor_id" = 1 OR "sparring_event"."target_id" = 1)
    AND "opp"."belt_level" = "ath"."belt_level"
    AND "opp"."weight_class" = "ath"."weight_class"
    AND "opp"."age_category" = "ath"."age_category"
GROUP BY "sparring_round"."opponent_id", "opp"."name"
ORDER BY "submission_against" DESC, "net_score" ASC, "points_conceded" DESC;


                -- EXPLAIN QUERY PLAN --
-- Query 1
-- QUERY PLAN
|--SCAN sparring_event
|--SEARCH sparring_round USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH opp USING INTEGER PRIMARY KEY (rowid=?)
|--USE TEMP B-TREE FOR GROUP BY
-- `--USE TEMP B-TREE FOR ORDER BY
-- sqlite>

-- Query 2
-- QUERY PLAN
|--SCAN sparring_event
|--SEARCH sparring_round USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH training_session USING INTEGER PRIMARY KEY (rowid=?)
|--USE TEMP B-TREE FOR GROUP BY
-- `--USE TEMP B-TREE FOR ORDER BY
-- sqlite> 

-- Query 3
-- QUERY PLAN
|--SCAN sparring_event
|--SEARCH event_type USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH technique USING INTEGER PRIMARY KEY (rowid=?) LEFT-JOIN
|--USE TEMP B-TREE FOR GROUP BY
--`--USE TEMP B-TREE FOR ORDER BY
-- sqlite> 

-- Query 4
-- QUERY PLAN
|--SCAN sparring_event
|--SEARCH event_type USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH technique USING INTEGER PRIMARY KEY (rowid=?) LEFT-JOIN
|--USE TEMP B-TREE FOR GROUP BY
-- `--USE TEMP B-TREE FOR ORDER BY
-- sqlite> 

-- Query 5
-- QUERY PLAN
|--SEARCH ath USING INTEGER PRIMARY KEY (rowid=?)
|--SCAN sparring_event
|--SEARCH sparring_round USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH opp USING INTEGER PRIMARY KEY (rowid=?)
|--SEARCH event_type USING INTEGER PRIMARY KEY (rowid=?)
|--USE TEMP B-TREE FOR GROUP BY
-- `--USE TEMP B-TREE FOR ORDER BY
-- sqlite> 







