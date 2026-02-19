
-- *** The Lost Letter ***

-- Identify the specific "id" of the package then use the "id" to track its scans.
SELECT * FROM "scans" WHERE "package_id" = (
    SELECT "id" FROM "packages" WHERE
    "contents" LIKE '%congratulatory %'
);

-- Identify the address where the package was dropped off.
SELECT * FROM "addresses" WHERE "id" = (
    SELECT "address_id" FROM "scans"
    WHERE "action" = 'Drop'
);

-- Identify the contents of the package.
SELECT "contents" FROM "packages"
WHERE "contents" LIKE '%congratulatory %';


-- *** The Devious Delivery ***

-- Use the clue to find the package which has "duck" in its contents and the from_address_id is not given
SELECT * FROM "packages"
WHERE "contents" LIKE '%duck%'
AND "from_address_id" IS NULL;

-- Use the package ID to find the latest scan on the package to determine its current location.
SELECT * FROM "scans" WHERE "package_id" = '5098'
ORDER BY "timestamp" DESC LIMIT 1;

-- Use the address_id from the last scan to determine the type of address.
SELECT * FROM "addresses" WHERE "id" = '348';


-- *** The Forgotten Gift ***

-- Use the address given to find the "id" of the address then use that to find "contents" of the package.
SELECT * FROM "packages"
WHERE "to_address_id" = (
    SELECT "id" FROM "addresses"
    WHERE "address" = '728 Maple Place'
);

-- Use the package ID to find out where and when the package was scanned last.
SELECT * FROM "scans" WHERE "package_id" = (
    SELECT "id" FROM "packages"
    WHERE "to_address_id" = (
        SELECT "id" FROM "addresses"
        WHERE "address" = '728 Maple Place'
    )
) ORDER BY "timestamp" DESC LIMIT 1;

-- Identify the last known location of the package using the last scan's address_id.
SELECT * FROM "addresses" WHERE "id" = '7432';

-- Identify the driver of the package using the driver_id from the last scan.
SELECT "name" FROM "drivers" WHERE "id" = (
    SELECT "driver_id" FROM "scans"
    WHERE "driver_id" = '17'
);

