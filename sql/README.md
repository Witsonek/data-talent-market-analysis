# SQL workflow

This directory contains the complete PostgreSQL workflow used to build, validate, and analyze the relational data model. The scripts are ordered by execution stage so that the path from raw source files to final result exports is reproducible.

## Execution order

| Script | Purpose | Main SQL techniques | Related output |
|---|---|---|---|
| `00_schema.sql` | Creates the `data_jobs` schema, four relational tables, primary keys, composite key, and foreign keys | DDL, constraints, relational modeling | PostgreSQL source model |
| `01_data_quality_checks.sql` | Validates table volumes, mandatory keys, duplicate keys, referential integrity, salary plausibility, and date scope | `UNION ALL`, anti-joins, `HAVING`, filtered checks | Validation result sets |
| `02_market_demand_by_role.sql` | Measures role volume, market share, high-volume roles, top roles, and monthly trends | `GROUP BY`, `HAVING`, window aggregate, `DATE_TRUNC`, `LIMIT` | `monthly_posting_trends_by_role.csv`; demand fields in `role_profiles.csv` |
| `03_skill_coverage_and_breadth.sql` | Measures skill-tag coverage and the average number of visible skills per tagged posting | CTE, `LEFT JOIN`, filtered aggregates, `NULLIF` | Skill coverage fields in `role_profiles.csv` |
| `04_role_specific_skill_requirements.sql` | Ranks the top five skills within each role | Multi-table joins, `COUNT(DISTINCT)`, CTEs, `DENSE_RANK` | `role_specific_top_skills.csv` |
| `05_remote_work_opportunities.sql` | Compares the count and share of postings explicitly marked as remote | `FILTER`, conditional aggregation | Remote-work fields in `role_profiles.csv` |
| `06_salary_transparency_and_pay.sql` | Measures salary disclosure and median reported annual and hourly values | `FILTER`, `PERCENTILE_CONT`, `NULLIF` | Salary fields in `role_profiles.csv` |
| `07_career_guidance_role_profiles.sql` | Combines demand, skills, remote work, and salary metrics into one role-level profile | Layered CTEs, posting-level pre-aggregation, window aggregate, continuous median | `role_profiles.csv` |

## Data model

The analysis uses four tables in the `data_jobs` schema:

```text
company_dim
    company_id
        │
        │ 1 : N
        ▼
job_postings_fact
    job_id
    company_id
        │
        │ 1 : N
        ▼
skills_job_dim
    job_id
    skill_id
        ▲
        │ N : 1
        │
skills_dim
    skill_id
```

The relationship between postings and skills is many-to-many. `skills_job_dim` resolves it with the composite primary key `(job_id, skill_id)`. A posting can therefore appear several times after a skill join, once for each listed skill.

## Grain protection

Correct grain is the central methodological requirement of this workflow. Demand, remote-work, and salary metrics use one row per job posting. Skill rankings use `COUNT(DISTINCT job_id)` so that a posting is not counted more than once for the same skill. Consolidated role profiles first aggregate the bridge table to one row per posting and only then aggregate to role level.

Without these safeguards, a direct join from `job_postings_fact` to `skills_job_dim` would inflate posting counts, remote counts, and salary observations.

## Metric definitions

### Market share

`job_posting_share_pct` is the number of postings for a role divided by the full number of imported postings. The project intentionally uses the full imported scope.

### Skill coverage

`skill_coverage_pct` is the share of a role's postings with at least one record in `skills_job_dim`. It shows how much of the role can support skill analysis.

### Skill demand

`skill_demand_pct` is the share of skill-tagged postings for a role that mention a specific skill. Its denominator excludes postings with no tagged skills.

### Skill breadth

`avg_listed_skills_per_skill_tagged_job` is the average number of skill records among postings that contain at least one listed skill. It measures visible breadth in job descriptions, not candidate proficiency.

### Remote-work opportunity rate

`remote_work_opportunity_rate` is the share of a role's postings where `job_work_from_home IS TRUE`. It does not imply that a role is available from every country.

### Salary disclosure

Annual and hourly disclosure rates are calculated independently. Medians include only non-null values and use PostgreSQL's continuous percentile function. The project model has no separate currency field, so documentation does not assign a currency to the reported values.

## Running the workflow

1. Create the database `portfolio_data_jobs`.
2. Run `00_schema.sql`.
3. Import source files in the order documented in [`../data/README.md`](../data/README.md).
4. Run `01_data_quality_checks.sql` and inspect all returned result sets.
5. Run scripts `02` through `07` in numerical order.
6. Export the approved final result sets to [`../results/sql/`](../results/sql/).

The final CSV outputs and their interpretation are documented in [`../results/sql/README.md`](../results/sql/README.md).
