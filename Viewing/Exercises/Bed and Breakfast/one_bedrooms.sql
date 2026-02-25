-- Create a View named "one_bedrooms".
-- This view should contain all listings that have exactly one bedroom.
-- View must contain the following columns from the "listings" table:
-- "id", "property_type", "host_name", "accommodates".

-- DROP VIEW IF EXISTS "one_bedrooms";

CREATE VIEW "one_bedrooms" AS
SELECT
    "id", "property_type",
    "host_name", "accommodates"
FROM "listings"
WHERE "bedrooms" = 1;

-- CHECK IF VIEW PRODUCES THE CORRECT RESULT
-- run:
    -- SELECT COUNT(*) FROM "one_bedrooms";
-- Output = 1228

-- run:
    -- SELECT COUNT(*)
    -- FROM "one_bedrooms"
    -- WHERE "accommodates" >= 4;
-- Output = 222