-- Create a view named available.
-- This View should contain all dates that are "available" at all listings.
-- View contains the following columns from "listings" table:
-- "id", "property_type", "host_name".
-- View contains "date", from the "availabilities" table.

-- DROP VIEW IF EXISTS "available";

CREATE VIEW "available" AS
SELECT
    "listings"."id",
    "listings"."property_type",
    "listings"."host_name",
    "availabilities"."date"
FROM "listings"
JOIN "availabilities" 
ON "listings"."id" = "availabilities"."listing_id"
WHERE "availabilities"."available" = 'TRUE';

-- CHECK IF VIEW PRODUCES THE CORRECT RESULT
-- run:
    -- SELECT COUNT(*)
    -- FROM available
    -- WHERE date = '2023-12-31';
-- Output = 2251

-- run:
    -- SELECT COUNT(*)
    -- FROM "available"
    -- WHERE "date" = '2023-12-31'
    -- AND "property_type" LIKE '%Boat%';
-- Output = 7