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

Raw source files are not committed to Git because of their size.

The raw dataset, including the files used to build the PostgreSQL source model, is available in the project Google Drive folder:

[Open the project data folder in Google Drive](https://drive.google.com/drive/folders/1PGuJpvtqyNe0TaHW8Y_T1KZW5nG82nN5?usp=drive_link)

The shared folder contains only materials for this project. Access is provided for viewing and downloading the project files.

## Acknowledgements

This project was inspired by Luke Barousse's Data Analyst learning materials and the [How I Would Learn to be a Data Analyst](https://www.youtube.com/watch?v=TFFzNjWkhDk&list=PL_CkpxkuPiT-RJ7zBfHVWwgltEWIVwrwb) course series.

The portfolio implementation is an independent project. It uses a documented PostgreSQL data model, its own data-quality validation process, and independently produced analysis outputs. Course materials are acknowledged as educational inspiration and are not presented as original work.
