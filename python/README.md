# Python Analysis Stage

This directory contains the Python analysis stage of the **Data Talent Market Analysis** portfolio project.

The Python workflow connects to the validated PostgreSQL database prepared in the earlier project stage and performs reproducible exploratory analysis on top of a documented relational model.

Findings, visualisations and output artefacts produced by this stage are stored in [`results/python/`](../results/python/README.md).

---

## Objectives

The Python stage answers the following analytical questions:

- How complete and usable is the dataset after import and validation?
- How transparent is salary information across the observed postings?
- Which data roles and skills appear most often in the market?
- Which skills frequently occur together in the same posting?
- Which skills are associated with higher disclosed annual salaries?
- Which posting sources and companies dominate the observed dataset?
- How should remote-work and location signals be interpreted in a global dataset?

---

## Data source

The notebooks query the `portfolio_data_jobs` database, schema `data_jobs`, tables:

- `company_dim`
- `job_postings_fact`
- `skills_dim`
- `skills_job_dim`

The relational grain is preserved throughout the workflow. Metrics are always calculated at the correct level of detail — in particular, the bridge table `skills_job_dim` is never used as a direct substitute for job-posting counts.

---

## Notebook structure

| Notebook | Purpose |
|---|---|
| `01_database_connection_and_loading.ipynb` | Connects to PostgreSQL, loads tables, confirms structure. |
| `02_data_quality_and_scope.ipynb` | Profiles date coverage, missing values, duplicates and limitations. |
| `03_salary_distribution_and_transparency.ipynb` | Examines salary disclosure rates, distributions and outliers. |
| `04_skill_demand_and_cooccurrence.ipynb` | Measures skill demand and identifies common skill combinations. |
| `05_skill_salary_premium.ipynb` | Compares skill-level median annual salary against the reference median. |
| `06_market_sources_and_company_concentration.ipynb` | Profiles posting sources, companies and concentration patterns. |
| `07_geographic_accessibility_and_location_quality.ipynb` | Evaluates remote indicators and raw location data quality. |

Run notebooks in numerical order.

---

## Environment setup

The stage uses a local virtual environment. Required packages:

```text
pandas
numpy
matplotlib
seaborn
SQLAlchemy
psycopg
python-dotenv
jupyter
```

Database credentials are stored in a local `.env` file that must not be committed to Git:

```text
DB_HOST=localhost
DB_PORT=5432
DB_NAME=portfolio_data_jobs
DB_USER=postgres
DB_PASSWORD=your_local_password
```

---

## Reproducibility

1. Complete the SQL import and data-quality validation stage.
2. Create and activate a virtual environment.
3. Install required packages.
4. Create a local `.env` file with database credentials.
5. Run notebooks in numerical order.

---

## Key interpretation rules

- **Grain matters.** Metrics are always calculated at the correct analytical level.
- **Salary results require caution.** Findings apply only to postings with disclosed salary values.
- **Association is not causation.** Skill co-occurrence and salary-premium results describe patterns, not causal mechanisms.
- **Geographic signals are approximate.** Remote flags and parsed locations are not a substitute for validated geographic data.
