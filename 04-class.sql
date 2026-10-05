CREATE TABLE watch_sales (
    sale_id SERIAL PRIMARY KEY,
    brand VARCHAR(50),
    model VARCHAR(50),
    city VARCHAR(50),
    units_sold INT,
    price_per_unit DECIMAL(10, 2),
    sale_date DATE
);

INSERT INTO watch_sales (brand,model,city,units_sold,price_per_unit,sale_date)
VALUES
('Rolex', 'Submariner', 'Mumbai', 3, 950000.00, '2025-01-10'),
('Rolex', 'Datejust', 'Delhi', 2, 820000.00, '2025-01-15'),

('Casio', 'G-Shock', 'Mumbai', 25, 12000.00, '2025-02-05'),
('Casio', 'Edifice', 'Bengaluru', 18, 9500.00, '2025-02-12'),

('Titan', 'Edge', 'Ahmedabad', 15, 18000.00, '2025-03-01'),
('Titan', 'Neo', 'Delhi', 22, 7500.00, '2025-03-08'),

('Fossil', 'Grant', 'Mumbai', 10, 14500.00, '2025-03-20'),
('Fossil', 'Machine', 'Bengaluru', 8, 16500.00, '2025-04-02'),

('Casio', 'Vintage', 'Delhi', 30, 3500.00, '2025-04-10'),
('Titan', 'Raga', 'Mumbai', 12, 11000.00, '2025-04-18');

INSERT INTO watch_sales (brand,model,city,units_sold,price_per_unit,sale_date)
VALUES
('Titan', 'Neo', 'Ahmedabad', '20', 7500.00, '2025-04-04'),
('Rolex', 'Submariner', 'Ahmedabad', '1', 950000.00, '2025-08-19');
=
SELECT * FROM watch_sales;

-- Ab tak humne basic DQL (SELECT) queries dekhi, jo mainly application level par data ko fetch karne ke liye use hoti hain.

-- Ab hum Aggregate Queries padhenge, jo data analysis aur reporting mein bahut useful hoti hain.

-- In queries mein hum data ko kisi column ke basis par GROUP karke summary values nikalte hain, jaise Total, Average, Maximum, Minimum, etc.

-- Ye aggregated results database mein permanently store nahi hote. DB runtime par calculation karta hai aur requirement ke hisaab se result generate karke application ko return karta hai.

-- COUNT(*):-
-- DB table ki saari rows ko count karta hai aur total number return karta hai.
SELECT count(*) AS total_stores FROM watch_sales;

-- SUM():-
-- DB har row ke liye (units_sold * price_per_unit) calculate karta hai,
-- phir un sab values ka total (sum) return karta hai.
SELECT SUM(units_sold * price_per_unit) AS total_revenue FROM watch_sales;

-- AVG():-
-- DB har row ki value ka average (mean) calculate karke return karta hai.
SELECT AVG(price_per_unit) AS average_price FROM watch_sales;

-- MIN():-
-- DB kisi column ki sabse chhoti (minimum) value return karta hai.
SELECT MIN(price_per_unit) AS lowest_price FROM watch_sales;

-- MAX():-
-- DB kisi column ki sabse badi (maximum) value return karta hai.
SELECT MAX(price_per_unit) AS highest_price FROM watch_sales;


-- -------------------------------------------------------------------------------------------------
-- GROUP BY:-
-- GROUP BY same values wali rows ko ek group mein divide karta hai. Uske baad har group par aggregate functions (SUM, COUNT, AVG, MIN, MAX) separately apply kiye jaate hain.

-- Original Table:
-- +---------+------------+
-- | brand   | units_sold |
-- +---------+------------+
-- | Casio   |     25     |
-- | Casio   |     18     |
-- | Titan   |     15     |
-- | Casio   |     30     |
-- | Titan   |     22     |
-- | Rolex   |      3     |
-- | Rolex   |      2     |
-- | Titan   |     12     |
-- +---------+------------+

-- GROUP BY brand:-
-- Casio  -> [25, 18, 30] -> SUM = 73
-- Titan  -> [15, 22, 12] -> SUM = 49
-- Rolex  -> [3, 2]       -> SUM = 5

SELECT brand, SUM(units_sold) AS total_units_sold FROM watch_sales
GROUP BY brand;

-- Output:
-- +---------+------------------+
-- | brand   | total_units_sold |
-- +---------+------------------+
-- | Casio   |        73        |
-- | Titan   |        49        |
-- | Rolex   |         5        |
-- +---------+------------------+

-- -------------------------------------------------------------------------------------------------
-- Agar GROUP BY na likhe:
SELECT brand, SUM(units_sold)
FROM watch_sales;

-- Database ko internally kuch aisa data dikhta hai:
-- +---------+------------+
-- | brand   | units_sold |
-- +---------+------------+
-- | Casio   |     25     |
-- | Casio   |     18     |
-- | Titan   |     15     |
-- | Casio   |     30     |
-- | Titan   |     22     |
-- | Rolex   |      3     |
-- | Rolex   |      2     |
-- | Titan   |     12     |
-- +---------+------------+

-- SUM(units_sold) = 127

-- To output kuch aisa hona chahiye:
-- +---------+------------------+
-- | brand   | SUM(units_sold)  |
-- +---------+------------------+
-- |   ???   |       127        |
-- +---------+------------------+

-- Problem:
-- 'brand' ke liye ek hi value return karni hai, lekin table mein multiple brands hain.

-- Casio ?
-- Titan ?
-- Rolex ?

-- Database decide nahi kar sakta ki 127 ke saath kaunsa brand return kare.

-- Isi ambiguity ki wajah se PostgreSQL error deta hai: 
-- "column 'brand' must appear in the GROUP BY clause or be used in an aggregate function."


-- ✅ Conclusion: Jab bhi SELECT mein koi non-aggregate column (jaise brand, city, department) aur koi aggregate function (SUM, COUNT, AVG, MIN, MAX) ek saath use karte ho, tab us non-aggregate column ko GROUP BY mein likhna mandatory hota hai.

-- Rule:    Non-Aggregate Columns  --> GROUP BY
--          Aggregate Functions    --> SELECT

-- Example:
SELECT brand, SUM(units_sold)
FROM watch_sales
GROUP BY brand;

-- Yahan:   brand            --> GROUP BY
--          SUM(units_sold)  --> Aggregate Function

-- GROUP BY tab use hota hai jab hume har group ka summary result chahiye, jaise "Har Brand ki Total Sales", "Har City ka Revenue", "Har Department ki Average Salary", etc.


-- -------------------------------------------------------------------------------------------------
-- Practice of GROUP BY:-
SELECT brand, MIN(price_per_unit) AS min_price FROM watch_sales
GROUP BY brand
ORDER BY min_price DESC;


-- Abhi dekhte hai ki Sabse Amir log kis city mein hai. Matlab Jis city mein se maximum revenue milega waha pe sabse jyaada Amir log rehte honge.
SELECT city, SUM(price_per_unit * units_sold) AS total_revenue_per_city FROM watch_sales
GROUP BY city
ORDER BY total_revenue_per_city DESC;


-- Ab hume dekhna hai ki har City mein har Brand ke total units kitne sell hue.
--
-- GROUP BY city, brand ka matlab hai:
-- 1. Pehle rows ko City ke basis par group karo.
-- 2. Har City ke andar Brand ke basis par groups banao.
-- 3. Ab har (City + Brand) group ke sabhi Models ke units_sold ko
--    SUM karke total nikal do.
--
-- Short mein: GROUP BY City → GROUP BY Brand → SUM(units_sold)

SELECT city, brand, SUM(units_sold) AS total_units_sold FROM watch_sales
GROUP BY city, brand
ORDER BY total_units_sold DESC;

-- Step 1: GROUP BY city
-- Sabse pehle rows ko City ke basis par groups mein divide kiya jata hai.

-- Mumbai     --> Rolex (3) | Casio (25) | Fossil (10) | Titan (12)
-- Delhi      --> Rolex (2) | Titan (22) | Casio (30)
-- Ahmedabad  --> Titan (15) | Titan (20) | Rolex (1)
-- Bengaluru  --> Casio (18) | Fossil (8)

------------------------------------------------------------
-- Step 2: GROUP BY brand (Inside each city)
-- Ab har City ke andar same Brand ke Models ek group ban jayenge.

-- Mumbai     --> Rolex [3] | Casio [25] | Fossil [10] | Titan [12]
-- Delhi      --> Rolex [2] | Titan [22] | Casio [30]
-- Ahmedabad  --> Titan [15, 20] | Rolex [1]
-- Bengaluru  --> Casio [18] | Fossil [8]

------------------------------------------------------------
-- Step 3: Apply SUM()

-- Mumbai     --> Rolex = 3 | Casio = 25 | Fossil = 10 | Titan = 12
-- Delhi      --> Rolex = 2 | Titan = 22 | Casio = 30
-- Ahmedabad  --> Titan = 15 + 20 = 35 | Rolex = 1
-- Bengaluru  --> Casio = 18 | Fossil = 8

-- Finally ORDER BY total_units_sold DESC apply hota hai.


-- -------------------------------------------------------------------------------------------------
-- HAVING Clause:-
-- HAVING ka use GROUP BY ke baad filtered groups ko select karne ke liye hota hai.
-- Ye aggregate values (SUM, COUNT, AVG, MIN, MAX) par condition lagata hai.

-- Example: Sirf un Brands ko dikhao jinke total units sold 30 se jyada hain.

SELECT brand, SUM(units_sold) AS total_units_sold FROM watch_sales
GROUP BY brand
HAVING SUM(units_sold) > 30;

-- Step 1: GROUP BY brand:-
-- Casio  --> [25, 18, 30]
-- Titan  --> [15, 22, 12, 20]
-- Fossil --> [10, 8]

-- Step 2: Apply SUM()
-- Rolex  --> 6
-- Casio  --> 73
-- Titan  --> 69
-- Fossil --> 18

-- Step 3: HAVING SUM(units_sold) > 30
-- Rolex  --> ❌ 6   (Rejected)
-- Casio  --> ✅ 73  (Selected)
-- Titan  --> ✅ 69  (Selected)
-- Fossil --> ❌ 18  (Rejected)


-- -------------------------------------------------------------------------------------------------
-- WHERE vs HAVING:-

-- 1. WHERE:- GROUP BY se pehle rows ko filter karta hai.
SELECT *
FROM watch_sales
WHERE city = 'Mumbai';

------------------------------------------------
-- 2. HAVING:- GROUP BY ke baad groups ko filter karta hai.
SELECT brand, SUM(units_sold)
FROM watch_sales
GROUP BY brand
HAVING SUM(units_sold) > 30;


-- 📌 Rule to Remember:-
-- Rows filter karni ho      --> WHERE
-- Groups filter karne ho    --> HAVING

-- Execution Order:
-- FROM
--    ↓
-- WHERE
--    ↓
-- GROUP BY
--    ↓
-- HAVING
--    ↓
-- SELECT
--    ↓
-- ORDER BY