-- Query to find the names and cities of all public schools in Massachusetts.

SELECT "name", "city" FROM "schools"
WHERE "type" = 'Public School'
AND "state" = 'MA';
