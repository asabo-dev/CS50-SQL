-- seed.sql inserts sample data to test queries.
-- it’s structured so your analytics (net score, submissions, weaknesses, etc.) all show something interesting

INSERT INTO "athlete" ("athlete_id", "name", "belt_level", "weight_class", "age_category")
VALUES
(1, 'Athlete A', 'Blue', 'Lightweight', 'Adult'),
(2, 'John Kim', 'Blue', 'Lightweight', 'Adult'),
(3, 'Carlos Silva', 'Blue', 'Lightweight', 'Adult'),
(4, 'Mike Tan', 'Blue', 'Lightweight', 'Adult'),
(5, 'Heavy Guy', 'Blue', 'Heavyweight', 'Adult'); -- Different weight class (should be filtered out)

INSERT INTO "event_type" ("event_type_id", "name", "is_submission", "default_points")
VALUES
(1, 'takedown', 0, 2),
(2, 'sweep', 0, 2),
(3, 'mount', 0, 4),
(4, 'back control', 0, 4),
(5, 'submission', 1, 5),
(6, 'escape', 0, 0);

INSERT INTO "technique" ("technique_id", "name")
VALUES
(1, 'double leg'),
(2, 'scissor sweep'),
(3, 'armbar'),
(4, 'triangle choke'),
(5, 'rear naked choke');

INSERT INTO "training_session" ("session_id", "athlete_id", "session_date")
VALUES
(1, 1, '2026-04-01'),
(2, 1, '2026-04-05');

INSERT INTO "sparring_round" ("round_id", "session_id", "opponent_id", "duration")
VALUES
(1, 1, 2, 5),
(2, 1, 3, 5),
(3, 2, 2, 5),
(4, 2, 4, 5),
(5, 2, 5, 5); -- Different weight class opponent

INSERT INTO "sparring_event"
("event_id", "round_id", "actor_id", "target_id", "event_type_id", "technique_id", "points_awarded")
VALUES

-- Round 1 vs John Kim
(1, 1, 1, 2, 1, 1, 2),  -- A takedown
(2, 1, 1, 2, 3, NULL, 4), -- A mount
(3, 1, 1, 2, 5, 3, 5), -- A armbar submission

-- Round 2 vs Carlos Silva
(4, 2, 3, 1, 1, 1, 2), -- Opp takedown
(5, 2, 3, 1, 5, 4, 5), -- Opp triangle submission

-- Round 3 vs John Kim again
(6, 3, 2, 1, 2, 2, 2), -- Opp sweep
(7, 3, 1, 2, 5, 5, 5), -- A rear naked choke

-- Round 4 vs Mike Tan
(8, 4, 4, 1, 3, NULL, 4), -- Opp mount
(9, 4, 1, 4, 6, NULL, 0), -- A escape

-- Round 5 vs Heavy Guy (should be filtered in category query)
(10, 5, 5, 1, 5, 4, 5); -- Opp submission

