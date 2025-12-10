CREATE TABLE "Users" (
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT,
    "password" TEXT NOT NULL, 
    PRIMARY KEY("username")
);

CREATE TABLE "Schools" (
    "school_name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "founded_year" INTEGER NOT NULL,
    PRIMARY KEY ("school_name")
);

CREATE TABLE "Companies" (
    "company_name" TEXT NOT NULL,
    "industry" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY ("company_name")
);

-- Mutual connections between users
CREATE TABLE "People_Connections" (
    "user_1" TEXT NOT NULL,
    "user_2" TEXT NOT NULL,
    PRIMARY KEY("user_1", "user_2"),
    FOREIGN KEY("user_1") REFERENCES "Users"("username"),
    FOREIGN KEY("user_2") REFERENCES "Users"("username"),
    CHECK (user_1 <> user_2)
);

-- User connections with schools
CREATE TABLE "School_Connections" (
    "username" TEXT NOT NULL,
    "name_of_school" TEXT NOT NULL,
    "start_date" TEXT NOT NULL, -- store as 'YYYY-MM-DD'
    "end_date" TEXT, -- NULL allowed
    "degree" TEXT,
    PRIMARY KEY("username", "name_of_school", "start_date"),
    FOREIGN KEY("username") REFERENCES "Users"("username"),
    FOREIGN KEY("name_of_school") REFERENCES "Schools"("school_name")
);

-- User work history
CREATE TABLE "Company_Connections" (
    "username" TEXT NOT NULL,
    "name_of_company" TEXT NOT NULL,
    "start_date"TEXT NOT NULL, -- store as 'YYYY-MM-DD'
    "end_date" TEXT, -- NULL allowed
    "job_title" TEXT NOT NULL,
    PRIMARY KEY ("username", "name_of_company", "start_date"),
    FOREIGN KEY("username") REFERENCES "Users"("username"),
    FOREIGN KEY("name_of_company") REFERENCES "Companies"("company_name")
);