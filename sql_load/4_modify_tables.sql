-- Subquery example
SELECT 
    name as company_name,
    company_id
FROM 
    company_dim
WHERE company_id IN (
        SELECT 
            company_id
        FROM 
            job_postings_fact
        WHERE 
            job_no_degree_mention = TRUE
    );

-- CTE example
WITH company_job_count AS (
    SELECT 
        company_id,
        Count(*) as total_jobs
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
)
SELECT 
    company_dim.name as company_name,
    company_job_count.total_jobs
FROM 
    company_dim
LEFT JOIN 
    company_job_count 
ON
    company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC;   
 
-- Practice Problem
WITH remote_job_skills AS(
        SELECT 
            skill_id,
            COUNT(*) AS skill_count
        FROM
            skills_job_dim As skills_to_job
        INNER JOIN
            job_postings_fact As job_postings
        ON
            job_postings.job_id = skills_to_job.job_id
        WHERE
            job_postings.job_work_from_home = TRUE AND
            job_title_short = 'Data Engineer'
        GROUP BY
            skill_id                  
)
SELECT 
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM 
    remote_job_skills
INNER JOIN
    skills_dim AS skills
ON
    skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT
    10;        

   -- Union Operators
SELECT 
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs  
UNION ALL
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs;

    -- Practie Problem

SELECT 
    quarter1_job_postings.job_title_short,
    quarter1_job_postings.job_location,
    quarter1_job_postings.job_posted_date::DATE,
    quarter1_job_postings.salary_year_avg
FROM  (
        SELECT *
        FROM january_jobs
        UNION ALL
        SELECT *
        FROM february_jobs
        UNION ALL
        SELECT *
        FROM march_jobs
) AS quarter1_job_postings
WHERE
    quarter1_job_postings.salary_year_avg > 70000 AND
    quarter1_job_postings.job_title_short = 'Data Analyst'
ORDER BY
    quarter1_job_postings.salary_year_avg DESC;    


