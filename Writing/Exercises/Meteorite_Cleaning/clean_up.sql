DROP TABLE IF EXISTS "meteorites";

-- Create permanent table for cleaned up data
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
