CREATE TABLE "created" (
    "artist_id" INTEGER,
    "collection_id" INTEGER,
    PRIMARY KEY("artist_id", "collection_id"),
    FOREIGN KEY("artist_id") REFERENCES "artists"("id"),
    FOREIGN KEY("collection_id") REFERENCES "collections"("id")
);

INSERT INTO "created" ("artist_id", "collection_id")
VALUES 
((SELECT "id" FROM "artists" WHERE "name" = 'Li Yin'), (SELECT "id" FROM "collections" WHERE "title" = 'Imaginative landscape')),
((SELECT "id" FROM "artists" WHERE "name" = 'Qian Weicheng'), (SELECT "id" FROM "collections" WHERE "title" = 'Profusion of flowers')),
((SELECT "id" FROM "artists" WHERE "name" = 'Unidentified artist'), (SELECT "id" FROM "collections" WHERE "title" = 'Farmers working at dawn')),
((SELECT "id" FROM "artists" WHERE "name" = 'Zhou Chen'), (SELECT "id" FROM "collections" WHERE "title" = 'Spring outing'));
