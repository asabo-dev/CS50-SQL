-- Create a new table to store data
DROP TABLE IF EXISTS "cipher";

CREATE TABLE "cipher" (
    "sentence_number" INTEGER NOT NULL,
    "character_number" INTEGER NOT NULL,
    "message_length" INTEGER NOT NULL,
    FOREIGN KEY("sentence_number") REFERENCES "sentences"("id")
);

-- Add given data to the new table "cipher"
INSERT INTO "cipher"
("sentence_number", "character_number", "message_length")
VALUES
(14, 98, 4),
(114, 3, 5),
(618, 72, 9),
(630, 7, 3),
(932, 12, 5),
(2230, 50, 7),
(2346, 44, 10),
(3041, 14, 5)
;

-- Use Join to establish relationship between "sentences" and "cipher" tables.
-- Create a View to decipher the given data.
DROP VIEW IF EXISTS "message";

CREATE VIEW "message" AS
SELECT substr("sentences"."sentence",
"cipher"."character_number", "cipher"."message_length")
AS "phrase" FROM "cipher"
JOIN "sentences" ON
"cipher"."sentence_number" = "sentences"."id"
ORDER BY "cipher"."sentence_number";



