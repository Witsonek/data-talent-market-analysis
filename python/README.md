# Python Analysis

This directory contains the Python analysis stage of the Data Talent Market Analysis portfolio project.

The Python workflow uses the validated PostgreSQL database prepared earlier in the project. Its purpose is not to rebuild the database layer, but to perform reproducible exploratory analysis on top of a documented relational model.

The analysis focuses on market demand, skill coverage, salary transparency, skill co-occurrence, salary associations, market concentration and geographic accessibility in the observed global data-jobs dataset.

## Analysis objectives

The Python stage was designed to answer the following questions:

- How complete and usable is the analytical dataset after import and validation?
- How transparent is salary information across the observed postings?
- Which data roles and skills appear most often in the market?
- Which skills frequently occur together in the same posting?
- Which skills are associated with higher disclosed annual salaries?
- Which posting sources and companies dominate the observed dataset?
- How should remote-work and location signals be interpreted in a global job-posting dataset?

## Data source

The notebooks connect to the validated PostgreSQL database created in the earlier project stage.

The analysis uses the following tables:

- `company_dim`
- `job_postings_fact`
- `skills_dim`
- `skills_job_dim`

The relational grain is preserved throughout the workflow:

- one row per company in `company_dim`
- one row per job posting in `job_postings_fact`
- one row per unique skill in `skills_dim`
- one row per job-to-skill assignment in `skills_job_dim`

This is important because demand, salary and skill metrics must be calculated at the correct level of detail. In particular, the bridge table cannot be used as a direct substitute for job-posting counts.

## Notebook structure

The Python workflow is organised into a sequence of focused notebooks.

| Notebook | Purpose |
|---|---|
| `01_database_connection_and_loading.ipynb` | Connects to PostgreSQL, loads the validated tables and confirms basic structure. |
| `02_data_quality_and_scope.ipynb` | Profiles date coverage, missing values, duplicates and analysis limitations. |
| `03_salary_distribution_and_transparency.ipynb` | Examines annual and hourly salary disclosure, distributions and outliers. |
| `04_skill_demand_and_cooccurrence.ipynb` | Measures skill demand and identifies common multi-skill combinations. |
| `05_skill_salary_premium.ipynb` | Compares skill-level median annual salary against the reference median. |
| `06_market_sources_and_company_concentration.ipynb` | Profiles posting sources, companies and concentration patterns. |
| `07_geographic_accessibility_and_location_quality.ipynb` | Evaluates raw location quality, remote indicators and parsed city candidates. |

## Scope of the analysed dataset

The analysed source dataset contains 478,895 observed job postings.

The skill mapping layer covers 410,025 postings, which means 85.62% of postings contain at least one mapped skill. The remaining 68,870 postings, or 14.38%, do not have a mapped skill and are excluded from skill-specific analysis.

The dataset contains 254 unique skills. Among postings with at least one mapped skill, the median number of skills per posting is 5 and the mean is 5.55. This shows that the typical posting does not ask for a single isolated tool, but rather for a bundle of competencies.

## Data quality and scope

The Python stage begins with analytical profiling of the validated PostgreSQL data.

The dataset contains no full-row duplicates in the core tables, and the bridge table preserves unique job-skill combinations. This matters because duplicate rows in a many-to-many structure would distort both demand counts and skill co-occurrence metrics.

Date profiling showed that the dataset is effectively a 2024 dataset, while a very small number of records dated before 2024 were intentionally retained in order to preserve the complete source extract. These records are documented as a limitation rather than silently removed.

Missing values are not treated as a cosmetic issue. They directly shape what can and cannot be claimed from the analysis, especially in salary and location-related sections.

## Salary transparency and salary distributions

Salary transparency is limited and this strongly affects interpretation.

Annual salary is disclosed for 20,335 postings, which represents 4.25% of the full dataset. Hourly salary is disclosed for 10,076 postings, which represents 2.10% of the dataset. Because salary coverage is low, salary findings describe disclosed-salary postings rather than the entire observed market.

Annual and hourly salaries are analysed separately. They are different units and are not merged into one metric. Hourly values are not converted into annual salary because the dataset does not provide a sufficiently reliable basis for a universal conversion across contract types, working hours, countries and compensation practices.

Salary distributions are right-skewed and include high-value outliers. These outliers were retained because statistical distance alone does not prove a data-quality error. For this reason, medians and percentiles are preferred over simple averages in interpretation.

## Skill demand and co-occurrence

Skill demand is measured at the posting level using distinct job IDs, not raw bridge-table row counts.

This distinction matters because one posting may require multiple skills, and counting bridge-table rows as postings would inflate demand measures. The notebook therefore keeps job-posting grain explicit in all demand calculations.

The co-occurrence analysis identifies skills that appear together within the same posting. This is useful for understanding competency bundles in the observed market, but it must be interpreted carefully. Co-occurrence does not prove causality, does not define a mandatory learning path and does not imply that two skills always belong to the same career track.

## Skill salary premium

The salary-premium notebook compares the median disclosed annual salary of postings that mention a given skill with the overall reference median from disclosed annual salaries.

This is an association analysis, not a causal model. A higher median linked to a skill may reflect the role in which the skill appears, the country, the employer, the seniority level or other hidden variables rather than the isolated value of the skill itself.

To reduce noise, the analysis applies a minimum sample threshold before reporting skill-level salary comparisons. This prevents small samples from dominating the ranking and makes the final interpretation more defensible.

## Market sources and company concentration

The Python workflow also examines where postings come from and which companies appear most frequently in the dataset.

This part of the analysis describes concentration within the observed dataset, not the true market share of platforms or employers. A large number of postings from one source may reflect scraper coverage or aggregation behaviour rather than real platform dominance. In the same way, a high posting count for a company does not directly measure headcount, completed hires or business size.

The concentration view is therefore descriptive. Its purpose is to explain the structure of the dataset and the visibility of actors inside it.

## Geography and remote-work interpretation

The source dataset contains 16,360 unique non-null raw location strings, which makes location analysis a data-quality problem as well as an analytical one.

A broad rule-based classification was used to identify postings that may be considered potentially location-independent. This logic combines the work-from-home flag, an `Anywhere` location and remote-related text in the location field. Using this broad rule, 63,711 postings, or 13.30% of the dataset, were classified as potentially location-independent.

This does not mean those postings are guaranteed to be globally remote or accessible from every country. It only means that the posting contains one of the technical signals associated with location flexibility.

The notebook also parses candidate city values from raw location text. A valid city candidate was obtained for 342,386 postings, or 71.50% of the dataset. After applying a minimum threshold of 100 postings, 483 city-country groups remained for descriptive comparison.

No geographic map was produced. The project deliberately avoids geocoding and map visualisation at this stage because the source data does not contain validated coordinates and the raw text locations are not fully standardised.

## Key interpretation rules

Several rules were followed throughout the Python stage to keep the analysis defensible.

### 1. Grain matters

Job postings, companies and job-skill assignments are different analytical grains. Metrics are always calculated at the correct level.

### 2. Salary results require caution

Salary findings apply only to postings with disclosed salary values. They should not be interpreted as a direct summary of the full global market.

### 3. Association is not causation

This applies especially to skill co-occurrence and skill salary premium. These methods help describe patterns, not prove causal mechanisms.

### 4. Geographic signals are approximate

Remote-related flags and parsed locations are useful for profiling the dataset, but they are not a substitute for validated geographic data.

## Tools and environment

The Python stage uses a local virtual environment and connects to PostgreSQL through environment variables stored in a local `.env` file.

Typical packages used in the notebooks include:

- pandas
- numpy
- matplotlib
- seaborn
- SQLAlchemy
- psycopg
- python-dotenv
- jupyter

The `.env` file is local only and must not be committed to Git.

Example structure:

```text
DB_HOST=localhost
DB_PORT=5432
DB_NAME=portfolio_data_jobs
DB_USER=postgres
DB_PASSWORD=your_local_password
```

## Reproducibility

To reproduce the Python stage:

1. Prepare the validated PostgreSQL database.
2. Create and activate a virtual environment.
3. Install the required Python packages.
4. Create a local `.env` file with database credentials.
5. Run the notebooks in numerical order.

The Python workflow assumes that the SQL import and data-quality validation stage has already been completed.

## Limitations

The Python stage inherits several important limitations from the source dataset and analytical design.

- The dataset represents observed postings from included sources, not a complete census of the global labour market.
- Salary analysis is limited by low disclosure rates.
- Skill-based salary differences are associative and may reflect multiple confounding factors.
- Location strings are raw text values and are not fully standardised.
- Remote-related indicators reflect technical signals in the data, not guaranteed employment eligibility across jurisdictions.

## Portfolio purpose

This Python stage was designed as a portfolio project for a junior data-analyst path.

Its main goal is not to produce a single business conclusion, but to show a structured and defensible analytical workflow built on top of a validated PostgreSQL source model. The emphasis is on correct analytical grain, transparent limitations, reproducible notebooks and careful interpretation of imperfect real-world job-posting data.
