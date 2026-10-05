-- Types of Join in SQL
-- 1. LEFT JOIN
-- 2. RIGHT JOIN
-- 3. INNER JOIN
-- 4. FULL OUTER JOIN

-- ===========================================
-- ⭐️ Foreign Key:-
-- ===========================================
-- Foreign Key ek column hota hai jo kisi dusre Table ki Primary Key ko reference karta hai.

-- Iska main purpose Tables ke beech Relationship banana aur Data Integrity maintain karna hota hai.

-- ===========================================
-- ⭐️ Why do we need a Foreign Key?
-- ===========================================
-- Dekho Foreign Key ke bina Data mein inconsistency aa jayegi.

-- Maan lo ham Foreign Key ka concept use hi nahi kar rahe. Ab hame internships ka table banana hai aur usme student ka name, email, branch, etc. bhi chahiye.

-- To ham kya karenge?
-- Ham students table se ye saara data copy karke internships table mein store kar denge.

-- students:
-- -------------------------------------
-- id | name   | email
-- -------------------------------------
-- 1  | Kirtan | abc@gmail.com

-- internships:
-- -------------------------------------------------------------------------
-- internship_id | company | student_name | student_email | student_branch
-- -------------------------------------------------------------------------
--       1       | Google  | Kirtan       | abc@gmail.com | CE

------------------------------------------------------------
-- Filhal to hamara kaam ho gaya. Par kal ko agar student apna email ya name change kar de,
-- to fir hame manually internships table mein bhi jaakar update karna padega.

-- students
-- -------------------------------------
-- id | name   | email
-- -------------------------------------
-- 1  | Kirtan | xyz@gmail.com

-- internships
-- -------------------------------------------------------------------------
-- internship_id | company | student_name | student_email | student_branch
-- -------------------------------------------------------------------------
--       1       | Google  | Kirtan       | abc@gmail.com | CE   ❌ Old Email

-- Kyunki dono tables ek dusre ke saath Sync (Relation) mein nahi hain.

------------------------------------------------------------
-- Aur socho agar hazaro students honge. Har din koi na koi apna email, phone ya name change karega.

-- To ye changes sirf students table mein honge, lekin internships table mein hame manually update karna padega. Ye process practically maintain karna bahut mushkil hai.

------------------------------------------------------------
-- Is problem ko solve karne ke liye Foreign Key ka concept market mein aaya.

-- Ab internships table mein ham sirf student_id store karenge.

-- students:
-- -------------------------------------
-- id | name   | email
-- -------------------------------------
-- 1  | Kirtan | xyz@gmail.com

-- internships:
-- ----------------------------------------
-- internship_id | company | student_id
-- ----------------------------------------
--       1       | Google  |     1

------------------------------------------------------------
-- Ab maan lo student ne apna email ya name change kar diya. Hame internships table mein kuch bhi update nahi karna padega. Kyunki internships table mein sirf student_id ka reference hai.

-- Jab bhi student ka data chahiye hoga, ham student_id ke basis par JOIN laga kar latest name aur email access kar lenge.

------------------------------------------------------------
-- Foreign Key kisi bhi UNIQUE column ko banaya ja sakta hai. Jaise Email bhi UNIQUE ho sakta hai.

-- Lekin best practice hai ki Primary Key (student_id) ko hi Foreign Key banaya jaye.

-- Reason:
-- ✔️ student_id system assign karta hai.
-- ✔️ Student usse kabhi change nahi kar sakta.
-- ✔️ Email, Username ya Phone Number future mein change ho sakte hain.
-- ✔️ Integer IDs par JOIN aur Indexing bhi fast hoti hai.

------------------------------------------------------------
-- Ek aur bahut bada fayda... MMMMMMMIIIIIIMMMMMPPPPPP

-- Duplicate data store nahi karna padta.

-- Agar Foreign Key na hoti, to Name, Email, Branch jaise columns hame dobara internships table mein banane padte.

-- Jabki ye data students table mein already store hai. To baar-baar same data alag-alag tables mein store karne ki koi zarurat nahi hai.

-- Bas student_id store karo aur zarurat padne par JOIN laga kar latest data le lo.

------------------------------------------------------------
-- Benefits of Foreign Key

-- ✔️ Tables ke beech Relationship maintain hota hai.
-- ✔️ Duplicate data store nahi karna padta.
-- ✔️ Data Inconsistency nahi aati.
-- ✔️ Updates sirf ek hi table mein karne padte hain.
-- ✔️ JOIN ki help se hamesha latest data milta hai.
-- ✔️ Database Referential Integrity maintain karta hai.

------------------------------------------------------------
-- One-line Summary: 
-- Foreign Key duplicate data ko avoid karti hai aur tables ke beech
-- relationship maintain karti hai. Isse data consistent rehta hai,
-- maintenance easy ho jaati hai aur latest information JOIN ke through
-- retrieve ki ja sakti hai.

-- --------------------------------------------------------------------------------------------
-- ===========================================
-- ⭐️ Problem with DELETE & ON DELETE CASCADE:-
-- ===========================================
-- Aage agar baat kare, to ek problem ye bhi thi ki...

-- Maan lo student ne apni id delete kar di. To internships table ko kaise pata chalega ki ye student delete ho gaya hai?

-- students:
-- ----------------------
-- id | name
-- ----------------------
-- 1  | Rahul
-- 2  | Mohan

-- internships:
-- ----------------------------------------
-- internship_id | company | student_id
-- ----------------------------------------
--       1       | Google  |     1
--       2       | Amazon  |     2

------------------------------------------------------------
-- Kyunki Backend mein normally ham sirf students table ke liye DELETE Query chalate hain.

-- ---> DELETE FROM studentsWHERE student_id = 1;

-- Ham saare related tables ke liye manually DELETE Queries nahi chalate.
-- To fir internships table ko kaise pata chalega ki Rahul delete ho gaya hai?

------------------------------------------------------------
-- Is problem ko solve karne ke liye ham use karte hain "ON DELETE CASCADE".

-- ---> student_id INT REFERENCES students(student_id) ON DELETE CASCADE

------------------------------------------------------------
-- Ab kya hoga?
-- Agar students table mein se Rahul ki ID delete ho jaati hai,

-- ---> DELETE FROM students WHERE student_id = 1;

-- To Database automatically internships table ki bhi wo saari rows delete kar dega jaha student_id = 1 hoga.

-- students:
-- ----------------------
-- id | name
-- ----------------------
-- 2  | Mohan

-- internships:
-- ----------------------------------------
-- internship_id | company | student_id
-- ----------------------------------------
--       2       | Amazon  |     2

------------------------------------------------------------
-- Dekho, aisa karne se ek aur bahut badi problem khadi ho jaati hai...

-- Dhyan rahe, abhi tak hamne Companies ke liye koi alag table nahi banaya hai.
-- Is example mein Company ka naam bhi internships table mein hi store ho raha hai.

-- internships
-- ----------------------------------------------------
-- internship_id | company    | student_id
-- ----------------------------------------------------
--      1        | Microsoft  |     1
--      2        | Microsoft  |     2
--      3        | Microsoft  |     3

------------------------------------------------------------
-- Maan lo Microsoft naam ki ek company hai, jisme 3 students ko internship mili hai.

-- Isliye internships table mein Microsoft ki 3 rows hongi, aur har row ek alag student ko represent karegi.

------------------------------------------------------------
-- Ab maan lo teeno students ne company chhod di ya apni IDs delete kar di.

-- ---> DELETE FROM students WHERE student_id = 1;
-- ---> DELETE FROM students WHERE student_id = 2;
-- ---> DELETE FROM students WHERE student_id = 3;

-- ON DELETE CASCADE ki wajah se internships table ki teeno rows bhi automatically delete ho jayengi.

------------------------------------------------------------
-- Ab dekho asli problem...

-- Company "Microsoft" to abhi bhi exist karti hai. Sirf us company mein abhi koi intern nahi hai.

-- Lekin kyunki Company ka data bhi internships table mein hi store tha, isliye teeno students delete hote hi Microsoft ka naam bhi delete ho gaya.

-- Yaani Company ka existence Students par depend ho gaya, jo ki ek Poor Database Design hai.

------------------------------------------------------------
-- Is problem ka solution bhi hai.

-- Company ka data ek alag "companies" table mein store kiya jata hai, aur internships table sirf Student aur Company ke beech Relationship maintain karta hai.

-- Isse agar saare students delete bhi ho jaye, tab bhi Company ka data safely companies table mein rahega.

-- Iss concept ko ham Normalization aur Proper Database Design padhte waqt detail mein samjhenge.


-- ===========================================
-- ⭐️ ON DELETE SET NULL:-
-- ===========================================
-- Before DELETE:
-- +----------------------+      +---------------------------------------------+
-- | students             |      | internships                                |
-- +----------------------+      +---------------------------------------------+
-- | id | name            |      | internship_id | company | student_id        |
-- +----+-----------------+      +---------------+---------+-------------------+
-- | 1  | Rahul           |      | 1             | Google  | 1                 |
-- | 2  | Kirtan          |      | 2             | Amazon  | 2                 |
-- +----+-----------------+      +---------------+---------+-------------------+

-- ---> DELETE FROM students WHERE student_id = 1;

-- After DELETE:
-- +----------------------+      +---------------------------------------------+
-- | students             |      | internships                                |
-- +----------------------+      +---------------------------------------------+
-- | id | name            |      | internship_id | company | student_id        |
-- +----+-----------------+      +---------------+---------+-------------------+
-- | 2  | Kirtan          |      | 1             | Google  | NULL              |
-- +----+-----------------+      | 2             | Amazon  | 2                 |
--                                +---------------+---------+-------------------+


-- ===========================================
-- ⭐️ ON DELETE RESTRICT:-
-- ===========================================
-- Chalo iise visually samajhte hain.

-- Initial Data:-

-- students:
-- ----------------------
-- student_id | name
-- ----------------------
-- 1          | Rahul
-- 2          | Kirtan

-- internships:
-- ----------------------------------------
-- internship_id | company | student_id
-- ----------------------------------------
--      1        | Google  |     1
--      2        | Amazon  |     2

-- Yaha Rahul ki internship chal rahi hai.

------------------------------------------------------------
-- Ab agar Foreign Key aise bani hai: student_id INT REFERENCES students(student_id) ON DELETE RESTRICT

------------------------------------------------------------
-- Aur tum ye Query chalao: DELETE FROM students WHERE student_id = 1;

------------------------------------------------------------
-- Database sochega:

-- "Ek minute! internships table mein abhi bhi student_id = 1 use ho raha hai."

-- "Agar maine Rahul ko delete kar diya, to internships table ki ye row kis Student ko point karegi?"

-- internship_id | company | student_id
-- ----------------------------------------
--      1        | Google  |     1   ❌

-- Isliye Database DELETE ko reject kar dega aur ERROR throw karega.

------------------------------------------------------------
-- Ab tum sochoge,"Agar Rahul company chhod de to?"

-- Real-world Apps mein Student ko delete nahi kiya jata sirf isliye kyunki usne company chhod di.

-- Internship record ko update kiya jata hai.

-- Example:
-- internship_id | company | student_id | status
-- ----------------------------------------------
--      1        | Google  |     1      | Completed

-- Ya end_date set kar di jaati hai.

------------------------------------------------------------
-- Student ko students table se tab delete kiya jata hai, jab user apna account permanently delete karta hai.

-- Agar us time internships table usse reference kar rahi hogi, to RESTRICT usse delete nahi hone dega.

------------------------------------------------------------
-- Student delete karna hai?

-- Option 1: Pehle Internship delete karo.

-- ---> DELETE FROM internships WHERE student_id = 1;

-- Fir Student delete karo.

-- ---> DELETE FROM students WHERE student_id = 1;

------------------------------------------------------------
-- Option 2: ON DELETE CASCADE use karo.

-- Student delete hoga,
-- to Internship bhi automatically delete ho jayegi.

------------------------------------------------------------
-- Option 3: ON DELETE SET NULL use karo.

-- Student delete hoga,
-- Internship rahegi,
-- bas student_id NULL ho jayega.

------------------------------------------------------------
-- One-line Summary:

-- RESTRICT bolta hai: "Jab tak koi Child Table Parent ko reference kar rahi hai, main Parent ko delete nahi hone dunga."



CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    branch VARCHAR(50)
);

CREATE TABLE internships (
    internship_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100),
    role VARCHAR(50),
    stipend INT CHECK(stipend >= 1000),
    status VARCHAR(20),     -- selected / pending / rejected

    student_id INT REFERENCES students(student_id) ON DELETE SET NULL   -- Foreign Key
);


INSERT INTO students (name, email, branch)
VALUES
('Rahul Sharma',   'rahul.sharma@gmail.com',   'CSE'),
('Priya Verma',    'priya.verma@gmail.com',    'IT'),
('Aman Gupta',     'aman.gupta@gmail.com',     'ECE'),
('Neha Singh',     'neha.singh@gmail.com',     'ME'),
('Arjun Mehta',    'arjun.mehta@gmail.com',    'CE');

SELECT * FROM students;

INSERT INTO internships (company_name, role, stipend, status, student_id)
VALUES
('Google',    'SDE Intern',      80000, 'Selected', 1),
('Microsoft', 'Backend Intern',  70000, 'Pending',  2),
('Amazon',    'Cloud Intern',    85000, 'Selected', 3),
('Adobe',     'Frontend Intern', 60000, 'Rejected', 5),
('Oracle',    'Database Intern', 65000, 'Selected', 2);

SELECT * FROM internships;


-- ===========================================
-- ⭐️ INNER JOIN:-
-- ===========================================

-- INNER JOIN tab use hota hai jab hame sirf dono Tables ka common (matching) data chahiye hota hai.

-- Yaani jis Student ki Internship hogi, sirf wahi result mein aayega.

------------------------------------------------------------
SELECT
    students.name,
    students.branch,
    internships.company_name,
    internships.role,
    internships.stipend
FROM students 
INNER JOIN internships
ON students.student_id = internships.student_id;

------------------------------------------------------------
-- Chalo is Query ko step-by-step samajhte hain.

-- Step 1: FROM students
-- Database sabse pehle students table ko read karega.

------------------------------------------------------------
-- Step 2: INNER JOIN internships
-- Ab Database internships table ko bhi read karega.

------------------------------------------------------------
-- Step 3: ON students.student_id = internships.student_id
-- Ye sabse important part hai.

-- Database dono tables ki student_id compare karega.

-- Agar student_id match hoti hai, to dono rows ko combine kar diya jayega.

-- Agar match nahi hoti, to wo row result mein nahi aayegi.

------------------------------------------------------------
-- Example:-

-- students:
-- ------------------------------------------
-- id | name   | branch
-- ------------------------------------------
-- 1  | Rahul  | CSE
-- 2  | Priya  | IT
-- 3  | Aman   | ECE
-- 4  | Neha   | ME

-- internships:
-- ----------------------------------------------------
-- internship_id | company    | student_id
-- ----------------------------------------------------
--      1        | Google     |     1
--      2        | Amazon     |     2
--      3        | Microsoft  |     2
--      4        | Adobe      |     3

------------------------------------------------------------
-- Database internally matching dekhega.

-- students               internships

-- Rahul (1)   ─────────► Google (1)      ✅ Match
-- Priya (2)   ─────────► Amazon (2)      ✅ Match
-- Priya (2)   ─────────► Microsoft (2)   ✅ Match
-- Aman  (3)   ─────────► Adobe (3)       ✅ Match
-- Neha  (4)   ─────────► No Match        ❌

------------------------------------------------------------
-- Final Result:-

-- -------------------------------------------------------------
-- name   | branch | company    | role             | stipend
-- -------------------------------------------------------------
-- Rahul  | CSE    | Google     | SDE Intern       | 80000
-- Priya  | IT     | Amazon     | Cloud Intern     | 85000
-- Priya  | IT     | Microsoft  | Backend Intern   | 70000
-- Aman   | ECE    | Adobe      | Frontend Intern  | 60000

-- Dhyan do...

-- Neha result mein nahi aayi,
-- kyunki internships table mein uska koi matching student_id nahi tha.

------------------------------------------------------------
-- Internally Database kya karta hai?

-- Conceptually Database kuch aisa sochta hai:

-- for every row in students
--      for every row in internships
--          if(student_id matches)
--              combine both rows
--              return result

-- Reality mein Database hamesha nested loops use nahi karta.
-- Optimizer data aur indexes dekhkar decide karta hai ki
-- Nested Loop Join, Hash Join ya Merge Join use karna hai.

------------------------------------------------------------
-- One-line Summary:

-- INNER JOIN sirf unhi rows ko return karta hai
-- jinka JOIN condition (ON clause) satisfy hota hai.
-- Agar matching row nahi milti,
-- to wo record result mein include nahi hota.

-- ⭐ Interview Tip:- 
-- "INNER JOIN returns only those rows for which the JOIN condition evaluates to TRUE."




-- --------------------------------------------------------------------------------------------
DELETE FROM students WHERE student_id = 5;

-- ===========================================
-- ⭐️ LEFT Table & RIGHT Table:-
-- ===========================================
-- LEFT aur RIGHT Table manually decide nahi hoti. Query khud decide karti hai.

-- Rule:    FROM ke baad wali Table  -> LEFT Table
--          JOIN ke baad wali Table  -> RIGHT Table

-- Example: SELECT *
--          FROM students
--          LEFT JOIN internships
--          ON students.student_id = internships.student_id;

-- LEFT Table  -> students
-- RIGHT Table -> internships


-- ===========================================
-- ⭐️ LEFT JOIN:-
-- ===========================================
-- LEFT JOIN ka matlab hai:
-- "Left Table ki saari rows lao."
-- Agar Right Table mein matching row milti hai,
-- to uska data bhi le aao.
-- Agar matching row nahi milti,
-- to Right Table ke columns mein NULL aa jayega.

------------------------------------------------------------
-- Current Data:-

-- students (Left Table):
-- -----------------------------------------
-- student_id | name   | branch
-- -----------------------------------------
-- 1          | Rahul  | CSE
-- 2          | Priya  | IT
-- 3          | Aman   | ECE
-- 4          | Neha   | ME

-- internships (Right Table):
-- ----------------------------------------------------------------------
-- internship_id | company_name | role              | student_id
-- ----------------------------------------------------------------------
-- 1             | Google       | SDE Intern        | 1
-- 2             | Microsoft    | Backend Intern    | 2
-- 3             | Amazon       | Cloud Intern      | 3
-- 4             | Adobe        | Frontend Intern   | NULL
-- 5             | Oracle       | Database Intern   | 2

-- (Student 5 delete hone ki wajah se ON DELETE SET NULL ne student_id ko NULL kar diya.)

------------------------------------------------------------
SELECT
    students.name,
    students.branch,
    internships.company_name,
    internships.role
FROM students
LEFT JOIN internships
ON students.student_id = internships.student_id;

------------------------------------------------------------
-- Database kya karega?

-- "Students table ki saari rows lao."

-- Rahul  ---> Google      ✅ Match
-- Priya  ---> Microsoft   ✅ Match
-- Priya  ---> Oracle      ✅ Match
-- Aman   ---> Amazon      ✅ Match
-- Neha   ---> No Match    ❌

------------------------------------------------------------
-- Final Result:-
-- -------------------------------------------------------
-- name   | branch | company_name | role
-- -------------------------------------------------------
-- Rahul  | CSE    | Google       | SDE Intern
-- Priya  | IT     | Microsoft    | Backend Intern
-- Priya  | IT     | Oracle       | Database Intern
-- Aman   | ECE    | Amazon       | Cloud Intern
-- Neha   | ME     | NULL         | NULL

-- Dhyan do...
-- Neha ki Internship nahi hai, fir bhi LEFT JOIN ne usse return kiya, kyunki Students Left Table hai.

------------------------------------------------------------
-- One-line Summary: LEFT JOIN hamesha Left Table ki saari rows return karta hai. Agar Right Table mein match na mile,to uske columns NULL ho jate hain.


-- --------------------------------------------------------------------------------------------
-- ===========================================
-- ⭐️ RIGHT JOIN:-
-- ===========================================

-- RIGHT JOIN ka matlab hai:
-- "Right Table ki saari rows lao."

-- Agar Left Table mein matching row milti hai,
-- to uska data bhi le aao.

-- Agar matching row nahi milti,
-- to Left Table ke columns mein NULL aa jayega.

------------------------------------------------------------
-- Current Data:-

-- students (Left Table):
-- -----------------------------
-- 1 | Rahul
-- 2 | Priya
-- 3 | Aman
-- 4 | Neha

-- internships (Right Table):
-- -----------------------------------
-- Google      | student_id = 1
-- Microsoft   | student_id = 2
-- Amazon      | student_id = 3
-- Adobe       | student_id = NULL
-- Oracle      | student_id = 2

------------------------------------------------------------
SELECT
    students.name,
    students.branch,
    internships.company_name,
    internships.stipend
FROM students
RIGHT JOIN internships
ON students.student_id = internships.student_id;

------------------------------------------------------------
-- Database internships table ki har row ko dekhega.

-- Google      ---> Rahul      ✅ Match
-- Microsoft   ---> Priya      ✅ Match
-- Amazon      ---> Aman       ✅ Match
-- Oracle      ---> Priya      ✅ Match
-- Adobe       ---> No Match   ❌

-- Adobe ke liye matching Student nahi mila.

-- Lekin RIGHT JOIN hone ki wajah se Adobe ki row fir bhi result mein aayegi.

-- Bas Student ke columns NULL ho jayenge.

------------------------------------------------------------
-- Final Result:-
-- ----------------------------
-- name   | company_name
-- ----------------------------
-- Rahul  | Google
-- Priya  | Microsoft
-- Aman   | Amazon
-- Priya  | Oracle
-- NULL   | Adobe

------------------------------------------------------------
-- One-line Summary:
-- LEFT JOIN  -> Left Table ki saari rows.
-- RIGHT JOIN -> Right Table ki saari rows.
-- INNER JOIN -> Sirf matching rows.


-- --------------------------------------------------------------------------------------------
-- ===========================================
-- ⭐️ FULL OUTER JOIN:-
-- ===========================================
-- FULL OUTER JOIN ka matlab hai:
-- "Dono Tables ki saari rows lao."

-- Agar matching row milti hai, to dono tables ka data combine kar do.

-- Agar kisi Table mein matching row nahi milti, to us Table ke columns mein NULL aa jayega.

------------------------------------------------------------
-- Current Data:-

-- students:
-- -----------------------------
-- 1 | Rahul
-- 2 | Priya
-- 3 | Aman
-- 4 | Neha

-- internships:
-- -----------------------------------
-- Google      | student_id = 1
-- Microsoft   | student_id = 2
-- Amazon      | student_id = 3
-- Adobe       | student_id = NULL
-- Oracle      | student_id = 2

------------------------------------------------------------
SELECT
    students.name,
    internships.company_name
FROM students
FULL OUTER JOIN internships
ON students.student_id = internships.student_id;

------------------------------------------------------------
-- Database matching dekhega.

-- Rahul  <----> Google      ✅ Match
-- Priya  <----> Microsoft   ✅ Match
-- Priya  <----> Oracle      ✅ Match
-- Aman   <----> Amazon      ✅ Match
-- Neha   <----> No Match    ❌
-- No Student <-> Adobe      ❌

------------------------------------------------------------
-- Final Result:-
-- ----------------------------
-- name   | company_name
-- ----------------------------
-- Rahul  | Google
-- Priya  | Microsoft
-- Priya  | Oracle
-- Aman   | Amazon
-- Neha   | NULL
-- NULL   | Adobe

------------------------------------------------------------
-- One-line Summary:

-- FULL OUTER JOIN dono Tables ki saari rows return karta hai. Jaha match milta hai, rows combine ho jaati hain. Jaha match nahi milta, waha NULL fill kar diya jata hai.

------------------------------------------------------------
-- Easy Trick:

-- INNER JOIN  -> Sirf Matching Rows
-- LEFT JOIN   -> Left Table ki saari Rows
-- RIGHT JOIN  -> Right Table ki saari Rows
-- FULL JOIN   -> Dono Tables ki saari Rows