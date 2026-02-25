-- Create a view named "frequently_reviewed".
-- View should contain the 100 most frequently reviewed listings.
-- Sorted from most- to least-frequently reviewed.
-- View contains "id", "property_type", "host_name" from "listings" table.
-- View contains "reviews", which is the number of reviews the listing has received.
-- ORDER BY "property_type" ASC, then "host_name" ASC.

-- DROP VIEW IF EXISTS "frequently_reviewed";

CREATE VIEW "frequently_reviewed" AS
SELECT
    "listings"."id" AS "id",
    "listings"."property_type" AS "property_type",
    "listings"."host_name" AS "host_name",
    COUNT("reviews"."id") AS "reviews"
FROM "listings"
JOIN "reviews" 
ON "listings"."id" = "reviews"."listing_id"
GROUP BY "listings"."id"
ORDER BY "reviews" DESC,
"listings"."property_type" ASC,
"listings"."host_name" ASC
LIMIT 100;

-- CHECK IF VIEW PRODUCES THE CORRECT RESULT
-- run:
    -- SELECT * FROM frequently_reviewed LIMIT 1;
-- (Output) The top row should show:
    -- Host: Tiffany
    -- Reviews: 860