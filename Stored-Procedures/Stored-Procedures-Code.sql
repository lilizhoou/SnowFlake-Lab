'''simple procedure to create a table'''
  
CREATE OR REPLACE PROCEDURE CREATE_NATION_TABLE()
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
    CREATE OR REPLACE TABLE NATION AS SELECT 
        N.N_NATIONKEY AS NATIONKEY, 
        N.N_NAME NATION, 
        R.R_NAME REGION
    FROM 
        SNOWBEARAIR_DB.PROMO_CATALOG_SALES.NATION N 
        INNER JOIN SNOWBEARAIR_DB.PROMO_CATALOG_SALES.REGION R ON N.N_REGIONKEY = R.R_REGIONKEY;
        
    RETURN 'Creation of table NATION complete.';
END;


CALL CREATE_NATION_TABLE();

=====================================================
  
''' use snowflae scripting IF-THEN'''
  
CREATE OR REPLACE PROCEDURE TRANSFER_STAGED_ROWS(T VARCHAR)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
    IF (T='N') THEN
        INSERT INTO NATION SELECT NATIONKEY, NATION, REGION FROM NATIONS_NEW;
        RETURN 'Completed insert.';
    ELSE
        INSERT INTO NATION SELECT NATIONKEY, NATION, REGION FROM NATIONS_NEW;
        TRUNCATE NATIONS_NEW;
        RETURN 'Completed insert and truncate.';
    END IF;
END;

CALL TRANSFER_STAGED_ROWS('N');


''' use CASE WHEN also works'''

CREATE OR REPLACE PROCEDURE TRANSFER_STAGED_ROWS(T VARCHAR)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
BEGIN
    CASE 
        WHEN T='N' THEN
            INSERT INTO NATION SELECT NATIONKEY, NATION, REGION FROM NATIONS_NEW;
            RETURN 'Completed insert.';
        WHEN T='Y' THEN
            INSERT INTO NATION SELECT NATIONKEY, NATION, REGION FROM NATIONS_NEW;
            TRUNCATE NATIONS_NEW;
            RETURN 'Completed insert and truncate.';
        ELSE
            TRUNCATE NATIONS_NEW;
            RETURN 'Completed truncate. No rows inserted.';        
    END;
END;


CALL TRANSFER_STAGED_ROWS('X');

=====================================================
''' log truncaed changes''' 
  
CREATE OR REPLACE PROCEDURE LOG_TRUNCATED_ROWS()
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
DECLARE
        counter integer DEFAULT 0;
        cur cursor for select nationkey, nation, region from nations_new;  
        nationkey NUMBER(38,0) DEFAULT 0;
        nation varchar;
        region varchar;
BEGIN   
        open cur;            
        FOR record IN cur DO
            nationkey := TO_NUMBER(record.nationkey);
            nation := TO_CHAR(record.nation);
            region := TO_CHAR(record.region); 
                           
            INSERT INTO TRUNCATED_NATIONS_LOG (NATIONKEY, NATION, REGION)
            VALUES (:NATIONKEY, :NATION, :REGION);             
            counter := counter + 1;           
        END FOR;
        close cur;
        RETURN 'Logged rows to be truncated.';
END;


''' call in when truncate'''
CREATE OR REPLACE PROCEDURE TRANSFER_STAGED_ROWS(T VARCHAR)
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS 
BEGIN
    CASE 
        WHEN T='N' THEN
            INSERT INTO NATION SELECT NATIONKEY, NATION, REGION FROM NATIONS_NEW;
            RETURN 'Completed insert.';
        WHEN T='Y' THEN
            INSERT INTO NATION SELECT NATIONKEY, NATION, REGION FROM NATIONS_NEW;
            TRUNCATE NATIONS_NEW;
            RETURN 'Completed insert and truncate.';
        WHEN T='T' THEN
            CALL LOG_TRUNCATED_ROWS(); # here  
            TRUNCATE NATIONS_NEW;
            RETURN 'Completed truncate. No rows inserted.'; 
        ELSE
            RETURN 'No action.';
    END;
END;






