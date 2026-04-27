-- Represent athletes whose performance would be recorded.
CREATE TABLE "athlete" (
    "athlete_id" INTEGER,
    "name" TEXT NOT NULL,
    "belt_level" TEXT NOT NULL 
    CHECK("belt_level" IN ('White', 'Blue', 'Purple', 'Brown', 'Black')),
    "weight_class" TEXT NOT NULL
    CHECK("weight_class" IN ('Featherweight', 'Lightweight', 'Middleweight', 'Heavyweight', 'Ultra Heavy')),
    "age_category" TEXT NOT NULL
    CHECK("age_category" IN ('Adult', 'Master 1', 'Master 2', 'Master 3', 'Master 4')),
    "created_at" NUMERIC DEFAULT CURRENT_TIMESTAMP,
    "athlete"("athlete_id")
    ON DELETE RESTRICT PRIMARY KEY("athlete_id")
);

-- Represent a category to which an action within a sparring round belongs.
-- Example of these actions include takedowns, sweeps, submission etc.
-- IBJJF conventions is being used.
CREATE TABLE "event_type" (
    "event_type_id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "is_submission" INTEGER NOT NULL DEFAULT 0, -- "is_submission is a flag (0=FALSE, 1=TRUE)"
    "default_points" INTEGER NOT NULL,
    PRIMARY KEY("event_type_id")
);

-- Represent a specific description the action taken during a sparring round.
CREATE TABLE "technique" (
    "technique_id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    PRIMARY KEY("technique_id")
);

-- Represent a typical BJJ Training session.
-- The main athlete being tracked (Athlete A) owns the training session.
CREATE TABLE  "training_session" (
    "session_id" INTEGER,
    "athlete_id" INTEGER NOT NULL,
    "session_date"  NUMERIC DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT NULL,
    PRIMARY KEY("session_id"),
    FOREIGN KEY("athlete_id") 
    REFERENCES 
);

-- Represent a typical sparring round within a training session.
-- Data is collected for only two participant: Athlete A(main athlete).  and Athlete B(opponent).
-- Athlete B (opponent) could be any athlete from the "athlete" table.
CREATE TABLE "sparring_round" (
    "round_id" INTEGER,
    "session_id" INTEGER NOT NULL, -- A sparring round cannot exist withot a session.
    "opponent_id" INTEGER NOT NULL, -- Refers to any athlete sparring against Athlete A.
    "duration" INTEGER NOT NULL, -- Length of time in minutes.
    CHECK ("duration" > 0),
    PRIMARY KEY("round_id"),
    FOREIGN KEY("opponent_id") 
    REFERENCES "athlete"("athlete_id")
    ON DELETE RESTRICT, -- Prevents accidental delition of an athlete whose data exists.
    FOREIGN KEY("session_id") 
    REFERENCES "training_session"("session_id")
    ON DELETE CASCADE
);

-- Represent actions that happen during a sparring round.
-- Record all actions during a round.
CREATE TABLE "sparring_event" (
    "event_id" INTEGER,
    "round_id" INTEGER NOT NULL,
    "actor_id" INTEGER NOT NULL, -- Who performed the action.
    "target_id" INTEGER NOT NULL, -- Who received the action.
    "event_type_id" INTEGER NOT NULL,
    "technique_id" INTEGER NULL,
    "points_awarded" INTEGER NOT NULL, -- Submission is recorded as 5 points.
    CHECK("points_awarded" IN (0, 2, 3, 4, 5)), -- 0 is for actions(events) which do not carry points such as 'escapes'.
    PRIMARY KEY("event_id"),
    FOREIGN KEY("round_id") 
    REFERENCES "sparring_round"("round_id")
    ON DELETE CASCADE,
    FOREIGN KEY("actor_id") 
    REFERENCES "athlete"("athlete_id")
    ON DELETE RESTRICT,
    FOREIGN KEY("target_id") 
    REFERENCES "athlete"("athlete_id")
    ON DELETE RESTRICT,
    FOREIGN KEY("event_type_id") 
    REFERENCES "event_type"("event_type_id")
    ON DELETE RESTRICT,
    FOREIGN KEY("technique_id") 
    REFERENCES "technique"("technique_id")
    ON DELETE SET NULL,
    CHECK ("actor_id" <> "target_id") -- Integrity constraint (an athlete cannot perform an action on himself)
);

