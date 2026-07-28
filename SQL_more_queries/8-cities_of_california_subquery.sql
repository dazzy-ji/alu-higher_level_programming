-- Lists all the cities of California without using the JOIN keyword
-- The state id is resolved with a subquery on the states table
SELECT id, name FROM cities
    WHERE state_id = (SELECT id FROM states WHERE name = 'California')
    ORDER BY id ASC;
