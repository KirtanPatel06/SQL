-- ===========================================
-- ⭐️ TRANSACTIONS (Txn):-
-- ===========================================
-- Dekho, ab ham ek bahut hi important Topic padhne wale hain, jiska naam hai Transactions.

-- Main Transactions ko short mein "Txn" bolunga.

------------------------------------------------------------
-- Transaction Start karne ke liye:-
-- BEGIN;

-- Transaction End karne ke liye hamare paas 2 options hote hai:-
-- 1. COMMIT; - (Changes permanently save ho jayenge)
-- 2. ROLLBACK;  - (BEGIN ke baad hue saare changes revert ho jayenge)

------------------------------------------------------------
-- Transaction ka sabse important Rule: "Ya to 100% complete hoga, ya fir 0%."

-- Matlab Transaction kabhi bhi 40%, 50% ya 90% complete nahi hota. Isliye Transactions ko    "Do or Die" concept bhi bol sakte hain.

------------------------------------------------------------
-- Chalo Example se samajhte hain.

-- accounts:-
-- ------------------------------------
-- id | owner  | balance
-- ------------------------------------
-- 1  | Motu   | 5000
-- 2  | Patlu  | 5000

------------------------------------------------------------
-- Ab Motu ko Patlu ko 500 Rs transfer karne hain.

-- Iske liye 2 Queries chalengi.

-- UPDATE accounts SET balance = balance - 500 WHERE owner = 'Motu';

-- UPDATE accounts SET balance = balance + 500 WHERE owner = 'Patlu';

------------------------------------------------------------
-- Expected Result:-
-- ------------------------------------
-- owner  | balance
-- ------------------------------------
-- Motu   | 4500
-- Patlu  | 5500

------------------------------------------------------------
-- Lekin Problem dekho...

-- Agar pehli Query successfully chal gayi.

-- ------------------------------------
-- owner  | balance
-- ------------------------------------
-- Motu   | 4500
-- Patlu  | 5000

-- Aur isi beech Database Crash ho gaya.

-- To Motu ke account se paise kat gaye, lekin Patlu ko paise mile hi nahi.

-- Yaani Database inconsistent state mein aa gaya.

------------------------------------------------------------
-- Isi problem ko solve karta hai Transaction.

-- BEGIN;
-- UPDATE accounts SET balance = balance - 500 WHERE owner = 'Motu';
-- UPDATE accounts SET balance = balance + 500 WHERE owner = 'Patlu';
-- COMMIT;

------------------------------------------------------------
-- Agar dono Queries successfully chal gayi,

-- to COMMIT hoga.

-- Aur tabhi Original Database update hoga.

------------------------------------------------------------
-- Agar kisi bhi Query mein Error aa gaya,

-- BEGIN;
-- UPDATE accounts SET balance = balance - 500 WHERE owner = 'Motu';

-- Error aa gaya...

-- ROLLBACK;
------------------------------------------------------------
-- Result:-

-- ------------------------------------
-- owner  | balance
-- ------------------------------------
-- Motu   | 5000
-- Patlu  | 5000

-- Yaani Database bilkul pehle jaisa ho jayega.

------------------------------------------------------------
-- Dhyan do...

-- BEGIN & COMMIT/ROLLBACK ke beech jitni bhi Queries chalti hain,

-- un sab ko milakar ek "Transaction Block" bolte hain.

------------------------------------------------------------
-- Ab ek aur important baat...

-- Kya BEGIN karte hi Original Database change ho jata hai?

-- Nahi.
-- Jab Transaction chal raha hota hai, Database internally changes ko temporary maintain karta hai.

-- Original Database tab tak permanently update nahi hota jab tak COMMIT na ho.

-- Agar ROLLBACK hua, to ye temporary changes discard kar diye jate hain.

-- (Internally PostgreSQL exactly duplicate table nahi banata. Wo MVCC aur WAL jaise mechanisms use karta hai. Beginners ke liye temporary copy sochna theek hai.)



-- ---------------------------------------------------------------------------------------------
-- ==========================================================
-- ⭐️ Ab baat karte hain Row Locking ki:-
-- ==========================================================
-- Maan lo do alag users ek hi account ko ek saath update karna chahte hain.

------------------------------------------------------------
-- Initial Data:-

-- accounts:
-- ------------------------------------
-- owner  | balance
-- ------------------------------------
-- Motu   | 5000
-- Patlu  | 5000

------------------------------------------------------------
-- Dono users ne alag-alag Terminal open kiye.

-- ==========================================================================
-- ------------------------------------------------------------------------
-- Terminal 1 (Txn 1)              | Terminal 2 (Txn 2)
-- ------------------------------------------------------------------------

-- BEGIN;                          |   BEGIN;
-- UPDATE accounts                 |   UPDATE accounts
-- SET balance = balance - 500     |   SET balance = balance - 5000
-- WHERE owner = 'Motu';           |   WHERE owner = 'Motu';
-- -- UPDATE 1                     |   █
--                                 |   (Cursor Blink...)
-- ==========================================================================

-- Current Lock Status:-
-- ------------------------------------
-- owner  | balance
-- ------------------------------------
-- Motu   | 5000   🔒 Locked by Txn 1
-- Patlu  | 5000

-- =============================================================

-- Ab kya hua?

-- Txn 1 ne Motu wali Row ko Lock kar diya hai.

-- Isliye Txn 2 bhi Motu wali Row ko update karna chahta hai, lekin wo tab tak WAIT karega,
-- jab tak Txn 1 COMMIT ya ROLLBACK nahi kar deta.

-- ==========================================================================
-- ------------------------------------------------------------------------
-- Terminal 1 (Txn 1)              | Terminal 2 (Txn 2)
-- ------------------------------------------------------------------------
-- COMMIT;                         | █
-- -- COMMIT                       | (Still Waiting...)
-- ==========================================================================

-- Jaise hi Txn 1 COMMIT karega,

-- Motu wali Row ka Lock release ho jayega.

-- ==========================================================================
-- ------------------------------------------------------------------------
-- Terminal 1 (Txn 1)              | Terminal 2 (Txn 2)
-- ------------------------------------------------------------------------
-- postgres=#                      | UPDATE 1
--                                 | postgres=#
-- ==========================================================================

-- Ab Txn 2 automatically continue karega, aur uski Query successfully execute ho jayegi.

------------------------------------------------------------
-- One-line Summary:

-- ✔ Ya to saari Queries Successfully Execute hongi.
-- ✔ Ya fir koi bhi Change Database mein Save nahi hoga.

-- Aur Transaction ke dauran jis Row par UPDATE/DELETE chal raha hota hai, us Row ko Database temporarily lock kar deta hai, taaki doosri Transaction usi Row ko ek hi time par modify na kar sake.



-- ---------------------------------------------------------------------------------------------
-- ===========================================
-- ⭐️ DEADLOCK (Visual Terminal View):-
-- ===========================================

-- Imagine karo tumne 2 terminals open kiye hain.

-- ==========================================================================
-- ------------------------------------------------------------------------
-- Terminal 1 (Txn 1)           |            Terminal 2 (Txn 2)
-- ------------------------------------------------------------------------
-- BEGIN;                          |         BEGIN;
--                                 |
-- UPDATE accounts                 |         UPDATE accounts
-- SET balance = balance - 500     |         SET balance = balance - 500
-- WHERE owner = 'Motu';           |         WHERE owner = 'Patlu';
--                                 |
--                                 |
-- -- ✅ UPDATE 1                  |         -- ✅ UPDATE 1
-- ==========================================================================

-- Current Locks:-
-- Motu   🔒 Locked by Txn 1
-- Patlu  🔒 Locked by Txn 2

-- Ab dono dusri Row update karne ki koshish karte hain.
-- ==========================================================================
-- ------------------------------------------------------------------------
-- Terminal 1 (Txn 1)           |            Terminal 2 (Txn 2)
-- ------------------------------------------------------------------------
-- UPDATE accounts                 | UPDATE accounts
-- SET balance = balance + 500     | SET balance = balance + 5000
-- WHERE owner = 'Patlu';          | WHERE owner = 'Motu';
--                                 |
-- █                               | █

-- (Cursor blink...)               | (Cursor blink...)
-- ==========================================================================

-- Txn 1 bol raha hai: "Mujhe Patlu wali Row chahiye."

-- Par Patlu pe to Txn 2 ka Lock hai.

-- ---------------------------------------------------------
-- Txn 2 bol raha hai: "Mujhe Motu wali Row chahiye."

-- Par Motu pe to Txn 1 ka Lock hai.
-- =========================================================


-- Txn 1  ----Waiting----►  Patlu 🔒 (Txn 2)
-- Txn 2  ----Waiting----►  Motu 🔒 (Txn 1)

-- Dono ek dusre ka wait kar rahe hain. Koi bhi aage nahi badh sakta. 
-- Isi Situation ko Deadlock bolte hain.


-- Kuch seconds baad PostgreSQL automatically Deadlock detect karega.
-- Maan lo Txn 2 ko Rollback kar diya.

-- ==========================================================================
-- ------------------------------------------------------------------------
-- Terminal 1 (Txn 1)              |            Terminal 2 (Txn 2)
-- ------------------------------------------------------------------------
-- UPDATE 1                        | ERROR: deadlock detected
--                                 | ROLLBACK
-- COMMIT;                         |
--                                 |

-- ✅ Transaction Completed        |

-- ==========================================================================

-- Final Data:-

-- owner    balance
-- ----------------
-- Motu      4500
-- Patlu     5500


-- MMMMIIIIIMMMMMPPPP:-
-- Ek last important baat: Ki Txn mein by Default, DB ROLLBACK karta hai.
-- Matlab tum terminal chala rahe ho, usme Txn start kiya hua hai BEGIN ka use karke aur tum terminal ko band kar do. To By Default DB usko ROLLBACK kar dega.
-- Kisi bhi Txn ko COMMIT karne ke liye hame Explicitly COMMIT kilhna hi padega, warna IMPLICITLY agar kuch unusual hua to DB turant usse ROLLBACK kardega.


-- ==============================================================================================
-- Dekho as a Developer tum Deadlock ko internally kaise detect hota hai, kaise resolve hota hai,ya kaunsi algorithm use hoti hai...

-- In sab cheezon ki tension mat lo. Ye sab Database Engine ka kaam hai.

-- PostgreSQL, MySQL jaise Databases itne mature hote hain ki Deadlock detect karke automatically
-- kisi ek Transaction ko ROLLBACK kar dete hain.

-- Tumhara kaam sirf itna hai ki Transactions sahi tarike se likho.

-- Kis Row par Lock lagega, kaunsi Transaction wait karegi, aur Deadlock aane par kise Rollback karna hai...

-- Ye sab Database khud handle kar lega.

-- Haan, mujhe pata hai College mein Deadlock Prevention, Deadlock Avoidance, Wait-for Graph, Banker Algorithm jaise topics detail mein padhaye jaate hain. Jo ki Bilkul waste hai, Kyunki Pehle Transactions ko, practically samajhna Zaroori hai, ye saari baat baad mein aati hai. Pehle foundations clear hona chahiye, wo bhi practically, to baaki automatic samajh aajayega.

-- Ek Backend Developer ke roop mein, tumhara focus Transactions aur Locking ko sahi tarike se use karne par hona chahiye.

-- Deadlock ko internally kaise solve karna hai, wo Database Engine ki responsibility hai.
-- ==============================================================================================


CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    owner VARCHAR(50) NOT NULL,
    balance INT CHECK (balance >= 0)
);

INSERT INTO accounts (owner, balance)
VALUES
('Motu', 5000),
('Patlu', 5000);

SELECT * FROM accounts;

-- VsCode pe table bana liya hai, to Ab terminal mein jaake practice karo.