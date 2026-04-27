---
title: BJJ Analytics
---
```mermaid
erDiagram
    ATHLETE ||--o{ TRAINING_SESSION : owns
    ATHLETE {
        int athlete_id PK
        string name
        string belt_level
    }

    TRAINING_SESSION ||--|{ SPARRING_ROUND : contains
    TRAINING_SESSION {
        int session_id PK
        int athlete_id FK "Main athlete (Athlete A)"
        date session_date
    }

    ATHLETE ||--o{ SPARRING_ROUND : is_opponent_in_round
    SPARRING_ROUND {
        int round_id PK
        int session_id FK
        int opponent_id FK "Opponent (Athlete B)"
    }

    SPARRING_ROUND ||--|{ SPARRING_EVENT : records
    SPARRING_EVENT {
        int event_id PK
        int round_id FK
        int actor_id FK "Performs action"
        int target_id FK "Receives action"
        int event_type_id FK
        int technique_id FK NULL
        int points_awarded NULL
    }

    ATHLETE ||--o{ SPARRING_EVENT : acts_as_actor
    ATHLETE ||--o{ SPARRING_EVENT : acts_as_target

    EVENT_TYPE ||--|| SPARRING_EVENT : categorizes
    EVENT_TYPE {
        int event_type_id PK
        string name 
    }

    TECHNIQUE ||--o| SPARRING_EVENT : specifies
    TECHNIQUE {
        int technique_id PK
        string name 
    }
