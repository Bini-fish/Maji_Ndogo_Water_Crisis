use md_water_services;

-- ----------------------------------------------------
-- Part 1: Initial Data Exploration and Cleaning
-- ----------------------------------------------------
-- First, let's get to know our data by looking at the tables.
-- A good data analyst would use SHOW TABLES to see all tables in the database.
SHOW TABLES;

-- Next, we'll examine the first few rows of each table to understand their structure and content.
-- This helps us understand what information is available.
select * from employee limit 10;
select * from visits limit 10;
select * from water_source limit 10;
select * from location limit 10;
select * from well_pollution limit 10;
select * from water_quality limit 10;
select * from data_dictionary;

-- Find specific information from the tables.
select * from data_dictionary where description like '%population%';
select * from global_water_access where name like 'Maji Ndogo' ;
select distinct type_of_water_source from water_source;
select * from employee where employee_name = 'Bello Azibo';
select * from employee where position = 'Micro Biologist';
select * from employee where employee_name = 'Wambui Jabali';
select * from water_source order by number_of_people_served DESC;

-- Assess the quality of water sources.
select * from water_quality where subjective_quality_score = 10 and visit_count = 2;

-- Task 5: Investigate and correct pollution issues
-- Finding inconsistencies in the `well_pollution` table.
select * from well_pollution where results = 'Clean' and biological > 0.01;
select * from well_pollution where biological > 0.01 and description like '%Clean%';

-- Correcting corrupt data in the `well_pollution` table.
-- Using `UPDATE` to correct descriptions and results.
UPDATE well_pollution
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

UPDATE well_pollution
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

UPDATE well_pollution
SET results = 'Contaminated: Biological'
WHERE biological > 0.01 AND results = 'Clean';

-- More specific searches for pollution.
SELECT * FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;

SELECT *
FROM well_pollution
WHERE description IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);


-- ----------------------------------------------------
-- Part 2: Integrated Analysis
-- ----------------------------------------------------
-- Honouring the workers: Analyzing employee performance.
-- Find the two worst-performing employees who visited the fewest sites.
select assigned_employee_id, count(distinct location_id) as unique_sites_visited from visits where location_id is not null group by assigned_employee_id order by unique_sites_visited;
select employee_name from employee where assigned_employee_id IN (20,22);

-- Investigate potential corruption based on the audit.
-- (This query is based on the screenshot provided)
SELECT
    a.employee_name,
    COUNT(v.record_id) AS number_of_visits,
    SUM(CASE WHEN a.auditor_report = 'incorrect_data' THEN 1 ELSE 0 END) AS errors_found,
    ROUND(AVG(a.auditor_report = 'incorrect_data' ) * 100, 2) AS error_rate
FROM
    employee AS e
INNER JOIN
    visits AS v
ON e.assigned_employee_id = v.assigned_employee_id
INNER JOIN
    auditing AS a
ON v.record_id = a.record_id
WHERE a.auditor_report = 'incorrect_data'
GROUP BY
    e.employee_name
ORDER BY
    error_rate DESC;


-- Analyzing queues and wait times.
-- Computes an average queue time for shared taps visited more than once.
SELECT
    location_id,
    time_in_queue,
    AVG(time_in_queue) OVER (PARTITION BY location_id ORDER BY time_of_record) AS total_avg_queue_time
FROM
    visits
WHERE
    visit_count > 1 -- Only shared taps were visited > 1
ORDER BY
    location_id, time_of_record;

-- Analyzing water source usage patterns.
SELECT
    TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
    -- Sunday
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue ELSE NULL END), 0) AS Sunday,
    -- Monday
    ROUND(AVG(CASE WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue ELSE NULL END), 0) AS Monday
    -- (The rest of the days can be added here)
FROM
    visits
WHERE
    time_in_queue != 0 -- this excludes other sources with 0 queue times
GROUP BY
    hour_of_day
ORDER BY
    hour_of_day;

-- More employee-related queries.
SELECT *
FROM employee
WHERE position = 'Civil Engineer' AND (province_name = 'Dahabu' OR address LIKE '%Avenue%');

select * from employee where (SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'M%'
    OR SUBSTRING_INDEX(employee_name, ' ', -1) LIKE 'A%') and (position =  'Field Surveyor') and (phone_number LIKE '%86%'
    OR phone_number LIKE '%11%');


-- ----------------------------------------------------
-- Part 3: Building a Final Analysis Table
-- ----------------------------------------------------
-- Creating a `combined_analysis_table` view to simplify further analysis.
drop view if exists combined_analysis_table;
CREATE VIEW combined_analysis_table AS(
SELECT
    ws.type_of_water_source as source_type,
    loc.town_name,
    loc.province_name,
    loc.location_type,
    ws.number_of_people_served as people_served,
    v.time_in_queue,
    wp.results
FROM visits AS v
INNER JOIN location AS loc
ON v.location_id = loc.location_id
INNER JOIN water_source AS ws
ON ws.source_id = v.source_id
LEFT JOIN well_pollution AS wp
ON wp.source_id = v.source_id
WHERE v.visit_count = 1
);
select * from combined_analysis_table limit 10;


-- Creating a temporary table to aggregate water access by town and province.
drop temporary table if exists town_aggregated_water_access;
CREATE TEMPORARY TABLE town_aggregated_water_access
WITH town_totals AS (
SELECT province_name, town_name, SUM(people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name,town_name
)
SELECT
    ct.province_name,
    ct.town_name,
    -- The results are aggregated and percentages are calculated
    ROUND((SUM(CASE WHEN source_type = 'river' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
    ROUND((SUM(CASE WHEN source_type = 'shared_tap' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
    ROUND((SUM(CASE WHEN source_type = 'tap_in_home' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
    ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
    ROUND((SUM(CASE WHEN source_type = 'well' THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table AS ct
JOIN -- Since the town names are not unique, we have to join on a composite key
town_totals AS tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
GROUP BY -- We group by province first, then by town.
ct.province_name,
ct.town_name
ORDER BY
ct.town_name;

select * from town_aggregated_water_access order by river DESC;
select * from town_aggregated_water_access where province_name = 'Amanzi' order by river DESC limit 100;

-- Calculate the ratio of people who have taps but no running water.
SELECT
province_name,
town_name,
ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) * 100,0) AS Pct_broken_taps
FROM
town_aggregated_water_access;

select province_name from town_aggregated_water_access group by province_name HAVING
    MAX(tap_in_home + tap_in_home_broken) < 50;


-- ----------------------------------------------------
-- Part 4: A Practical Plan & Final Project Table
-- ----------------------------------------------------
-- This query creates the final `Project_progress` table.
CREATE TABLE IF NOT EXISTS Project_progress (
Project_id SERIAL PRIMARY KEY,
/* Project_id -- Unique key for sources in case we visit the same
source more than once in the future.
*/
source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
/* source_id -- Each of the sources we want to improve should exist,
and should refer to the source table. This ensures data integrity.
*/
Address VARCHAR(50), -- Street address
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
Improvement VARCHAR(50), -- What the engineers should do at that place
Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
/* Source_status -- We want to limit the type of information engineers can give us, so we
limit Source_status.
- By DEFAULT all projects are in the "Backlog" which is like a TODO list.
- CHECK() ensures only those three options will be accepted. This helps to maintain clean data.
*/
Date_of_completion DATE, -- Engineers will add this the day the source has been upgraded.
Comments TEXT -- Engineers can leave comments. We use a TEXT type that has no limit on char length
);

-- This query populates the `Project_progress` table with actionable data.
INSERT INTO Project_progress (
    source_id,
    Address,
    Town,
    Province,
    Source_type,
    Improvement
)
SELECT
    ws.source_id,
    loc.address,
    loc.town_name,
    loc.province_name,
    ws.type_of_water_source,
    CASE
        WHEN ws.type_of_water_source = 'shared_tap' AND v.time_in_queue >= 30 THEN CONCAT("Install ", FLOOR(v.time_in_queue/30), " taps nearby")
        WHEN wp.results LIKE '%Chemical%' THEN 'Install RO filter'
        WHEN wp.results LIKE '%Biological%' THEN 'Install UV and RO filter'
        WHEN ws.type_of_water_source = 'river' THEN 'Drill well'
        WHEN ws.type_of_water_source = 'tap_in_home_broken' THEN 'Diagnose infrastructure'
        ELSE NULL
    END AS Improvement
FROM
    water_source AS ws
LEFT JOIN
    well_pollution AS wp ON ws.source_id = wp.source_id
INNER JOIN
    visits AS v ON ws.source_id = v.source_id
INNER JOIN
    location AS loc ON loc.location_id = v.location_id
WHERE
    v.visit_count = 1 -- This must always be true
AND (
    wp.results != 'Clean'
    OR ws.type_of_water_source IN ('tap_in_home_broken','river')
    OR (ws.type_of_water_source = 'shared_tap' AND v.time_in_queue >= 30)
);

-- Final queries to check the populated `Project_progress` table.
select * from Project_progress;
select * from Project_progress where Source_type = 'shared_tap' order by Improvement DESC limit 100;

-- Using a window function to rank improvement projects by population.
SELECT
    project_progress.Project_id,
    project_progress.Town,
    project_progress.Province,
    project_progress.Source_type,
    project_progress.Improvement,
    water_source.number_of_people_served,
    RANK() OVER (PARTITION BY project_progress.Province ORDER BY water_source.number_of_people_served DESC) AS Ranking
FROM
    project_progress
JOIN
    water_source
    ON water_source.source_id = project_progress.source_id
WHERE
    project_progress.Improvement = 'Drill Well'
ORDER BY
    project_progress.Province DESC, water_source.number_of_people_served DESC;

-- Export the final results to a CSV file.
-- (Note: This is an example of a query to export data)
SELECT
project_progress.Project_id,
project_progress.Town,
project_progress.Province,
project_progress.Source_type,
project_progress.Improvement,
water_source.number_of_people_served,
RANK() OVER (PARTITION BY project_progress.Province ORDER BY water_source.number_of_people_served) AS Ranking
FROM
    project_progress
JOIN
    water_source
    ON water_source.source_id = project_progress.source_id
WHERE
    project_progress.Improvement = 'Drill Well'
ORDER BY
    project_progress.Province DESC, water_source.number_of_people_served
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/Suggested_Improvements.csv'
    FIELDS TERMINATED BY ','
    LINES TERMINATED BY '\n';