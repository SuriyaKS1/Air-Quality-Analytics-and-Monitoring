USE air_quality_analytics;
SET GLOBAL local_infile = 1;

DROP TABLE IF EXISTS air_quality_live_staging;
CREATE TABLE air_quality_live_staging(
  location_id INT,
  sensor_id BIGINT PRIMARY KEY,
  station VARCHAR(100),
  city VARCHAR(50) NULL,
  state VARCHAR(50) NULL,
  country VARCHAR(20),
  provider VARCHAR(20),
  latitude DOUBLE,
  longitude DOUBLE,
  source_parameter VARCHAR(30),
  pollutant_id VARCHAR(30),
  parameter_type VARCHAR(20),
  measurement_value DOUBLE,
  unit VARCHAR(10),
  last_update_utc DATETIME,
  extracted_at_utc DATETIME,
  measurement_age_hours DOUBLE,
  freshness_status VARCHAR(20)
) DEFAULT CHARSET = utf8mb4;

LOAD DATA LOCAL INFILE
'C:/Suriya_Sankaran_K/Data__Analyst/New folder/cpcb_mysql_import.csv'
INTO TABLE air_quality_live_staging
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;