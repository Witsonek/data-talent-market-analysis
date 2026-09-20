-- Purpose: Measure salary disclosure and reported pay levels across major data job roles.
-- This query compares salary disclosure rates and median disclosed annual and hourly salaries by role.

SELECT
    job_title_short,
    COUNT(*) AS total_job_posting_count,
    
    COUNT(*) FILTER (
        WHERE salary_year_avg IS NOT NULL
    ) AS annual_salary_posting_count,
    
    ROUND(
        100.0
            * COUNT(*) FILTER (
                WHERE salary_year_avg IS NOT NULL
            )
            / NULLIF(COUNT(*), 0),
        2
    ) AS annual_salary_disclosure_pct,
    
    ROUND(
        (
            PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY salary_year_avg
            ) FILTER (
                WHERE salary_year_avg IS NOT NULL
            )
        )::NUMERIC,
        2
    ) AS median_annual_salary,
    
    COUNT(*) FILTER (
        WHERE salary_hour_avg IS NOT NULL
    ) AS hourly_salary_posting_count,
    
    ROUND(
        100.0
            * COUNT(*) FILTER (
                WHERE salary_hour_avg IS NOT NULL
            )
            / NULLIF(COUNT(*), 0),
        2
    ) AS hourly_salary_disclosure_pct,
    
    ROUND(
        (
            PERCENTILE_CONT(0.5) WITHIN GROUP (
                ORDER BY salary_hour_avg
            ) FILTER (
                WHERE salary_hour_avg IS NOT NULL
            )
        )::NUMERIC,
        2
    ) AS median_hourly_salary
FROM data_jobs.job_postings_fact
GROUP BY
    job_title_short
ORDER BY
    job_title_short ASC;