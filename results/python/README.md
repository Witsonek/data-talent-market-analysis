# Python Analysis Results

This folder contains the output artefacts produced by the Python analysis stage of the **Data Talent Market Analysis** project.

All findings described below are derived from the validated PostgreSQL source database (`portfolio_data_jobs`, schema `data_jobs`). The dataset covers global data-job postings labelled as 2024 data (478 895 source postings).

---

## Dataset overview

| Attribute | Value |
|---|---|
| Total source postings | 478 895 |
| Date range (UTC) | 2024-01-01 – 2024-12-31 |
| Postings before 2024 | 90 (< 0.02 %) |
| Postings from 2025 | 0 |
| Scope | Global |

---

## Data quality summary

No fully-duplicated rows were found in any table.

| Table | Total rows | Full duplicates |
|---|---|---|
| `company_dim` | 98 372 | 0 |
| `job_postings_fact` | 478 895 | 0 |
| `skills_dim` | 254 | 0 |
| `skills_job_dim` | 2 274 756 | 0 |

### Salary missingness

Salary information is sparse. Analysis is restricted to postings that carry a value.

| Column | Non-missing rows | Missing % |
|---|---|---|
| `salary_year_avg` | 20 335 | 95.75 % |
| `salary_hour_avg` | 10 076 | 97.90 % |
| `salary_rate` | 30 411 | 93.65 % |

### Salary methodology

- Annual and hourly salaries are analysed separately because they represent different units with no reliable universal conversion.
- Outliers are retained in the dataset; statistical distance alone does not prove a data error.
- Medians and percentiles are preferred over means for describing right-skewed salary distributions.

---

## Skill demand

85.62 % of all postings (410 025 out of 478 895) carry at least one mapped skill. The median number of skills per mapped posting is **5**, with a mean of **5.55**.

### Top 10 skills by posting count

| Rank | Skill | Type | Postings | Share of skill-mapped postings |
|---|---|---|---|---|
| 1 | python | programming | 244 416 | 59.61 % |
| 2 | sql | programming | 240 179 | 58.58 % |
| 3 | aws | cloud | 100 386 | 24.48 % |
| 4 | azure | cloud | 93 849 | 22.89 % |
| 5 | r | programming | 71 823 | 17.52 % |
| 6 | spark | libraries | 71 962 | 17.55 % |
| 7 | tableau | analyst_tools | 73 513 | 17.93 % |
| 8 | excel | analyst_tools | 71 807 | 17.51 % |
| 9 | power bi | analyst_tools | 66 183 | 16.14 % |
| 10 | java | programming | 51 294 | 12.51 % |

---

## Skill co-occurrence

Co-occurrence analysis was run on skills appearing in at least 5 000 postings, covering 74 skills and 405 631 postings.

### Top skill pairs by posting count

| Skill 1 | Skill 2 | Co-occurrence count | Share of selected jobs | Lift |
|---|---|---|---|---|
| python | sql | 166 315 | 41.00 % | 1.149 |
| aws | python | 77 557 | 19.12 % | 1.282 |
| python | r | 66 585 | 16.42 % | 1.538 |
| azure | python | 65 869 | 16.24 % | 1.165 |
| aws | sql | 64 331 | 15.86 % | 1.082 |
| azure | sql | 63 776 | 15.72 % | 1.148 |
| python | spark | 59 322 | 14.62 % | 1.368 |
| sql | tableau | 57 407 | 14.15 % | 1.318 |

> **Lift > 1** indicates that the two skills appear together more often than random chance would predict. A lift of 1.538 for the python–r pair means these skills co-occur 53.8 % more often than expected.

---

## Artefacts in this folder

| File | Description |
|---|---|
| `project_summary.json` | Machine-readable summary of all metrics above (source of this README). |
| *(figures to be added)* | Visualisations produced by the Python notebooks will be stored here. |

---

## Reproducibility

All numbers in this document can be reproduced by:

1. Importing the source CSV files into `portfolio_data_jobs` using the schema in `sql/00_schema.sql`.
2. Running the data-quality checks in `sql/01_data_quality_checks.sql`.
3. Executing the Python notebooks in `python/` in the order documented in `python/README.md`.

Raw source files are not committed to Git. They are available in the [project Google Drive folder](https://drive.google.com) linked from the root README.
