-- 1
CREATE SCHEMA IF NOT EXISTS pandemic;
USE pandemic;

-- 2
DROP TABLE IF EXISTS infectious_cases_data;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS diseases;

CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    entity VARCHAR(255),
    code VARCHAR(12)
);

CREATE TABLE diseases (
    disease_id INT AUTO_INCREMENT PRIMARY KEY,
    disease_name VARCHAR(255)
);

CREATE TABLE infectious_cases_data (
    ic_data_id INT AUTO_INCREMENT PRIMARY KEY,
    country_id INT,
    Year INT,
    disease_id INT,
    cases INT,
    FOREIGN KEY (country_id) REFERENCES countries(country_id),
    FOREIGN KEY (disease_id) REFERENCES diseases(disease_id)
);

INSERT INTO countries (entity, code)
SELECT DISTINCT entity, code
FROM infectious_cases;

INSERT INTO diseases (disease_name) 
VALUES
	('yaws'),
	('polio'),
	('guinea_worm'),
	('rabies'),
	('malaria'),
	('hiv'),
	('tuberculosis'),
	('smallpox'),
	('cholera');

INSERT INTO infectious_cases_data (country_id, Year, disease_id, cases)
SELECT
	c.country_id,
    ic.Year,
    d.disease_id,
    ic.Number_yaws
FROM infectious_cases ic
JOIN diseases d ON d.disease_name = 'yaws'
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
	WHERE ic.Number_yaws IS NOT NULL;
    
INSERT INTO infectious_cases_data (country_id, Year, disease_id, cases)
SELECT
	c.country_id,
    ic.Year,
	d.disease_id,
    ic.polio_cases
FROM infectious_cases ic
JOIN diseases d ON d.disease_name = 'polio'
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
WHERE ic.polio_cases IS NOT NULL;

INSERT INTO infectious_cases_data (country_id, Year, disease_id, cases)
SELECT
	c.country_id,
    ic.Year,
    d.disease_id,
    ic.cases_guinea_worm
FROM infectious_cases ic
JOIN diseases d ON d.disease_name = 'guinea_worm'
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
WHERE ic.cases_guinea_worm IS NOT NULL;

INSERT INTO infectious_cases_data (country_id, Year, disease_id, cases)
SELECT
	c.country_id,
    ic.Year,
    d.disease_id,
    ic.Number_rabies
FROM infectious_cases ic
JOIN diseases d ON d.disease_name = 'rabies'
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
WHERE ic.Number_rabies IS NOT NULL;

INSERT INTO infectious_cases_data (country_id, Year, disease_id, cases)
SELECT
	c.country_id,
    ic.Year,
    d.disease_id,
    ic.Number_malaria
FROM infectious_cases ic
JOIN diseases d ON d.disease_name = 'malaria'
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
WHERE ic.Number_malaria IS NOT NULL;

INSERT INTO infectious_cases_data (country_id, Year, disease_id, cases)
SELECT
	c.country_id,
    ic.Year,
    d.disease_id,
    ic.Number_hiv
FROM infectious_cases ic
JOIN diseases d ON d.disease_name = 'hiv'
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
WHERE ic.Number_hiv IS NOT NULL;

INSERT INTO infectious_cases_data (country_id, Year, disease_id, cases)
SELECT
	c.country_id,
    ic.Year,
    d.disease_id,
    ic.Number_tuberculosis
FROM infectious_cases ic
JOIN diseases d ON d.disease_name = 'tuberculosis'
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
WHERE ic.Number_tuberculosis IS NOT NULL;

INSERT INTO infectious_cases_data (country_id, Year, disease_id, cases)
SELECT
	c.country_id,
    ic.Year,
    d.disease_id,
    ic.Number_smallpox
FROM infectious_cases ic
JOIN diseases d ON d.disease_name = 'smallpox'
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
WHERE ic.Number_smallpox IS NOT NULL;

INSERT INTO infectious_cases_data (country_id, Year, disease_id, cases)
SELECT
	c.country_id,
    ic.Year,
    d.disease_id,
    ic.Number_cholera_cases
FROM infectious_cases ic
JOIN diseases d ON d.disease_name = 'cholera'
JOIN countries c ON ic.Entity = c.entity AND ic.Code = c.code
WHERE ic.Number_cholera_cases IS NOT NULL;

-- 3
SELECT
    c.entity,
    c.code,
    AVG(ic_data.cases) AS Average_Rabies,
    MIN(ic_data.cases) AS Min_Rabies,
    MAX(ic_data.cases) AS Max_Rabies,
    SUM(ic_data.cases) AS Sum_Rabies
FROM
	infectious_cases_data ic_data
JOIN
	countries c ON ic_data.country_id = c.country_id
JOIN
	diseases d ON ic_data.disease_id = d.disease_id
WHERE
	d.disease_name = 'rabies' AND ic_data.cases != '' AND ic_data.cases IS NOT NULL
GROUP BY
	c.entity, c.code
ORDER BY
	Average_Rabies DESC
LIMIT
	10;

-- 4
SELECT 
	Year,
    CONCAT(Year, '-01-01') AS Start_Date,
    CURDATE() AS Curr_Date,
    TIMESTAMPDIFF(year, CONCAT(Year, '-01-01'), CURDATE()) AS Year_Difference
FROM
	infectious_cases_data;
    

-- 5
DELIMITER //
DROP FUNCTION IF EXISTS Year_Difference;
CREATE FUNCTION Year_Difference(input_year INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    DECLARE start_date DATE;
    DECLARE year_difference INT;
    SET start_date = CONCAT(input_year, '-01-01');
    SET year_difference = TIMESTAMPDIFF(YEAR, start_date, CURDATE());
    RETURN year_difference;
END//

DELIMITER ;

SELECT 
    Year,
    CONCAT(Year, '-01-01') AS Start_Date,
    CURDATE() AS Curr_Date,
    Year_Difference(Year) AS Year_Difference
FROM 
	infectious_cases_data;
