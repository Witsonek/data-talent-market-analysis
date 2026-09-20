# SQL Analysis Results — Data Talent Market Analysis

## Executive summary

This report presents the final results of the PostgreSQL analysis of **478,895 job postings** classified into 10 standardized roles. The imported dataset is concentrated in 2024 and intentionally retains 90 records dated December 2023. These boundary records represent less than 0.02% of the import and remain visible in the monthly export so that the analytical scope is transparent.

Demand is strongly concentrated. **Data Engineer, Data Analyst, and Data Scientist account for 339,524 postings, or 70.90% of the full dataset.** Data Engineer is the largest category at 26.94%, followed by Data Analyst at 23.57% and Data Scientist at 20.39%. The dataset therefore emphasizes the core occupations that build, analyze, and model data rather than adjacent or highly specialized roles.

Skill requirements divide the market into distinct career tracks. Analyst roles combine **SQL, spreadsheets, and business intelligence tools**. Data science and machine learning roles are led by **Python**, supported by SQL, cloud platforms, and specialist libraries. Engineering roles require the broadest visible technology stacks and combine SQL and Python with cloud platforms and distributed-processing technologies.

The time series reaches its highest combined volume in February 2024 with 55,279 postings and its lowest in November with 13,691. Average monthly volume was 48,180 postings between January and August, compared with 20,855 between September and November, a decline of approximately 56.7%. December rebounds to 30,799 postings, but one year of data is insufficient to distinguish market seasonality from changes in source coverage or collection completeness.

Remote postings represent 62,995 records, approximately 13.15% of the full import. Salary transparency is much more limited: only 20,335 postings, approximately 4.25%, contain an annual salary value. Salary medians must therefore be interpreted as descriptions of the salary-reporting subset, not as representative estimates for the entire market.

## Report purpose

This document interprets four reproducible SQL exports:

- [`role_profiles.csv`](role_profiles.csv) — a consolidated profile of each role;
- [`role_specific_top_skills.csv`](role_specific_top_skills.csv) — the five most frequently requested skills within each role;
- [`monthly_posting_trends_by_role.csv`](monthly_posting_trends_by_role.csv) — monthly posting volume by role;
- [`geographic_coverage.csv`](geographic_coverage.csv) — the number of countries represented in the dataset.

The purpose is not to rank occupations from “best” to “worst.” Roles differ in responsibilities, specialization, and expected experience. The analysis compares observed demand, visible skill requirements, remote-work availability, and salary disclosure without reducing these dimensions to a single score.

## Methodology

The PostgreSQL source model contains a job-posting fact table, company and skill dimensions, and a bridge table connecting postings to skills. One row in `job_postings_fact` represents one posting. Skills form a many-to-many relationship: a posting can list multiple skills and a skill can occur in multiple postings.

Demand metrics are calculated from the fact table at posting grain. Monthly values are obtained by truncating `job_posted_date` to month and grouping by standardized role. The final monthly export uses the full imported scope and therefore includes the small December 2023 boundary group.

Skill metrics join postings through `skills_job_dim`. Because this join creates multiple rows for postings with multiple skills, the query uses `COUNT(DISTINCT job_id)` when counting postings associated with a skill. The denominator for `skill_demand_pct` is the number of postings in that role with at least one tagged skill, not all postings in the role.

Role-profile metrics are first calculated at individual-posting grain and only then aggregated to role level. This prevents skill counts, remote postings, and salary records from being inflated by the many-to-many join. Salary medians use `PERCENTILE_CONT(0.5)` and include only non-null salary observations.

Percentages are rounded to two decimal places. Derived figures in this report, such as combined market shares and month-to-month changes, are calculated from the committed CSV exports.

## Result files

| File | Source query | Grain | Main purpose |
|---|---|---|---|
| `role_profiles.csv` | `07_career_guidance_role_profiles.sql` | One row per role | Consolidates demand, skills coverage, remote work, and salary disclosure |
| `role_specific_top_skills.csv` | `04_role_specific_skill_requirements.sql` | One row per role and ranked skill | Identifies the top five visible skill requirements within each role |
| `monthly_posting_trends_by_role.csv` | `02_market_demand_by_role.sql` | One row per role and month | Describes monthly posting volume across roles |
| `geographic_coverage.csv` | Geographic scope query | One row | Confirms the number of distinct countries represented |

## Market demand

### Posting distribution

| Role | Postings | Market share |
|---|---:|---:|
| Data Engineer | 128,994 | 26.94% |
| Data Analyst | 112,866 | 23.57% |
| Data Scientist | 97,664 | 20.39% |
| Senior Data Engineer | 30,608 | 6.39% |
| Business Analyst | 28,584 | 5.97% |
| Software Engineer | 23,402 | 4.89% |
| Senior Data Scientist | 21,731 | 4.54% |
| Senior Data Analyst | 15,347 | 3.20% |
| Machine Learning Engineer | 12,860 | 2.69% |
| Cloud Engineer | 6,839 | 1.43% |

The three largest categories form a clear market core. Data Engineer, Data Analyst, and Data Scientist account for 70.90% of all postings, while the remaining seven roles account for 29.11%. This concentration shows where most observed recruitment activity sits, but it does not measure applicant competition, hiring success, or the difficulty of entering a role.

Data Engineer is the largest category, highlighting the importance of data infrastructure and pipeline development. Data Analyst is the second-largest category and the largest role directly centered on analysis, reporting, and decision support. Data Scientist is slightly smaller than Data Analyst but has a substantially different technical profile.

Senior categories are much smaller than their broader counterparts. Senior Data Engineer volume equals approximately 23.7% of Data Engineer volume, Senior Data Scientist approximately 22.3% of Data Scientist volume, and Senior Data Analyst approximately 13.6% of Data Analyst volume. The dataset does not consistently identify junior and mid-level roles, so these ratios should not be treated as a complete seniority structure.

## Monthly dynamics

### Combined monthly volume

| Month | Postings | Month-over-month change |
|---|---:|---:|
| January 2024 | 52,933 | — |
| February 2024 | 55,279 | +4.4% |
| March 2024 | 48,716 | -11.9% |
| April 2024 | 43,558 | -10.6% |
| May 2024 | 45,746 | +5.0% |
| June 2024 | 41,635 | -9.0% |
| July 2024 | 50,734 | +21.9% |
| August 2024 | 46,839 | -7.7% |
| September 2024 | 29,849 | -36.3% |
| October 2024 | 19,026 | -36.3% |
| November 2024 | 13,691 | -28.0% |
| December 2024 | 30,799 | +125.0% |

February has the highest combined volume and November the lowest. January through August remains comparatively active, although the period is not perfectly stable: March and April decline, May partially recovers, and July records a strong increase. The average across these eight months is 48,180 postings.

September through November shows three consecutive declines. Average monthly volume in that period is 20,855 postings, approximately 56.7% below the January–August average. This is the strongest sustained change in the time series and appears across every analyzed role.

December rises by approximately 125% from November but remains well below early-year levels. The pattern should not automatically be described as seasonality. Confirming seasonality would require several years of comparable data and validation that collection coverage was consistent across every month.

### Differences by role

Most roles reach their maximum in February: Business Analyst, Cloud Engineer, Data Analyst, Data Engineer, Data Scientist, Senior Data Scientist, and Software Engineer. Machine Learning Engineer and Senior Data Engineer peak in July, while Senior Data Analyst peaks in January. Every role reaches its minimum in November.

Between September and November, Data Analyst declines from 6,850 to 3,694 postings, or approximately 46.1%. Data Engineer declines from 8,468 to 3,805, or 55.1%, and Data Scientist from 5,636 to 2,054, or 63.6%. The largest percentage decline occurs for Senior Data Scientist at approximately 67.9%.

Because the decline affects all roles, it appears to be a dataset-wide pattern rather than a role-specific event. The analysis does not assign a cause. Without additional years and collection metadata, the change could reflect recruitment cycles, market conditions, source coverage, or data-collection completeness.

## Skill data coverage

A total of 410,025 postings contain at least one tagged skill, representing approximately 85.62% of the full dataset. Untagged postings cannot safely be interpreted as requiring no skills; the absence of a tag may reflect missing or unrecognized information.

| Role | Skill-tagged postings | Coverage | Average listed skills |
|---|---:|---:|---:|
| Data Engineer | 117,877 | 91.38% | 6.67 |
| Data Analyst | 90,964 | 80.59% | 3.95 |
| Data Scientist | 82,430 | 84.40% | 5.38 |
| Senior Data Engineer | 28,665 | 93.65% | 7.43 |
| Business Analyst | 21,830 | 76.37% | 3.80 |
| Software Engineer | 19,954 | 85.27% | 6.04 |
| Senior Data Scientist | 19,030 | 87.57% | 5.67 |
| Senior Data Analyst | 13,126 | 85.53% | 4.66 |
| Machine Learning Engineer | 11,301 | 87.88% | 6.55 |
| Cloud Engineer | 4,848 | 70.89% | 5.41 |

Senior Data Engineer has the highest skill coverage, while Cloud Engineer has the lowest. The difference exceeds 22 percentage points, so skill rankings have different levels of coverage across roles. Cloud Engineer findings are based on 4,848 tagged postings out of 6,839 total, whereas the Senior Data Engineer profile covers almost the entire segment.

Engineering roles display broader visible skill profiles. Senior Data Engineer postings list an average of 7.43 skills, Data Engineer 6.67, Machine Learning Engineer 6.55, and Software Engineer 6.04. Data Analyst averages 3.95, Business Analyst 3.80, and Senior Data Analyst 4.66. This does not prove that analyst roles are easier; it only shows that their postings name fewer distinct skills from the available taxonomy.

## Top skills by role

| Role | Rank 1 | Rank 2 | Rank 3 | Rank 4 | Rank 5 |
|---|---|---|---|---|---|
| Business Analyst | SQL 50.55% | Excel 46.23% | Tableau 28.56% | Power BI 27.86% | Python 26.07% |
| Cloud Engineer | Python 41.50% | Azure 36.18% | AWS 33.37% | SQL 27.39% | Kubernetes 19.00% |
| Data Analyst | SQL 57.72% | Excel 41.45% | Python 39.04% | Tableau 29.62% | Power BI 29.13% |
| Data Engineer | SQL 67.89% | Python 65.20% | AWS 39.13% | Azure 37.77% | Spark 30.50% |
| Data Scientist | Python 78.40% | SQL 53.69% | R 37.77% | AWS 20.29% | Tableau 18.44% |
| Machine Learning Engineer | Python 83.58% | PyTorch 42.68% | TensorFlow 40.34% | AWS 35.79% | Azure 29.61% |
| Senior Data Analyst | SQL 71.63% | Python 48.77% | Tableau 41.91% | Excel 32.69% | Power BI 28.11% |
| Senior Data Engineer | SQL 70.44% | Python 68.51% | AWS 44.96% | Azure 42.52% | Spark 37.03% |
| Senior Data Scientist | Python 81.42% | SQL 60.21% | R 35.98% | AWS 27.73% | Azure 21.56% |
| Software Engineer | Python 43.79% | SQL 34.27% | AWS 30.03% | Java 26.63% | Azure 21.68% |

Each percentage uses skill-tagged postings for that role as its denominator. For example, SQL appears in 57.72% of tagged Data Analyst postings, not 57.72% of all Data Analyst postings.

### Analyst track

Data Analyst and Business Analyst have the most similar visible profiles. SQL and Excel occupy the top two positions in both roles, followed by Tableau and Power BI. Python ranks third for Data Analyst but fifth for Business Analyst. This suggests that Data Analyst roles more often combine querying, programming, and reporting, while Business Analyst roles place relatively greater emphasis on spreadsheets and reporting tools.

For an entry-level Data Analyst portfolio, the most evidence-based foundation is SQL, Excel, Python, and one BI platform. The data does not require equal mastery of Tableau and Power BI: their demand shares are similar, so deeper competency in one can be more defensible than superficial exposure to both.

Senior Data Analyst postings show stronger demand for SQL, Python, and Tableau than the broader Data Analyst category. SQL rises by 13.91 percentage points, Python by 9.73, and Tableau by 12.29, while Excel falls by 8.76 points. This may indicate a shift from basic spreadsheet work toward more advanced processing and communication of analytical results, although the data does not measure required proficiency levels.

### Engineering track

Data Engineer requirements are built around SQL and Python, each appearing in roughly two-thirds of tagged postings. AWS, Azure, and Spark complete the top five, showing that employers seek database and programming skills together with cloud and distributed-data capabilities.

Senior Data Engineer extends rather than replaces this stack. Every top-five skill appears more frequently than in the broader Data Engineer category: SQL by 2.55 percentage points, Python by 3.31, AWS by 5.83, Azure by 4.75, and Spark by 6.53. Average listed skills also rise from 6.67 to 7.43, indicating a broader visible technical profile at senior level.

Cloud Engineer differs from Data Engineer. Python remains first, SQL is less prominent, and Azure, AWS, and Kubernetes form the infrastructure core. The profile is more focused on runtime environments and orchestration than on data pipelines alone.

### Data science and machine learning

Python is the dominant skill for Data Scientist, Senior Data Scientist, and Machine Learning Engineer. It appears in at least 78% of tagged postings for each of these roles and exceeds 83% for Machine Learning Engineer.

Data Scientist combines Python with SQL and R. Machine Learning Engineer is more specialized: PyTorch and TensorFlow occupy the second and third positions, followed by AWS and Azure. The difference separates a broad statistical and analytical profile from a profile centered on building, training, and deploying machine-learning systems.

Senior Data Scientist retains Python, SQL, and R as its three leading skills but shows stronger demand for SQL and cloud platforms than Data Scientist. SQL rises by 6.52 percentage points, AWS by 7.44, and Azure enters the top five. This may reflect greater responsibility for integrating models into broader data and production environments.

## Remote work

| Role | Remote postings | Remote share |
|---|---:|---:|
| Machine Learning Engineer | 2,283 | 17.75% |
| Senior Data Engineer | 5,242 | 17.13% |
| Data Engineer | 19,018 | 14.74% |
| Software Engineer | 3,339 | 14.27% |
| Senior Data Scientist | 3,030 | 13.94% |
| Data Scientist | 13,468 | 13.79% |
| Senior Data Analyst | 1,922 | 12.52% |
| Business Analyst | 2,914 | 10.19% |
| Data Analyst | 11,185 | 9.91% |
| Cloud Engineer | 594 | 8.69% |

Remote postings represent approximately 13.15% of the full import. No role exceeds an 18% remote share, so explicitly remote work remains a minority of observed postings. Machine Learning Engineer and Senior Data Engineer have the highest shares; Cloud Engineer and Data Analyst have the lowest.

Data Analyst has 11,185 remote postings, a substantial absolute count, but they represent only 9.91% of the role. This distinction matters: a large occupation may offer many remote vacancies while still having a low remote proportion. Candidates searching exclusively for remote work should consider the share as well as the count.

Senior variants show slightly higher remote shares than their broader counterparts. The difference is 2.61 percentage points for analysts, 2.39 for engineers, and only 0.15 for data scientists. The relationship is not equally strong across tracks and should not be presented as a universal seniority effect.

A posting marked `job_work_from_home = TRUE` is classified as remote in the source data. It does not guarantee work from any country or the absence of legal, tax, time-zone, or residency restrictions.

## Salary disclosure and reported pay

| Role | Annual records | Annual disclosure | Annual median | Hourly records | Hourly disclosure | Hourly median |
|---|---:|---:|---:|---:|---:|---:|
| Data Engineer | 3,643 | 2.82% | 126,268.00 | 2,609 | 2.02% | 59.16 |
| Data Analyst | 6,227 | 5.52% | 90,000.00 | 3,171 | 2.81% | 32.50 |
| Data Scientist | 5,065 | 5.19% | 125,000.00 | 2,392 | 2.45% | 43.04 |
| Senior Data Engineer | 1,128 | 3.69% | 146,500.00 | 491 | 1.60% | 58.68 |
| Business Analyst | 944 | 3.30% | 95,350.00 | 329 | 1.15% | 43.00 |
| Software Engineer | 643 | 2.75% | 145,000.00 | 135 | 0.58% | 60.00 |
| Senior Data Scientist | 1,259 | 5.79% | 155,500.00 | 498 | 2.29% | 49.90 |
| Senior Data Analyst | 936 | 6.10% | 107,310.00 | 369 | 2.40% | 39.45 |
| Machine Learning Engineer | 429 | 3.34% | 155,000.00 | 58 | 0.45% | 60.75 |
| Cloud Engineer | 61 | 0.89% | 113,837.50 | 24 | 0.35% | 50.00 |

Salary transparency is the weakest analytical dimension in the dataset. Annual salary values are available for approximately 4.25% of all postings, and no role exceeds a 6.10% disclosure rate. Cloud Engineer has only 61 annual observations and 24 hourly observations, making its medians particularly fragile. Ranking occupations solely by these values would be methodologically weak.

Senior-role medians exceed their broader counterparts. Senior Data Analyst is approximately 19.2% above Data Analyst, Senior Data Engineer 16.0% above Data Engineer, and Senior Data Scientist 24.4% above Data Scientist. These figures describe salary-reporting postings only and should not be interpreted as precise market premiums caused by promotion.

The source model stores standardized `salary_year_avg` and `salary_hour_avg` values but does not include a separate currency field. Because the dataset is global, this report deliberately does not label these values as USD or any other currency. Assigning a currency without verified source documentation would be unsupported.

Low salary disclosure is both a limitation and a result. It indicates that most postings in the dataset do not provide enough compensation information for candidates to compare opportunities before applying.

## Seniority patterns

Across three comparable role pairs, senior categories show both higher reported annual medians and broader visible skill profiles.

| Career track | Annual median difference | Skill-breadth difference | Remote-share difference |
|---|---:|---:|---:|
| Data Analyst → Senior Data Analyst | +19.2% | +18.0% | +2.61 pp |
| Data Engineer → Senior Data Engineer | +16.0% | +11.4% | +2.39 pp |
| Data Scientist → Senior Data Scientist | +24.4% | +5.4% | +0.15 pp |

The analyst track shows the largest relative increase in average listed skills. Data science shows the smallest increase in breadth, but senior postings more frequently request SQL and cloud technologies. Career progression may therefore involve greater integration and production responsibility, not only adding more tools.

These are comparisons between posting categories, not a longitudinal study of individual workers. They can inform skill planning but do not prove that acquiring the listed tools causes promotion or a specific salary increase.

## Geographic coverage

The dataset contains 160 distinct country values, confirming broad international coverage. This supports cross-market exploration but also makes salary and remote-work interpretation more difficult without local context.

Country count does not establish geographic balance. One country may account for a large share of postings while others may have very few records. `geographic_coverage.csv` confirms breadth, not distribution. Country-level concentration is an appropriate extension for the Python or Power BI stages.

## Practical implications

### Students and candidates

SQL is the most transferable foundation across the analyzed roles. An aspiring Data Analyst should prioritize SQL, Excel, Python, and one BI tool. A Data Engineer track should add cloud platforms, Spark, and pipeline-oriented projects. A Data Scientist track should emphasize Python, SQL, statistical work, and model development.

Tool rankings should guide learning priorities, not replace a complete development plan. The dataset does not measure business understanding, communication, portfolio quality, or practical experience.

### University career services

Career guidance should distinguish at least three paths: analytics and reporting, data engineering, and data science or machine learning. A single generic “data career” curriculum would conceal substantial differences in technology requirements.

Because fully remote postings are a minority, guidance should not assume that remote-only searches reflect the full entry-level market. Candidates may increase their available opportunities by considering local or hybrid work where feasible.

### Training providers

An analyst curriculum should combine SQL, spreadsheets, Python, and a BI platform. Engineering programs should add cloud platforms, distributed processing, and pipeline design. Advanced modules should extend a common foundation instead of presenting disconnected technology lists.

Training outcomes should not be marketed solely using posting counts or reported salary medians. The dataset does not include applicant competition, placement success, or complete compensation information.

### Talent acquisition teams

Differences in skill coverage and breadth suggest value in standardizing how requirements are described. Salary transparency is particularly limited and reduces candidates' ability to evaluate opportunities before applying.

Broad technology lists in engineering postings may also indicate overly expansive job profiles. The dataset does not distinguish mandatory from optional skills, so textual analysis of job descriptions would be a useful future extension.

## Limitations

1. **Postings are not hires.** Posting volume measures recruitment activity, not filled positions.
2. **Applicant competition is unavailable.** High demand does not automatically imply easy entry.
3. **Skill tagging is incomplete.** Approximately 14.38% of postings have no tagged skill.
4. **Top five is a simplification.** Skills below the cutoff may remain important in specific specializations.
5. **Salary disclosure is low.** Salary medians rely on small, potentially non-representative subsets.
6. **Currency is not verified.** The global dataset has no separate currency field in the project model.
7. **The time horizon is limited.** One year cannot establish long-term trends or seasonality.
8. **Boundary dates are retained.** The full import includes 90 December 2023 records for scope consistency.
9. **Coverage is not balance.** Representation across 160 countries does not imply even geographic distribution.
10. **Remote does not mean globally available.** Location restrictions may still apply.
11. **The analysis is descriptive.** Observed associations do not establish causal explanations.
12. **Educational origin is acknowledged.** The portfolio implementation is independent, while the source inspiration is documented in the main project README.

## Reproducing the results

1. Create the local PostgreSQL database `portfolio_data_jobs`.
2. Run `sql/00_schema.sql`.
3. Import the four source CSV files in the order documented in `data/README.md`.
4. Run `sql/01_data_quality_checks.sql` and inspect every validation result.
5. Run the analytical scripts `sql/02` through `sql/07`.
6. Compare the generated outputs with the committed CSV files in this directory.

For query-level documentation, see [`../../sql/README.md`](../../sql/README.md). For source-data access and the full project roadmap, see the [main project README](../../README.md).
