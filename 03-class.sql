CREATE TABLE canteen_menu (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(100),
    category VARCHAR(50),
    price INT,
    is_available BOOLEAN DEFAULT TRUE
);

INSERT INTO canteen_menu (item_name, category, price) 
VALUES
('Masala Chai', 'Beverages', 10),
('Vadapav', 'Snack', 25),
('Dabeli', 'Snack', 35),
('Rajma Chawal', 'Meal', 100),
('Maggi', 'Snack', 50),
('Oreo Shake', 'Coolers', 120),
('Iced Tea', 'Beverages', 60);

-- Manipulating the values in the Table
UPDATE canteen_menu
SET price = 30
WHERE item_name = 'Vadapav';

UPDATE canteen_menu
SET price = price + 10
WHERE category = 'Beverages';

UPDATE canteen_menu
SET is_available = FALSE
WHERE item_name = 'Maggi';


-- ⚠️ Jivan mein Kabhi bhi DELETE query ko WHERE clause ke bina execute mat karna. Agar WHERE clause nahi hoga, to table ki saari rows delete ho jayengi.
--
-- Example: DELETE FROM users;
--
-- Ye TRUNCATE ki tarah table ka poora data remove kar dega, lekin table ki structure (columns, constraints, indexes) delete nahi hogi.
--
-- Difference:  DELETE    -> DML command, rows delete karta hai (WHERE support karta hai).
--              TRUNCATE  -> DDL command, table ka saara data ek saath remove karta hai.

DELETE FROM canteen_menu
WHERE item_name = 'Rajma Chawal';

-- -------------------------------------------------------------------------------------------------
-- DROP:
-- DROP ek DDL command hai. Ye table ka data aur structure dono permanently delete kar deta hai.
-- DROP ke baad table database mein exist hi nahi karta.

-- Example: DROP TABLE users;  (Aisa karne se pura table "with structure" delete ho jaayega).

-- -------------------------------------------------------------------------------------------------
--  Dry Run in SQL:-

-- 💡 Ek useful trick:
-- DELETE query execute karne se pehle uska "Dry Run" karo.
--
-- Bas DELETE FROM ki jagah SELECT use karke check karo ki
-- kaunsi rows select ho rahi hain.
--
-- Agar SELECT ka output wahi rows dikhata hai jo tum delete karna chahte ho,
-- tabhi usi condition ke saath DELETE query execute karo.
--
-- Ye practice real-world projects mein accidental data deletion se bachati hai.

-- For Example:-
SELECT * FROM canteen_menu WHERE item_name = 'Iced Tea';
DELETE FROM canteen_menu WHERE item_name = 'Iced Tea';

-- Filhal to ye Query easy thi isliye O/P figure-out karna easy ho jaat hai, par jab Lambi aur Hard Query ho, aur real world mein kaam kar rahe ho, to galti ki koi gunjaish nahi hoti. Isliye Ye    "Dry Run" Wali trick ko yaad karke use kar lena. 
-- Job bach jaayegi Tumhari 🙂.


SELECT * FROM canteen_menu;