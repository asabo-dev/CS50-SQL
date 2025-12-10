CREATE TABLE "Passengers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "age" INTEGER,
    PRIMARY KEY("id")
);

CREATE TABLE "Check_Ins" (
    "passenger_id" INTEGER,
    "check_in_time" TEXT NOT NULL, -- store as 'YYYY-MM-DD HH:MM:SS'
    "flight_id" TEXT NOT NULL,
    FOREIGN KEY("passenger_id") REFERENCES "Passengers"("id"),
    FOREIGN KEY("flight_id") REFERENCES "Flights"("flight_number")
);

CREATE TABLE "Airlines" (
    "name" TEXT,
    PRIMARY KEY("name")
);

CREATE TABLE "Airline_Concourses" (
    "airline_name" TEXT,
    "concourse" TEXT,
    PRIMARY KEY("airline_name", "concourse"),
    FOREIGN KEY("airline_name") REFERENCES "Airlines"("name")
);

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