CREATE TABLE ipl_players (
    player_id SERIAL PRIMARY KEY,

    name VARCHAR(100) NOT NULL,
    team VARCHAR(50),

    role VARCHAR(50),
    runs_scored INT CHECK (runs_scored >= 0),
    wickets_taken INT CHECK (wickets_taken >= 0),

    auction_price_crores DECIMAL(5, 2)
);

ALTER TABLE ipl_players
ADD COLUMN nickname VARCHAR(50);

INSERT INTO ipl_players (name,team,role,runs_scored,wickets_taken,auction_price_crores,nickname)
VALUES
('Virat Kohli', 'Royal Challengers Bengaluru', 'Batsman', 741, 0, 21.00, 'King Kohli'),
('Rohit Sharma', 'Mumbai Indians', 'Batsman', 417, 0, 16.30, 'Hitman'),
('Jasprit Bumrah', 'Mumbai Indians', 'Bowler', 0, 20, 18.00, 'Boom Boom'),
('MS Dhoni', 'Chennai Super Kings', 'Wicketkeeper-Batsman', 161, 0, 12.00, 'Thala'),
('Ravindra Jadeja', 'Chennai Super Kings', 'All-Rounder', 267, 13, 16.00, 'Sir Jadeja'),
('KL Rahul', 'Delhi Capitals', 'Wicketkeeper-Batsman', 520, 0, 14.00, 'KL'),
('Rishabh Pant', 'Lucknow Super Giants', 'Wicketkeeper-Batsman', 446, 0, 27.00, 'RP17'),
('Shubman Gill', 'Gujarat Titans', 'Batsman', 890, 0, 16.50, 'Prince'),
('Hardik Pandya', 'Mumbai Indians', 'All-Rounder', 216, 11, 15.00, 'Kung Fu Pandya'),
('Yuzvendra Chahal', 'Punjab Kings', 'Bowler', 0, 18, 18.00, 'Yuzi'),
('Sunil Narine', 'Kolkata Knight Riders', 'All-Rounder', 488, 17, 12.75, 'Carrom King');

SELECT * FROM ipl_players;

SELECT name, nickname, team FROM ipl_players;


-- Filtering
SELECT * FROM ipl_players WHERE team = 'Mumbai Indians';    --Use Single Quotes('')

SELECT name, auction_price_crores FROM ipl_players WHERE auction_price_crores > 20


-- Logical Operators (AND & OR)
SELECT * FROM ipl_players WHERE wickets_taken >= 15 AND role = 'All-Rounder';

SELECT * FROM ipl_players WHERE team = 'Chennai Super Kings' OR team = 'Royal Challengers Bengaluru';


-- Pattern Matching
SELECT * FROM ipl_players WHERE name LIKE '_a%';    
-- '_'represents a single position & '%' represents the rest of the positions

SELECT * FROM ipl_players WHERE team IN ('Mumbai Indians', 'Punjab Kings');

SELECT * FROM ipl_players WHERE auction_price_crores BETWEEN 10 AND 15;

SELECT * FROM ipl_players WHERE team != 'Chennai Super Kings';


-- Sorting
SELECT name, auction_price_crores FROM ipl_players
ORDER BY auction_price_crores DESC;

SELECT team, nickname, auction_price_crores FROM ipl_players
ORDER BY team ASC, auction_price_crores DESC;


-- pagination
SELECT name, auction_price_crores FROM ipl_players
ORDER BY auction_price_crores DESC
LIMIT 3;

SELECT name, auction_price_crores FROM ipl_players
ORDER BY auction_price_crores DESC
LIMIT 5 OFFSET 3;   -- OFFSET means how many rows to skip

-- Real-world applications mein OFFSET pagination ke liye use hota hai.
-- Formula: OFFSET = (page_number - 1) * page_size
-- Example: Page Size = 10
--          Page 1 -> LIMIT 10 OFFSET 0
--          Page 2 -> LIMIT 10 OFFSET 10
--          Page 3 -> LIMIT 10 OFFSET 20


-- Modifying data at runtime (it's not manipulating, it's Modifying, both things are different)
-- Means here we give a modified data to the user, does not change the actual data in the DB.
-- Displaying the the "auction_price" into 'lakhs' instead of 'crores'.
SELECT nickname, CONCAT((auction_price_crores * 100), ' lakhs') AS auction_price_lakhs
FROM ipl_players;

SELECT nickname, auction_price_crores, (auction_price_crores + 2) AS new_price FROM ipl_players;


-- How you can get distinct values ?
SELECT DISTINCT role AS unique_roles FROM ipl_players;

-- MMMMIIIIMMMMPPPP INTERVIEW:-
-- What is DQL ?
-- DQL stands for "Data Query Language". It is used to retrieve (query) data from a SQL database without modifying its structure or data.
-- The primary DQL command is: SELECT

