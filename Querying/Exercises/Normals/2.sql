-- Query to find the normal temperature of the deepest sensor near the Gulf of Maine.
-- With 42.5° of latitude and -69.5° of longitude.
-- The deepest sensor records temperatures at 225 meters of depth (225m column).

SELECT "225m" FROM "normals" WHERE "latitude" = 42.5
AND "longitude" =  -69.5;
