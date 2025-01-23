CREATE OR REPLACE TABLE book 
AS 
SELECT
   parse_xml($1) AS x
FROM VALUES
('
<catalog issue="spring" date="2015-04-15">
    <book id="bk101">
        <title>Some Great Book</title>
        <genre>Great Books</genre>
        <author>Jon Smith</author>
        <publish_date>2001-12-28</publish_date>
        <price>23.39</price>
        <description>This is a great book!</description>
    </book>
    <cd id="cd101">
        <title>Sad Music</title>
        <genre>Sad</genre>
        <artist>Emo Jones</artist>
        <publish_date>2010-11-23</publish_date>
        <price>15.25</price>
        <description>This music is so sad!</description>
    </cd>
    <map id="map101">
        <title>Good CD</title>
        <location>North America</location>
        <author>Joey Bagadonuts</author>
        <publish_date>2013-02-02</publish_date>
        <price>102.95</price>
        <description>Trail map of North America</description>
    </map>
</catalog>');

SELECT
x:"@issue"::STRING AS issue, 
TO_DATE(x:"@date"::STRING, 'YYYY-MM-DD' ) AS date, 
XMLGET( VALUE, 'title' ):"$"::STRING AS title, 
COALESCE( XMLGET( VALUE, 'genre' ):"$"::STRING, 
          XMLGET( VALUE, 'location' ):"$"::STRING ) AS genre_or_location, 
COALESCE( XMLGET( VALUE, 'author' ):"$"::STRING, 
          XMLGET( VALUE, 'artist' ):"$"::STRING ) AS author_or_artist, 
TO_DATE( XMLGET( VALUE, 'publish_date' ):"$"::String ) AS publish_date, 
XMLGET( VALUE, 'price' ):"$"::FLOAT AS price, 
XMLGET( VALUE, 'description' ):"$"::STRING AS desc
FROM book,
LATERAL FLATTEN( INPUT => x:"$" );



