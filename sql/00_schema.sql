CREATE SCHEMA IF NOT EXISTS data_jobs;

CREATE TABLE IF NOT EXISTS data_jobs.company_dim (
    company_id BIGINT PRIMARY KEY,
    name TEXT,
    link TEXT,
    link_google TEXT,
    thumbnail TEXT
);

CREATE TABLE IF NOT EXISTS data_jobs.skills_dim (
    skill_id BIGINT PRIMARY KEY,
    skills TEXT NOT NULL,
    type TEXT
);

CREATE TABLE IF NOT EXISTS data_jobs.job_postings_fact (
    job_id BIGINT PRIMARY KEY,
    company_id BIGINT,
    job_title_short TEXT,
    job_title TEXT,
    job_location TEXT,
    job_via TEXT,
    job_schedule_type TEXT,
    job_work_from_home BOOLEAN,
    search_location TEXT,
    job_posted_date TIMESTAMPTZ,
    job_no_degree_mention BOOLEAN,
    job_health_insurance BOOLEAN,
    job_country TEXT,
    salary_rate TEXT,
    salary_year_avg NUMERIC(14, 2),
    salary_hour_avg NUMERIC(14, 2),
    CONSTRAINT fk_job_company
        FOREIGN KEY (company_id)
        REFERENCES data_jobs.company_dim (company_id)
);

CREATE TABLE IF NOT EXISTS data_jobs.skills_job_dim (
    job_id BIGINT,
    skill_id BIGINT,
    CONSTRAINT pk_skills_job PRIMARY KEY (job_id, skill_id),
    CONSTRAINT fk_skills_job_posting
        FOREIGN KEY (job_id)
        REFERENCES data_jobs.job_postings_fact (job_id),
    CONSTRAINT fk_skills_job_skill
        FOREIGN KEY (skill_id)
        REFERENCES data_jobs.skills_dim (skill_id)
);
