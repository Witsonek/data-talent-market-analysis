-- Purpose: Create descriptive career-guidance profiles for major data job roles.
-- This query combines market demand, visible skill requirements, remote-work availability,
-- and salary disclosure metrics without creating an overall role ranking.

WITH job_level_profile AS (
    SELECT
        jpf.job_id,
        jpf.job_title_short,
        jpf.job_work_from_home,
        jpf.salary_year_avg,
        jpf.salary_hour_avg,
        COUNT(sjd.skill_id) AS listed_skill_count
    FROM data_jobs.job_postings_fact AS jpf
    LEFT JOIN data_jobs.skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    GROUP BY
        jpf.job_id,
        jpf.job_title_short,
        jpf.job_work_from_home,
        jpf.salary_year_avg,
        jpf.salary_hour_avg
),
role_profile_metrics AS (
    SELECT
        job_title_short,
        COUNT(*) AS total_job_posting_count,

        COUNT(*) FILTER (
            WHERE listed_skill_count > 0
        ) AS skill_tagged_job_posting_count,

        ROUND(
            100.0
                * COUNT(*) FILTER (
                    WHERE listed_skill_count > 0
                )
                / NULLIF(COUNT(*), 0),
            2
        ) AS skill_coverage_pct,

        ROUND(
            AVG(listed_skill_count) FILTER (
                WHERE listed_skill_count > 0
            ),
            2
        ) AS avg_listed_skills_per_skill_tagged_job,

        COUNT(*) FILTER (
            WHERE job_work_from_home IS TRUE
        ) AS remote_job_posting_count,

        ROUND(
            100.0
                * COUNT(*) FILTER (
                    WHERE job_work_from_home IS TRUE
                )
                / NULLIF(COUNT(*), 0),
            2
        ) AS remote_work_opportunity_rate,

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
    FROM job_level_profile
    GROUP BY
        job_title_short
)
SELECT
    job_title_short,
    total_job_posting_count,

    ROUND(
        100.0
            * total_job_posting_count
            / SUM(total_job_posting_count) OVER (),
        2
    ) AS job_posting_share_pct,

    skill_tagged_job_posting_count,
    skill_coverage_pct,
    avg_listed_skills_per_skill_tagged_job,

    remote_job_posting_count,
    remote_work_opportunity_rate,

    annual_salary_posting_count,
    annual_salary_disclosure_pct,
    median_annual_salary,

    hourly_salary_posting_count,
    hourly_salary_disclosure_pct,
    median_hourly_salary
FROM role_profile_metrics
ORDER BY
    total_job_posting_count DESC,
    job_title_short ASC;