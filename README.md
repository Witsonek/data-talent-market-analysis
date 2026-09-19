# Data Talent Market Analysis

Portfolio project for analysing demand, skills, remote-work opportunities and salary transparency in the global data-job market.

## Project status

This repository currently documents the data-import and PostgreSQL preparation phase. The database uses a relational star-like model and is intended to become the validated source for later SQL, Python and Power BI work.

## Objectives

- Build a reproducible PostgreSQL data source.
- Validate row-level and relational data quality before analysis.
- Analyse demand by data role, skill requirements, location, remote work and salary information in later project stages.

## Technology

- PostgreSQL 18
- SQL
- Python (planned)
- Power BI (planned)

## Data model

- `company_dim`: one row per company.
- `job_postings_fact`: one row per job posting.
- `skills_dim`: one row per unique skill.
- `skills_job_dim`: one row per job-posting-to-skill assignment.

`skills_job_dim` resolves the many-to-many relationship between job postings and skills through the composite primary key `(job_id, skill_id)`.

## Repository layout

```text
data/       Data documentation; source CSV files are intentionally excluded from Git.
sql/        PostgreSQL schema and validation scripts.
python/     Reserved for the separate Python analysis stage.
power-bi/   Reserved for the separate Power BI dashboard stage.
results/    Reserved for final, reproducible exports.
```

## Scope

The imported dataset contains global data-job postings from 2024. The project does not reuse numerical findings from the course materials that inspired the dataset; all future results must be generated from this database and documented in `results/`.

## Reproducibility

1. Create the `portfolio_data_jobs` database locally.
2. Run `sql/00_schema.sql`.
3. Import source CSV files into the tables in the dependency order described in `data/README.md`.
4. Run `sql/01_data_quality_checks.sql` and retain the outputs.
5. Only then use the validated tables in the dedicated SQL, Python and Power BI project stages.

## Data access

Raw source CSV files are not committed because of their size. Their local structure, expected schema and import order are documented in `data/`. A shareable data-access link may be added here later if appropriate.
