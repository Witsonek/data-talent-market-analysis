-- Purpose: Compare remote-work opportunities across major data job roles.
-- This query calculates the share of job postings explicitly marked as remote for each major data job role.

SELECT
    job_title_short,
    COUNT(*) FILTER (WHERE job_work_from_home IS TRUE) AS remote_job_posting_count,
    COUNT(*) AS total_job_posting_count,
    ROUND(
        COUNT(*) FILTER (WHERE job_work_from_home IS TRUE) * 100.0 / COUNT(*),
        2
    ) AS remote_work_opportunity_rate
FROM
    data_jobs.job_postings_fact
GROUP BY
    job_title_short
ORDER BY
    remote_work_opportunity_rate DESC,
    total_job_posting_count DESC,
    job_title_short ASC;
    