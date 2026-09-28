# Python Analysis Results

This folder stores the output artefacts produced by the Python analysis stage of the **Data Talent Market Analysis** project.

All numbers and findings presented here come from the validated PostgreSQL source database (`portfolio_data_jobs`, schema `data_jobs`). The dataset covers global data-job postings labelled as 2024 data. Results from course materials or external benchmarks are not reproduced here.

Source CSV files and the Power BI dashboard file are not stored in this repository. They are available in the [project Google Drive folder](https://drive.google.com/drive/folders/1NIMxwh9M63p4NvJNOmcM3NqkFhnhacTO?usp=sharing).

---

## Dataset scope

The source dataset contains **478 895 job postings**. The vast majority fall within the calendar year 2024: 478 805 postings (99.98 %) have a UTC posting date between 2024-01-01 and 2024-12-31. Ninety postings carry a date of 2023-12-31 in UTC; these were retained in full because they fall within the source extract and removing them would not change any analytical conclusion.

| Attribute | Value |
|---|---|
| Total source postings | 478 895 |
| Postings in 2024 (UTC) | 478 805 |
| Postings before 2024 | 90 |
| Postings from 2025 | 0 |
| Scope | Global |

The global scope is an important distinction from course materials that focused on the United States market in 2023. All results in this document reflect the full observed global market from the 2024 extract.

---

## Data quality

### Duplicates

Full-row duplicate checking was performed on all four tables. No duplicates were found in any of them.

| Table | Total rows | Full duplicates |
|---|---|---|
| `company_dim` | 98 372 | 0 |
| `job_postings_fact` | 478 895 | 0 |
| `skills_dim` | 254 | 0 |
| `skills_job_dim` | 2 274 756 | 0 |

The absence of duplicates in `skills_job_dim` confirms that the composite primary key `(job_id, skill_id)` holds without violation across all 2.27 million bridge-table rows. This matters because any duplicate job-skill pair would inflate skill demand counts silently.

### Missing values

The three salary columns have high missing rates. This is not a data-import error; it reflects genuine non-disclosure in the source postings. The table below shows only the columns with meaningful missingness.

| Column | Non-missing rows | Missing % |
|---|---|---|
| `salary_year_avg` | 20 335 | 95.75 % |
| `salary_hour_avg` | 10 076 | 97.90 % |
| `salary_rate` | 30 411 | 93.65 % |

Salary analysis throughout this project is therefore restricted to postings that carry a value. Findings about salary do not describe the full observed market; they describe the subset of postings where salary was disclosed.

### Salary methodology

Three methodological decisions were made before any salary analysis was run.

First, annual and hourly salaries are analysed separately. They are different units and converting between them requires assumptions about working hours, contract type and country-level norms. No universal conversion is applied.

Second, outliers are retained. Removing a high-value observation because it looks large would require evidence that it is a genuine data error, not just an unusual salary. In the absence of that evidence, outliers stay in the dataset and the choice of summary statistics (medians and percentiles over means) is the defensive response to their presence.

Third, medians and percentiles are the primary descriptive statistics for salary. Salary distributions in this dataset are right-skewed and contain high-value outliers, which means the arithmetic mean is a poor representative of a typical value.

---

## Skill demand

### Coverage

410 025 out of 478 895 postings (85.62 %) carry at least one mapped skill. The remaining 68 870 postings (14.38 %) have no mapped skill and are excluded from all skill-specific analysis. These postings still exist in the database and they still count towards job-volume metrics, but they cannot contribute to skill demand or co-occurrence results.

Among postings with at least one skill, the median number of skills per posting is **5** and the mean is **5.55**. This shows that the typical posting asks for a bundle of tools rather than a single technology. It also means that skill demand percentages add up to well above 100 % because multiple skills can be counted from a single posting.

### Top 10 skills by posting count

| Rank | Skill | Type | Postings | Share of skill-mapped postings |
|---|---|---|---|---|
| 1 | python | programming | 244 416 | 59.61 % |
| 2 | sql | programming | 240 179 | 58.58 % |
| 3 | aws | cloud | 100 386 | 24.48 % |
| 4 | azure | cloud | 93 849 | 22.89 % |
| 5 | tableau | analyst_tools | 73 513 | 17.93 % |
| 6 | spark | libraries | 71 962 | 17.55 % |
| 7 | r | programming | 71 823 | 17.52 % |
| 8 | excel | analyst_tools | 71 807 | 17.51 % |
| 9 | power bi | analyst_tools | 66 183 | 16.14 % |
| 10 | java | programming | 51 294 | 12.51 % |

Python and SQL together form the dominant skill pair in the observed market, each appearing in roughly 59 % and 58 % of skill-mapped postings respectively. The gap between them and the third-ranked skill (aws at 24.48 %) is substantial, which suggests that Python and SQL have broad baseline demand across multiple role types while cloud and visualisation tools are more specialised.

The presence of both cloud platforms (aws, azure) and analyst tools (tableau, excel, power bi) in the top 10 reflects the mixed nature of the dataset, which covers data engineer, data scientist and data analyst roles simultaneously. A role-level breakdown would likely show a different ranking within each title.

### Skill type distribution in top 10

| Type | Count in top 10 |
|---|---|
| programming | 4 |
| analyst_tools | 3 |
| cloud | 2 |
| libraries | 1 |

---

## Skill co-occurrence

### Setup

The co-occurrence analysis was restricted to skills that appeared in at least 5 000 postings. This threshold kept 74 skills and 405 631 postings in scope. Skills below the threshold were excluded to prevent rare combinations from producing unstable or misleading association metrics.

For each pair of skills the analysis records three values: the raw co-occurrence count (how many postings contain both skills), the confidence from skill A to skill B (given a posting requires skill A, how often does it also require skill B), and the lift (how much more often the pair appears together compared to what pure chance would predict given their individual frequencies).

### Top skill pairs by posting count

| Skill 1 | Skill 2 | Co-occurrence | Share of in-scope jobs | Lift |
|---|---|---|---|---|
| python | sql | 166 315 | 41.00 % | 1.149 |
| aws | python | 77 557 | 19.12 % | 1.282 |
| python | r | 66 585 | 16.42 % | 1.538 |
| azure | python | 65 869 | 16.24 % | 1.165 |
| aws | sql | 64 331 | 15.86 % | 1.082 |
| azure | sql | 63 776 | 15.72 % | 1.148 |
| python | spark | 59 322 | 14.62 % | 1.368 |
| sql | tableau | 57 407 | 14.15 % | 1.318 |

### Reading the lift metric

A lift value above 1.0 means the two skills appear together more often than their individual frequencies would predict by chance. A lift of 1.538 for the python and r pair means those skills co-occur 53.8 % more often than a random pairing of postings would produce. A lift close to 1.0 means the co-occurrence is roughly what chance alone would predict.

The python-r pair has the highest lift in the top 8, which makes sense: r is a programming language used primarily in statistical and academic data contexts, and postings that require it tend to also require python. The raw count for python-r (66 585) is smaller than for python-sql (166 315), but the association is proportionally stronger.

The python-sql pair has the highest raw count by a wide margin (166 315 postings, 41 % of in-scope jobs) but a relatively modest lift of 1.149. This tells a specific story: python and sql are so individually common that their co-occurrence is nearly expected. The pair is large in absolute terms, but not especially surprising given how often each skill appears on its own.

### Interpretation caution

Co-occurrence describes what appears together in job postings. It does not define a required learning path, does not prove that employers treat the two skills as substitutes or complements, and does not control for confounding variables like role type or seniority. A high lift between two skills means they cluster in the same postings, not that learning one causes demand for the other.

---

## Artefacts in this folder

| File | Description |
|---|---|
| `project_summary.json` | Machine-readable summary of all metrics above. This file is the primary source for the numbers in this README. |
| *(figures to be added)* | Charts and tables produced by the Python notebooks will be stored here after the notebooks are finalised. |

---

## Reproducibility

Every number in this document can be reproduced from the validated PostgreSQL source:

1. Import source CSV files into `portfolio_data_jobs` using `sql/00_schema.sql`.
2. Run `sql/01_data_quality_checks.sql` and confirm the outputs match the quality summary above.
3. Run the Python notebooks in `python/` in numerical order as documented in `python/README.md`.

Source CSV files are not committed to Git due to their size. They are available in the [project Google Drive folder](https://drive.google.com/drive/folders/1NIMxwh9M63p4NvJNOmcM3NqkFhnhacTO?usp=sharing).
