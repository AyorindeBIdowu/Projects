/*
Hotels in Lagos Data Cleaning
/*
# This query script will clean up the data containing datas related to Hotels in Lagos, Nigeria and make it ready for explorattion and visualisation.

SELECT *
FROM hotels_in_lagos;

# creating a duplicate of the table 

DROP TABLE IF EXISTS lagos_hotel_staging;
CREATE TABLE lagos_hotel_staging
LIKE hotels_in_lagos;

SELECT *
FROM lagos_hotel_staging;

INSERT lagos_hotel_staging
SELECT *
FROM hotels_in_lagos;

# trimming the leading spaces on columns

SELECT Hotel_Name, TRIM(Hotel_Name)
FROM lagos_hotel_staging
ORDER BY Hotel_Name;

UPDATE lagos_hotel_staging
SET Hotel_Name = Trim(Hotel_Name);

ALTER TABLE lagos_hotel_staging
DROP COLUMN MyUnknownColumn;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY Hotel_Name, Location, Address, Cost, Property_type, Likes, Rating, Review) as row_num
FROM lagos_hotel_staging;

WITH CTE as (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Hotel_Name, Location, Address, Cost, Property_type, Likes, Rating, Review) as row_num
FROM lagos_hotel_staging
)
SELECT *
FROM CTE
WHERE row_num > 1
;

SELECt *
FROM lagos_hotel_staging
WHERE Hotel_Name LIKE "Aplus%"
;
CREATE TABLE `lagos_hotel_staging_2` (
  `Hotel_Name` text,
  `Location` text,
  `Address` text,
  `Cost` text,
  `Property_type` text,
  `Likes` int DEFAULT NULL,
  `Rating` text,
  `Review` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

# insert row number to identify duplicates

INSERT lagos_hotel_staging_2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY Hotel_Name, Location, Address, Cost, Property_type, Likes, Rating, Review) as row_num
FROM lagos_hotel_staging;

SELECT *
FROM lagos_hotel_staging_2;

DELETE
FROM lagos_hotel_staging_2
WHERE row_num > 1;

SELECT *
FROM lagos_hotel_staging_2
WHERE row_num > 1;

# Removing leading characters from Cost and Address

SELECT Cost, trim(LEADING 'â‚¦' FROM Cost),
Address, trim(LEADING ',' From Address)
FROM lagos_hotel_staging_2;

UPDATE lagos_hotel_staging_2
SET Cost = trim(LEADING 'â‚¦' FROM Cost);

UPDATE lagos_hotel_staging_2
SET Address = trim(LEADING ',' From Address);

UPDATE lagos_hotel_staging_2
SET Address = TRIM(Address);

# removing rows where the cost is missing
SELECT *
FROM lagos_hotel_staging_2
WHERE COST = 'NA';

DELETE
FROM lagos_hotel_staging_2
WHERE Cost = 'NA';

SELECT DISTINCT Location
FROM lagos_hotel_staging_2;

UPDATE lagos_hotel_staging_2
SET Location = Trim(Location);

SELECT *
FROM lagos_hotel_staging_2
WHERE Location = '';

# changing cost column type

SELECT Cost, CONVERT(REPLACE(Cost, ',', ''), DECIMAL(10, 0)) AS amount
FROM lagos_hotel_staging_2;

UPDATE lagos_hotel_staging_2
SET Cost = CONVERT(REPLACE(Cost, ',', ''), DECIMAL(10, 0));

# Deleting the row number column

SELECT *
FROM lagos_hotel_staging_2;

ALTER TABLE lagos_hotel_staging_2
DROP COLUMN row_num;

SELECT DISTINCT(Location)
FROM lagos_hotel_staging_2
ORDER BY Location;

# trim location to remove spaces

SELECT DISTINCT Location, TRIM(TRAILING '.' FROM Location)
FROM lagos_hotel_staging_2
WHERE Location LIKE 'Abule%';

Update lagos_hotel_staging_2
SET Location = TRIM(TRAILING '.' FROM Location);
-- WHERE Location LIKE 'Abule%';

SELECT DISTINCT Location
FROM lagos_hotel_staging_2
WHERE Location LIKE 'Allen%';

Update lagos_hotel_staging_2
SET Location = 'Yaba'
WHERE Location LIKE 'Yaba%';

SELECT *
FROM lagos_hotel_staging_2;

































