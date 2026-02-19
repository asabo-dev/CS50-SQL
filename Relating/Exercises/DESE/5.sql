-- Find cities with 3 or fewer public schools.
-- Your query should return the names of the cities and the number of public schools within them.
-- Ordered from greatest number of public schools to least.
-- If two cities have the same number of public schools, order them alphabetically.

SELECT "city", COUNT("type")
AS "Number Of Public Schools"
FROM "schools" WHERE "type" = 'Public School'
GROUP BY "city"
HAVING COUNT("type") <= 3
ORDER BY "Number Of Public Schools" DESC, "city";
