
CREATE WAREHOUSE IF NOT EXISTS GROUNDHOG_WH;
ALTER WAREHOUSE GROUNDHOG_WH SET WAREHOUSE_SIZE=XSmall;
USE WAREHOUSE GROUNDHOG_WH;

CREATE DATABASE IF NOT EXISTS GROUNDHOG_DB;

CREATE SCHEMA IF NOT EXISTS GROUNDHOG_db.regions_dev;
USE SCHEMA GROUNDHOG_db.regions_dev;

-- 3.1.2   Clone the table you need into the regions_dev schema.

CREATE OR REPLACE TABLE region 
CLONE snowbearair_db.promo_catalog_sales.region;

-- 3.2.0   Add Regions to the Region Table

-- 3.2.1   Check that the table has five rows.

SELECT * FROM region;

-- 3.2.2   Fetch the current timestamp and save it as a session variable.

SET dev_before_changes = current_timestamp();


-- 3.2.3   Insert four rows into the region table.

INSERT INTO 
   region
VALUES
   (6, 'Western Europe'),
   (7, 'Eastern Europe'),
   (8, 'Northern Europe'),
   (9, 'Southern Europe');


-- 3.2.4   Fetch the last query ID and save it as a session variable.

SET dev_new_europe_regions = LAST_QUERY_ID();


-- 3.2.5   Check that the region table has nine rows.

SELECT * FROM region;


-- 3.3.0   Standardize Region Names in the Region Table
--         Since you were not provided with specifics, you decided to make all
--         the entries mixed-case. You will delete the existing regions and then
--         re-add them.

-- 3.3.1   Delete the pre-existing regions from the region table.

DELETE FROM 
   region
WHERE
   r_regionkey < 6;


-- 3.3.2   Fetch the query id of the DELETE statement and save it in a session
--         variable.

SET dev_remove_existing_UC_regions = LAST_QUERY_ID();

--         By saving the execution of this DELETE statement as a point-in-time
--         in variable dev_remove_existing_UC_regions, we can leverage Time
--         Travel to check the state of the table prior to that DELETE
--         statement. We’ll do that in just a moment.

-- 3.3.3   Determine the regions to add back in.
--         Now, you need to add the existing regions back in using mixed-case.
--         However, you realize you don’t know what the existing regions were or
--         their region IDs. So you need to use Time Travel to look at the table
--         before you took that information out.

SELECT *
FROM region
BEFORE(statement=>$dev_remove_existing_UC_regions);

--         As you can see, the BEFORE clause allowed us to see what regions were
--         in the table before we deleted them.

-- 3.3.4   Add the previous regions back into the table in mixed case.
--         Now you know the regions and can add them back in.

INSERT INTO
   region
VALUES
   (0, 'Africa'),
   (1, 'America'),
   (2, 'Apac'),
   (3, 'Europe'),
   (4, 'Middle East');

SET dev_old_regions_mixed_case = LAST_QUERY_ID();

SELECT * FROM region;

--         When you look at the output, you notice a problem. You have added
--         four new regions for different areas of Europe, but the region Europe
--         is still in the table. You point this out to the project manager.

-- 3.3.5   Remove the region Europe from the table.

DELETE FROM 
   region
WHERE
   r_name = 'Europe';

SET dev_remove_europe = LAST_QUERY_ID();

--         Once again, we save the point-in-time this last query was run into a
--         variable called dev_remove_europe. We can use this later in a BEFORE
--         statement.
--        
-- 3.4.0   Change the Region Names to Upper Case
--         Rather than recreate the old table, you decide to restore the
--         original version, remove Europe, and then add the new regions. You no
--         longer have the ability to clone the table from production, so you
--         decide to drop the table and then undrop the earliest version.

-- 3.4.1   Drop the current version of the region table.

DROP TABLE region;


-- 3.4.4   UNDROP the region table and clone it.

UNDROP TABLE region;

CREATE TABLE
   restored_region
CLONE
   region
BEFORE(timestamp=>$dev_before_changes);

SELECT * FROM restored_region;


-- 3.5.0   Make the Necessary Changes to the Restored Region Table
--         Now that you fully understand the requirements, you can make the
--         necessary changes.

-- 3.5.1   Delete the EUROPE record from the restored table and verify the table
--         data.

DELETE FROM
   restored_region
WHERE
   r_name = 'EUROPE';

SET dev_dropped_europe = LAST_QUERY_ID();

SELECT * FROM restored_region;


-- 3.5.2   Insert the new EUROPE records into the restored table and verify the
--         table data.

INSERT INTO
   restored_region
VALUES
   (5, 'EUROPE: EASTERN'),
   (6, 'EUROPE: NORTHERN'),
   (7, 'EUROPE: SOUTHERN'),
   (8, 'EUROPE: WESTERN');


SET dev_added_new_UC_regions = LAST_QUERY_ID();

SELECT * FROM restored_region;


-- 3.5.3   Compare the restored_region table with the original.

SELECT * FROM restored_region
MINUS
SELECT * FROM region AT(timestamp=>$dev_before_changes);

--         You can also compare the tables with a JOIN:

SELECT 
   o.r_regionkey AS original_key,
   o.r_name AS original_name,
   n.r_regionkey AS new_key,
   n.r_name AS new_name
FROM 
   restored_region n
FULL JOIN
   region AT(timestamp=>$dev_before_changes) o
ON 
   o.r_regionkey = n.r_regionkey
ORDER BY
   original_key, 
   new_key;

-- 3.5.4   Drop the table region and rename restored_region to region.

DROP TABLE region;

ALTER TABLE
   restored_region
RENAME TO
   region;

SELECT * FROM region;

-- 3.5.5   Suspend your virtual warehouse.

ALTER WAREHOUSE GROUNDHOG_wh SUSPEND;
