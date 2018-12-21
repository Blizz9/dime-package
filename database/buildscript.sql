-- This script will be run on the containerized postgres DB during the init-db make command.

-- a simple table to hold a time as a string
CREATE TABLE world_time
(
    id SERIAL PRIMARY KEY,
    time TEXT NOT NULL
);

-- a table to hold the team records
CREATE TABLE teams
(
    id SERIAL PRIMARY KEY,
    year INT NOT NULL,
    name TEXT NOT NULL,
    conference TEXT NOT NULL
);
