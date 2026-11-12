-- 1. Missing readings by pollutant
SELECT pollutant_id, COUNT(*) AS total_rows,
       SUM(pollutant_avg IS NULL) AS missing
FROM air_pollution
GROUP BY pollutant_id;

-- 2. Duplicates: should be one row per station per pollutant
SELECT station, pollutant_id, COUNT(*)
FROM air_pollution
GROUP BY station, pollutant_id
HAVING COUNT(*) > 1;

SELECT
    state,
    city_clean,
    station,
    pollutant_id,
    last_update,
    COUNT(*) AS duplicate_count
FROM air_pollution
GROUP BY
    state,
    city_clean,
    station,
    pollutant_id,
    last_update
HAVING COUNT(*) > 1;

-- 3. Logic check: min <= avg <= max must always hold
SELECT COUNT(*) FROM air_pollution
WHERE pollutant_min > pollutant_avg OR pollutant_avg > pollutant_max;

SELECT COUNT(*) AS invalid_readings
FROM air_pollution
WHERE pollutant_min IS NOT NULL
  AND pollutant_avg IS NOT NULL
  AND pollutant_max IS NOT NULL
  AND (
      pollutant_min < 0
      OR pollutant_avg < 0
      OR pollutant_max < 0
      OR pollutant_min > pollutant_avg
      OR pollutant_avg > pollutant_max
  );

-- 4. Suspicious zeros
SELECT pollutant_id, COUNT(*) FROM air_pollution
WHERE pollutant_avg = 0
GROUP BY pollutant_id;

-- 5. Do the city columns agree?
SELECT state, city, city_clean, station, pollutant_id
FROM air_pollution
WHERE city <> city_clean;

SELECT
    state,
    city,
    city_clean,
    station
FROM air_pollution
WHERE BINARY city <> BINARY city_clean;

-- 6. How many different timestamps are there?
SELECT COUNT(DISTINCT last_update) FROM air_pollution;

-- Which cities have the worst PM2.5 right now?
SELECT city_clean, state,
       ROUND(AVG(pollutant_avg), 1) AS avg_pm25,
       COUNT(pollutant_avg) AS stations_reporting
FROM air_pollution
WHERE pollutant_id = 'PM2.5'
GROUP BY city_clean, state
ORDER BY avg_pm25 DESC
LIMIT 10;

SELECT city_clean, state,
       ROUND(AVG(pollutant_avg), 1) AS avg_pm25,
       COUNT(pollutant_avg) AS stations_reporting
FROM air_pollution
WHERE pollutant_id = 'PM2.5'
GROUP BY city_clean, state
HAVING COUNT(pollutant_avg) >= 3
ORDER BY avg_pm25 DESC
LIMIT 10;

SELECT
  CASE
    WHEN pollutant_avg <= 30  THEN '1 Good'
    WHEN pollutant_avg <= 60  THEN '2 Satisfactory'
    WHEN pollutant_avg <= 90  THEN '3 Moderate'
    WHEN pollutant_avg <= 120 THEN '4 Poor'
    WHEN pollutant_avg <= 250 THEN '5 Very Poor'
    ELSE '6 Severe'
  END AS pm25_category,
  COUNT(*) AS stations
FROM air_pollution
WHERE pollutant_id = 'PM2.5'
  AND pollutant_avg IS NOT NULL
GROUP BY pm25_category
ORDER BY pm25_category;

SELECT
    city_clean,
    state,
    ROUND(AVG(pollutant_avg), 1) AS avg_pm25,
    COUNT(DISTINCT station) AS stations_reporting
FROM air_pollution
WHERE pollutant_id = 'PM2.5'
  AND pollutant_avg IS NOT NULL
GROUP BY city_clean, state
HAVING COUNT(DISTINCT station) >= 3
ORDER BY avg_pm25 DESC
LIMIT 10;

SELECT
    pollutant_id,
    COUNT(*) AS total_records,
    COUNT(pollutant_avg) AS available_readings,
    COUNT(*) - COUNT(pollutant_avg) AS missing_readings,
    ROUND(
        100.0 * COUNT(pollutant_avg) / COUNT(*),
        2
    ) AS availability_percentage
FROM air_pollution
GROUP BY pollutant_id
ORDER BY availability_percentage ASC;