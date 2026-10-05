# FCA Enforcement & Regulatory Breach Analysis, 2021–2025

## Project Overview

This project analyses **98 FCA fine cases published between 2021 and 2025** to identify patterns in regulatory misconduct, breached rules and regulations, enforcement activity, and financial penalties.

The project is designed as an end-to-end regulatory data analysis workflow, covering:

- public-data extraction
- data quality assurance
- relational database design
- regulatory notice enrichment
- breach mapping
- analytical classification
- SQL analysis
- Pandas analysis
- Tableau visualisation

The project is currently in the **analysis stage**, with SQL and Pandas analysis in progress and Tableau visualisation to follow.

---

## Analytical Objective

The main research question is:

> **What types of regulatory failures led to FCA fines between 2021 and 2025, which rules and regulations were breached, and how did patterns vary across cases and years?**

The analysis will examine areas including:

- number of enforcement cases by year
- total, average and median financial penalties
- misconduct patterns
- regulatory regimes involved
- most frequently cited breached provisions
- number of breaches per case
- conduct duration
- enforcement timing
- differences between misconduct categories

---

## Data Scope

The dataset contains **98 FCA fine cases covering 2021–2025**.

| Year | Cases |
|---|---:|
| 2021 | 10 |
| 2022 | 26 |
| 2023 | 12 |
| 2024 | 27 |
| 2025 | 23 |
| **Total** | **98** |

The original annual fines data is retained as a source-preserving raw layer.

Additional regulatory information was derived from relevant FCA enforcement material, including Final Notices, Decision Notices, infringement decisions and FCA enforcement releases where appropriate.

---

## Data Pipeline

```text
FCA annual fines pages
        ↓
Raw extraction
        ↓
Source-preserving database
        ↓
Regulatory notice enrichment
        ↓
Breach mapping
        ↓
Analytical misconduct classification
        ↓
Data cleaning & derived fields
        ↓
Multi-stage QA
        ↓
SQL & Pandas analysis
        ↓
Tableau dashboard


Database Design
The project uses PostgreSQL through Supabase.
fca_fines_raw
Preserves the original case-level FCA annual fines data.
Key fields include:
- case_id
- year
- firm_individual_fined
- case_url
- date
- amount
- reason
The raw table is preserved rather than overwritten during cleaning.
fca_fines_clean
Analysis-ready representation of the raw case data.
Derived fields include:
- entity_name_clean — whitespace cleaning only
- annual_fines_date — converted to SQL DATE
- amount_numeric — penalty converted to a numeric value
The project intentionally keeps transformations minimal so the analytical data remains close to the original FCA source.
fca_enforcement_cases
Contains notice-level regulatory enrichment such as:
- notice type
- notice date
- conduct start and end dates
- regulatory regime
- detailed misconduct theme
fca_case_breaches
Stores breached provisions using a one-to-many relationship between an enforcement case and its cited breaches.
This design allows a single case to contain multiple breached rules without duplicating the main case record.
fca_case_classification
Contains the project's broad analytical misconduct category for each case.
Analytical Misconduct Taxonomy
For cross-case analysis, the project uses an 11-category controlled taxonomy:
1. Financial Crime / AML
2. Market Conduct / Market Abuse / Wholesale Conduct
3. Consumer Treatment
4. Suitability / Advice / Mis-selling
5. Governance / Systems & Controls / Regulatory Compliance
6. Disclosure / Listing / Reporting
7. Conflicts of Interest
8. Integrity / Fitness & Propriety / Cooperation
9. Competition / Antitrust
10. Data Protection / Privacy
11. Other / Unclassified
Important: these categories are an analytical classification created for this project. They are not official FCA misconduct categories.
FCA-sourced facts and project-created analytical classifications are deliberately stored separately.
Data Quality & Validation
The dataset went through multiple QA stages before analysis.
Checks included:
- raw and enriched case coverage
- duplicate case detection
- duplicate breach detection
- missing breach mappings
- orphan-record checks
- NULL-value review
- conduct-date validation
- annual fines year vs notice-date consistency
- notice-type consistency
- regulatory-regime standardisation
- regime-to-breach consistency
- amount conversion validation
- date conversion validation
- classification count validation
The final case-level dataset contains:
- 98 distinct cases
- 98 classified cases
- 98 cases with mapped breach information
- 97 usable numeric penalty values
- 1 source-level missing penalty amount
Missing values are retained as NULL when the underlying FCA material does not provide enough information to infer them.
Regulatory Data Methodology
Automation handled repetitive extraction and candidate identification, while regulatory interpretation was validated manually.
A regulatory notice may reference:
- actual breached provisions
- definitions
- procedural provisions
- enforcement powers
- contextual regulatory requirements
Only provisions assessed as actual breaches are included in the breach-mapping layer.
Where FCA material provided multiple relevant conduct periods, the project records the earliest defined start date and latest defined end date as a case-level conduct envelope.
Where only month and year were available, dates were normalised to the first day of the stated month and documented as normalised rather than exact FCA dates.
Where no sufficiently defined conduct period was available, the value remains NULL.
Technology
- Python
- Pandas
- PostgreSQL
- Supabase
- SQL
- Tableau
- Git / GitHub
Current Project Status
- [x] FCA annual fines extraction
- [x] Raw data QA
- [x] PostgreSQL relational database
- [x] Regulatory notice enrichment
- [x] Breach mapping
- [x] Misconduct taxonomy
- [x] Multi-stage data QA
- [x] Analysis-ready data fields
- [ ] SQL analysis
- [ ] Pandas analysis
- [ ] Tableau dashboard
- [ ] Final analytical findings
Planned Analysis
The next stage will examine:
- enforcement cases by year
- penalty totals by year
- average vs median penalties
- penalties by misconduct category
- regulatory regimes
- most frequently cited provisions
- breach counts per case
- conduct duration
- enforcement delay
- relationships between enforcement characteristics and penalty size
Disclaimer:
This is an independent portfolio project based on publicly available FCA information.
The analytical classifications, transformations and interpretations used in this repository are the author's own and should not be treated as official FCA classifications or regulatory guidance.
