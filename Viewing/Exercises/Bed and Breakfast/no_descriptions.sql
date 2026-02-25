-- Create a View named "no_descriptions".
-- View includes all the columns in "listings" except "description".

-- DROP VIEW IF EXISTS "no_descriptions";

CREATE VIEW "no_descriptions" AS
SELECT
    "id", "property_type", "host_name",
    "accommodates", "bedrooms"
FROM "listings";

-- CHECK IF VIEW PRODUCES THE CORRECT RESULT
-- run:
    -- SELECT COUNT(*) FROM "no_descriptions";
-- Output = 3973

-- run: 
    -- SELECT * FROM "no_descriptions" LIMIT 5;