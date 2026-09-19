# Data dictionary

## `company_dim`

| Column | Type | Description |
|---|---|---|
| `company_id` | BIGINT | Unique company identifier |
| `name` | TEXT | Company name |
| `link` | TEXT | Company link |
| `link_google` | TEXT | Google-related company link |
| `thumbnail` | TEXT | Company thumbnail link |

## `job_postings_fact`

| Column | Type | Description |
|---|---|---|
| `job_id` | BIGINT | Unique job-posting identifier |
| `company_id` | BIGINT | Company identifier; foreign key to `company_dim` |
| `job_title_short` | TEXT | Standardised short job-title category |
| `job_title` | TEXT | Original job title |
| `job_location` | TEXT | Job location text |
| `job_via` | TEXT | Posting source/channel |
| `job_schedule_type` | TEXT | Schedule or employment type |
| `job_work_from_home` | BOOLEAN | Work-from-home flag |
| `search_location` | TEXT | Location used in the source search |
| `job_posted_date` | TIMESTAMPTZ | Posting timestamp |
| `job_no_degree_mention` | BOOLEAN | Flag for no degree requirement mention |
| `job_health_insurance` | BOOLEAN | Health-insurance flag |
| `job_country` | TEXT | Country associated with the posting |
| `salary_rate` | TEXT | Salary period/rate |
| `salary_year_avg` | NUMERIC(14,2) | Average annual salary when available |
| `salary_hour_avg` | NUMERIC(14,2) | Average hourly salary when available |

## `skills_dim`

| Column | Type | Description |
|---|---|---|
| `skill_id` | BIGINT | Unique skill identifier |
| `skills` | TEXT | Skill name |
| `type` | TEXT | Skill category/type |

## `skills_job_dim`

| Column | Type | Description |
|---|---|---|
| `job_id` | BIGINT | Foreign key to `job_postings_fact` |
| `skill_id` | BIGINT | Foreign key to `skills_dim` |
