-- This script will be run on the containerized postgres DB during the init-db make command.

-- insert a starting record into the example table we have created
INSERT INTO world_time(id, time) VALUES (1, 'BLAH');
SELECT setval('world_time_id_seq', 1);
