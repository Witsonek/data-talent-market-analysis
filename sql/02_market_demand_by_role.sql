-- Purpose: Measure job posting demand across major data job roles.
-- This query identifies the role categories with the highest representation in the 2024 dataset.

SELECT 
    job_title_short,
    COUNT(*) AS job_posting_count
FROM data_jobs.job_postings_fact
GROUP BY job_title_short
ORDER BY job_posting_count DESC, job_title_short ASC;

-- Purpose: Identify high-volume data job roles in the project dataset.
-- This query filters role categories with at least 20,000 job postings to support focused career guidance.
SELECT 
    job_title_short,
    COUNT(*) AS job_posting_count
FROM data_jobs.job_postings_fact
GROUP BY job_title_short
HAVING COUNT(*) >= 20000
ORDER BY job_posting_count DESC, job_title_short ASC;

SELECT 
    job_title_short,
    DATE_TRUNC('month', job_posted_date) AS posting_month,
    COUNT(*) AS job_posting_count
FROM 
data_jobs.job_postings_fact
GROUP BY 
    job_title_short, posting_month
ORDER BY
    job_title_short ASC,
    posting_month ASC;


SELECT 
    job_title_short,
    COUNT(*) AS job_posting_count
FROM 
    data_jobs.job_postings_fact
GROUP BY 
    job_title_short
ORDER BY
    job_posting_count DESC,
    job_title_short ASC
LIMIT 3;

SELECT 
    job_title_short,
    COUNT(job_title_short) AS job_posting_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS job_posting_share_pct
FROM 
    data_jobs.job_postings_fact
GROUP BY 
    job_title_short
ORDER BY
    job_posting_count DESC,
    job_title_short ASC;


