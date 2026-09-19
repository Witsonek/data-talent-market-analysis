# SQL scripts

This directory contains only scripts for database preparation and validation at this project stage. Business analysis queries belong to a separate workflow and will be added only after the imported data have passed validation.

- `00_schema.sql`: creates the `data_jobs` schema and relational tables.
- `01_data_quality_checks.sql`: produces validation result sets for table volume, null keys, duplicate business keys, referential integrity and selected domain checks.
