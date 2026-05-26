---
title: BJJ Performance Analysis
---
erDiagram
    ATHLETE ||--o{ TRAINING_SESSION : owns
    ATHLETE {
        int athlete_id PK
        text name
        text belt_level
    }

    TRAINING_SESSION ||--|{ SPARRING_ROUND : contains
    TRAINING_SESSION {
        int session_id PK
        int athlete_id FK 
        datetime session_date
    }

    ATHLETE ||--o{ SPARRING_ROUND : is_opponent_in_round
    SPARRING_ROUND {
        int round_id PK
        int session_id FK
        int opponent_id FK 
    }

    SPARRING_ROUND ||--|{ SPARRING_EVENT : records
    SPARRING_EVENT {
        int event_id PK
        int round_id FK
        int actor_id FK 
        int target_id FK 
        int event_type_id FK
        int technique_id FK 
    }

    ATHLETE ||--o{ SPARRING_EVENT : acts_as_actor
    ATHLETE ||--o{ SPARRING_EVENT : acts_as_target

    EVENT_TYPE ||--o{ SPARRING_EVENT : categorizes
    EVENT_TYPE {
        int event_type_id PK
        text name 
    }

    TECHNIQUE ||--o{ SPARRING_EVENT : specifies
    TECHNIQUE {
        int technique_id PK
        text name 
    }

