-- This script will be run on the containerized postgres DB during the init-db make command.

-- a simple table to hold a time as a string
CREATE TABLE world_time
(
    id SERIAL PRIMARY KEY,
    time TEXT NOT NULL
);
