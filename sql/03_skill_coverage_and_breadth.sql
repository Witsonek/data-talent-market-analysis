-- Purpose: Assess skill data coverage and visible skill requirement breadth across major data job roles.
-- This query calculates total postings, skill-tagged postings, skill coverage rates,
-- and the average number of listed skills per skill-tagged posting.

WITH job_skill_counts AS (
    SELECT
        jpf.job_id,
        jpf.job_title_short,
        COUNT(sjd.skill_id) AS listed_skill_count
    FROM data_jobs.job_postings_fact AS jpf
    LEFT JOIN data_jobs.skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    GROUP BY
        jpf.job_id,
        jpf.job_title_short
)
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
    ) AS skill_coverage_rate,
    ROUND(
        AVG(listed_skill_count) FILTER (
            WHERE listed_skill_count > 0
        ),
        2
    ) AS avg_listed_skills_per_skill_tagged_job
FROM job_skill_counts
GROUP BY
    job_title_short
ORDER BY
    skill_coverage_rate ASC,
    total_job_posting_count DESC,
    job_title_short ASC;