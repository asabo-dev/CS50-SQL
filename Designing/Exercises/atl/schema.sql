-- First name, last name, and age. That’s all we need to know
CREATE TABLE "Passengers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "age" INTEGER,
    PRIMARY KEY("id")
);

-- The exact date and time at which our passenger checked in.
-- The flight they are checking in for.
CREATE TABLE "Check_Ins" (
    "passenger_id" INTEGER,
    "check_in_time" TEXT NOT NULL, -- store as 'YYYY-MM-DD HH:MM:SS'
    "flight_id" TEXT NOT NULL,
    FOREIGN KEY("passenger_id") REFERENCES "Passengers"("id"),
    FOREIGN KEY("flight_id") REFERENCES "Flights"("flight_number")
);

-- The name of the airline
-- The “concourse”, the section of our airport where the airline operates. 
CREATE TABLE "Airlines" (
    "name" TEXT,
    PRIMARY KEY("name")
);

-- We have 7 concourses: A, B, C, D, E, F, and T.
CREATE TABLE "Airline_Concourses" (
    "airline_name" TEXT,
    "concourse" TEXT,
    PRIMARY KEY("airline_name", "concourse"),
    FOREIGN KEY("airline_name") REFERENCES "Airlines"("name")
);

-- The flight number. For example, “900”.
-- The airline operating the flight. 
-- The code of the airport they’re departing from. For example, “ATL” or “BOS”.
-- The code of the airport they’re heading to.
-- The expected departure date and time (to the minute, of course!).
-- The expected arrival date and time, to the very same accuracy.

CREATE TABLE "Flights" (
    "flight_number" TEXT,
    "airline_name" TEXT NOT NULL,
    "departure_airport" TEXT NOT NULL,
    "arrival_airport" TEXT NOT NULL,
    "departure_time" TEXT NOT NULL, -- store as 'YYYY-MM-DD HH:MM:SS'
    "arrival_time" TEXT NOT NULL, -- store as 'YYYY-MM-DD HH:MM:SS'
    PRIMARY KEY("flight_number"),
    FOREIGN KEY("airline_name") REFERENCES "Airlines"("name")

);