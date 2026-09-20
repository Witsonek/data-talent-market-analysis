-- Purpose: Rank the most frequently requested skills within each major data job role.
-- This query identifies the top five skill requirements based on skill demand rates.

WITH role_skill_counts AS (
    SELECT
        jpf.job_title_short,
        sd.skills AS skill_name,
        sd.type AS skill_type,
        COUNT(DISTINCT jpf.job_id) AS skill_job_posting_count
    FROM data_jobs.job_postings_fact AS jpf
    INNER JOIN data_jobs.skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN data_jobs.skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    GROUP BY
        jpf.job_title_short,
        skill_name,
        skill_type
),
role_totals AS (
    SELECT
        jpf.job_title_short,
        COUNT(DISTINCT sjd.job_id) AS skill_tagged_job_posting_count
    FROM data_jobs.job_postings_fact AS jpf
    INNER JOIN data_jobs.skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    GROUP BY
        jpf.job_title_short
),
role_skill_demand AS (
    SELECT
        rsc.job_title_short,
        rsc.skill_name,
        rsc.skill_type,
        rsc.skill_job_posting_count,
        rt.skill_tagged_job_posting_count,
        ROUND(
            100.0
                * rsc.skill_job_posting_count
                / rt.skill_tagged_job_posting_count,
            2
        ) AS skill_demand_pct
    FROM role_skill_counts AS rsc
    INNER JOIN role_totals AS rt
        ON rsc.job_title_short = rt.job_title_short
),
ranked_role_skills AS (
    SELECT
        rsd.*,
        DENSE_RANK() OVER (
            PARTITION BY rsd.job_title_short
            ORDER BY rsd.skill_demand_pct DESC
        ) AS skill_rank
    FROM role_skill_demand AS rsd
)
SELECT
    job_title_short,
    skill_name,
    skill_type,
    skill_job_posting_count,
    skill_tagged_job_posting_count,
    skill_demand_pct,
    skill_rank
FROM ranked_role_skills
WHERE skill_rank <= 5
ORDER BY
    job_title_short ASC,
    skill_rank ASC,
    skill_name ASC;