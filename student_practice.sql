-- SQLBook: Code
/* ==========================================================================
   student_practice.sql
   CIS 4720 Database Management and SQL
   In Class Lab 5d

   WHAT THIS FILE IS
   Your working file for Lab 5d. The first two statements are written for
   you. Everything from Step 1 down is yours to write, under the heading
   that is already there for each step.

   HOW TO USE IT
   Run one statement at a time. Put the cursor on it and press Ctrl + E
   twice, or right click and choose Run Current Query. Do not run the whole
   file in one go, because Step 8 creates a function and that step has to be
   run as a single block on its own.

   LABELING AND COMMENTING IS REQUIRED
   Above every statement you write, put a short comment in your own words
   saying what it does. The headings below are already numbered, so keep
   your work underneath the right one. The comments are graded.
   ========================================================================== */


-- =================================================================
-- SETUP. Run these two first, in this order
-- =================================================================

-- Every schema on this server. Look for cis_students_db afterwards.
show databases;

-- Make the schema for this lab. IF NOT EXISTS means it is safe to run
-- twice, and it will not complain if you already made it.
create database if not exists cis_students_db;


-- =================================================================
-- POINT YOURSELF AT THE NEW SCHEMA
-- =================================================================

-- Everything below has to land in cis_students_db, not in the schema you
-- connected to. This line switches the session over.
--
-- IMPORTANT: if your tables keep appearing in the wrong place, your tool
-- is opening a new connection for each statement and this line is being
-- forgotten. Step 3 of the lab tells you how to fix that for good by
-- adding a second SQLTools connection that points at cis_students_db.
use cis_students_db;


-- ######################################################################
-- YOUR WORK STARTS BELOW THIS LINE
--
-- You write the SQL for Steps 1 through 7 yourself. The handout gives you
-- the specification, the data and the result you should get.
--
-- Steps 8, 9 and 10 are printed in the handout for you to copy, because
-- you have not written a function or a trigger before.
--
-- STEPS 8 AND 10 ARE RUN AT THE COMMAND PROMPT, not in VS Code. They
-- start with DELIMITER, which is an instruction to the command prompt
-- program rather than SQL, so the server rejects it. The handout says
-- what to do. Everything else in this file runs in VS Code as usual.
-- ######################################################################


-- =================================================================
-- STEP 1. Create the students table, then describe it
-- =================================================================

-- Create the students table with columns

create table if not exist students ( student_id INT auto_increment primary key, first_name varchar (40) not null, last_name varchar (40) not null, gpa float (4,2)) show full tables; describe student;

-- =================================================================
-- STEP 2. Insert four rows using NULL for student_id and gpa
-- =================================================================

-- Insert these four students in a single statement. Supply NULL for student_id and NULL for gpa. The NULL in
student_id is what tells AUTO_INCREMENT to do its job. The NULL in gpa is a real empty value, which you fill
in at the end of the lab.
Insert into students VALUES
(null, "Jenna", "Wilsion", null),
(null, "Robert", "Reese", null),
(null, "Inder", "Singh", null)
*/
select * from students;


-- =================================================================
-- STEP 3. Insert two more rows, naming the columns first
-- =================================================================

-- 
/*  Insert new rows supplying the column name first so that null does not need to be inlcuded for the studnet_id or the gpa */
*/
insert into students (first_name, last_name) values
("Rita", "Numez"),
("James", "Toor")
*/
select * from students;


-- =================================================================
-- STEP 4. Delete James Toor
-- =================================================================

-- Delete the row for James Toor, then select the table again. Five rows left, with ids 1 through 5.
delete from students where first_name = 'James' and last_name = 'Toor';

select * from students;




-- =================================================================
-- STEP 5. Create the test_scores table
-- =================================================================

--
-- create table if not exist test_scores (
   test_scores_id auto_increment primary key,
   test_name varchar (20) not null, 
   student_id int not null,
   score float, 
   foreign key (student_id) references students(student_id));


-- =================================================================
-- STEP 6. Insert the ten test score rows
-- =================================================================

-- your comment goes here
/*
insert into test_scores values
(null,"quiz1", 1, 90),
(null, "quiz2", 4, 91),
(null, "quiz1",  2, 85),
(null, "quiz3", 2, 95),
(null, "quiz1", 3, 95),
(null, "quiz3", 3, 94),
(null, "quiz2",  1, 80),
(null, "quiz3",  4, 74),
(null, "quiz2", 2, 72),
(null, "quiz2", 3, 88)
*/
select * from test_scores;

-- =================================================================
-- STEP 7. Create the student_scores view from a LEFT OUTER JOIN,
--         then query it twice
-- =================================================================

-- write left outer join for students so student diplay is even
create view student_scores as
select 
concat(s.first_name, ' ', s.last_name) as student_name,t.test_name, 
    t.score
    from students s
    left outer join test_scores t on s.student_id = t.student_id;

select * from student_scores;
select * from student_scores where student_id = 3;

-- =================================================================
-- STEP 8. Create the calculate_gpa function
--
-- Paste the block from the handout in here so it is part of what you
-- submit, then RUN IT AT THE COMMAND PROMPT, not in VS Code.
--
-- DELIMITER is an instruction to the mysql command prompt program. It is
-- not SQL. Run it here and the server rejects it with
--   ERROR 1064 ... near 'DELIMITER $$' at line 1
-- =================================================================
create function calculate_gpa(p_student_id INT)[cite: 8]
returns decimal(4,2)[cite: 8]
deterministic[cite: 8]
reads sql data[cite: 8]
begin
    declare v_gpa decimal(4,2);[cite: 8]
    
    select round(avg(score), 2)[cite: 8]
    into v_gpa[cite: 8]
    from test_scores[cite: 8]
    where student_id = p_student_id[cite: 8]
    and score is not null;[cite: 8]
    
    return ifnull(v_gpa, 0.00);[cite: 8]
end$$
DELIMITER ;
-- Confirm the function was created successfully
show create function calculate_gpa;


-- =================================================================
-- STEP 9. Run the function and fill in every gpa
-- =================================================================
update students 
set gpa = calculate_gpa(student_id);
-- check system if updated
select * from students;


-- =================================================================
-- STEP 10. Create the triggers that recalculate the gpa
--
-- Same as Step 8. Paste the block in here, then run it at the command
-- prompt. Afterwards add a score or change one, back here in VS Code,
-- and check that the gpa moved on its own.
-- =================================================================

-- your comment goes here
create trigger trg_scores_after_insert
after insert on test_scores
for each row
begin
    update students set gpa = calculate_gpa(new.student_id)
    where student_id = new.student_id;
END
*/
-- and the same again for score changed 
create trigger trg_scores_after_update after update on test_scores for each row begin update students set gpa = calculate_gpa(new.student_id) where student_id = new.student_id;
END */
-- check to see if trigger works
show triggers;
-- TEst triggers by ad dbew score for student Jenna.
insert into test_scores (test_name, student_id, score) values ('quiz4', 1, 100);
-- check jenna gpa 
select * from students where student_id = 1;


-- =================================================================
-- STEP 11. Push this file to GitHub
-- Nothing to write here. Follow the handout.
-- =================================================================
