--This cleaning project is an exploration of KPMG customer list, specifically customer demographics.

SELECT *
FROM CustomerDemographic$

-- Cleaning  Date

SELECT DOBConverted, CONVERT(Date, DOB) 
FROM CustomerDemographic$

ALTER TABLE CustomerDemographic$
ADD DOBConverted Date;

UPDATE CustomerDemographic$
SET DOBConverted = CONVERT(Date, DOB)

-- Cleaning mistakes in strings. The example below will demonstrate how I would go about changing the strings within first_name and last_name column 
--to read uniformly.ie Starting with a upper-case while the remainder of the strings is in lower-case.

--First Name Column

SELECT first_name, UPPER(LEFT(first_name,1)) + LOWER(SUBSTRING(first_name,2,LEN(first_name))) AS FirstName2 
FROM CustomerDemographic$

--Last Name Column

SELECT last_name, UPPER(LEFT(last_name, 1)) + LOWER(SUBSTRING(last_name,2,LEN(last_name))) AS LastName2
FROM CustomerDemographic$

--The age column shows all ages in decimals, this is how I'd go about rounding the ages to show whole numbers.

SELECT Age, ROUND(Age, 0) As RoundedAge
FROM CustomerDemographic$

--Deleting un-useable columns * Note, Im aware that in real life I would need permission from an authority to execute this query;It might not be
--legal to delete a companies information.This project is merely to showcase my skills.

ALTER TABLE CustomerDemographic$
DROP COLUMN past_3_years_bike_related_pOrchases,deceased_indicator,tenure;

--Update strings within columns to fix mistakes

UPDATE CustomerDemographic$
SET job_indOstry_category = 'Manufacturing'
WHERE customer_id = 2113

UPDATE CustomerDemographic$
SET job_indOstry_category = 'Agriculture'
WHERE customer_id = 2114

UPDATE CustomerDemographic$
SET job_indOstry_category = 'Telecommunications'
WHERE customer_id = 3213

--Finding duplicates in columns 

--1. Identify duplicates

WITH row_numCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY customer_id, 
				 first_name,
				 age,
				 last_name,
				 job_title,
				 job_indOstry_category
				 ORDER BY 
				 customer_id
				 ) row_num
FROM CustomerDemographic$
)
SELECT *
FROM row_numCTE
WHERE row_num >1
ORDER BY age

--2. Delete duplicates

WITH row_numCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY customer_id, 
				 first_name,
				 age,
				 last_name,
				 job_title,
				 job_indOstry_category
				 ORDER BY 
				 customer_id
				 ) row_num
FROM CustomerDemographic$
)
DELETE
FROM row_numCTE
WHERE row_num >1


--Changing column name of column title job_indOstry_category

EXECUTE sp_rename '[dbo].CustomerDemographic$.job_indOstry_category',
' job_industry_category', 'Column'