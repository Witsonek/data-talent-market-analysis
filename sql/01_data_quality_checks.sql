-- Run after all four source files have been imported.

-- 1. Table volumes
SELECT 'company_dim' AS table_name, COUNT(*) AS row_count FROM data_jobs.company_dim
UNION ALL
SELECT 'job_postings_fact', COUNT(*) FROM data_jobs.job_postings_fact
UNION ALL
SELECT 'skills_dim', COUNT(*) FROM data_jobs.skills_dim
UNION ALL
SELECT 'skills_job_dim', COUNT(*) FROM data_jobs.skills_job_dim
ORDER BY table_name;

-- 2. Mandatory-key null checks: each result must equal zero.
SELECT 'company_dim.company_id' AS check_name, COUNT(*) AS invalid_row_count
FROM data_jobs.company_dim WHERE company_id IS NULL
UNION ALL
SELECT 'job_postings_fact.job_id', COUNT(*)
FROM data_jobs.job_postings_fact WHERE job_id IS NULL
UNION ALL
SELECT 'skills_dim.skill_id', COUNT(*)
FROM data_jobs.skills_dim WHERE skill_id IS NULL
UNION ALL
SELECT 'skills_dim.skills', COUNT(*)
FROM data_jobs.skills_dim WHERE skills IS NULL
UNION ALL
SELECT 'skills_job_dim.job_id', COUNT(*)
FROM data_jobs.skills_job_dim WHERE job_id IS NULL
UNION ALL
SELECT 'skills_job_dim.skill_id', COUNT(*)
FROM data_jobs.skills_job_dim WHERE skill_id IS NULL;

-- 3. Duplicate-key checks: each result must return no rows.
SELECT company_id, COUNT(*) AS duplicate_count
FROM data_jobs.company_dim
GROUP BY company_id
HAVING COUNT(*) > 1;

SELECT job_id, COUNT(*) AS duplicate_count
FROM data_jobs.job_postings_fact
GROUP BY job_id
HAVING COUNT(*) > 1;

SELECT skill_id, COUNT(*) AS duplicate_count
FROM data_jobs.skills_dim
GROUP BY skill_id
HAVING COUNT(*) > 1;

SELECT job_id, skill_id, COUNT(*) AS duplicate_count
FROM data_jobs.skills_job_dim
GROUP BY job_id, skill_id
HAVING COUNT(*) > 1;

-- 4. Referential-integrity checks: each result must equal zero.
SELECT 'job_postings_fact -> company_dim' AS relationship, COUNT(*) AS orphan_count
FROM data_jobs.job_postings_fact j
LEFT JOIN data_jobs.company_dim c ON c.company_id = j.company_id
WHERE j.company_id IS NOT NULL AND c.company_id IS NULL
UNION ALL
SELECT 'skills_job_dim -> job_postings_fact', COUNT(*)
FROM data_jobs.skills_job_dim sj
LEFT JOIN data_jobs.job_postings_fact j ON j.job_id = sj.job_id
WHERE j.job_id IS NULL
UNION ALL
SELECT 'skills_job_dim -> skills_dim', COUNT(*)
FROM data_jobs.skills_job_dim sj
LEFT JOIN data_jobs.skills_dim s ON s.skill_id = sj.skill_id
WHERE s.skill_id IS NULL;

-- 5. Salary plausibility: inspect any returned rows before analysis.
SELECT job_id, salary_rate, salary_year_avg, salary_hour_avg
FROM data_jobs.job_postings_fact
WHERE salary_year_avg < 0
   OR salary_hour_avg < 0
   OR (salary_year_avg IS NOT NULL AND salary_hour_avg IS NOT NULL);

-- 6. Date-scope profile: confirms the actual timestamp range in the imported data.
SELECT
    MIN(job_posted_date) AS min_job_posted_date,
    MAX(job_posted_date) AS max_job_posted_date,
    COUNT(*) FILTER (WHERE job_posted_date IS NULL) AS null_job_posted_date_count
FROM data_jobs.job_postings_fact;
