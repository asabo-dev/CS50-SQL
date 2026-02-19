-- This view contains, from greatest to least, the most populated districts in Nepal
DROP VIEW IF EXISTS "most_populated";

CREATE VIEW "most_populated" AS
SELECT
"district",
SUM("families") AS "families",
SUM("households") AS "households",
SUM("population") AS "population",
SUM("male") AS "male",
SUM("female") AS "female"
FROM "census"
GROUP BY "district"
ORDER BY "population" DESC;
