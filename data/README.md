# Data documentation

## Source files

The local source directory contains the following CSV files:

- `company_dim.csv`
- `job_postings_fact.csv`
- `skills_dim.csv`
- `skills_job_dim.csv`

Raw CSV files are excluded from Git because of their size.

## Import order

Import tables in this order so that foreign-key relationships can be enforced:

1. `company_dim`
2. `skills_dim`
3. `job_postings_fact`
4. `skills_job_dim`

## Target database

- Database: `portfolio_data_jobs`
- Schema: `data_jobs`
- PostgreSQL host: `localhost`
- Port: `5432`

## Data grain

| Table | Grain | Primary key |
|---|---|---|
| `company_dim` | One row per company | `company_id` |
| `job_postings_fact` | One row per job posting | `job_id` |
| `skills_dim` | One row per unique skill | `skill_id` |
| `skills_job_dim` | One skill assigned to one job posting | `(job_id, skill_id)` |

## Relationship notes

A job posting may contain multiple skills and one skill may appear in multiple job postings. `skills_job_dim` therefore uses the composite key `(job_id, skill_id)`; neither column can be a standalone primary key.
