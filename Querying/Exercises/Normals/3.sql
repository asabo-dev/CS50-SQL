-- Choose a location of your own. 
-- Query DB to find the normal temperature at 0 meters, 100 meters, and 200 meters.

SELECT "0m", "100m", "200m" FROM "normals" 
WHERE "latitude" = 4.67
AND "longitude" =  8.41;
