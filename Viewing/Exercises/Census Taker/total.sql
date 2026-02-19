-- Sums for each numeric column in census, across all districts and localities
DROP VIEW IF EXISTS "total";

CREATE VIEW "total" AS
SELECT
SUM("families") AS "families",
SUM("households") AS "households",
SUM("population") AS "population",
SUM("male") AS "male",
SUM("female") AS "female"
FROM "census";
