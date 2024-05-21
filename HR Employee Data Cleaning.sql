/* SQL DATASET : hr */

-- Creating the database and importing the data 
CREATE DATABASE projects;
USE projects;

-- /* DATA CLEANING */
SELECT * FROM hr;
-- Changing the name of columns to easy understanadable form
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- Checking the data types 
DESCRIBE hr;

-- Changing the data type into the required data type format

-- Birthdate data type change
SELECT birthdate FROM hr;
SET sql_safe_updates =0;

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%Y'), '%Y-%m-%d')
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m-%d-%Y'), '%Y-%m-%d')
	ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

SELECT birthdate FROM hr;

DESCRIBE hr;

-- Hire date data change
/* Set Hire date format */

SET sql_safe_updates =0;
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'),'%Y-%m-%d')
    WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'),'%Y-%m-%d')
    ELSE null
END;
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;
SELECT hire_date FROM hr;
DESCRIBE hr;

-- Trem date data type change
/* Modify tremdate in dataset */

SELECT termdate FROM hr;
UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate !='';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- 1.Set invalid date values to NULL
UPDATE hr
SET termdate = NULL
WHERE termdate = '' OR termdate IS NULL OR STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s') IS NULL;

-- 2.Convert valid text dates to DATE format
UPDATE hr
SET termdate = STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s')
WHERE termdate IS NOT NULL AND termdate != '';

-- 3.Alter the column to DATE type
ALTER TABLE hr
MODIFY COLUMN termdate DATE;

SELECT termdate FROM hr;

-- Looking if additional columns to be added to make analysis easier?

-- ADD AGE COLUMN 
ALTER TABLE hr
ADD COLUMN age INT;
SELECT * FROM hr;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT birthdate, age FROM hr;

SELECT
	min(age) AS youngest,
        max(age) AS oldest    
FROM hr;
-- Cross verifying the data ands solutions being obtained
SELECT count(*) FROM hr WHERE age<18;
