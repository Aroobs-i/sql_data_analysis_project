-- Database Loading
COPY company_dim
FROM '/home/arooba/developer/sql_data_analysis_project/csv_files/company_dim.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );
COPY skills_dim
FROM '/home/arooba/developer/sql_data_analysis_project/csv_files/skills_dim.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );
COPY job_postings_fact
FROM '/home/arooba/developer/sql_data_analysis_project/csv_files/job_postings_fact.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );
COPY skills_job_dim
FROM '/home/arooba/developer/sql_data_analysis_project/csv_files/skills_job_dim.csv' WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',',
        ENCODING 'UTF8'
    );
    
-- type casting
SELECT *
FROM company_dim
LIMIT 100;
SELECT 
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'true'::BOOLEAN,
    '3.14'::REAL;

-- Changing the time zones
SELECT 
    job_title_short As title,
    job_location As location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' As date,
    EXTRACT(
        MONTH
        FROM job_posted_date
    ) As month,
    EXTRACT(
        YEAR
        FROM job_posted_date
    ) As year
FROM job_postings_fact
LIMIT 10;

-- Extracting the month from the job_posted_date column
SELECT 
    COUNT(job_id) as count,
    EXTRACT(
        MONTH
        FROM job_posted_date
    ) AS month
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY count DESC;

-- Extract method
CREATE TABLE january_jobs AS
SELECT *
FROM job_postings_fact
WHERE 
    EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 1;

CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE 
    EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 2;

CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE 
    EXTRACT(
        MONTH
        FROM job_posted_date
    ) = 3;
SELECT job_posted_date
FROM march_jobs;

-- Case Expression
SELECT 
    COUNT(job_id) AS job_count,
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END as location_category
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    location_category;

-- Subquery
SELECT *
FROM (
        SELECT *
        From job_postings_fact
        WHERE EXTRACT(
                MONTH
                FROM job_posted_date
            ) = 1
    ) AS january_jobs;

-- CTEs
WITH april_jobs AS (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(
            MONTH
            FROM job_posted_date
        ) = 4
)
SELECT *
FROM april_jobs;