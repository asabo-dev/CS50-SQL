# Design Document

By Efiom Ndaeyo

Video overview: <https://youtu.be/AVmqEQmNKz0?si=2HuXbAv6Nrx_L0FA>

## Scope

* WHAT IS THE PURPOSE OF THIS DATABASE? 
This is a relational database that tracks Brazilian Jiu Jitsu (BJJ) training sessions, techniques and performance outcomes, enabling athletes to analyze progress and optimize training.
The purpose of the database is to enable athletes to measure improvement using meaningful performance indicators such as frequency of successful techniques, positional dominance, and effectiveness against different opponents.
Data is collected from regular BJJ practitioners (athletes) in a typical martial arts gym. As such, included in the database's scope is:

* Athletes: BJJ practitioners who participate in training.
* Training Session: Individual BJJ training sessions or classes.
* Sparring Round: Distinct, time limited sparring round.
* Sparring Event: Successful execution of a BJJ technique against an opponent.
* Event Type: Abstract category of BJJ actions that is awarded points (e.g sweeps, takedowns, positional advancement).
* Technique: Specific description or name of the BJJ technique being executed.

The following are intentionally excluded from this database:
    - Video storage or streaming of BJJ matches.
    - Social engagement features such as likes, comments, followers.
    - Payment systems or subscriptions.
    - Real time match tracking system.
    - Strict enforcemment of IBJJF competition rules.


## Functional Requirements
In this section you should answer the following questions:

* What should a user be able to do with your database?
Users of the database should be able to:
    - Record training sessions and associated sparring rounds.
    - Log multiple sparring rounds against different opponents.
    - Record events during sparring rounds such as:
        * Positional advancement (e.g guard pass, mount, back-take).
        * Transitions (e.g takedowns, sweeps).
        * Submissions (e.g "rare naked choke", "armbar").
    - Associate events during sparring with specific techniques.
    - Analyze performance over time using:
        * Success rate of techniques.
        * Frequency of specific actions.
        * Performance against selected opponent(s).
    - Commpute performance metrics such as total points per round, using IBJJF-inspired scoring.


* What's beyond the scope of what a user should be able to do with your database?
The database does not:
    - Enforce rules or validate correctness of recorded events.
    - Provide real-time analytics during sparring.
    - Track physiological data (e.g heartrate, fatigue).
    - Automatically infer techniques from video or sensors.


## Representation

The database includes the following entities:

#### Athlete
Represents individuals who participate in regular BJJ training.

The `athlete` table includes:

* `athlete_id`, which specifies the unique ID for BJJ athletes as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the athlete's name as `TEXT`, given `TEXT` is appropriate for name fields.
* `belt_level`, which specifies the athlete's rank as `TEXT`, given `TEXT` is appropriate for string fields. Column constraint ensures that only acceptable input is stored e.g. 'Purple', 'Blue', 'White'.
* `weight_class`, which specifies the athlete's weight division as `TEXT`, given `TEXT` is appropriate for string fields. Column constraint ensures that only acceptable input is stored e.g. 'Lightweight', 'Middleweight', 'Heavyweight'.
* `age_category`, which specifies the athlete's age category as `TEXT`, given `TEXT` is appropriate for string fields. Column constraint ensures that only acceptable input is stored e.g. 'Adult', 'Master 1', 'Master 2'.
* `created_at`, which stores the date and time the athlete record was created. SQLite represents timestamps using the `NUMERIC` type, and this column uses `DEFAULT CURRENT_TIMESTAMP` to automatically capture the insertion time.

** Design Choices:
- A single athletes table is used to represent both primary athletes and their opponents. This avoids duplication and enables self-referential relationships when recording sparring interactions.

- IBJJF competition divisions are used instead of raw numerical values (e.g age or weight). This simplifies grouping, improves readability and aligns the database structure with real-world competition standards.

#### Event_Type
Represents predefined classifications of actions that can occur during sparring, including their scoring rules.

The `event_type` table includes:

* `event_type_id`, which specifies the unique ID for an event during sparring, as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the name of the event, as `TEXT`, given `TEXT` is appropriate for string fields. This column has a UNIQUE constraint to avoid duplicates or inconsistent entries (e.g 'takedown' vs 'take down').
* `is_submission`, which indicates whether an event represents a submission technique. This is stored as an INTEGER flag (0=FALSE, 1=TRUE), with a default value of 0. This allows easy filtering of submission-related events in queries.
* `default_points` which defines the number of points awarded for the event type based on IBJJF-inspired scoring rules (e.g., 2 points for a takedown, 4 points for mount). The INTEGER type is appropriate as scoring values are discrete.
    
** Design Choices:
- The event_type table separates abstract definitions of events from their actual occurrences during sparring. This reduces redundancy and ensures consistency when assigning meaning and scoring to events.
- Using a reference table for event types allows the system to be easily extended. For example, new techniques or scoring rules can be added without modifying existing sparring data.
- The inclusion of default_points enables standardized scoring while still allowing flexibility for overrides at the event level if needed.
- The is_submission flag simplifies analytical queries, such as calculating submission success rates or filtering submission-only events.

#### Technique
Represents specific Brazilian Jiu Jitsu (BJJ) techniques that can be executed during sparring. 

The `technique` table includes:

* `technique_id`, which specifies the unique identifier for each technique as an INTEGER. This column has the PRIMARY KEY constraint to ensure each technique is uniquely identifiable.
* `name`, which specifies the name of the technique as TEXT. A UNIQUE constraint is applied to prevent duplicate or inconsistent entries (e.g., 'double leg takedown' vs 'double_leg take down').

** Design Choices:
- The technique table separates the specific execution of a move from the broader classification defined in the event_type table. For example, a "takedown" is an event type, while a "double leg takedown" is a specific technique.
- This separation avoids redundancy and allows multiple techniques to be associated with a single event type without duplicating data.
- Storing techniques independently enables more detailed analysis, such as identifying the most frequently used or most effective techniques for an athlete.
- The UNIQUE constraint on the name column ensures consistency in naming, which is important for accurate querying and aggregation.

#### Training_Session
Represents a Brazilian Jiu Jitsu (BJJ) class or training session during which sparring activities are recorded.

The `training_session` table includes:

* `session_id`, which specifies the unique identifier for each training session as an INTEGER. This column has the PRIMARY KEY constraint to ensure each session is uniquely identifiable.
* `athlete_id`, which specifies the athlete whose performance is being tracked during the session, as an INTEGER. This column is a FOREIGN KEY referencing athlete(athlete_id), ensuring referential integrity.
* `session_date`, which stores the date the training session occured. This column uses the `DATETIME` type to clearly represent temporal data. Using DATETIME improves schema readability and makes the intended use of the column explicit. The column uses `DEFAULT CURRENT_TIMESTAMP` to automatically record the session time when no value is provided.
* `notes`, which stores optional comments about the training session as TEXT. This column allows NULL values, making it optional.

** Design Choices:
- Each training session is associated with a single athlete (Athlete A), representing the primary subject of performance analysis. Opponents are recorded separately in sparring-related tables, allowing flexible modeling of interactions.
- The training_session table provides a time-based grouping for sparring rounds and events, enabling analysis of performance over time (e.g., progress across sessions).
- Allowing multiple sessions per day reflects real-world training scenarios where athletes may attend more than one class or session.
- Storing timestamps enables time-based queries, such as filtering sessions by date range or analyzing performance trends over time.
- Values are stored in ISO 8601 format (YYYY-MM-DD HH:MM:SS) for consistency and compatibility with SQLite date functions.

#### Sparring_Round
Represents individual sparring rounds that occur during a BJJ training session. 

The `sparring_round` table includes:

* `round_id`, which specifies the unique identifier for each sparring round as an `INTEGER`. This column has the `PRIMARY KEY` constraint to ensure each round is uniquely identifiable.
* `session_id`, which specifies the training session in which the sparring round occurred. This column is a `FOREIGN KEY` referencing `session_id` in the `training_session` table. The `ON DELETE CASCADE` constraint ensures that when a training session is deleted, all associated sparring rounds are automatically removed, maintaining data consistency.
* `opponent_id`, which specifies the athlete who participates in the round against the primary athlete (Athlete A). This column is a `FOREIGN KEY` referencing `athlete`(`athlete_id`). The `ON DELETE RESTRICT` constraint prevents deletion of an athlete record if it is referenced in any sparring round, thereby preserving referential integrity.
* `duration`, which records the length of time (minutes) for the sparring round, as an `INTEGER`. A `CHECK` constraint ensure that only reasonable values are stored, preventing invalid data entry.

** Design Choices:
- A sparring round can only happen during a training session.
- Each round models an interaction between two participants: the primary athlete (linked via the `training_session`) and an opponent (linked via `opponent_id`).
- The `opponent_id` creates a self-referential relationship within the `athlete` table, allowing all participants to be stored in a single unified entity without duplication.
- Separating sparring rounds from training sessions enables more granular analysis, such as evaluating performance across individual rounds rather than entire sessions.

#### Sparring_Event
Represents individual actions performed between athletes during sparring rounds.

The `sparring_event` table includes:

* `event_id`, which specifies the unique identifier for each sparring event as an `INTEGER`. This column has the `PRIMARY KEY` constraint to ensure each event is uniquely identifiable.
* `round_id`, which specifies the sparring round in which the event occurred, as an `INTEGER`. This column is a `FOREIGN KEY` referencing `sparring_round`(`round_id`). The `ON DELETE CASCADE` constraint ensures that when a sparring round is deleted, all associated events are also removed.
* `actor_id`, which specifies the athlete who performed the action, as an `INTEGER`. This column is a `FOREIGN KEY` referencing `athlete`(`athlete_id`). The `ON DELETE RESTRICT` constraint prevents deletion of an athlete if they are referenced in any sparring event.
* `target_id`, which specifies the athlete on whom the action was performed, as an `INTEGER`. This column is a `FOREIGN KEY` referencing `athlete`(`athlete_id`). The `ON DELETE RESTRICT` constraint ensures referential integrity, similar to actor_id.
* `event_type_id`, which specifies the type of action performed, as an `INTEGER`. This column is a `FOREIGN KEY` referencing `event_type`(`event_type_id`). The `ON DELETE RESTRICT` constraint prevents deletion of an event type that is in use, preserving classification consistency.
* `technique_id`, which specifies the technique used to execute the action, as an `INTEGER`. This column is a `FOREIGN KEY` referencing `technique`(`technique_id`). The `ON DELETE SET NULL` constraint allows the technique to be optional, as not all events require a specific technique classification.

** Design Choices:
- The sparring_event table is the core of the database, capturing granular interactions between athletes. All performance analysis is derived from these recorded events.
- The use of both actor_id and target_id enables modeling of directional interactions, allowing analysis of both offensive actions (performed by the actor) and defensive outcomes (experienced by the target).
- A constraint ensures that an athlete cannot perform an action on themselves (e.g., `actor_id` != `target_id`), preserving logical consistency.
- The event-based design provides flexibility and scalability, allowing new event types and techniques to be incorporated without altering the schema.


### Relationships

* Entity Relationship Diagram 
![BJJ Performance Analysis ER Diagram](bjj_analysis.png)

The database includes the following relationships:
* An athlete can have many training sessions (one to many relationship).
* A training session can have many sparring rounds (one to many relationship).
* Each sparring round involves two athletes: the primary athlete (Athlete A), linked through the training session, and an opponent (Athlete B), linked via a foreign key in the `sparring_round` table.
* A sparring round can have many sparring events (one to many relationship).
* An athlete can participate in many sparring events, either as the actor (performing an action) or as the target (receiving an action), forming two distinct relationships with the `sparring_event` table.
* Each sparring event is associated with one event type, while an event type can be associated with many sparring events (many to one relationship).
* Each sparring event may optionally reference a technique, allowing flexibility as not all events require a specific technique classification (many to one relationship).


## Optimizations

In this section you should answer the following questions:

To improve query performance, indexes were created on the `sparring_event` table, which serves as the core table for performance analysis. Since most analytical queries involve filtering and aggregating data from this table, indexing key foreign key columns significantly reduces query execution time.

The following indexes were implemented:

* An index on `sparring_event`(`actor_id`) to optimize queries that analyze actions performed by a specific athlete, such as calculating total points scored or frequency of techniques used.
* An index on `sparring_event`(`target_id`) to improve performance of queries that analyze defensive performance, such as tracking how often an athlete concedes points or is subjected to specific techniques.
* An index on `sparring_event`(`round_id`) to optimize queries that filter events within a specific sparring round, enabling efficient retrieval of round-level performance data.

While individual indexes were sufficient for the current scope of queries, a composite index (e.g., on (`actor_id`, `round_id`)) could be considered for further optimization of more complex filtering conditions. Views were not implemented, as the current queries can be efficiently executed using indexed tables.


## Limitations

* The database relies on manual data entry, which may result in incomplete or inaccurate records if events are missed or incorrectly logged.
* The schema does not capture contextual factors such as fatigue, injuries, or fitness levels, limiting the ability to explain performance outcomes.
* While constraints enforce structural integrity, they cannot guarantee data accuracy; incorrect or dishonest inputs may lead to misleading analysis.