-- Create a view named "june_vacancies".
-- View contains all listings and number of days in June, 2023 that they remained vacant.
-- View contains "id", "property_type", "host_name" from "listings" table.
-- View contains "days_vacant" (number of days in June, 2023, when listing was available.)

-- DROP VIEW IF EXISTS "june_vacancies";
CREATE VIEW "june_vacancies" AS
SELECT
    "listings"."id",
    "listings"."property_type",
    "listings"."host_name",
    COUNT("availabilities"."date") AS "days_vacant"
FROM "listings"
LEFT JOIN "availabilities"
    ON "listings"."id" = "availabilities"."listing_id"
    AND "availabilities"."date"
        BETWEEN '2023-06-01' AND '2023-06-30'
    AND "availabilities"."available" = 'TRUE'
GROUP BY
    "listings"."id";

-- CHECK IF VIEW PRODUCES THE CORRECT RESULT
-- run:
    -- SELECT COUNT(*) FROM june_vacancies;
-- Output = 3973

-- run:
    -- SELECT COUNT(*) FROM june_vacancies 
    -- WHERE days_vacant > 0;
-- Output = 1895

-- After Check/50, the number of rows expected did not match, even though the querry produced the correct result.

