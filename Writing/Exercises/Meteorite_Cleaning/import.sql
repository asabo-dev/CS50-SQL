DROP TABLE IF EXISTS "meteorites_temp";

-- name,id,nametype,class,mass,discovery,year,lat,long (according to meteorites.csv)
CREATE TABLE "meteorites_temp" (
    "name" TEXT,
    "id" INTEGER,
    "nametype" TEXT,
    "class" TEXT,
    "mass" REAL,
    "discovery" TEXT,
    "year" NUMERIC,
    "lat" REAL,
    "long" REAL
);

-- Import the csv file into the temporary table
.mode csv
.import meteorites.csv meteorites_temp

-- Start cleaning up the data inside temporary table
-- Remove empty values from csv inside temporary table
UPDATE "meteorites_temp" SET "mass" = NULL
WHERE "mass" = '';

UPDATE "meteorites_temp" SET "year" = NULL
WHERE "year" = '';

UPDATE "meteorites_temp" SET "lat" = NULL
WHERE "lat" = '';

UPDATE "meteorites_temp" SET "long" = NULL
WHERE "long" = '';

-- Round off columns with decimal values to the nearest hundredths place
UPDATE meteorites_temp
SET
    "mass" = ROUND("mass", 2),
    "lat" = ROUND("lat", 2),
    "long" = ROUND("long", 2);

-- Remove all entries in the database where the "nametype" column has the value "Relict"
DELETE FROM "meteorites_temp" WHERE "nametype" = 'Relict';

-- Create permanent table for cleaned up data
DROP TABLE IF EXISTS "meteorites";

CREATE TABLE "meteorites" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "class" TEXT NOT NULL,
    "mass" REAL,
    "discovery" TEXT NOT NULL,
    "year" NUMERIC,
    "lat" REAL,
    "long" REAL,
    PRIMARY KEY("id")
);

-- Sort data by 'year', 'name' columns and move it to the permanent table.
INSERT INTO "meteorites"
    ("name", "class", "mass", "discovery", "year", "lat", "long")
SELECT
    "name", "class", "mass", "discovery", "year", "lat", "long"
FROM "meteorites_temp"
ORDER BY "year" ASC, "name" ASC;

-- Delete the temporary table
DROP TABLE "meteorites_temp";
