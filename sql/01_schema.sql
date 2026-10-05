-- ============================================================
-- FCA Enforcement & Regulatory Breach Analysis, 2021–2025
-- Database schema
-- PostgreSQL / Supabase
-- ============================================================


-- ------------------------------------------------------------
-- 1. Raw FCA annual fines data
-- ------------------------------------------------------------

CREATE TABLE fca_fines_raw (
    case_id BIGSERIAL PRIMARY KEY,
    year INTEGER,
    firm_individual_fined TEXT,
    case_url TEXT,
    date TEXT,
    amount TEXT,
    reason TEXT
);


-- ------------------------------------------------------------
-- 2. Enforcement notice-level enrichment
-- ------------------------------------------------------------

CREATE TABLE fca_enforcement_cases (
    case_id BIGINT PRIMARY KEY,
    notice_type TEXT,
    notice_date DATE,
    conduct_start_date DATE,
    conduct_end_date DATE,
    regulatory_regime TEXT,
    misconduct_theme TEXT,

    CONSTRAINT fk_enforcement_case
        FOREIGN KEY (case_id)
        REFERENCES fca_fines_raw(case_id)
);


-- ------------------------------------------------------------
-- 3. Regulatory breach mapping
--
-- One enforcement case can contain multiple breached provisions.
-- ------------------------------------------------------------

CREATE TABLE fca_case_breaches (
    breach_id BIGSERIAL PRIMARY KEY,
    case_id BIGINT NOT NULL,
    breach_reference TEXT NOT NULL,

    CONSTRAINT fk_breach_case
        FOREIGN KEY (case_id)
        REFERENCES fca_fines_raw(case_id),

    CONSTRAINT unique_case_breach
        UNIQUE (case_id, breach_reference)
);


-- ------------------------------------------------------------
-- 4. Analytical misconduct classification
--
-- primary_misconduct_theme is a project-created taxonomy and
-- is not an official FCA classification.
-- ------------------------------------------------------------

CREATE TABLE fca_case_classification (
    case_id BIGINT PRIMARY KEY,
    primary_misconduct_theme TEXT NOT NULL,

    CONSTRAINT fk_classification_case
        FOREIGN KEY (case_id)
        REFERENCES fca_fines_raw(case_id)
);


-- ------------------------------------------------------------
-- 5. Analysis-ready view
--
-- The raw source fields remain unchanged in fca_fines_raw.
-- Only minimal transformations required for analysis are applied.
-- ------------------------------------------------------------

CREATE VIEW fca_fines_clean AS
SELECT
    case_id,
    year,
    firm_individual_fined,

    -- Whitespace-only cleaning. FCA entity wording is preserved.
    regexp_replace(
        trim(firm_individual_fined),
        '[[:space:]]+',
        ' ',
        'g'
    ) AS entity_name_clean,

    case_url,
    date,

    -- Convert source date strings to PostgreSQL DATE.
    CASE
        WHEN date ~ '^\d{1,2} [A-Za-z]+ \d{4}$'
            THEN to_date(date, 'DD Month YYYY')

        WHEN date ~ '^\d{1,2}/\d{1,2}/\d{4}$'
            THEN to_date(date, 'DD/MM/YYYY')

        WHEN date ~ '^\d{1,2}/\d{1,2}/\d{2}$'
            THEN to_date(date, 'DD/MM/YY')

        WHEN date ~ '^\d{4}-\d{2}-\d{2}$'
            THEN date::date

        ELSE NULL
    END AS annual_fines_date,

    -- Convert FCA penalty text to numeric values for analysis.
    NULLIF(
        regexp_replace(
            amount,
            '[^0-9.]',
            '',
            'g'
        ),
        ''
    )::NUMERIC(15,2) AS amount_numeric,

    reason

FROM fca_fines_raw;
