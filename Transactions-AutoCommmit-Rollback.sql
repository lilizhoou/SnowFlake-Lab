'''
The goal of this lab is to help understand how transaction works with 'autocommit','rollback' and 'locks'
Best practice is should always let autocommit to true, make life easier i guess ..
'''



-- Get Ready!
USE ROLE TRAINING_ROLE;
CREATE DATABASE IF NOT EXISTS GROUNDHOG_DB;
USE SCHEMA GROUNDHOG_DB.PUBLIC;
CREATE WAREHOUSE IF NOT EXISTS GROUNDHOG_WH;
USE WAREHOUSE GROUNDHOG_WH;

-- create table and insert record
CREATE OR REPLACE TABLE t1 
(
  c1   BIGINT,
  c2   STRING
);

INSERT INTO t1 (c1, c2)
    VALUES(1,'ONE'), (2, 'TWO'), (3,'THREE');
    
-- show the session is set to autocommit by default
SHOW PARAMETERS LIKE 'AUTOCOMMIT' IN SESSION;

SELECT * FROM t1;

-- rollback the above INSERT statement
ROLLBACK;

SELECT * FROM t1;
--  we can still see records bc of the auto-commit, nothing can roll back.


ALTER SESSION SET AUTOCOMMIT = FALSE;
SHOW PARAMETERS LIKE 'AUTOCOMMIT' IN SESSION;
INSERT INTO T1 (C1, C2)
    VALUES(4,'FOUR'), (5, 'FIVE');

SELECT * FROM t1;
-- if now we query from a new sheet, we won't see new record 4 and 5
rollback;
SELECT * FROM t1;
-- 4 and 5 records gone.

INSERT INTO T1 (C1, C2)
    VALUES(4,'FOUR'), (5, 'FIVE');
commit;

INSERT INTO t1 (c1, c2)  VALUES(6,'SIX');

INSERT INTO t1 (c1, c2)  VALUES(7,'SEVEN'), (8,'EIGHT');

COMMIT;

INSERT INTO T1 (C1, C2)  VALUES(9,'NINE');
ROLLBACK;


-- 4.5.0   Monitor Using SHOW LOCKS and LOCK_TIMEOUT Parameters for Concurrency
--         Control
--         Snowflake acquires resource locks while executing DML commands. The
--         locks are released when the transaction is committed or rolled back.
--         In this lab, AUTOCOMMIT has been set to false in Sheet A. Thus, any
--         DML command executed on Sheet A acquires the required resource lock.
--         This is to prevent any other session from making changes to the same
--         resource until the change has been committed or rolled back.
--         Explore the transaction-related parameter, LOCK_TIMEOUT, which
--         controls the number of seconds to wait while trying to lock a
--         resource before timing out and aborting the waiting statement.

SHOW PARAMETERS LIKE '%lock%';
SELECT * FROM t1;
SHOW LOCKS;
UPDATE t1
  SET c2='Second UPDATE'
  WHERE c1=8;

SELECT c2
FROM t1
WHERE c1 = 8;

SHOW LOCKS;
--         The current transaction in SHEET-A has a HOLDING status with a lock
--         on the target table, t1.

-- perfom following in anoter sheet
DELETE FROM t1
WHERE c1=7;
-- find this seems will take forever.

SHOW LOCKS;
-- we can see the delete transaction status is WAITING, and former update status is HOLDING

ROLLBACK;
SHOW LOCKS;

DELETE FROM t1
WHERE c1=6;

SELECT SYSTEM$ABORT_TRANSACTION('1737666204329000000');

rollback;

ALTER WAREHOUSE GROUNDHOG_wh SUSPEND;

