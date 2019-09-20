
- The Locator App: http://www.cs.nuim.ie/~pmooney/locator/ 

- PostGIS Function Reference: https://postgis.net/docs/reference.html 

- UTM Grid: https://en.wikipedia.org/wiki/Universal_Transverse_Mercator_coordinate_system#/media/File:Utm-zones.jpg 

- geojson.io

- WKT Notation: POINT(-6.575274 53.390956) This is of the form (LONG, LAT)

-- Gives the number of rows in the table
SELECT count(*) FROM <table_name>

-- Datatypes in create table
INTEGER 
DECIMAL 
REAL
BIT
DATE
TIME
TIMESTAMP
CHAR
VARCHAR

-- sorting
ORDER BY <obj> ASC;

-- pattern matching
WHERE (manager LIKE 'A%')

-- Find names with 2 r's anywhere
SELECT * from Lecture6 WHERE Owner SIMILAR TO '%r{2}%'

-- Find surnames with 2 or more o's (note the space after the first %)
SELECT * from Lecture6 WHERE Owner SIMILAR TO '% %o{2,}%'

-- find all names where the first name is 5 chars/letters long and ends in 'y'
SELECT * from Lecture6 WHERE Owner SIMILAR TO '____y %'

-- Find all surnames which are just FOUR LETTERS LONG (note space after first %)
SELECT * from Lecture6 WHERE Owner SIMILAR TO '% ____'

 -- Find all IP address with 3 digits in each field
-- So we are looking for IP addresses which have the format
-- 3 digits dot 3 digits dot 3 digits dot 3 digits
SELECT * from Lecture18 where IP SIMILAR TO '___.___.___.___'

-- Search for several words with just one pattern.
SELECT * from Lecture6 where Bitcoinaddress SIMILAR TO '%(GAP|DAN|POW|CORE)%';

-- char_length() counts the number of characters in the string (including spaces)
select * from Lecture6 where char_length(Owner) >= 15;

-- page 54 of document CS621_Week3_Part1.pdf shows a list of constraints/quantifiers 
-- for regular expressions

-- ColumnName ~ 'REGEX' (case sensitive)
-- ColumnName ~* 'REGEX' (case insensitive)

-- Find all street address where the house number has one digit?
-- note one digit then a space
select * from lecture6b where streetaddress ~ '^\d{1}\s{1}.*$'

-- Find all phone numbers where there is a single digit first prefix and finishes in 68?
-- single digit, then a dash, then ends in 68
select * from lecture6b where phone ~ '^\d­.*68$'

-- The combination of .* matches ANYTHING ... it is the equivalent of the % symbol with LIKE
-- \d matches a single digit
-- \d\d matches two digits only, 
-- \d\d\d three digits only
-- \d{7} will match 7 digits only
-- \d{1,3} will match between 1 and 3 digits together (inclusive)
-- ^ start of the string
-- $ end of the string 

-- this will match 4 or more b's
MyWord ~* ‘^.*b{4,}.*$’

-- this will match 2 or 3 occurrences of ab
MyWord ~* ‘^.*(ab){2,3}.*$’

-- the IP Address begins with 99 and ends with 9
select * from cs621week3ex1 where IP_Address like '99%9';

-- find email addresses in the database which contain 2 or 3 digits together, 
-- ONLY AFTER the @ in the email address?
select * from cs621week3ex1 where emailaddress ~* '^.*@.*\d{2,3}.*$';

-- find 2 or 3 letter e together OR 2 or 3 letter o together ANYWHERE in the username
select * from cs621week3ex1 where 
(username ~* '^.*e{2,3}.*$')
or 
(username ~* '^.*o{2,3}.*$')


-- DATE AND TIME
-- Select all hurricanes that occurred in 2005. Sort in chronological order
SELECT 
HurricaneName,DateOccurred,MaxSpeed 
from Hurricanes 
where (DateOccurred >= '2005­01­01')
and (DateOccurred <='2005­12­31')
order by DateOccurred asc

-- postgres will store the FinishTime in time format
INSERT into AlpeDhuez 
(StagePosition,Cyclist,TeamName,FinishTime) 
values (1,'Thibaut PINOT','FDJ','03:17:21')

-- Selecting all cyclists with a finish time of 3hr 18m
SELECT Cyclist, FinishTime 
FROM AlpeDhuez 
WHERE (FinishTime >= '03:18:00') 
and (FinishTime <= '03:18:59')

CREATE TABLE MyDiary
(
 EntryNumber INTEGER NOT NULL,
 diaryDate DATE NOT NULL,
 diaryTime TIME NOT NULL,
 diaryEntry VARCHAR(400) NOT NULL,
 CONSTRAINT MyDiary_pkey PRIMARY KEY (EntryNumber)
)

-- DATE has a format 'YYYY-MM-DD', TIME has a format 'HH:MM:SS'
INSERT into MyDiary 
(EntryNumber,diaryDate,diaryTime,diaryEntry) values 
(1001,'2015­10­15','12:05:00','CS130 Lecture 7 ­ 
Iontas Lecture Hall, North Campus')

-- You can have a TIMESTAMP type in CREATE TABLE
-- Instant is a TIMESTAMP data type
SELECT Instant, Rainfall from Rainfall 
where Instant > '2016­12­31 23:59:59';

--  list all tweets sent on the first day of any month
- tweettime is type TIMESTAMP
select * from tweetdb where
date_part('day',tweettime) = 1;

-- list all tweets sent in the month of June
select * from tweetdb where
date_part('month',tweettime) = 6;

-- list all tweets sent between midnight and 06:59 am inclusive in any year 
-– order the results chronologically
select * from tweetdb where 
(date_part('hour',tweettime) >= 0) and 
(date_part('hour',tweettime) <= 6)
order by tweettime desc;

-- Select ALL data in the database where the timestamp is in the FUTURE
select * from MYdb where timestampCol > NOW()


create table JobsTable (
	RowID INT not null,
	CompanyName VARCHAR(50) not null,
	State VARCHAR(50) not null,
	JobTitle VARCHAR(50) not null,
	Salary DECIMAL(7,2) not null,
	Skills VARCHAR(50) not null,
	CONSTRAINT JobsTablePKEY Primary Key (RowID)
);

insert into JobsTable (RowID, CompanyName, State, JobTitle, Salary, Skills) 
values (1, 'Blogtags', 'California', 'Chemical Engineer', 60650.39, 'Townhomes');
insert into JobsTable (RowID, CompanyName, State, JobTitle, Salary, Skills) 
values (2, 'Flashspan', 'Texas', 'VP Quality Control', 59657.51, 'C++');


-- Query
SELECT CompanyName, JobTitle, State, Salary FROM JobsTable WHERE 
(CompanyName = 'Babblestorm' AND State = 'Texas' AND Salary > 60000);




create table MyTwitter (
	RowID INT NOT NULL,
	username VARCHAR(50) NOT NULL,
	emailAddress VARCHAR(50) NOT NULL,
	TweetText VARCHAR(140) NOT NULL,
    CONSTRAINT MyTwitterPKEY PRIMARY KEY (RowID)
);
insert into MyTwitter (RowID, username, emailAddress, TweetText) 
values (1, 'atreadger0', 'rnerval0@ebay.co.uk', 'Diverse grid-enabled moderator');
insert into MyTwitter (RowID, username, emailAddress, TweetText) 
values (2, 'madamovitch1', 'rspall1@cargocollective.com', 'Multi-channelled global leverage');

-- Select username where username does not contain lowercase e
SELECT username FROM MyTwitter WHERE NOT(username LIKE '%e%') ORDER BY username desc


-- Select all attributes of rows where email address ends in .org or tweet text contains 
-- 'ed' or 'en' in this order and can be separated by other text
SELECT rowID, username, emailAddress, TweetText FROM MyTwitter WHERE 
(emailAddress LIKE '%.org') OR (TweetText LIKE '%ed%en%');




create table observations (
	obs_id INT NOT NULL,
	animal VARCHAR(50) NOT NULL,
	country VARCHAR(50) NOT NULL,
	latitude FLOAT NOT NULL,
	longitude FLOAT NOT NULL,
	gender VARCHAR(50) NOT NULL,
	color VARCHAR(6) NOT NULL,
	snumber INT NOT NULL,
	Constraint observationspkey PRIMARY KEY (obs_id)
);
insert into observations (obs_id, animal, country, latitude, longitude, gender, color, snumber) 
values (1, 'Two-banded monitor', 'United States', 44.9799999, -93.26, 'Female', 'Yellow', 28);
insert into observations (obs_id, animal, country, latitude, longitude, gender, color, snumber) 
values (2, 'Penguin', 'Morocco', 33.8521783, -7.0390904, 'Male', 'Black', 58);
insert into observations (obs_id, animal, country, latitude, longitude, gender, color, snumber) 
values (3, 'Snake', 'Croatia', 45.6518526, 16.5355901, 'Female', 'Yellow', 32);

SELECT animal, gender, color, snumber FROM observations WHERE 
(gender = 'Female' AND snumber > 70) OR (gender = 'Male' AND color = 'Red');

SELECT obs_id, animal, country, latitude, longitude, gender, color, snumber 
FROM observations WHERE (animal LIKE '%-%') AND NOT(country LIKE '%a%');


SELECT obs_id, animal, country, latitude, longitude, gender, color, snumber FROM observations 
WHERE (latitude > 20.00 AND latitude < 35.00) AND (longitude > 100.00 AND longitude < 118.00);


-- Find all email addresses in the database which contain 2 or 3 digits together, 
-- ONLY AFTER the @ in the emailaddress
SELECT * FROM cs621week3ex1 WHERE emailaddress ~* '^.*@.*\d{2,3}.*$';



-- Find all usernames which contain 2 or 3 e's together or 2 or 3 o's 
-- together ANYWHERE in the database
SELECT * FROM cs621week3ex1 WHERE username ~* '^.*(e{2,3|o{2,3}).*$';
SELECT * FROM cs621week3ex1 WHERE username ~* '^.*e{2,3).*$';


-- List all people where fullname is longer than 10 chars and have made calls in India
SELECT * FROM cs621week3ex1 WHERE (char_length(fullname) > 10) AND (country = 'India');


-- List all mobile phone numbers where the first space char in the number appears after 6 digits
SELECT mobilephone FROM cs621week3ex1 WHERE mobilephone ~* '^.*\d{6}\s.*$';


-- List all mobile numbers where at least two 9 appear consecutively anywhere in the number
SELECT mobilephone from cs621week3ex1 WHERE mobilephone ~* '^.*9{2}.*$';
OR
SELECT mobilephone from cs621week3ex1 WHERE mobilephone LIKE '%99%';


-- List company names where 'and' appears anywhere. 
SELECT company_name from cs621week3ex1 WHERE company_name ~* '^.*\sand\s.*$';


-- 087 is a vodafone number. List details of calls when mobile number is vodafone,
-- country is Ireland and company name longer than 10 chars
SELECT * from cs621week3ex1 WHERE (mobilephone ~* '^087.*$') 
AND (country = 'Ireland') AND ((char_length(company_name) > 10));


-- Lists all company names with no space in the name
SELECT company_name FROM cs621week3ex1 WHERE NOT (company_name ~* '^.*\s.*$');


-- Lists fullname of users who have more than two parts to their name. Parts are separated by a space
SELECT fullname FROM cs621week3ex1 WHERE (fullname ~* '^.*\s.*\s.*$');


-- List all usernames which are 5 chars or less in size, order alphabetically
SELECT username FROM cs621week3ex1 WHERE (char_length(username) < 5) ORDER BY username asc;

-- Gives all stocktimes in the future
SELECT * FROM cs621week3_investors WHERE stocktime > NOW();


SELECT * FROM cs621week3_investors WHERE 
(stocktime >= '2017-12-25' AND stocktime <= '2018-12-25')
ORDER BY stocktime desc;


-- gives timestamp
SELECT NOW();


-- day is 7, month is 7, regardless of year, stockname > 20 chars
SELECT * FROM cs621week3_investors WHERE 
(date_part('day', stocktime) = 7 AND date_part('month', stocktime) = 7) AND char_length(stockname) > 20;


-- day of the evaluation is same as month of evaluation e.g. 06/06, 07/07, 08,08 etc
-- comparing the output of two functions
SELECT * FROM cs621week3_investors WHERE 
(date_part('day', stocktime) = date_part('month', stocktime));


-- 4 digits, 0 or 1 spaces, replicated 6 times
SELECT investoriban FROM cs621week3_investors WHERE 
investoriban ~* '^.*(\d{4}\s{0,1}){6}.*$';


-- Stockname begins with a capital letter vowel
SELECT stockname FROM cs621week3_investors WHERE 
(stockname SIMILAR TO '(A|E|I|O|U)%');


-- Select all investor IBAN where the last block is 4 digits – and does not include any other character.
SELECT investoriban FROM cs621week3_investors WHERE
investoriban ~* '^.*\s\d{4}$';


-- Select all investor IBAN where the last block is 4 digits but the first digit of this final block is 0
SELECT investoriban FROM cs621week3_investors WHERE
investoriban ~* '^.*\s0\d{3}$';


-- Select all investor IBAN where the last block is 4 digits and this block starts with a 0 or 9. The
-- entire length of the investor IBAN should be exactly 34 characters.
SELECT investoriban FROM cs621week3_investors WHERE
((investoriban ~* '^.*\s0\d{3}$') OR (investoriban ~* '^.*\s9\d{3}$')) 
AND (char_length(investoriban) = 34);


-- Select all investor stocktimes where the sum of the hours minutes and seconds is LESS THAN the
-- sum of the month and day for any stock time.
SELECT stocktime FROM cs621week3_investors WHERE
(date_part('hour', stocktime) + date_part('minute', stocktime) + date_part('second', stocktime)) <
 (date_part('day', stocktime) + date_part('month', stocktime));


-- Select all IBANS which are Palindromes
SELECT investoriban FROM cs621week3_investors WHERE
reverse(investoriban) = investoriban;


-- Select all stocks where the stockname includes a three digit number and the stock name is in the
-- future. Use the results of your query to find which stock has the stocktime further in the future.
SELECT stockname, stocktime FROM cs621week3_investors WHERE
(stockname ~* '^.*\d{3}.*$') AND stocktime > NOW();


-- Select all stocks which have a stock value that if we calculated 95% of the stockvalue it would be
-- still greater than 180 euros.
SELECT stockname, stockvalue FROM cs621week3_investors WHERE
(stockvalue * 0.95) > 180;

-- List ALL stock evaluations where the DAY of the stock evaluation is equal to the MONTH of the evaluation
SELECT * from CS621Week3_investors where 
(date_part('day',stocktime) = date_part('month',stocktime))
order by stocktime desc;

-- List ALL IBAN numbers which consist of 6 blocks of 4 digits ONLY
SELECT investoriban from CS621Week3_investors where 
investoriban ~ '^.*(\d{4}\s{0,1}){6}.*$'



DROP TABLE if exists mymovies;
CREATE TABLE mymovies
(
  Movievisitnumber integer NOT NULL,
  moviename varchar(200) NOT NULL,
  movieminutes integer NOT NULL,
  movierating real NOT NULL,
  movieguide varchar(20) NOT NULL,
  CONSTRAINT mymovies_pkey PRIMARY KEY (Movievisitnumber)
);

INSERT INTO mymovies
(Movievisitnumber,moviename,movieminutes,movierating,movieguide)
values (101,'Interstellar', 169, 8.7, 'PG-13');




-- Spatial reference system (SRS) or coordinate reference system (CRS)
-- Spatial Reference System Identifier (SRID) 
-- European Petroleum Survey Group (EPSG) EPSG:4326 is the most well known CRS

-- Point as Well Known Text: POINT(-6.548624 53.388243)
-- Point as Well Known Text for PostGIS: St_GeomFromText('POINT(-6.548624 53.388243)',4326);

geometry := ST_GeomFromText(text WKT, integer srid);
-- allows us to specify which SPATIAL REFERENCE system our data is in.

-- PostGIS provides a wide range of functions to OUTPUT geometry in HUMAN and
-- MACHINE readable formats.
-- The query below will add a new column, ST_AsText which gives the coords in WKT
SELECT airname,aircoords, ST_AsText(AirCoords) 
FROM CS621Airports;

-- The query below will add a new column, ST_AsGeoJSON which gives the coords 
-- in geojson format
SELECT airname,aircoords, 
ST_AsGeoJSON(AirCoords) FROM 
CS621Airports;

Geometries can be POINT, POLYGON (a building) or POLYLINE (a road/path)

CREATE Table CS621Airports
(
    AirID VARCHAR NOT NULL,
    AirName VARCHAR NOT NULL,
    AirCountry VARCHAR NOT NULL,
    AirDesc TEXT NOT NULL,
    AirCoords GEOMETRY NOT NULL,
    CONSTRAINT CS621Airports_pkey PRIMARY KEY (AirID)
);


INSERT INTO CS621Airports
(AirID, AirName, AirCountry, AirDesc, AirCoords) VALUES
(
'DUB',
'Dublin Ireland',
'Ireland',
'This is Dublin Airport. It is the largest airport in Ireland.',
ST_GeomFromText('POINT(-6.239601 53.427430)',4326) -- POINT as WKT in PostGIS
);

-- Adds a new column 
SELECT airname, aircoords,
ST_AsText(Aircoords) FROM
CS621Airports;

SELECT airname, aircoords,
ST_AsKML(Aircoords) FROM
CS621Airports;

SELECT airname, aircoords,
ST_AsGeoJSON(Aircoords) FROM
CS621Airports;




DROP TABLE if exists CS621Campus;
CREATE table CS621Campus
(
    objectID INT NOT NULL,
    objectName VARCHAR NOT NULL,
    objectGeom GEOMETRY NOT NULL,
    CONSTRAINT CS621Campus_pkey PRIMARY KEY (objectID)
);


-- You get the POLYGONS from Geojson
INSERT INTO CS621Campus (objectID, objectName, objectGeom)
VALUES
(1,
'Eolas Building',
ST_GeomFromText('POLYGON ((-6.60236 53.38524, -6.60178 53.38451,
-6.60112 53.3847, -6.60172 53.38539, -6.60236 53.38524))',4326)
);

INSERT INTO CS621Campus (objectID, objectName, objectGeom)
VALUES
(2,
'Path JHume to Arts',
ST_GeomFromText('LINESTRING (-6.6002 53.3840, -6.6003 53.38398,
               -6.6005 53.3839, -6.6006 53.38389, -6.60076 53.38387, 
               -6.6008 53.3839)',4326)
);

-- ST_Distance(g1,g2) finds the straightline spatial distance between the object g1 and g2. 
-- We then need to transform it to units that we can measure e.g. kilometres.

-- Adds a column showing POLYGON/LINESTRING/POINT coords.
SELECT *, ST_AsText(objectGeom) FROM CS621Campus;

-- Adds an ST_IsValid column returning a boolen t of f if the geometry is well formed.
SELECT *, St_IsValid(objectgeom) FROM CS621Campus;

-- Returns an integer value of the number of points on the geometry
SELECT *, St_NPoints(objectgeom) from CS621Campus;

-- Returns St_SRID column for the geometry (most likely 4326)
SELECT *, St_SRID(objectgeom) from CS621Campus;

-- We need to transform the ST_Distance command to get our answer in a meter based system.
-- e.g. UTM is one such system. Ireland is almost contained in grid 29, United Kingdom in 30.
-- For every one ST_Distance command we need two ST_Transform/ST_GeomFromText commands
-- 32629 is the UTM for Ireland 
-- 32630 is the UTM for most of U.K.


-- This is a point from Maynooth train station to a point on campus
SELECT 
ST_Distance(
	St_Transform(
		St_GeomFromText('POINT(-6.590532 53.377981)',4326),32629),
	St_Transform(
		St_GeomFromText('POINT(-6.593644 53.382056)',4326),32629)
)/1000 as TheDistance;


-- ST_Distance calcuates the distance between the POINT and EVERY "location" 
-- in the CS631London table. "location" is a column of geometries.
-- Limit statement must always be the last statement in a query. You can 
-- use LIMIT to restrict the number of rows returned to the user.
-- Ensure that your query ORDERS the results correctly before using limit.
-- St_Distance can find the distance between ANY TWO geometry objects i.e.
-- whether POINT or POLYGON
 
SELECT *,
ST_Distance(
	ST_Transform(
		ST_GeomFromText('POINT(-0.191805 51.543643)',4326),32630),
	ST_Transform(location,32630)
)/1000.00
AS TheDistance
FROM CS621London
WHERE network LIKE '%Underground%'
ORDER BY TheDistance ASC
LIMIT 5;


DROP TABLE if exists dublinHotels;
CREATE table dublinHotels
(
    HotelID INT NOT NULL,
    HotelName VARCHAR NOT NULL,
	NumberStars INT NOT NULL,
	AvgRoomPrice INT NOT NULL,
    HotelLocation GEOMETRY NOT NULL,
	HotelStreet VARCHAR NOT NULL,
    CONSTRAINT dublinHotels_pkey PRIMARY KEY (HotelID)
);


INSERT INTO dublinHotels
(HotelID, HotelName, NumberStars, AvgRoomPrice, HotelLocation, HotelStreet) VALUES
(
'001',
'Gresham Hotel',
'5',
'200',
ST_GeomFromText('POINT(-6.260311 53.351605)',4326),
'O Connell Street'
);

  
-- Write a query to return all hotels with 5 stars – 
-- order the results by spatial distance to the user’s position.
-- HotelLocation is a column in the table 
SELECT *,
ST_Distance(
	ST_Transform(
		ST_GeomFromText('POINT(-6.259034 53.347300)',4326),32630),
	ST_Transform(HotelLocation,32630))/1000.00
AS TheDistance
FROM dublinHotels
WHERE NumberStars = 5
ORDER BY TheDistance ASC;


-- Write a query to return all hotels with rooms costing on average less than 100 euros –
-- order the results by spatial distance to the user’s position. 
SELECT *,
ST_Distance(
	ST_Transform(
		ST_GeomFromText('POINT(-6.259034 53.347300)',4326),32630),
	ST_Transform(HotelLocation,32630))/1000.00
AS TheDistance
FROM dublinHotels
WHERE AvgRoomPrice < 100
ORDER BY TheDistance ASC;


-- Write a query to return the 5 hotels which are FURTHEST away from the user’s current position. 
SELECT *,
ST_Distance(
	ST_Transform(
		ST_GeomFromText('POINT(-6.259034 53.347300)',4326),32630),
	ST_Transform(HotelLocation,32630))/1000.00
AS TheDistance
FROM dublinHotels
ORDER BY TheDistance DESC
LIMIT 5;


-- Some objects (locationgeom, animalname, observtime are allowed to take on null values
CREATE TABLE cs621_ie_animals
(
 id integer NOT NULL,
 locationgeom geometry,
 postalcode character varying(50) NOT NULL,
 animalname text,
 observtime timestamp,
 CONSTRAINT cs621_ie_animals_pkey PRIMARY KEY (id)
);

-- Can use (ColName IS NULL) or (ColName IS NOT NULL)
-- in a WHERE condition to check if any rows are NULL for that column 
-- A primary key must NEVER be null.
SELECT * FROM CS621_IE_ANIMALS  where animalname is NULL;

-- setting animal name and observation = NULL       
INSERT INTO cs621_ie_animals
(id, locationgeom, postalcode, animalname, observtime)
values (3002, ST_GeomFromText('POINT(-9.159604 53.302644)',4326),
       'A41', NULL, NULL);
	   
	   
--  find the 100 closest animal observations to the Eolas Building in Maynooth University
-- Could have just used POINT here too.
-- locationgeom is where animals were observed
SELECT *, 
ST_Distance(
	St_Transform(
		St_GeomFromText('POLYGON ((-6.60236 53.38524, -6.60178 53.38451,
-6.60112 53.3847, -6.60172 53.38539, -6.60236 53.38524))',4326),32629),
	ST_Transform(locationgeom,32629))/1000.00 as TheDistance
FROM cs621_ie_animals  
ORDER BY observtime DESC
LIMIT 100; 


CREATE table Maynooth
(
    objectID INT NOT NULL,
    objectName VARCHAR NOT NULL,
    objectGeom GEOMETRY NOT NULL,
    CONSTRAINT Maynooth_pkey PRIMARY KEY (objectID)
);

-- Repeat this for all objects you want to add to the table
INSERT INTO Maynooth (objectID, objectName, objectGeom)
VALUES
(1,
'Field',
ST_GeomFromText('POLYGON ((-6.58253788948059 53.38382111119917, -6.581465005874634 53.382566843475985, 
                -6.5803062915802 53.38292520945286, -6.5814220905303955 53.384160269083985, 
                -6.58253788948059 53.38382111119917))',4326)
);


-- ST_MakeEnvelope takes two x,y coords: bottom left x,y and top right x,y
-- Get the coordinates from the Locator App and put them into the ST_MakeEnvelope
-- syntax. Use geojson.io to make polygon, linestring or point shapes.

-- @ CONTAINS
-- using @ returned 3 items in the table. It doesn't return the 'field' object.
-- Using the @ symbol only return objects completely inside/contained in the bounding box 
SELECT *, St_AsText(objectGeom) 
FROM Maynooth WHERE
objectGeom @ ST_MakeEnvelope(-6.5869,53.3795,-6.5767,53.3834, 4326);
-- @ symbol means that the objectGeom object is CONTAINED within the ENVELOPE
-- Note commas between all points


-- && INTERSECTS
-- using && returned all 4 items in the table. If they overlap in any way
-- with the bounding box, it will include it in the resulting table.
SELECT *, St_AsText(objectGeom) 
FROM Maynooth WHERE
objectGeom && ST_MakeEnvelope(-6.5869,53.3795,-6.5767,53.3834, 4326);
-- && Returns TRUE if geom A's 2D bounding box intersects geom B's 2D bounding box.



-- For this european dataset use EPSG 3035
-- "round" rounds the distance to an integer for a nicer 
-- This query gets the distance from Maynooth to all cities in Ireland
SELECT cityname, country, round
(
    ST_Distance(
		ST_Transform(
    ST_GeomFromText('POINT(-6.601702 53.384994)',4326),3035),
		ST_Transform(citygeom,3035)
    )/1000
) as TheDistanceKM
FROM cs621_eurocities
WHERE (country = 'Ireland')
ORDER BY TheDistanceKM ASC;


SELECT * FROM cs621_eurocities ORDER BY country DESC;

-- Find the distance from Dublin Airport to all cities in the UK
SELECT cityname, country, round
(
    ST_Distance(
		ST_Transform(
    ST_GeomFromText('POINT(-6.252122 53.427895)',4326),3035),
		ST_Transform(citygeom,3035)
    )/1000
) as TheDistanceKM
FROM cs621_eurocities
WHERE (country = 'United Kingdom')
ORDER BY TheDistanceKM ASC;


-- In a self join we are joining the same table to itself by essentially 
-- creating two copies of that table.
-- The table names must use aliases
-- The join condition is in the where statement
SELECT e1.employee_name,e1.employee_location
FROM employee e1, employee e2
WHERE (e1.employee_location = e2.employee_location)


-- Find the distance between all of the cities in the same country?
-- Self Join to compare cities in Ireland to other cities (not comparing to itself)
SELECT
A.cityname,A.country,B.cityname,B.country,
round(
	ST_Distance(
		ST_Transform(A.citygeom,3035),
		ST_Transform(B.citygeom,3035)
	)/1000.00
)as TheDistanceKM
FROM cs621_eurocities as A,cs621_eurocities as B
WHERE (A.cityid != B.cityid) AND (A.country='Ireland') AND
(B.country='Ireland')
ORDER BY A.cityname ASC, TheDistanceKM ASC;


-- find the distances between cities with pop_max > 50,000
SELECT
A.cityname,A.country,A.pop_max,B.cityname,B.country,B.pop_max,
round(
	ST_Distance(
		ST_Transform(A.citygeom,3035),
		ST_Transform(B.citygeom,3035)
	)/1000.00
)as TheDistanceKM
FROM cs621_eurocities as A,cs621_eurocities as B
WHERE (A.cityid != B.cityid) AND (A.country='Ireland') AND
(B.country='Ireland') AND (A.pop_max > 50000) AND
(B.pop_max > 50000)
ORDER BY A.cityname ASC, TheDistanceKM ASC;


-- how do you find the 100 cities closest to each other, 
-- regardless of the country they are in
SELECT
A.cityname,A.country,B.cityname,B.country,
round(
	ST_Distance(
		ST_Transform(A.citygeom,3035),
		ST_Transform(B.citygeom,3035)
	)/1000.00
)as TheDistanceKM
FROM cs621_eurocities as A,cs621_eurocities as B
WHERE (A.cityid != B.cityid)
ORDER BY TheDistanceKM ASC LIMIT 100;


-- Find the 100 cities closest to each other, regardless of the country they are in? The cities
-- should be less than 100KM apart.
SELECT a.cityname,a.country,b.cityname, b.country,
round(
	ST_Distance(
		ST_Transform(A.citygeom,3035),
		ST_Transform(B.citygeom,3035)
	)/1000.00) 
as TheDistanceKM
FROM CS621_EuroCities as A, CS621_EuroCities as B
WHERE (A.cityid != B.cityid) and
(round(
	ST_Distance(
		ST_Transform(A.citygeom,3035),
		ST_Transform(B.citygeom,3035)
	)/1000.00) < 100)
ORDER BY A.cityname ASC, TheDistanceKM ASC
LIMIT 100;
-- from "(round" onwards, this calculates 100km apart


-- Find the 100 cities closest to each other, BUT THEY MUST NOT BE IN THE SAME COUNTRY?
-- The cities should be less than 100KM apart.
SELECT a.cityname,a.country,b.cityname, b.country,
round(
	ST_Distance(
		St_Transform(A.citygeom,3035),
		ST_Transform(B.citygeom,3035)
	)/1000.00) 
as TheDistanceKM
FROM CS621_EuroCities as A, CS621_EuroCities as B
WHERE (A.cityid != B.cityid) and (A.Country != B.Country) AND -- <-------
(round(
	ST_Distance(
		St_Transform(A.citygeom,3035),
		ST_Transform(B.citygeom,3035)
	)/1000.00) < 100)
ORDER BY A.cityname ASC, TheDistanceKM ASC
LIMIT 100;


-- Intersecting two databases, not joining them.
SELECT
KE.ED_NAME, ST_AsText(Animals.locationgeom),
Animals.animalname, Animals.observtime
FROM Kildare_eds_2017 as KE,
cs621_ie_animals as Animals
WHERE (KE.ed_name LIKE '%MAYNOOTH%')
AND Animals.locationgeom @ KE.edgeom;  -- <--- The spatial relationship
-- the line above intersects the two geometry columns from the two tables.


-- Entity Relationship Diagrams
CREATE TABLE StaysIn (

	HotelID INTEGER NOT NULL REFERENCES Hotels(HotelID),
	StaffNumber VARCHAR(10) NOT NULL REFERENCES Employees(StaffNumber),
	DateOfStay DATE NOT NULL,
	CONSTRAINT StaysIn_pkey PRIMARY KEY(HotelID,StaffNumber,DateOfStay)
);

-- Where has Andrea Rossi Stayed. It will show if she has stayed there more than once.
SELECT Hotels.Name,Employees.Name,Employees.Slevel
FROM Hotels, Employees,StaysIn
WHERE Hotels.hotelid = StaysIn.hotelid AND
Employees.StaffNumber = StaysIn.StaffNumber
AND Employees.Name = 'Andrea Rossi'
ORDER BY StaysIn.DateOfStay ASC;


-- DELETE/UPDATE
DELETE From EUPopulation WHERE
(population2004 % 100) = 0 OR
(population2014 %100 = 0)


UPDATE GoogleSharesOctober2015
SET
openvalue = openvalue + 20,
highvalue = highvalue + 20,
lowvalue = lowvalue + 20,
closevalue = closevalue + 20
WHERE sharedate = '2015-10-20';


UPDATE Inventory
SET NumberInStock = NumberInStock +1
WHERE
ProductName = 'Camera Backpack';


UPDATE Inventory
SET NextOrderDate = NULL
WHERE
ProductName = 'Nikon Selfie Stick';


-- increate no of instagram posts and no of tweets by any user who
-- lives in Fresno by 10
update californiasocial 
set numberofinstagram = numberofinstagram + 10,
numberoftweets = numberoftweets + 10
where (city = 'Fresno')

-- select/delete any user who sent last tweet on 2nd Nov 2017
select lasttweettime from californiasocial
where (lasttweettime >= '2017-11-02 00:00:00')
and (lasttweettime <= '2017-11-02 23:59:59');

-- now need to delete!!
delete from californiasocial
where (lasttweettime <= '2017-11-02 00:00:00')
and (lasttweettime <= '2017-11-02 23:59:59');


-- set buzzword field to NULL where buzzwordused contains "mobile"
-- anywhere in the string
select buzzwordsused from californiasocial
where (buzzwordsused ~* '^.*mobile.*$');
-- better to use regexp than LIKE

update californiasocial
set buzzwordsused = NULL
where (buzzwordsused ~* '^.*mobile.*$');


-- update user with twitterhandle cportman2u2 so location is long 39.33 and lat -121.18
select twitterhandle, location, St_SRID(location), ST_asText(location) 
from californiasocial
where twitterhandle = 'cportman2u2';

update californiasocial
set location = ST_GeomFromText('POINT(-112.18 39.33)',4326)
where twitterhandle = 'cportman2u2';


-- delete all users who are inside the bounding rectangle or envelope
-- -121.5469, 38.5492    -121.4214,38.610
select * from californiasocial
where location @ ST_MakeEnvelope(-121.5469,38.5492,-121.4214,38.610, 4326);

delete from californiasocial
where location @ ST_MakeEnvelope(-121.5469,38.5492,-121.4214,38.610, 4326);


-- EXAMPLE OF ROLLBACK
-- Run each line below SEPARATELY - so you can see the effect of using the transaction. 

BEGIN;

-- INCORRECT bounding rectangle or envelope. 
-- CHECK and see if this 'mistake' returns rows. 
SELECT * from CaliforniaSocial where St_MakeEnvelope(-122.5415,37.1603,-121.5720,37.8141,4326) && location;

-- suppose we accidentally delete them
DELETE FROM CaliforniaSocial where St_MakeEnvelope(-122.5415,37.1603,-121.5720,37.8141,4326) && location;

-- see if the delete statement worked?
SELECT * from CaliforniaSocial where St_MakeEnvelope(-122.5415,37.1603,-121.5720,37.8141,4326) && location;
-- it has worked

ROLLBACK;  -- this will reverse our actions to the state of the database BEFORE we started this transaction. 

END;

-- Now if we try our SELECT statement again - everything should be back to normal. 55 rows restored. 
SELECT * from CaliforniaSocial where St_MakeEnvelope(-122.5415,37.1603,-121.5720,37.8141,4326) && location;


-- ST_DWithin
-- Returns true if the geometries are within a specified distance of one another.
-- It effectively operates as a circle with a point as the centre.
-- It is of type boolean. It uses GiST as its index type.

-- Find all users who are located within 30KM of SACRAMENTO California
select * from CaliforniaSocial
where
ST_DWithin(
	ST_Transform(
		ST_GeomFromText('POINT(-121.49315 38.57651)',4326),2163),
	ST_Transform(location,2163),
30000);

-- This will create a View in PostGreSQL (at same level as tables)
-- You will then be able to see this view (which is your map) in QGIS
DROP VIEW IF EXISTS MyFirstView;
CREATE OR REPLACE VIEW  
MyFirstVIEW AS

SELECT calsocialpk,twitterHandle,city,ST_AsText(location),
ST_Distance(
	ST_Transform(
        St_GeomFromText('POINT(-121.49315 38.57651)',4326),2163),
    ST_Transform(location,2163))/1000 
as TheDistanceKM,location FROM CaliforniaSocial 
where ST_DWithin(
    ST_Transform(
		St_GeomFromText('POINT(-121.49315 38.57651)',4326),2163),
    ST_Transform(location,2163),30000) 
order by TheDistanceKM desc;


-- STARBUCKS USA

-- A) The yearEst column is the year that the cafe was first opened. Due to data collection errors
-- any cafe opened between 1996 and 1999 has an incorrect yearEst and needs to be
-- incremented by one year. Write an appropriate UPDATE statement.
update starbucksUSA 
set yearEst = yearEst + 1
where (yearEst=1996 or yearEst=1997 or yearEst=1998 or yearEst=1999);
-- 2300 rows affected

select * from starbucksUSA


-- B) Develop a TRANSACTION block where you DELETE all cafes in New York state and
-- California State. Run the TRANSACTION as shown in the lectures and verify that all of the
-- data is correctly returned to the database table.
BEGIN;

-- INCORRECT bounding rectangle or envelope. 
-- CHECK and see if this 'mistake' returns rows. 
SELECT * from starbucksUSA where (state = 'CA' or state = 'NY'); 

-- suppose we accidentally delete them
DELETE FROM starbucksUSA where (state = 'CA' or state = 'NY'); 

-- see if the delete statement worked?
SELECT * from starbucksUSA where (state = 'CA' or state = 'NY');
-- it has worked

ROLLBACK;  -- this will reverse our actions to the state of the database BEFORE we started this transaction. 

END;


-- C) Write a DELETE statement which WILL DELETE any cafe which has a rating of two or
-- less.
SELECT * from starbucksUSA where rating <= 2;
DELETE FROM starbucksUSA where rating <= 2;
-- 2670 rows removed


-- D) Write an appropriate ST_Dwithin based query which displays all of the starbucks cafes
-- within 5KM of the approximate center of Central Park in New York city.
SELECT * ,ST_AsText(location),
ST_Distance(
	ST_Transform(
        St_GeomFromText('POINT(-73.965497 40.782296)',4326),2163),
    ST_Transform(location,2163))/1000 
as TheDistanceKM,location FROM starbucksUSA 
where ST_DWithin(
    ST_Transform(
		St_GeomFromText('POINT(-73.965497 40.782296)',4326),2163),
    ST_Transform(location,2163),5000) 
order by TheDistanceKM desc;


-- E) Update the location of the cafe with address “6709 Frank Lloyd Wright Ave” such that its
-- longitude and latitude now are increased by 0.0002
-- Note this cafe seemed to have been deleted so I re-added it

insert into starbucksUSA (name,street,state,rating,yearEst,location) 
values ('Allen Boulevard','6709 Frank Lloyd Wright Ave','WI',2,1996,
ST_GeomFromText('POINT(-89.486618042 43.1034393311)',4326));

select *, ST_AsText(location) from starbucksUSA where street = '6709 Frank Lloyd Wright Ave';

update starbucksUSA 
set location = ST_Transform(ST_translate(ST_Transform(location::geometry,4326), 0.0002, 0.0002), 4326)
where street = '6709 Frank Lloyd Wright Ave'; 

update StarbucksUSA 
-- find what 6709's point was (ST_AsText). Add 0.0002 manually and update the point as below.
set location = ST_GeomFromText('POINT(-88.372160767 41.721165802)',4326) 
where street like '6709 Frank Lloyd Wright Ave';       


-- F) Create an ST_MakeEnvelope for the region of Urban Chicago – you don’t have to be too
-- accurate. Ensure that the envelope includes as much of Chicago as you can. Then create a
-- database view called StabucksChicago which contains all of the details of every cafe within
-- this envelope.
drop view if exists StarbucksChicago;
create or replace view StarbucksChicago as
select * from starbucksUSA
where ST_MakeEnvelope(-88.139191, 41.603121, -87.543182, 42.185794, 4326) && location;
-- TO BRING BACK INTO QGIS...
Database -> DB Manager -> DB Manager
	Navigate in window to the "view" created in PostGIS.
	Right click, Add to Canvas


-- H) The geographic center of the contiguous states of the USA is often cited as (39.828175,
-- -98.5795) in EPSG:4326. Find the 200 geographically closest Starbuck cafes to this
-- location. Create a VIEW in the database for this query. Use QGIS to make an appropriate
-- visualisation of this piece of analysis. Export your map as an image.
DROP VIEW IF EXISTS starbucks1;
CREATE OR REPLACE VIEW starbucks1 AS
 

SELECT starbuckspk,name,street, state,ST_AsText(location),location,
ST_Distance(
	ST_Transform(
		St_GeomFromText('POINT(-98.5795 39.828175)',4326),2163),
	ST_Transform(location,2163))/1000 as TheDistanceKM 
FROM StarbucksUSA 
order by TheDistanceKM ASC 
LIMIT 200;



-- KILDARE EDS
-- It is important to understand the queries below – from the point of 
-- view of being able to change the VARIABLE names in each of the tables. 
-- You need to be able to understand which table in PostGIS represents the 
-- POINTs and which represents the POLYGONS. Then you need to make sure you
-- understand the attribute names.
ALTER TABLE kildare_eds_2017_week8 ADD COLUMN AbsoluteDiff INTEGER;
SELECT * FROM kildare_eds_2017_week8;

UPDATE kildare_eds_2017_week8 SET AbsoluteDiff = ABS(popfemales - popmales);
SELECT * FROM kildare_eds_2017_week8;

ALTER TABLE kildare_eds_2017_week8 ADD COLUMN DENSITY REAL;
SELECT * FROM kildare_eds_2017_week8;

-- need to use ST_Area() function
-- Do an ST_Transform from 4326 to 29920
UPDATE kildare_eds_2017_week8
SET DENSITY = population/
(ST_Area(
ST_Transform(geom,29902))
/1000000);


-- This is doing a join to see for a polygon, how many objects are inside that polygon
SELECT count(*) as NumPoints, ED.ed_english
FROM kildare_mobile as ThePoints,
kildare_eds_2017_week8 as ED
WHERE
ST_CONTAINS(ED.geom, ThePoints.geom)
group by ED.ed_english

-- add new column to the table
ALTER TABLE kildare_eds_2017_week8 ADD COLUMN numpoints INTEGER;
SELECT * FROM kildare_eds_2017_week8

-- Running a query, which will be an update to the subquery
WITH TableSubquery as (
SELECT count(*) as NumPoints,
ED.ed_english 
FROM kildare_mobile  as ThePoints, kildare_eds_2017_week8 as ED
WHERE 
ST_CONTAINS(ED.geom, ThePoints.geom)
group by ED.ed_english

)
UPDATE kildare_eds_2017_week8
set numpoints = TableSubquery.numpoints FROM TableSubquery 
where kildare_eds_2017_week8.ed_english = TableSubquery.ed_english;

SELECT * FROM kildare_eds_2017_week8;


-- In QGIS
-- Use CATEGORIZED if your column does not contain numerical data as you cannot create intervals or classes
-- Use GRADUATED if you are dealing with a numerical field


-- adds column, values are null
ALTER TABLE india_south ADD COLUMN districtArea REAL;
SELECT * FROM india_south;

-- Q4
-- Use ST_Area to convert to KM^2
UPDATE india_south
SET districtArea = ST_Area(ST_Transform(geom,32643))/1000000;

SELECT * FROM india_south

-- Q5
-- Create a new attribute in the India Districts dataset in PostGIS called numpoints. 
-- Write the appropriate UPDATE query such that numpoints is assigned the number
-- of points from the GeoJSON dataset for that corresponding individual district. 
ALTER TABLE india_south ADD COLUMN numpoints INTEGER;
SELECT * FROM india_south

WITH TableSubquery as (
SELECT count(*) as NumPoints,
IND.district 
FROM india_mobile  as ThePoints, india_south as IND
WHERE 
ST_CONTAINS(IND.geom, ThePoints.geom)
group by IND.district

)
UPDATE india_south
set numpoints = TableSubquery.numpoints FROM TableSubquery 
where india_south.district = TableSubquery.district;

SELECT * FROM india_south;


-- Suggested Solution Q5
ALTER TABLE india_districts ADD COLUMN numpoints INTEGER;
-- in the India_Districts table the ID field is called 'id'
-- the two tables involved are the POINT table india_mobile_usage and the polygon district table
india_districts
-- we first need to do a sub query with ST_Contains to find which POINTs are within which
POLYGON.
-- We group the results by POLYGON ID - so for each polygon we get the number of points
contained in it.
UPDATE india_districts set numpoints = 0;
BEGIN;
WITH TableSubquery as (
select count(*) as NumPoints,IndiaDist.id as 
IndiaDistrictIdentification from india_mobile_usage  as iMob, 
india_districts as IndiaDist
WHERE ST_CONTAINS(IndiaDist.geom, iMob.geom)
group by IndiaDist.id 
)
UPDATE india_districts
set NumPoints = TableSubquery.NumPoints FROM TableSubquery 
where id = TableSubquery.IndiaDistrictIdentification;
COMMITT;
ROLLBACK;



-- Q6
ALTER TABLE india_south ADD COLUMN airtelpts INTEGER;
SELECT * FROM india_south

WITH TableSubquery as (
SELECT count(*) as airtelpts,
IND.district 
FROM india_mobile  as ThePoints, india_south as IND
WHERE 
ST_CONTAINS(IND.geom, ThePoints.geom) AND (ThePoints.network = 'Airtel')
group by IND.district

)
UPDATE india_south
set airtelpts = TableSubquery.airtelpts FROM TableSubquery 
where india_south.district = TableSubquery.district;
    
select * from india_south


-- Suggested Solution Q6
-- ALTER TABLE india_districts ADD COLUMN AirTelPoints INTEGER;
-- in the India_Districts table the ID field is called 'id'
-- the two tables involved are the POINT table india_mobile_usage 
-- and the polygon district table india_districts
-- we first need to do a sub query with ST_Contains to find which 
-- POINTs are within which POLYGON. 
-- We group the results by POLYGON ID ­ so for each polygon we get
-- the number of points contained in it. 
-- We need an addtional where clause for the NETWORK in the POINT 
-- dataset ­ we are only interested in POINTS which are Airtel 
-- networks. 

UPDATE india_districts set AirTelPoints = 0;

BEGIN;
WITH TableSubquery as (
select count(*) as NumPoints,IndiaDist.id as 
IndiaDistrictIdentification from india_mobile_usage  as iMob, 
india_districts as IndiaDist
WHERE ST_CONTAINS(IndiaDist.geom, iMob.geom) and (iMob.network = 
'Airtel')
group by IndiaDist.id 
)
UPDATE india_districts
set AirTelPoints = TableSubquery.NumPoints FROM TableSubquery 
where id = TableSubquery.IndiaDistrictIdentification;

COMMITT;
ROLLBACK;

-- It is important to understand this query – from the point of view of being able to change the
-- VARIABLE names in each of the tables. You need to be able to understand which table in PostGIS
-- represents the POINTs and which represents the POLYGONS. Then you need to make sure you
-- understand the attribute names. 



-- Know how to import a SHP file and a GEOJSON file into QGIS
SHP : Layer -> Add Layer -> Add Vector Layer
	Source type : file
	Navigate to SHP file 
	Click Open
	
SHP file is usually geographical info for boundaries, counties, districts.
	
	
	
GEOJSON : Layer -> Add Layer -> Add Vector Layer
	      Source type : file
	      Navigate to GEOJSON file 
	      Click Open
		  
GEOJSON file is usually a point/polygon based dataset depicting for example points 
where people access the internet.
	
When adding columns you will usually add the column to the district/boundary 
table.

-- Importing Layers into PostGIS/PGAdmin as tables
Database -> DB Manager
	Navigate to p180008
	Hit the Import button (down arrow)
	Click Create Spatial Data
	
-- Go into PGAdmin/PostGIS
Table should now exist in PGAdmin.
Do TableSubQuery / Update as above

-- Now, go back to QGIS
Database -> DB Manager -> Refresh
Find the table with the new data added. Right click Add To Canvas.
Right click on the layer in the layer panel. Select Properties.
Choose Graduated. Select appropriate classes.




-- LAB EXAM 1 SOLUTIONS
-- Write a query to select ALL ATM transactions which happened in 2017 where the day of the month 
-- is either 1st, 7th, 14th, 21st, 28th or 31st and the ATM Operator is Bank of Ireland. The 
-- Moodle Quiz will ask you to state the number of rows returned by this query. 
select * from CS621_LabExam1_ATMS where (date_part('day',atime) in (1,7,14,21,28,31)) 
and (date_part('year',atime) = 2017) and (atm_operator = 'Bank of Ireland');

-- Write a query to select ALL ATM transactions where the first three characters and last 
-- three characters of the customer account number are digits and the withdrawl amount is greater 
-- than 100 euros. The Moodle Quiz will ask you to state the number of rows returned by this query.  
select * from CS621_LabExam1_ATMS where ((custaccount ~* '^\d\d\d.*\d\d\d$') and (aamount > 100));

-- Write a query to select ALL ATM transactions where the customer account is composed of ONLY 
-- digit characters. The Moodle Quiz will ask you to specify the customer account number of the 
-- transaction which occured MOST RECENTLY. 
select * from CS621_LabExam1_ATMS where (custaccount ~* '^\d{1,}$') 
and (custaccount ~* '^(1|3|5|7|9)\d{1,}$') ORDER BY atime desc;

select * from CS621_LabExam1_ATMS where  (custaccount ~* '^(1|3|5|7|9)\d{1,}$') ORDER BY atime desc;

select * from CS621_LabExam1_ATMS where  (custaccount ~* '^(1|3|5|7|9)\d{9}$') ORDER BY atime desc;



-- 
-- Donadea Forest Park is a beautiful small parkland about 16KM from Maynooth. 
-- The Latitude Longitude coordinates of Donadea Forest Park is (Lat, Lon): 53.338520,-6.746035. 
-- Write a distance query to list 100 transactions which happened at the ATM machines CLOSEST 
-- to Donadea Forest Park. You should NOT use the ROUND operator in this query. 
-- The Moodle Quiz will ask you to state the ATM_ID of the ATM machine which is listed as 
-- CLOSEST to Donadea Forest Park. Please ensure that you very carefully record the ATM_ID 
-- for the purposes of the quiz.  


SELECT *, ST_AsText(atmlocation),
ST_Distance(
	St_Transform(
		St_GeomFromText('POINT(-6.746035 53.338520)',4326),32629),
	ST_Transform(atmlocation,32629))/1000.00 as TheDistance
FROM CS621_LabExam1_ATMS   ORDER BY TheDistance ASC LIMIT 100; 



-- http://overpass-api.de/api/map?bbox=-8.9717,52.5672,-8.4032,52.7770
-- Suppose a bounding rectangle or envelope is define over the area around the city of Limerick 
-- in the south west of Ireland. The bottom left coordinates are -8.9717,52.5672 (EPSG:4326) 
-- and the top right coordinates are -8.4032,52.7770 (EPSG:4326)
-- Write an SQL query which returns ALL ATM transactions which are contained within this spatial area. 
-- Your query should not return any ATMs which are operated by Permanet TSB. 

select *,St_AsText(atmlocation) from CS621_LabExam1_ATMS 
where atmlocation && ST_MakeEnvelope(-8.9717,52.5672,-8.4032,52.7770,4326) 
and (ATM_OPERATOR != 'Permanent TSB');


-- For this query you will need to use the IE_Counties table provided. 
-- Write an SQL query which lists all of the transactions on ATMS which are located in 
-- County Kildare Ireland. Please note that the 'countyname' field holds this information and 
-- County Kildare will be stored as 'Kildare County'.  

select A.*,St_AsText(atmlocation)
FROM IE_Counties as C, 
CS621_LabExam1_ATMS as A
WHERE 
A.atmlocation && C.geom and C.countyname = 'Kildare County';


-- Write an SQL query which lists all of the transactions on ATMS which are located in the 
-- countyname 'Cork City' and the amount withdrawl is less than 50 euro.  

select A.*,St_AsText(atmlocation)
FROM IE_Counties as C, 
CS621_LabExam1_ATMS as A
WHERE 
(A.atmlocation && C.geom) and (C.countyname = 'Cork City') and (A.aamount < 50);


-- Using the CS621_Berlin table - write an SQL query to find the CAFE which is closest to the 
-- the cafe with the name 'CS621 Student Cafe'. You SHOULD NOT USE the round() function of method. 
-- In the Moodle Quiz you will be asked to give the name of the cafe which is geographically 
-- closest to the CS621 Student Cafe in Berlin. 
-- answer is "Mattea"
--use 3035

SELECT 
a.name,b.name, 
ST_Distance(
	St_Transform(A.cafegeom,3035),
	ST_Transform(B.cafegeom,3035))/1000.00 as TheDistanceKM
FROM cs621_berlin as A, cs621_berlin as B
WHERE A.cafeid != B.cafeid and a.name = 'CS621 Student Cafe'
ORDER by TheDistanceKM ASC
LIMIT 100;

SELECT 
a.name,b.name, 
ST_Distance(
	St_Transform(A.cafegeom,32633),
	ST_Transform(B.cafegeom,32633))/1000.00 as TheDistanceKM
FROM cs621_berlin as A, cs621_berlin as B
WHERE A.cafeid != B.cafeid and a.name = 'CS621 Student Cafe'
ORDER by TheDistanceKM ASC
LIMIT 100;



-- cs621_berlin
-- "node/66917229";"Starbucks"
-- The Brandenberg Gate is the most famous landmark in Berlin. The geographic point is 
-- POINT(13.377722 52.516272) in EPSG 4326. Write an SQL query which will provide the 
-- Cafe ID and the Name of the geographically closest cafe to the Brandenberg Gate. 
-- You should NOT USE the round function.  

SELECT *, ST_AsText(cafegeom),
ST_Distance(
	St_Transform(
		St_GeomFromText('POINT(13.377722 52.516272)',4326),3035),
	ST_Transform(cafegeom,3035))/1000.00 as TheDistance
FROM cs621_berlin   ORDER BY TheDistance ASC LIMIT 100; 

SELECT *, ST_AsText(cafegeom),
ST_Distance(
	St_Transform(
		St_GeomFromText('POINT(13.377722 52.516272)',4326),32633),
	ST_Transform(cafegeom,32633))/1000.00 as TheDistance
FROM cs621_berlin   ORDER BY TheDistance ASC LIMIT 10; 



---- FINAL QUESTION 

--bbox=13.3237,52.4857,13.4686,52.5590
             

select * from CS621_Berlin limit 1;

INSERT INTO CS621_Berlin (cafegeom,cafeid,name,waccess) 
VALUES (ST_GeomFromText('POINT (13.2540   52.4099)',4326),'node/Q10A','Starbucks','no');
INSERT INTO CS621_Berlin (cafegeom,cafeid,name,waccess) 
VALUES (ST_GeomFromText('POINT ( 13.601   52.604)',4326),'node/Q10B','Starbucks','no');

select *,St_AsText(cafegeom) from CS621_Berlin 
where cafegeom && ST_MakeEnvelope(13.3237,52.4857,13.4686,52.5590,4326) 
and (waccess = 'no') and (name ~* '^.*Starbucks.*$');



-- WEEK 7 SELF ASSESSMENT - STARBUCKS

--QUESTION A

-- Use a select to test first
SELECT * from StarbucksUSA where (yearEst >= 1996) and (yearEst <= 1999);  -- 2300 rows

UPDATE StarbucksUSA set yearEst = yearEst + 1 where (yearEst >= 1996) and (yearEst <= 1999); --2300 rows

-- QUESTION B

--Develop a TRANSACTION block where you DELETE all cafes in New York state and
--California State. Run the TRANSACTION as shown in the lectures and verify that all of the
--data is correctly returned to the database table.


BEGIN;

DELETE from StarbucksUSA where (state  ='NY') or (state = 'CA');  --3451 rows deleted
SELECT *  from StarbucksUSA where (state  ='NY') or (state = 'CA'); -- should be no rows. 

COMMIT;
ROLLBACK;

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--QUESTION C
-- Write a DELETE statement which WILL DELETE any cafe which has a rating of two or less.

DELETE from StarbucksUSA where (rating <= 2);

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--QUESTION D
-- Write an appropriate ST_Dwithin based query which displays all of the starbucks cafes within 
-- 5KM of the approximate center of Central Park in New York city.
-- https://www.openstreetmap.org/?mlat=40.782222&mlon=-73.965278&zoom=15&layers=M
-- You might get slightly different results depending on the precise point you choose in Central park. 
-- In exams you will be given the exact point to use. 

SELECT starbuckspk,name,street, state,ST_AsText(location),
ST_Distance(
	ST_Transform(
		St_GeomFromText('POINT(-73.965278 40.782222)',4326),2163),
	ST_Transform(location,2163))/1000 as TheDistanceKM 
FROM StarbucksUSA where    
ST_DWithin(
	ST_Transform(
		St_GeomFromText('POINT(-73.965278 40.782222)',4326),2163),
	ST_Transform(location,2163),5000) order by TheDistanceKM desc;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--QUESTION e
-- Update the location of the cafe with address “6709 Frank Lloyd Wright Ave” such that 
-- its longitude and latitude now are increased by 0.0002
select * from starbucksusa where street like '6709 Frank%';

-- now this location appears to have been deleted by the queries above. 
-- Let's just pick another point 
-- 14;"Montgomery-Orchard & Rte 30";"2080 Orchard Rd.";"IL"

select *,st_astext(location) from starbucksusa where street like '2080 Orchard Rd.';

-- There might be a few ways to do this but this is the way that I was hoping for. 
-- Method 1 - the way I would expect you to try. Look at the location with ST_AsText() and then 
-- simply change the location as per the question by making a NEW point 

-- POINT(-88.3741607666 41.719165802) would change to POINT(−88.372160767 41.721165802) when we 
-- do these calculations manually. Then we do an UPDATE with an ST_GeomFromText()

UPDATE StarbucksUSA set location = ST_GeomFromText('POINT(-88.372160767 41.721165802)',4326) 
where street like '2080 Orchard Rd.';


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--QUESTION F
--Create an ST_MakeEnvelope for the region of Urban Chicago – you don’t have to be too
--accurate. Ensure that the envelop includes as much of Chicago as you can. Then create a
--database view called StabucksChicago which contains all of the details of every cafe within
--this envelope.

-- The envelope I used was -88.2600,41.4746,-87.2493,42.3535

CREATE OR REPLACE VIEW StarbucksChicago as 
SELECT * from StarbucksUSA where location @ ST_MakeEnvelope(-88.2600,41.4746,-87.2493,42.3535,4326);

-- From week 8 - using the DB manager - you can get QGIS to connect to this VIEW via the DB Manager 
-- then you can see your output on a MAP in QGIS (see screenshot with this solution)



-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--QUESTION G

-- see visualisation

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--QUESTION H
--The geographic center of the contiguous states of the USA is often cited as (39.828175,-98.5795) 
-- in EPSG:4326. Find the 200 geographically closest Starbuck cafes to this location. 
-- Create a VIEW in the database for this query. Use QGIS to make an appropriate 
-- visualisation of this piece of analysis. Export your map as an image.

-- REMEMBER .... With a VIEW ... you will ALWAYS need to return a PRIMARY KEY with your SELECT statement. 
-- So just include the PRIMARY KEY from your table. Or just do a * if suitable. 

-- There are two ways you could do this. You have the find the 200 closest ....
-- The very important thing here is the ORDER BY Statement - 
-- so that you ORDER the distance to the CENTER POINT in ascending order. 

-- if you want QGIS to display the results of this VIEW via the DB Manager then 
-- you'll have to make sure to include the location geometry in your SELECT statement. 

-- METHOD 1 - use ST_DWithin ... and just keep guessing until you get the right 
-- RADIUS for the ST_DWithin circle ... .. see 500KM below. 

DROP VIEW  StarbucksCenterView;
CREATE OR REPLACE VIEW StarbucksCenterView as 

SELECT starbuckspk,name,street, state,ST_AsText(location),location,
ST_Distance(
	ST_Transform(
		St_GeomFromText('POINT(-98.5795 39.828175)',4326),2163),
	ST_Transform(location,2163))/1000 as TheDistanceKM 
FROM StarbucksUSA where    
ST_DWithin(
	ST_Transform(
		St_GeomFromText('POINT(-98.5795 39.828175)',4326),2163),
	ST_Transform(location,2163),500000) order by TheDistanceKM ASC   LIMIT 200;


-- METHOD 2 ... use ST DISTANCE on it's own like we did a number of weeks ago. 
-- Hopefully the SPATIAL INDEX will help us here. NOTICE that we have no where statement conditions. 

CREATE OR REPLACE VIEW StarbucksCenterViewMethod2 as 
SELECT starbuckspk,name,street, state,ST_AsText(location),location,
ST_Distance(
	ST_Transform(
		St_GeomFromText('POINT(-98.5795 39.828175)',4326),2163),
	ST_Transform(location,2163))/1000 as TheDistanceKM 
FROM StarbucksUSA 
order by TheDistanceKM ASC   LIMIT 200;



-- Suggested solutions Lab Exam 2 part A

SELECT * FROM copenhagen2017 limit 10;


-- QUESTION 1: Delete the rows from the copenhagen2017 dataset where the website column, 
-- the phone column and the cuisine column are all null values. The Moodle Quiz will ask 
-- you to state the number of rows affected by this query statement. 
-- ANS 56 ROWS. 

SELECT * From copenhagen2017 where (website is null) and (phone is null) and (cuisine is null);
DELETE from copenhagen2017 where (website is null) and (phone is null) and (cuisine is null);


-- QUESTION 2: The Little Mermaid statue is one of the most famous tourist attractions in 
-- Copenhagen city. The statue is located beside the water in Copenhagen Port at 
-- Latitude = 55.692861 and Longitude = 12.59927.
-- Write an SQL query to find the total number of restaurants which are within 1KM 
-- of the Little Mermaid statue. You should use EPSG:23032 for your calculations. 
-- The Moodle Quiz will ask you state the number of rows returned by this query. 
-- ANSWER = 10 Rows

SELECT *,
ST_Distance(
	ST_Transform(
		St_GeomFromText('POINT(12.59927 55.692861)',4326),23032),
	ST_Transform(geom,23032))/1000 as TheDistanceKM 
FROM copenhagen2017 where 
ST_DWithin(
	ST_Transform(
		St_GeomFromText('POINT(12.59927 55.692861)',4326),23032),
	ST_Transform(geom,23032 ),1000) order by TheDistanceKM desc;

-- QUESTION 3: 
-- Update the copenhagen2017 table in the following way. If the website column is null then set the 
-- website value to http://www.visitcopenhagen.com  The Moodle Quiz will ask you to state the number 
-- of rows updated by this query. 

-- ANSWER = ROWS = 96

Select * from copenhagen2017 where website is null; 
UPDATE Copenhagen2017 set website = 'http://www.visitcopenhagen.com' where website is null;


-- QUESTION 4:

-- Kongens Nytorv  "The King's New Square"  is a public square in Copenhagen. 
-- The latitude, longitude (55.680278,12.585833) are the coordinates of the approximate 
-- center of the square. Write an SQL query to find the number of restaurants which are 
-- within 500 meters of Kongens Nytorv with the cuisine column equal to null and the 
-- POI has been last updated in OpenStreetMap from October 2017 onwards. 
-- ANSWER = 4 ROWS

SELECT *,
ST_Distance(
	ST_Transform(
		St_GeomFromText('POINT(12.585833 55.680278)',4326),23032),
	ST_Transform(geom,23032))/1000 as TheDistanceKM 
FROM copenhagen2017 where 
ST_DWithin(
	ST_Transform(
		St_GeomFromText('POINT(12.585833 55.680278)',4326),23032),
	ST_Transform(geom,23032 ),500) and (cuisine is null) and (lastupdated > '2017-09-30') 
order by TheDistanceKM desc;

-- QUESTION 5:
Select ST_ASTEXT(geom),* from copenhagen2017 limit 20;

-- The spatial coordinates of the Danish restaurant 'Ingolfs Kaffebar' are incorrect. 
-- The Latitude and Longitude both need to be rounded to two decimal places. Write an appropriate 
-- SQL statement to make this update. The Moodle Quiz will ask you how many rows are affected by 
-- this query. 
-- ANS = 1 ROW

UPDATE copenhagen2017 set geom = St_GeomFromText('POINT(12.62 55.65)',4326) 
where name = 'Ingolfs Kaffebar';


-- QUESTION 6: 
-- An envelope with bottom left coordinates 12.5691,55.6827 and top right coordinates 
-- 12.5839,55.6892 is created to cover the Botanical Gardens area of Copenhagen. 
-- A set of Italian tourists would like to eat at an Italian restaurant (cuisine = italian) 
-- in this area. Using this Envelope write an SQL query to find the total number of Italian 
-- restuarants inside this envelope. 
ANS = 5 ROWS

SELECT * From copenhagen2017 where geom @ ST_MakeEnvelope(12.5691,55.6827,12.5839,55.6892,4326) 
and (cuisine = 'italian');


-- QUESTION 7:

-- Using the envelope from Question 6 - write an SQL Statement which deletes any restaurant 
-- which are not Italian cuisine within this envelope. The Moodle quiz will ask you to state the 
-- number of rows affected by this query. 
-- You are advised to use a SELECT statement to ensure you write the delete statement correctly 
-- for this question. 
-- ANS = 9 Rows

BEGIN;
SELECT * From copenhagen2017 where geom @ ST_MakeEnvelope(12.5691,55.6827,12.5839,55.6892,4326) 
and ((cuisine != 'italian') or (cuisine is null));
DELETE From copenhagen2017 where geom @ ST_MakeEnvelope(12.5691,55.6827,12.5839,55.6892,4326) 
and ((cuisine != 'italian') or (cuisine is null));
COMMIT;
ROLLBACK;

SELECT * from Copenhagen2017 limit 20;

-- QUESTION 8
-- Write an SQL query which investigates the lastupdated column. The query should find any 
-- lastupdated timestemp where the month is equal to the day and the hour is equal to the minute. 
-- The Moodle quiz will ask you to indicate the number of rows returned. 
ANS = 1;

SELECT lastupdated from Copenhagen2017 
where (date_part('month', lastupdated) = date_part('day', lastupdated)) 
and (date_part('hour', lastupdated) = date_part('minute', lastupdated));

-- QUESTION 9

-- Write an SQL query to find the closest restaurant to Copenhagen Main Railway station 
-- (55.67219,12.56525). You should use EPSG:23032 for your calculations. Do not round any of your 
-- calculations. 
-- The Moodle quiz will require the exact osm_id of the closest restaurnt. "node/1806980582"

SELECT 
ST_Distance(
	St_Transform(
		St_GeomFromText('POINT(12.56525 55.67219)',4326),23032),
	ST_Transform(geom,23032))/1000.00 as TheDistance,*
FROM Copenhagen2017 ORDER BY TheDistance ASC LIMIT 5; 

-- QUESTION 10:
-- ANS = 609
Select count(*) from copenhagen2017;



-- LAB EXAM 1 LECTURER SOLUTIONS


-- Write a query to select ALL ATM transactions which happened in 2017 where the day of the month is either 1st, 7th, 14th, 21st, 28th or 31st and the ATM Operator is Bank of Ireland. The Moodle Quiz will ask you to state the number of rows returned by this query. 
select * from CS621_LabExam1_ATMS where (date_part('day',atime) in (1,7,14,21,28,31)) and (date_part('year',atime) = 2017) and (atm_operator = 'Bank of Ireland');

-- Write a query to select ALL ATM transactions where the first three characters and last three characters of the customer account number are digits and the withdrawl amount is greater than 100 euros. The Moodle Quiz will ask you to state the number of rows returned by this query.  
select * from CS621_LabExam1_ATMS where ((custaccount ~* '^\d\d\d.*\d\d\d$') and (aamount > 100));

-- Write a query to select ALL ATM transactions where the customer account is composed of ONLY digit characters. The Moodle Quiz will ask you to specify the customer account number of the transaction which occured MOST RECENTLY. 
select * from CS621_LabExam1_ATMS where (custaccount ~* '^\d{1,}$') and  (custaccount ~* '^(1|3|5|7|9)\d{1,}$') ORDER BY atime desc;

select * from CS621_LabExam1_ATMS where  (custaccount ~* '^(1|3|5|7|9)\d{1,}$') ORDER BY atime desc;

select * from CS621_LabExam1_ATMS where  (custaccount ~* '^(1|3|5|7|9)\d{9}$') ORDER BY atime desc;



-- 
-- Donadea Forest Park is a beautiful small parkland about 16KM from Maynooth. The Latitude Longitude coordinates of Donadea Forest Park is (Lat, Lon): 53.338520,-6.746035. Write a distance query to list 100 transactions which happened at the ATM machines CLOSEST to Donadea Forest Park. You should NOT use the ROUND operator in this query. The Moodle Quiz will ask you to state the ATM_ID of the ATM machine which is listed as CLOSEST to Donadea Forest Park. Please ensure that you very carefully record the ATM_ID for the purposes of the quiz.  


SELECT *, ST_AsText(atmlocation),ST_Distance(St_Transform(St_GeomFromText('POINT(-6.746035 53.338520)',4326),32629),ST_Transform(atmlocation,32629))/1000.00 as TheDistance
FROM CS621_LabExam1_ATMS   ORDER BY TheDistance ASC LIMIT 100; 



-- http://overpass-api.de/api/map?bbox=-8.9717,52.5672,-8.4032,52.7770
-- Suppose a bounding rectangle or envelope is define over the area around the city of Limerick in the south west of Ireland. The bottom left coordinates are -8.9717,52.5672 (EPSG:4326) and the top right coordinates are -8.4032,52.7770 (EPSG:4326)
-- Write an SQL query which returns ALL ATM transactions which are contained within this spatial area. Your query should not return any ATMs which are operated by Permanet TSB. 

select *,St_AsText(atmlocation) from CS621_LabExam1_ATMS where atmlocation && ST_MakeEnvelope(-8.9717,52.5672,-8.4032,52.7770,4326) and (ATM_OPERATOR != 'Permanent TSB');


-- For this query you will need to use the IE_Counties table provided. Write an SQL query which lists all of the 
-- transactions on ATMS which are located in County Kildare Ireland. Please note that the 'countyname' field 
-- holds this information and County Kildare will be stored as 'Kildare County'. The Moodle Quiz will ask you to 
-- state the number of rows returned by this query. 

select A.*,St_AsText(atmlocation)
FROM IE_Counties as C, 
CS621_LabExam1_ATMS as A
WHERE 
A.atmlocation && C.geom and C.countyname = 'Kildare County';


-- Write an SQL query which lists all of the transactions on ATMS which are located in the countyname 'Cork City' 
-- and the amount withdrawl is less than 50 euro. In the Moodle Quiz you will be asked to indicate the number of 
-- rows returned by this query. 

select A.*,St_AsText(atmlocation)
FROM IE_Counties as C, 
CS621_LabExam1_ATMS as A
WHERE 
(A.atmlocation && C.geom) and (C.countyname = 'Cork City') and (A.aamount < 50);


-- Using the CS621_Berlin table - write an SQL query to find the CAFE which is closest to the the cafe with the name 'CS621 Student Cafe'. You SHOULD NOT USE the round() function of method. In the Moodle Quiz
-- you will be asked to give the name of the cafe which is geographically closest to the CS621 Student Cafe in Berlin. 
-- answer is "Mattea"
--use 3035

SELECT 
a.name,b.name, ST_Distance(St_Transform(A.cafegeom,3035),ST_Transform(B.cafegeom,3035))/1000.00 as TheDistanceKM
FROM cs621_berlin as A, cs621_berlin as B
WHERE A.cafeid != B.cafeid and a.name = 'CS621 Student Cafe'
ORDER by TheDistanceKM ASC
LIMIT 100;

SELECT 
a.name,b.name, ST_Distance(St_Transform(A.cafegeom,32633),ST_Transform(B.cafegeom,32633))/1000.00 as TheDistanceKM
FROM cs621_berlin as A, cs621_berlin as B
WHERE A.cafeid != B.cafeid and a.name = 'CS621 Student Cafe'
ORDER by TheDistanceKM ASC
LIMIT 100;



-- cs621_berlin
-- "node/66917229";"Starbucks"
-- The Brandenberg Gate is the most famous landmark in Berlin. The geographic point is POINT(13.377722 52.516272) in EPSG 4326. Write an SQL query which will provide the Cafe ID and the Name of the geographically closest cafe to the Brandenberg Gate. You should NOT USE the round function.  

SELECT *, ST_AsText(cafegeom),ST_Distance(St_Transform(St_GeomFromText('POINT(13.377722 52.516272)',4326),3035),ST_Transform(cafegeom,3035))/1000.00 as TheDistance
FROM cs621_berlin   ORDER BY TheDistance ASC LIMIT 100; 

SELECT *, ST_AsText(cafegeom),ST_Distance(St_Transform(St_GeomFromText('POINT(13.377722 52.516272)',4326),32633),ST_Transform(cafegeom,32633))/1000.00 as TheDistance
FROM cs621_berlin   ORDER BY TheDistance ASC LIMIT 10; 



---- FINAL QUESTION 

--bbox=13.3237,52.4857,13.4686,52.5590
             

select * from CS621_Berlin limit 1;

INSERT INTO CS621_Berlin (cafegeom,cafeid,name,waccess) VALUES (ST_GeomFromText('POINT (13.2540   52.4099)',4326),'node/Q10A','Starbucks','no');
INSERT INTO CS621_Berlin (cafegeom,cafeid,name,waccess) VALUES (ST_GeomFromText('POINT ( 13.601   52.604)',4326),'node/Q10B','Starbucks','no');

select *,St_AsText(cafegeom) from CS621_Berlin where cafegeom && ST_MakeEnvelope(13.3237,52.4857,13.4686,52.5590,4326) and (waccess = 'no') and (name ~* '^.*Starbucks.*$');



---

SELECT * from IE_Counties limit 1;

SELECT * FROM CS621_LabExam1_ATMS limit 1;



-- LAB EXAM 2 LECTURER'S SOLUTIONS
SELECT * FROM copenhagen2017 limit 10;


-- QUESTION 1: Delete the rows from the copenhagen2017 dataset where the website column, the phone column and the cuisine column are all null values. The Moodle Quiz will ask you to state the number of rows affected by this query statement. 
-- ANS 56 ROWS. 

SELECT * From copenhagen2017 where (website is null) and (phone is null) and (cuisine is null);
DELETE from copenhagen2017 where (website is null) and (phone is null) and (cuisine is null);


-- QUESTION 2: The Little Mermaid statue is one of the most famous tourist attractions in Copenhagen city. The statue is located beside the water in Copenhagen Port at Latitude = 55.692861 and Longitude = 12.59927.
-- FWrite an SQL query to find the total number of restaurants which are within 1KM  of the Little Mermaid statue. You should use EPSG:23032 for your calculations. The Moodle Quiz will ask you state the number of rows returned by this query. 
-- ANSWER = 10 Rows

SELECT *,ST_Distance(ST_Transform(St_GeomFromText('POINT(12.59927 55.692861)',4326),23032),ST_Transform(geom,23032))/1000 as TheDistanceKM 
FROM copenhagen2017 where    ST_DWithin(ST_Transform(St_GeomFromText('POINT(12.59927 55.692861)',4326),23032),ST_Transform(geom,23032 ),1000) order by TheDistanceKM desc;

-- QUESTION 3: 
-- Update the copenhagen2017 table in the following way. If the website column is null then set the website value to http://www.visitcopenhagen.com  The Moodle Quiz will ask you to state the number of rows updated by this query. 

-- ANSWER = ROWS = 96

Select * from copenhagen2017 where website is null; 
UPDATE Copenhagen2017 set website = 'http://www.visitcopenhagen.com' where website is null;


-- QUESTION 4:

-- Kongens Nytorv  "The King's New Square"  is a public square in Copenhagen. The latitude, longitude (55.680278,12.585833) are the coordinates of the approximate center of the square. Write
-- an SQL query to find the number of restaurants which are within 500 meters of Kongens Nytorv with the cuisine column equalt to null and the POI has been last updated in OpenStreetMap from October 2017 onwards. 
-- ANSWER = 4 ROWS

SELECT *,ST_Distance(ST_Transform(St_GeomFromText('POINT(12.585833 55.680278)',4326),23032),ST_Transform(geom,23032))/1000 as TheDistanceKM 
FROM copenhagen2017 where    ST_DWithin(ST_Transform(St_GeomFromText('POINT(12.585833 55.680278)',4326),23032),ST_Transform(geom,23032 ),500) and (cuisine is null) and (lastupdated > '2017-09-30') order by TheDistanceKM desc;

-- QUESTION 5:
Select ST_ASTEXT(geom),* from copenhagen2017 limit 20;

-- The spatial coordinates of the Danish restaurant 'Ingolfs Kaffebar' are incorrect. The Latitude and Longitude both need to be rounded to two decimal places. Write an appropriate SQL statement to make this update. The Moodle Quiz will ask you how many rows are affected by this query. 
-- ANS = 1 ROW

UPDATE copenhagen2017 set geom = St_GeomFromText('POINT(12.62 55.65)',4326) where name = 'Ingolfs Kaffebar';


-- QUESTION 6: 
-- An envelope with bottom left coordinates 12.5691,55.6827 and top right coordinates 12.5839,55.6892 is created to cover the Botanical Gardens area of Copenhagen. A set of Italian tourists would like to eat at an Italian restaurant (cuisine = italian) in this area. Using this Envelope
-- write an SQL query to find the total number of Italian restuarants inside this envelope. 
-- ANS = 5 ROWS

SELECT * From copenhagen2017 where geom @ ST_MakeEnvelope(12.5691,55.6827,12.5839,55.6892,4326) and (cuisine = 'italian');


-- QUESTION 7:

-- Using the envelope from Question 6 - write an SQL Statement which deletes any restaurant which are not Italian 
-- cuisine within this envelope. The Moodle quiz will ask you to state the number of rows affected by this query. 
-- You are advised to use a SELECT statement to ensure you write the delete statement correctly for this question. 
-- ANS = 9 Rows

BEGIN;
SELECT * From copenhagen2017 where geom @ ST_MakeEnvelope(12.5691,55.6827,12.5839,55.6892,4326) and ((cuisine != 'italian') or (cuisine is null));
DELETE From copenhagen2017 where geom @ ST_MakeEnvelope(12.5691,55.6827,12.5839,55.6892,4326) and ((cuisine != 'italian') or (cuisine is null));
COMMIT;
ROLLBACK;

SELECT * from Copenhagen2017 limit 20;

-- QUESTION 8
-- Write an SQL query which investigates the lastupdated column. The query should find any lastupdated timestemp where the month is equal to the day and the hour is equal to the minute. The Moodle quiz will ask you to indicate the number of rows returned. 
-- ANS = 1;

SELECT lastupdated from Copenhagen2017 where (date_part('month', lastupdated) = date_part('day', lastupdated)) and (date_part('hour', lastupdated) = date_part('minute', lastupdated));

-- QUESTION 9

-- Write an SQL query to find the closest restaurant to Copenhagen Main Railway station (55.67219,12.56525). You should use EPSG:23032 for your calculations. Do not round any of your calculations. 
-- The Moodle quiz will require the exact osm_id of the closest restaurnt. "node/1806980582"

SELECT ST_Distance(St_Transform(St_GeomFromText('POINT(12.56525 55.67219)',4326),23032),ST_Transform(geom,23032))/1000.00 as TheDistance,*
FROM Copenhagen2017 ORDER BY TheDistance ASC LIMIT 5; 

-- QUESTION 10:
-- ANS = 609
Select count(*) from copenhagen2017;


SELECT * FROM copenhagen2017 limit 10;

