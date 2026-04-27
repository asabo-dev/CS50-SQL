-- Query 1
-- Net performance against opponents.
-- What is Athlete A's net score against  each opponent?
-- Athlete A (main athlete being tracked) is athlete_id = 1.
-- SELECT "sparring_round"."opponent_id",
SELECT "opp"."name"
    AS "opponent_name", 
    SUM( 
        -- Use of Conditional Expressions can be seen in postgresql documentation
        -- https://www.postgresql.org/docs/18/functions-conditional.html#FUNCTIONS-CASE
        CASE
            WHEN "sparring_event"."actor_id" = 1
            THEN "sparring_event"."points_awarded"
            WHEN "sparring_event"."target_id" = 1
            THEN - "sparring_event"."points_awarded"
            ELSE 0
        END
    ) AS "net_score",
    COUNT(*) AS "total_events" -- Helps to differentiate between +10 (50 events) vs +10 (5 events).

FROM "sparring_event"

JOIN "sparring_round" 
ON "sparring_event"."round_id" = "sparring_round"."round_id"

JOIN "athlete" AS "opp"
ON "sparring_round"."opponent_id" = "opp"."athlete_id" -- Opponent

WHERE "sparring_event"."actor_id" = 1
    OR "sparring_event"."target_id" = 1

GROUP BY 
    "sparring_round"."opponent_id",
    "opp"."name"
    
ORDER BY
    "net_score" DESC; -- Athletes dominated by Athlete A occupy top of the table.


-- Query 2
-- Net Performance overtime (by training session).
-- Athlete A is athlete_id = 1.
-- Calculate Athlete A's performance per training session.
-- "total_points_scored" = offensive techniques successfully executed.
-- "total_points_conceded" = defensive exposure.
SELECT "training_session"."session_date",
    -- Points scored by Athlete A.
    SUM(
        CASE
            WHEN "sparring_event"."actor_id" = 1
            THEN "sparring_event"."points_awarded"
            ELSE 0
        END  
    ) AS "total_points_scored",
    -- Points conceded by Athlete A.
    SUM(
        CASE
            WHEN "sparring_event"."target_id" = 1
            THEN "sparring_event"."points_awarded"
            ELSE 0
        END  
    ) AS "total_points_conceded",
    -- Net score = points scored - points conceded.
    SUM( 
        CASE
            WHEN "sparring_event"."actor_id" = 1
            THEN "sparring_event"."points_awarded"
            WHEN "sparring_event"."target_id" = 1
            THEN - "sparring_event"."points_awarded"
            ELSE 0
        END
    ) AS "net_score"
FROM "training_session"

JOIN "sparring_round"
ON "training_session"."session_id" = "sparring_round"."session_id"

JOIN "sparring_event" 
ON "sparring_round"."round_id" = "sparring_event"."round_id"

WHERE "sparring_event"."actor_id" = 1
    OR "sparring_event"."target_id" = 1

GROUP BY 
    "training_session"."session_id",
    "training_session"."session_date"

ORDER BY "training_session"."session_date";


-- Query 3
-- Determine technique effectiveness (including submissions).
-- Athlete A is athlete_id = 1.
SELECT 
    -- Use of Conditional Expressions can be seen in postgresql documentation.
    -- https://www.postgresql.org/docs/18/functions-conditional.html#FUNCTIONS-COALESCE
    COALESCE("technique"."name", "event_type"."name")
    AS "technique_name", 
    COUNT(*)
    AS "number_of_execution",
    SUM("sparring_event"."points_awarded")
    AS "total_points",
    SUM("event_type"."is_submission") 
    AS "submission_count"

FROM "sparring_event"

JOIN "event_type" 
ON "sparring_event"."event_type_id" = "event_type"."event_type_id"

LEFT JOIN "technique" 
ON "sparring_event"."technique_id" = "technique"."technique_id"

WHERE "sparring_event"."actor_id" = 1 

GROUP BY 
    -- Filter groupings by techniques' or events' unique ID.
    -- Else filter groupings by technique/event name.
    COALESCE("technique"."technique_id", "event_type"."event_type_id"),
    COALESCE("technique"."name", "event_type"."name")

ORDER BY 
    "submission_count" DESC, -- Techniques that can end a match.
    "number_of_execution" DESC, -- Frequently used techniques.
    "total_points" DESC; -- Techniques that score high points.


-- Query 4
-- Determine techniques frequently used against Athlete A.
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

JOIN "event_type" 
ON "sparring_event"."event_type_id" = "event_type"."event_type_id"

LEFT JOIN "technique" 
ON "sparring_event"."technique_id" = "technique"."technique_id"

WHERE "sparring_event"."target_id" = 1 

GROUP BY 
    -- Filter groupings by techniques' or events' unique ID.
    -- Else filter groupings by technique/event name.
    COALESCE("technique"."technique_id", "event_type"."event_type_id"),
    COALESCE("technique"."name", "event_type"."name")

ORDER BY 
    "submission_count" DESC, -- Techniques that will make Athlete A lose matches.
    "number_of_execution" DESC, -- Techniques used most frequently against Athlete A.
    "points_conceded" DESC; -- Techniques that score high points against Athlete A.


-- Query 5
-- Determine Athlete A's performance against opponents in his (competition) category.
-- Athlete A is athlete_id = 1
SELECT "opp"."name"
    AS "opponent_name",
    -- Points scored by Athlete A.
    SUM(
        CASE
            WHEN "sparring_event"."actor_id" = 1
            THEN "sparring_event"."points_awarded"
            ELSE 0
        END  
    ) AS "points_scored", 
    -- Points conceded by Athlete A (points scored by opponent).
    SUM(
        CASE
            WHEN "sparring_event"."target_id" = 1
            THEN "sparring_event"."points_awarded"
            ELSE 0
        END  
    ) AS "points_conceded",
    -- Net score during sparring round.
    SUM( 
        CASE
            WHEN "sparring_event"."actor_id" = 1
            THEN "sparring_event"."points_awarded"
            WHEN "sparring_event"."target_id" = 1
            THEN -"sparring_event"."points_awarded"
            ELSE 0
        END
    ) AS "net_score", -- (Win/loss depending if result is positive integer or negative integer).
    -- Submission performed by Athlete A.
    SUM(
        CASE
            WHEN "sparring_event"."actor_id" = 1
            THEN "event_type"."is_submission"
            ELSE 0
        END  
    ) AS "submission_by", 
    -- Submission performed against Athlete A (by opponent).
    SUM(
        CASE
            WHEN "sparring_event"."target_id" = 1
            THEN "event_type"."is_submission"
            ELSE 0
        END  
    ) AS "submission_against" 

FROM "sparring_event"

JOIN "sparring_round" 
ON "sparring_event"."round_id" = "sparring_round"."round_id"

JOIN "athlete" AS "opp"
ON "sparring_round"."opponent_id" = "opp"."athlete_id" -- Opponent

JOIN "athlete" AS "ath"
ON "ath"."athlete_id" = 1  -- Main Athlete (Athlete A)

JOIN "event_type" 
ON "sparring_event"."event_type_id" = "event_type"."event_type_id"

-- Opponent is in the same (competition) category with Athlete A.
WHERE 
    ("sparring_event"."actor_id" = 1
    OR "sparring_event"."target_id" = 1)
    AND "opp"."belt_level" = "ath"."belt_level"
    AND "opp"."weight_class" = "ath"."weight_class"
    AND "opp"."age_category" = "ath"."age_category"

GROUP BY 
    "sparring_round"."opponent_id",
    "opp"."name"

ORDER BY 
    "submission_against" DESC, -- Toughest opponents.
    "net_score" ASC,
    "points_conceded" DESC;


-- Optimize search where "sparring_event"."actor_id" = 1.
CREATE INDEX "search_performance_by_actor_id"
ON "sparring_event"("actor_id");

-- Optimize search where "sparring_event"."target_id" = 1.
CREATE INDEX "search_performance_by_target_id"
ON "sparring_event"("target_id");

-- Optimize search by filtering "sparring_event"."round_id"
CREATE INDEX "filter_performance_by_round_id"
ON "sparring_event"("round_id");