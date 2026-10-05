-- ============================================================
-- FCA Enforcement & Regulatory Breach Analysis, 2021–2025
-- Data cleaning and derived analytical fields
-- PostgreSQL / Supabase
--
-- Purpose:
-- Create an analysis-ready view while preserving the original
-- FCA source data in fca_fines_raw.
-- ============================================================


-- ------------------------------------------------------------
-- Source-preservation principle
-- ------------------------------------------------------------
-- fca_fines_raw is retained as the original source layer.
--
-- Cleaning is intentionally minimal:
--   1. entity_name_clean     -> whitespace cleanup only
--   2. annual_fines_date     -> convert source date text to DATE
--   3. amount_numeric        -> convert penalty text to NUMERIC
--
-- No FCA wording is rewritten or standardised beyond whitespace.
-- The original source fields remain available in fca_fines_raw.


CREATE OR REPLACE VIEW fca_fines_clean AS
SELECT
    case_id,
    year,

    -- Original FCA entity name
    firm_individual_fined,

    -- --------------------------------------------------------
    -- Derived field: entity_name_clean
    --
    -- Only leading/trailing and repeated whitespace is cleaned.
    -- Capitalisation, legal status, wording and entity naming are
    -- otherwise preserved exactly as provided by the FCA source.
    -- --------------------------------------------------------
    regexp_replace(
        trim(firm_individual_fined),
        '[[:space:]]+',
        ' ',
        'g'
    ) AS entity_name_clean,

    case_url,

    -- Original FCA date text
    date,

    -- --------------------------------------------------------
    -- Derived field: annual_fines_date
    --
    -- Converts multiple source date formats to PostgreSQL DATE.
    -- Supported source formats identified during QA:
    --   DD Month YYYY
    --   DD/MM/YYYY
    --   DD/MM/YY
    --   YYYY-MM-DD
    --
    -- Values that do not match a recognised format remain NULL
    -- rather than being inferred.
    -- --------------------------------------------------------
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

    -- --------------------------------------------------------
    -- Derived field: amount_numeric
    --
    -- Removes currency symbols, commas and other non-numeric
    -- characters so the source amount can be analysed using
    -- SUM, AVG, MEDIAN and other numeric functions.
    --
    -- Missing source amounts remain NULL.
    -- --------------------------------------------------------
    NULLIF(
        regexp_replace(
            amount,
            '[^0-9.]',
            '',
            'g'
        ),
        ''
    )::NUMERIC(15,2) AS amount_numeric,

    -- Original FCA reason text
    reason

FROM fca_fines_raw;


-- ------------------------------------------------------------
-- QA checks for the cleaned analytical view
-- ------------------------------------------------------------


-- Confirm all source cases are represented once in the view.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT case_id) AS distinct_cases
FROM fca_fines_clean;


-- Check for date conversion failures.
SELECT
    case_id,
    firm_individual_fined,
    date,
    annual_fines_date
FROM fca_fines_clean
WHERE annual_fines_date IS NULL
ORDER BY case_id;


-- Confirm the converted date year matches the FCA annual fines year.
SELECT
    case_id,
    year,
    annual_fines_date
FROM fca_fines_clean
WHERE annual_fines_date IS NOT NULL
  AND EXTRACT(YEAR FROM annual_fines_date) <> year
ORDER BY case_id;


-- Check for missing numeric penalty values.
SELECT
    case_id,
    firm_individual_fined,
    amount_numeric
FROM fca_fines_clean
WHERE amount_numeric IS NULL
ORDER BY case_id;


-- Check for invalid negative penalty values.
SELECT
    case_id,
    firm_individual_fined,
    amount_numeric
FROM fca_fines_clean
WHERE amount_numeric < 0
ORDER BY case_id;


-- Summary validation of the penalty field.
SELECT
    COUNT(*) AS total_cases,
    COUNT(DISTINCT case_id) AS distinct_cases,
    COUNT(amount_numeric) AS cases_with_amount,
    COUNT(*) - COUNT(amount_numeric) AS cases_without_amount,
    MIN(amount_numeric) AS minimum_amount,
    MAX(amount_numeric) AS maximum_amount
FROM fca_fines_clean;
