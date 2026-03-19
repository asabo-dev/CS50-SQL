CREATE TABLE `Users` (
    -- Add 'user_id' column to allow for easy joins and scalability
    `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `username` VARCHAR(32) NOT NULL UNIQUE,
    `password` VARCHAR(128) NOT NULL,
    PRIMARY KEY(`user_id`)
);


CREATE TABLE `Schools` (
    -- Add 'school_id' column to allow for easy joins and scalability
    `school_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `school_name` VARCHAR(128) NOT NULL UNIQUE,
    `type` ENUM('Primary', 'Secondary', 'Higher Education') NOT NULL,
    `location` VARCHAR(100) NOT NULL,
    `founded_year` YEAR NOT NULL,
    PRIMARY KEY (`school_id`)
);

CREATE TABLE `Companies` (
    -- Add 'company_id' column to allow for easy joins and scalability
    `company_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `company_name` VARCHAR(128) NOT NULL UNIQUE,
    `industry` ENUM('Technology', 'Education', 'Business') NOT NULL,
    `location` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`company_id`)
);

-- Mutual connections between users
CREATE TABLE `People_Connections` (
    `user_1` INT UNSIGNED NOT NULL,
    `user_2` INT UNSIGNED NOT NULL,
    PRIMARY KEY(`user_1`, `user_2`),
    FOREIGN KEY(`user_1`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
    FOREIGN KEY(`user_2`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
    -- Eliminate duplicate mirror relationships by adding the condition user_1 < user_2
    CHECK (user_1 < user_2)
);

-- User connections with schools
CREATE TABLE `School_Connections` (
    -- Use INT type for PK  to allow for easy joins and scalability
    `user_id` INT UNSIGNED NOT NULL,
    `school_id` INT UNSIGNED NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE, -- NULL allowed
    `degree` VARCHAR(50) NULL, -- type of degree earned/pursued (e.g., “BA”, “MA”, “PhD”, etc.)
    PRIMARY KEY(`user_id`, `school_id`, `start_date`),
    FOREIGN KEY(`user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
    FOREIGN KEY(`school_id`) REFERENCES `Schools`(`school_id`) ON DELETE CASCADE,
    -- Add data integrity constraint
    CHECK (`end_date` IS NULL OR `end_date` >= `start_date`)
);

-- User work history
CREATE TABLE `Company_Connections` (
    `user_id` INT UNSIGNED NOT NULL,
    `company_id` INT UNSIGNED NOT NULL,
    `start_date` DATE NOT NULL, -- store as 'YYYY-MM-DD'
    `end_date` DATE, -- NULL allowed
    `job_title` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`user_id`, `company_id`, `start_date`),
    FOREIGN KEY(`user_id`) REFERENCES `Users`(`user_id`) ON DELETE CASCADE,
    FOREIGN KEY(`company_id`) REFERENCES `Companies`(`company_id`) ON DELETE CASCADE,
    -- Add data integrity constraint
    CHECK (`end_date` IS NULL OR `end_date` >= `start_date`)
);

-- Use mysql -h 127.0.0.1 -P 3306 -u root -p (sign into mysql)
-- Type crimson as your password.
-- CREATE DATABASE `linkedin`;
-- USE `linkedin`;
-- SOURCE schema.sql; (to read schema.sql file into `linkedin` DB)
