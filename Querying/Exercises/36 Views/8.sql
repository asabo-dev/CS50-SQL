-- Query to list the English titles of the 5 prints with the least contrast by Hokusai.
-- ORDER BY from least to highest contrast. 

SELECT "english_title" FROM "views" 
WHERE "artist" = 'Hokusai'
ORDER BY "contrast" ASC LIMIT 5;
