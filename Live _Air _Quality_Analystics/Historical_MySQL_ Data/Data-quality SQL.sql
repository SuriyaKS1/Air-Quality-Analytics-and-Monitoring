CREATE DATABASE IF NOT EXISTS air_quality_analytics;
USE air_quality_analytics;

DROP TABLE IF EXISTS air_pollution;
CREATE TABLE air_pollution (
  id INT AUTO_INCREMENT PRIMARY KEY,
  country VARCHAR(20),
  state VARCHAR(50),
  city VARCHAR(50),
  station VARCHAR(100),
  last_update DATETIME,
  latitude DOUBLE,
  longitude DOUBLE,
  pollutant_id VARCHAR(10),
  pollutant_min INT NULL,
  pollutant_max INT NULL,
  pollutant_avg INT NULL,
  city_clean VARCHAR(50),
  measurement_status VARCHAR(30)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/air_quality_cleaned.csv'
INTO TABLE air_pollution
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(country, state, city, station, @last_update, latitude, longitude,
 pollutant_id, @pmin, @pmax, @pavg, city_clean, measurement_status)
SET last_update   = STR_TO_DATE(@last_update, '%d-%m-%Y %H:%i'),
    pollutant_min = NULLIF(@pmin, ''),
    pollutant_max = NULLIF(@pmax, ''),
    pollutant_avg = NULLIF(@pavg, '');

SELECT COUNT(*) FROM air_pollution;                              -- expect 3759
SELECT COUNT(*) FROM air_pollution WHERE pollutant_avg IS NULL;  -- expect 335
SELECT last_update FROM air_pollution LIMIT 3;                   -- expect 2026-10-26 16:00:00