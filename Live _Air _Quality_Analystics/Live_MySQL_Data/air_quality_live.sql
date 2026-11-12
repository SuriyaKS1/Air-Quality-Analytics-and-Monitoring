USE air_quality_analytics;
DESCRIBE air_quality_live;



SELECT
    COUNT(*) AS total_records,
    SUM(location_id IS NULL) AS missing_location_id,
    SUM(sensor_id IS NULL) AS missing_sensor_id,
    SUM(station IS NULL) AS missing_station,
    SUM(city IS NULL) AS missing_city,
    SUM(state IS NULL) AS missing_state,
    SUM(country IS NULL) AS missing_country,
    SUM(latitude IS NULL) AS missing_latitude,
    SUM(longitude IS NULL) AS missing_longitude,
    SUM(source_parameter IS NULL) AS missing_parameter,
    SUM(measurement_value IS NULL) AS missing_value,
    SUM(last_update_utc IS NULL) AS missing_timestamp,
    SUM(freshness_status IS NULL) AS missing_freshness
FROM air_quality_live;

SELECT *
FROM air_quality_live
WHERE measurement_value < 0;

SELECT *
FROM air_quality_live
WHERE latitude NOT BETWEEN -90 AND 90
   OR longitude NOT BETWEEN -180 AND 180;

 SELECT
    source_parameter,
    pollutant_id,
    parameter_type,
    COUNT(*) AS total_readings
FROM air_quality_live
GROUP BY source_parameter, pollutant_id, parameter_type;

SELECT
    source_parameter,
    unit,
    COUNT(*) AS total_readings,
    ROUND(AVG(measurement_value), 2) AS average_value,
    ROUND(MAX(measurement_value), 2) AS maximum_value,
    ROUND(MIN(measurement_value), 2) AS minimum_value
FROM air_quality_live
GROUP BY source_parameter, unit
ORDER BY average_value DESC;

SELECT
    city,
    state,
    source_parameter,
    ROUND(AVG(measurement_value), 2) AS average_pollution,
    COUNT(*) AS total_readings
FROM air_quality_live
GROUP BY city, state, source_parameter
ORDER BY average_pollution DESC;

SELECT
    station,
    city,
    source_parameter,
    ROUND(AVG(measurement_value), 2) AS average_value
FROM air_quality_live
GROUP BY station, city, source_parameter
ORDER BY average_value DESC;

SELECT
    DATE(last_update_utc) AS reading_date,
    source_parameter,
    ROUND(AVG(measurement_value), 2) AS daily_average
FROM air_quality_live
GROUP BY DATE(last_update_utc), source_parameter
ORDER BY reading_date;

SELECT
    HOUR(last_update_utc) AS reading_hour,
    source_parameter,
    ROUND(AVG(measurement_value), 2) AS hourly_average
FROM air_quality_live
GROUP BY HOUR(last_update_utc), source_parameter
ORDER BY reading_hour;

SELECT
    freshness_status,
    COUNT(*) AS total_records,
    ROUND(AVG(measurement_age_hours), 2) AS avg_age_hours
FROM air_quality_live
GROUP BY freshness_status;

SELECT
    station,
    city,
    source_parameter,
    measurement_value,
    unit,
    last_update_utc
FROM air_quality_live
ORDER BY measurement_value DESC
LIMIT 10;

CREATE OR REPLACE VIEW vw_air_quality_clean AS
SELECT *
FROM air_quality_live
WHERE measurement_value IS NOT NULL
AND measurement_value >= 0
AND last_update_utc IS NOT NULL
AND latitude BETWEEN -90 AND 90
AND longitude BETWEEN -180 AND 180;

