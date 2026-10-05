-- Dekho SQL mein string ko represent karne ke liye hamesha Single Quotes('') ka use karo.

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY, --SERIAL is an auto-incremented INT & PK = UNIQUE + NOT NULL
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),

    email VARCHAR(322) UNIQUE NOT NULL,
    phone_number VARCHAR(10) UNIQUE,
    country_code VARCHAR(4),

    age INT CHECK(age > 12),

    current_status VARCHAR(20) DEFAULT 'active' CHECK (current_status IN ('active', 'graduated', 'dropped_out')),

    masterji_handle VARCHAR(50) UNIQUE,

    has_joined_masterji BOOLEAN DEFAULT FALSE,

    current_score INT DEFAULT 0 CHECK(current_score >= 0 AND current_score <= 100),

    enrollment_date DATE DEFAULT CURRENT_DATE
);


ALTER TABLE students    -- It i used to change the structure of any table
ADD COLUMN batch_name VARCHAR(50) DEFAULT 'Web Dev 2026';

-- MMMIIIMMMMPPP INTERVIEW:-
-- What is DDL ? 
-- DDL stands for "Data Definition Language", It is used to define a structure in a SQL Database. 