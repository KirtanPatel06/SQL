-- ===========================================
-- INDEXING
-- ===========================================
-- Dekho, maan lo tumhare Database mein 1 Crore rows hain.

-- SELECT *
-- FROM users
-- WHERE email = 'abc@gmail.com';

------------------------------------------------------------
-- Agar email column par Index nahi hai, to Database ko ye nahi pata ki ye row kis location par padi hai.

-- Isliye Database ko ek-ek row check karni padegi ki email match ho raha hai ya nahi.

-- Is process ko Sequential Scan bolte hain.

-- Time Complexity: O(n)

------------------------------------------------------------
-- PostgreSQL by default Sequential Scan use karta hai.

-- Aur ek important baat...

-- Sequential Scan ka matlab ye nahi hai ki
-- sirf ek hi CPU ya ek hi pointer rows check karta hai.

-- PostgreSQL Parallel Sequential Scan bhi use kar sakta hai.

-- Matlab multiple workers ek saath alag-alag pages scan karte hain.

-- Isse performance improve hoti hai, lekin fir bhi saari rows dekhni padti hain.

-- Isliye Time Complexity fir bhi O(n) hi rehti hai.

------------------------------------------------------------
-- Maan lo 1 Crore rows scan karne mein 100ms lag gaye.

-- 100ms ek Web Application ke liye kaafi zyada hai, kyunki ek request mein sirf ek Query nahi chalti. Backend ek request ke liye multiple Queries chala sakta hai.

------------------------------------------------------------
-- Is problem ko solve karta hai INDEX.

-- Lekin Index ka bhi Cost hota hai.

-- CREATE INDEX karte waqt Database ko saari existing rows padhni padti hain aur unka Index prepare karna padta hai.

-- Isliye pehli baar Index banane mein time lagta hai.

-- Aur future mein jab bhi INSERT, UPDATE ya DELETE hoga,
-- to Database ko Index bhi update karna padega.

-- Isliye:  Reads  -> Fast
--          Writes -> Thodi Slow

------------------------------------------------------------
-- Ab sawal aata hai...

-- Index actually hota kya hai?

-- Bahut log sochte hain ki Database sirf Table hi store karta hai.

-- Lekin aisa nahi hai.

-- Jab tum kisi column par Index banate ho,

-- CREATE INDEX idx_users_email
-- ON users(email);

-- Tab Database Table ko modify nahi karta.

-- Balki Database us Table ke alawa ek alag Data Structure bhi create karta hai. Aur Usko bhi Disk mein store kar leta hai.

------------------------------------------------------------
-- Disk:-

-- users Table:

-- id | name | email
-- ----------------------------
-- 1  | A    | a@gmail.com
-- 2  | B    | b@gmail.com
-- 3  | C    | c@gmail.com
-- ...

------------------------------------------------------------
-- Saath hi Database ek aur structure banata hai.

-- B+ Tree Index:

-- a@gmail.com ---> Page 15, Row 2
-- b@gmail.com ---> Page 28, Row 7
-- c@gmail.com ---> Page 40, Row 1
-- ...

-- Dhyan do...

-- B+ Tree poora row store nahi karta.

-- Wo sirf:
-- 1. Indexed Column ki Value
-- 2. Us Row ka Address (Pointer / TID)

-- store karta hai.

------------------------------------------------------------
-- Ab jab Query chalegi,

-- SELECT *
-- FROM users
-- WHERE email = 'b@gmail.com';

-- To Database pehle Table mein search nahi karega.

-- Sabse pehle B+ Tree mein 'b@gmail.com' ko search karega.

------------------------------------------------------------

-- B+ Tree internally kuch aisa dikhta hai.

--                 [m@gmail.com]
--                /             \
--       [f@gmail]             [t@gmail]
--       /      \              /       \
--      ...    ...           ...      ...

-- Tree sorted order mein hota hai.

-- Har comparison ke baad Database decide karta hai ki Left jana hai ya Right.

-- Isliye har baar search space aadhi ho jaati hai.

------------------------------------------------------------
-- Jaise hi Email milta hai,

-- B+ Tree Database ko bata deta hai: "Actual Row Page 28, Row 7 par padi hai."

-- Fir Database seedha Page 28 read karta hai aur Row 7 user ko return kar deta hai.

-- Database ko baaki 99,99,999 rows dekhne ki zarurat hi nahi padti.

------------------------------------------------------------
-- Time Complexity:-

-- 1. Without Index
-- Table Scan: O(n)

-- 2. With Index
-- B+ Tree Search: O(log n)

------------------------------------------------------------
-- One-line Summary:

-- Index actual data nahi hota.

-- Index ek alag B+ Tree Data Structure hota hai, jo Indexed Column ki Values aur unke corresponding Row Addresses ko store karta hai.

-- Database pehle B+ Tree mein search karta hai, fir seedha us Row ke Address par jaakar actual data read karta hai.


-- ==============================================
-- ⭐️ CREATE INDEX vs CREATE INDEX CONCURRENTLY:-
-- ==============================================
-- Ek important baat...

-- Jab tum normally Index create karte ho,

-- ---> CREATE INDEX idx_users_email ON users(email);

-- To PostgreSQL us Table par lock laga deta hai. Iska matlab ye nahi hai ki SELECT bhi band ho jayega.

-- SELECT queries chal sakti hain.

-- Lekin INSERT, UPDATE aur DELETE operations tab tak wait karte hain jab tak Index create nahi ho jata. Agar Table bahut badi hai, to ye lock kaafi time tak reh sakta hai.

------------------------------------------------------------
-- Is problem ko solve karne ke liye PostgreSQL ne diya hai: "CREATE INDEX CONCURRENTLY"

-- CREATE INDEX CONCURRENTLY idx_users_email ON users(email);

-- Is mode mein PostgreSQL Table ko write operations ke liye lock nahi karta.

-- Matlab Index bante waqt bhi

-- ✔ INSERT
-- ✔ UPDATE
-- ✔ DELETE

-- normal tarike se chal sakte hain.

-- Isliye Production Databases mein zyadatar CONCURRENTLY use kiya jata hai.

------------------------------------------------------------
-- Lekin iska bhi Cost hai.

-- 1. Index banne mein normal se zyada time lagta hai.

-- 2. Ye Database ko multiple scans karwata hai, isliye I/O aur CPU usage badh sakta hai.

-- 3. Ye Transaction Block ke andar nahi chal sakta.

------------------------------------------------------------
-- One-line Summary:

-- CREATE INDEX
-- Faster, but Table ke writes temporarily block ho jate hain.

-- CREATE INDEX CONCURRENTLY
-- Thoda slow hota hai, lekin Index bante waqt bhi users Table mein INSERT, UPDATE aur DELETE kar sakte hain.


-- --------------------------------------------------------------------------------------------
-- ===========================================
-- ⭐️ INCLUDE (Non-Key Columns):-
-- ===========================================

-- Dekho bade-bade Real-world Projects mein, ek Request ke liye ek hi Query nahi chalti.
-- Backend parallel mein multiple Queries chalata hai.

-- Maan lo ek Request mein 7 Queries chal rahi hain. Unme se 6 Queries milliseconds mein complete ho rahi hain.

-- Lekin ek Query 50-60 seconds le rahi hai.

------------------------------------------------------------
-- Query ekdam Simple thi: SELECT <column> FROM <table> WHERE <search_column> = 'xyz';

-- Aur Table mein lagbhag 3 Crore rows thi.

------------------------------------------------------------
-- Sabse pehle hamne WHERE wale column par Index banaya.

-- ---> CREATE INDEX idx_name ON <table>(search_column);

-- Isse performance improve hui. Lekin Query fir bhi 10-12 seconds le rahi thi.

------------------------------------------------------------
-- Ab sawal tha...

-- "Index hone ke baad bhi itna time kyun lag raha hai?"

-- Reason ye tha ki, B+ Tree mein sirf do cheeze store thi.

-- 1. search_column (Indexed Value)
-- 2. Actual Row ka Address

-- Jab Query chalti thi,

-- Step 1: Database B+ Tree mein search_column search karta.

-- Step 2: Address mil jaata.

-- Step 3: Fir Database actual Table mein jaakar <column> ki value read karta.

-- Yaani har matching row ke liye Table access karna pad raha tha.

------------------------------------------------------------
-- Is problem ko solve karne ke liye PostgreSQL mein INCLUDE use kiya.

-- ---> CREATE INDEX idx_name ON <table>(any_column) INCLUDE (<column>);

------------------------------------------------------------
-- Dhyan do...

-- search_column ko Key Column bolte hain.

-- INCLUDE ke andar jo columns aate hain, unhe Non-Key Columns bolte hain.

------------------------------------------------------------
-- Ab B+ Tree mein 3 cheeze store hongi.

-- search_column (Key)
-- <column> (Included / Non-Key Value)
-- Row Address (Pointer)

------------------------------------------------------------
-- Ab Query chalne par: SELECT <column> FROM <table> WHERE <any_column> = 'xyz';

-- Database pehle B+ Tree mein search karega.

-- Match milte hi usse <column> ki value bhi wahi mil jayegi.

-- Ab Database ko actual Table tak jaane ki zarurat hi nahi padegi.

-- Is process ko "Index Only Scan" bolte hain.

------------------------------------------------------------
-- Isi wajah se Query jo pehle

-- 50-60 sec
-- ↓
-- 10-12 sec (Normal Index)
-- ↓
-- ~560 ms (Index + INCLUDE)

-- tak aa gayi.

------------------------------------------------------------
-- One-line Summary:

-- Normal Search -> Table (Sequential Scan)

-- Normal Index B+ Tree -> Table  (Index Scan)

-- Index + INCLUDE Sirf B+ Tree se hi answer mil sakta hai. (Index Only Scan)

-- Isliye Table access avoid ho jata hai aur Query aur bhi fast ho jaati hai.


-- ---------------------------------------------------------------------------------------------
-- Creating a marks table to show Demo of Indexing
CREATE TABLE marks (
    id SERIAL PRIMARY KEY,
    name TEXT,
    cgpa NUMERIC(3, 2) NOT NULL
);

-- Here we have altered the type of column named 'cgpa' from NUMERIC(3, 2) to TYPE NUMERIC(4, 2)
ALTER TABLE marks
ALTER COLUMN cgpa TYPE NUMERIC(4, 2)


-- The Below code inserts 1 Million rows inside our 'marks' Table
INSERT INTO marks (name, cgpa)
SELECT 
    substr(
        translate(
            md5(random()::text || gs::text),
            'abcdefghijklmnopqrstuvwxyz',
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        ),
        1,
        12
    ) AS name,
    round((6 + random() * 4)::numeric, 2) AS cgpa

FROM generate_series(1, 1000000) AS gs



-- Checking if rows are inserted
SELECT * FROM marks;


-- Here we have used 'EXPLAIN ANALYZE', what it does?
-- So it basically tells us that which type of Scan is used, how many seconds the query has taken to get run, etc.

-- Without Indexing it is taking around: 25ms. & uses 'Sequential Scan'.
EXPLAIN ANALYZE SELECT * FROM marks WHERE name = '55D697C8827D';


-- Now we will do indexing. Initially creating index will take time.
CREATE INDEX idx_name ON marks(name);

-- Now execute same Query after indexing, it is taking around: 0.1ms & uses 'Index Scan'.
EXPLAIN ANALYZE SELECT * FROM marks WHERE name = '55D697C8827D';


-- Now lets do INDEX + INCLUDE
-- before that DROP the currently made index.
DROP INDEX idx_name;

-- Now create new INDEX with INCLUDING a column.
-- As I want to fetch 'cgpa', I will include 'cgpa' column in INCLUDE.
CREATE INDEX idx_name ON marks(name) INCLUDE(cgpa);

-- Now it will also take about: 0.1ms
-- beacuse we only have 10 Lakh rows. If we had 1 Crore rows then You can See Clear differece in Normal Index & Index + Include.
-- Btw you can see the change in Scanning Techinque. It will show 'Index Only Scan' instead of 'Index Scan'.
EXPLAIN ANALYZE SELECT cgpa FROM marks WHERE name = '55D697C8827D';