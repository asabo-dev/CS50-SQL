---
title: BJJ Analytics
---

erDiagram

    %% CORE ENTITY: ATHLETE
    ATHLETE {
        int athlete_id PK
        string name
        string belt_level
        string weight_class
        string age_category
        datetime created_at
    }

    %% TRAINING SESSION
    %% Defines the "main athlete" (Athlete A)
    TRAINING_SESSION {
        int session_id PK
        int athlete_id FK  "Main athlete (Athlete A)"
        date session_date
        string notes
    }

    %% SPARRING ROUND
    %% Defines opponent (Athlete B)
    %% Only 2 participants exist:
    %% - Athlete A (via session)
    %% - Opponent (via opponent_id)
    SPARRING_ROUND {
        int round_id PK
        int session_id FK
        int opponent_id FK  "Opponent athlete"
        int duration_minutes
    }

    %% SPARRING EVENT
    %% Records all actions during a round
    SPARRING_EVENT {
        int event_id PK
        int round_id FK

        int actor_id FK     "Who performed the action"
        int target_id FK    "Who received the action"

        int event_type_id FK
        int technique_id FK NULL

        int points_awarded NULL
        int event_time
    }

    %% EVENT TYPE (IBJJF LOGIC)
    EVENT_TYPE {
        int event_type_id PK
        string name
        int ibjjf_points NULL
    }

    %% TECHNIQUE (OPTIONAL DETAIL)
    TECHNIQUE {
        int technique_id PK
        string name
        string position
    }


    %% RELATIONSHIPS

    %% One athlete can have many training sessions
    ATHLETE ||--o{ TRAINING_SESSION : owns

    %% One session has many rounds
    TRAINING_SESSION ||--|{ SPARRING_ROUND : contains

    %% Each round has exactly one opponent
    ATHLETE ||--o{ SPARRING_ROUND : is_opponent

    %% One round has many events
    SPARRING_ROUND ||--|{ SPARRING_EVENT : records

    %% Events track both actor and target (both are athletes)
    ATHLETE ||--o{ SPARRING_EVENT : acts_as_actor
    ATHLETE ||--o{ SPARRING_EVENT : acts_as_target

    %% Each event has one type
    EVENT_TYPE ||--|| SPARRING_EVENT : categorizes

    %% Technique is optional for an event
    TECHNIQUE ||--o| SPARRING_EVENT : specifies