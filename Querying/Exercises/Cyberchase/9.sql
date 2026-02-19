-- Query that counts the number of episodes released in Cyberchase’s first 6 years.
-- From 2002 to 2007, inclusive.

SELECT COUNT("id") FROM "episodes"
WHERE "air_date" <= '2007-12-12';
