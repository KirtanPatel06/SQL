CREATE TABLE seats(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    is_booked BOOLEAN NOT NULL
);

ALTER TABLE seats
ALTER COLUMN is_booked
TYPE INT
USING (is_booked::INT);

INSERT INTO seats (is_booked)
SELECT 0
FROM generate_series(1, 40);

UPDATE seats
SET is_booked = 0, name = NULL
WHERE is_booked = 1;