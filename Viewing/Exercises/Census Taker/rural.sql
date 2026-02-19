-- This view contains all census records relating to a rural municipality 

DROP VIEW IF EXISTS "rural";

CREATE VIEW "rural" AS
SELECT * FROM "census"
WHERE LOWER("locality") LIKE '%rural%';
