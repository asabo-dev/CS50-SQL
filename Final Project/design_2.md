# Design Document

By Efiom Ndaeyo

Video overview: <URL HERE>

## Scope

* WHAT IS THE PURPOSE OF THIS DATABASE? 
This is a relational database that tracks Brazilian Jiu Jitsu (BJJ) training sessions, techniques and performance outcomes, enabling athletes to analyze progress and optimize training.

The purpose of the database is to enable athletes to measure improvement using meaningful performance indicators such as frequency of successful techniques, positional dominance, and effectiveness against different opponents.

The database tracks both offensive and defensive actions during sparring rounds by recording the actor responsible for each event. This enables analysis of not only successful techniques but also defensive performance, such as escapes and resistance to opponent actions.


* Which people, places, things, etc. are you including in the scope of your database?
Data is collected from regular BJJ practitioners (athletes) in a typical martial arts gym. Each training session consists of several sparring rounds in which BJJ athletes executes different techniques against each other within alotted time for the round.

The database includes:
    - Athletes (BJJ practitioners who participate in training).
    - Training session (individual BJJ training sessions or classes).
    - Sparring rounds (distinct, time limited sparring round during a training session).
    - Sparring event (successful execution of a BJJ technique against an opponent).
    - Event type (abstract category of BJJ actions that is awarded points e.g sweeps, takedowns, positional advancement).
    - Technique (specific description or name of the BJJ technique being executed e.g "armbar from closed guard", "triangle from mount" etc).

* Which people, places, things, etc. are *outside* the scope of your database?
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

### Entities

In this section you should answer the following questions:
* Which entities will you choose to represent in your database?
* What attributes will those entities have?
* Why did you choose the types you did?
* Why did you choose the constraints you did?

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
This represents specific BJJ techniques used during sparring. 

The `technique` table includes:

* `technique_id`, which specifies the unique ID for a BJJ technique during sparring, as an `INTEGER`. This column has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the name of the technique, as `TEXT`, given `TEXT` is appropriate for string fields. This column has a UNIQUE constraint to avoid duplicates or inconsistent entries (e.g 'double leg takedown' vs 'double_leg take down').

** Design Choices:
- Separates technique specificity from event abstraction.
- Enables detailed analysis of technique effectiveness.

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

## Optimizations

In this section you should answer the following questions:

* Which optimizations (e.g., indexes, views) did you create? Why?

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?
* What might your database not be able to represent very well?
