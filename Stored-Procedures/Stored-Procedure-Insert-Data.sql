'''insert and log insert logs.'''

  
CREATE OR REPLACE PROCEDURE INSERT_NATIONS_INTO_REGION_TABLES()
RETURNS VARCHAR NOT NULL
LANGUAGE SQL
AS
DECLARE
        counter integer DEFAULT 0;
        cur cursor for select nationkey, nation, region from nation;  
        nationkey NUMBER(38,0) DEFAULT 0;
        nation varchar;
        region varchar;

BEGIN   
            open cur;            
            FOR record IN cur DO
                nationkey := to_NUMBER(record.nationkey);
                nation := TO_CHAR(record.nation);
                region := TO_CHAR(record.region);
                                
                CASE 
                    WHEN region='AFRICA' THEN
                        INSERT INTO AFRICA (NATIONKEY, NATION, REGION)
                        VALUES (:NATIONKEY, :NATION, :REGION);
                    WHEN region='AMERICA' THEN
                        INSERT INTO AMERICA (NATIONKEY, NATION, REGION)
                        VALUES (:NATIONKEY, :NATION, :REGION);
                    WHEN region='APAC' THEN
                        INSERT INTO APAC (NATIONKEY, NATION, REGION)
                        VALUES (:NATIONKEY, :NATION, :REGION);            
                    WHEN region='EUROPE' THEN
                        INSERT INTO EUROPE (NATIONKEY, NATION, REGION)
                        VALUES (:NATIONKEY, :NATION, :REGION);            
                    WHEN region='MIDDLE EAST' THEN
                        INSERT INTO MIDDLE_EAST (NATIONKEY, NATION, REGION)
                        VALUES (:NATIONKEY, :NATION, :REGION);       
                END;
                
                INSERT INTO INSERT_LOG (NATIONKEY, NATION, REGION, TABLENAME, TS)
                VALUES (:NATIONKEY, :NATION, :REGION, :REGION, current_timestamp(2));                
                
                counter := counter + 1;   
                
            END FOR;
            close cur;
            RETURN 'Insertion and logging complete.';
END;

CALL INSERT_NATIONS_INTO_REGION_TABLES();
