-- ============================================================
-- FCA Enforcement & Regulatory Breach Analysis, 2021–2025
-- Database QA checks
-- PostgreSQL / Supabase
--
-- Purpose:
-- Validate coverage, uniqueness, date logic, breach mapping,
-- naming consistency and classification completeness before
-- analytical SQL is run.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Coverage across core tables
-- ------------------------------------------------------------

SELECT
    (SELECT COUNT(*) FROM fca_fines_raw) AS raw_cases,
    (SELECT COUNT(*) FROM fca_enforcement_cases) AS enriched_cases,
    (SELECT COUNT(DISTINCT case_id) FROM fca_case_breaches)
        AS cases_with_breaches,
    (SELECT COUNT(*) FROM fca_case_classification)
        AS classified_cases;


-- ------------------------------------------------------------
-- 2. Missing enrichment records
-- ------------------------------------------------------------

SELECT
    r.case_id,
    r.firm_individual_fined
FROM fca_fines_raw r
LEFT JOIN fca_enforcement_cases e
    ON r.case_id = e.case_id
WHERE e.case_id IS NULL
ORDER BY r.case_id;


-- ------------------------------------------------------------
-- 3. Duplicate enrichment records
-- ------------------------------------------------------------

SELECT
    case_id,
    COUNT(*) AS row_count
FROM fca_enforcement_cases
GROUP BY case_id
HAVING COUNT(*) > 1
ORDER BY case_id;


-- ------------------------------------------------------------
-- 4. Cases without mapped breaches
-- ------------------------------------------------------------

SELECT
    r.case_id,
    r.firm_individual_fined
FROM fca_fines_raw r
LEFT JOIN fca_case_breaches b
    ON r.case_id = b.case_id
GROUP BY
    r.case_id,
    r.firm_individual_fined
HAVING COUNT(b.breach_id) = 0
ORDER BY r.case_id;


-- ------------------------------------------------------------
-- 5. Duplicate breach mappings
-- ------------------------------------------------------------

SELECT
    case_id,
    breach_reference,
    COUNT(*) AS duplicate_count
FROM fca_case_breaches
GROUP BY
    case_id,
    breach_reference
HAVING COUNT(*) > 1
ORDER BY case_id;


-- ------------------------------------------------------------
-- 6. Orphan breach records
-- ------------------------------------------------------------

SELECT
    b.breach_id,
    b.case_id,
    b.breach_reference
FROM fca_case_breaches b
LEFT JOIN fca_enforcement_cases e
    ON b.case_id = e.case_id
WHERE e.case_id IS NULL
ORDER BY b.case_id;


-- ------------------------------------------------------------
-- 7. Conduct-date logic
-- ------------------------------------------------------------

-- Conduct start date should not be after conduct end date.
SELECT
    case_id,
    conduct_start_date,
    conduct_end_date
FROM fca_enforcement_cases
WHERE conduct_start_date IS NOT NULL
  AND conduct_end_date IS NOT NULL
  AND conduct_start_date > conduct_end_date
ORDER BY case_id;


-- Notice date should not precede the end of conduct.
SELECT
    case_id,
    notice_date,
    conduct_start_date,
    conduct_end_date
FROM fca_enforcement_cases
WHERE notice_date IS NOT NULL
  AND conduct_end_date IS NOT NULL
  AND notice_date < conduct_end_date
ORDER BY case_id;


-- ------------------------------------------------------------
-- 8. NULL review in enrichment fields
-- ------------------------------------------------------------

SELECT
    case_id,
    notice_type,
    notice_date,
    conduct_start_date,
    conduct_end_date,
    regulatory_regime,
    misconduct_theme
FROM fca_enforcement_cases
WHERE notice_type IS NULL
   OR notice_date IS NULL
   OR conduct_start_date IS NULL
   OR conduct_end_date IS NULL
   OR regulatory_regime IS NULL
   OR misconduct_theme IS NULL
ORDER BY case_id;


-- ------------------------------------------------------------
-- 9. Annual fines year vs notice year
-- ------------------------------------------------------------

SELECT
    r.case_id,
    r.year AS annual_fines_year,
    r.firm_individual_fined,
    e.notice_date,
    EXTRACT(YEAR FROM e.notice_date) AS notice_year
FROM fca_fines_raw r
JOIN fca_enforcement_cases e
    ON r.case_id = e.case_id
WHERE e.notice_date IS NOT NULL
  AND r.year <> EXTRACT(YEAR FROM e.notice_date)
ORDER BY r.case_id;


-- ------------------------------------------------------------
-- 10. Notice type consistency
-- ------------------------------------------------------------

SELECT
    notice_type,
    COUNT(*) AS number_of_cases
FROM fca_enforcement_cases
GROUP BY notice_type
ORDER BY number_of_cases DESC;


-- ------------------------------------------------------------
-- 11. Regulatory regime consistency
-- ------------------------------------------------------------

SELECT
    regulatory_regime,
    COUNT(*) AS number_of_cases
FROM fca_enforcement_cases
GROUP BY regulatory_regime
ORDER BY regulatory_regime;


-- ------------------------------------------------------------
-- 12. Blank-string checks
-- ------------------------------------------------------------

SELECT
    case_id,
    notice_type,
    regulatory_regime,
    misconduct_theme
FROM fca_enforcement_cases
WHERE TRIM(COALESCE(notice_type, '')) = ''
   OR TRIM(COALESCE(regulatory_regime, '')) = ''
   OR TRIM(COALESCE(misconduct_theme, '')) = ''
ORDER BY case_id;


-- ------------------------------------------------------------
-- 13. Breach-count review
-- ------------------------------------------------------------

SELECT
    r.case_id,
    r.firm_individual_fined,
    COUNT(b.breach_id) AS breach_count
FROM fca_fines_raw r
JOIN fca_case_breaches b
    ON r.case_id = b.case_id
GROUP BY
    r.case_id,
    r.firm_individual_fined
ORDER BY
    breach_count DESC,
    r.case_id;


-- ------------------------------------------------------------
-- 14. Regime-to-breach consistency check
-- ------------------------------------------------------------

SELECT
    e.case_id,
    r.firm_individual_fined,
    e.regulatory_regime,
    STRING_AGG(
        b.breach_reference,
        '; '
        ORDER BY b.breach_id
    ) AS breaches
FROM fca_enforcement_cases e
JOIN fca_fines_raw r
    ON e.case_id = r.case_id
JOIN fca_case_breaches b
    ON e.case_id = b.case_id
GROUP BY
    e.case_id,
    r.firm_individual_fined,
    e.regulatory_regime
HAVING
       (
           STRING_AGG(b.breach_reference, ' ')
               ILIKE '%PRIN%'
           AND e.regulatory_regime NOT ILIKE '%PRIN%'
       )

    OR (
           STRING_AGG(b.breach_reference, ' ')
               ILIKE '%APER%'
           AND e.regulatory_regime NOT ILIKE '%APER%'
       )

    OR (
           STRING_AGG(b.breach_reference, ' ')
               ILIKE '%SYSC%'
           AND e.regulatory_regime NOT ILIKE '%SYSC%'
       )

    OR (
           STRING_AGG(b.breach_reference, ' ')
               ILIKE '%CONC%'
           AND e.regulatory_regime NOT ILIKE '%CONC%'
       )

    OR (
           STRING_AGG(b.breach_reference, ' ')
               ILIKE '%MAR%'
           AND e.regulatory_regime NOT ILIKE '%MAR%'
       )

ORDER BY e.case_id;


-- ------------------------------------------------------------
-- 15. Classification completeness
-- ------------------------------------------------------------

SELECT
    primary_misconduct_theme,
    COUNT(*) AS case_count
FROM fca_case_classification
GROUP BY primary_misconduct_theme
ORDER BY case_count DESC;


-- ------------------------------------------------------------
-- Expected final QA state
-- ------------------------------------------------------------
-- 98 raw cases
-- 98 enriched cases
-- 98 cases with mapped breach information
-- 98 classified cases
--
-- No duplicate case rows
-- No duplicate breach mappings
-- No orphan breach records
-- No invalid conduct-date ordering
-- No year / notice-year mismatches
-- No blank key enrichment fields
--
-- Four cases retain NULL conduct dates because no sufficiently
-- defined conduct period was available from the FCA source.
--
-- One case retains a NULL numeric penalty amount because the
-- source-level amount was unavailable.
