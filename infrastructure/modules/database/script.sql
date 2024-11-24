-- Description: This script is used to create the database schema.

-- Create the examples table.
CREATE TABLE examples (
    id SERIAL PRIMARY KEY,
    description TEXT
);

-- Insert a record into the examples table.
INSERT INTO examples (description)
VALUES (
     'Hello world!'
);