-- ============================================================
-- Analysis 1: 2024 cases with penalties above £1 million
-- Which FCA fine cases in 2024 had penalties above £1 million?
-- ============================================================

SELECT
    case_id,
    entity_name_clean,
    amount_numeric
FROM fca_fines_clean
WHERE year = 2024
  AND amount_numeric > 1000000
ORDER BY amount_numeric DESC;

**Additional finding**
Percentage calculation for fines over 1 million
SELECT ROUND ((SUM(CASE 
                    WHEN amount_numeric > 1000000
                    THEN amount_numeric
                    ELSE 0
                    END)
                    / SUM(amount_numeric)
                    )* 100,
                    2 
                    )AS percentage
FROM fca_fines_clean
WHERE year = 2024;

-- ============================================================
-- Analysis 2: 2024 penalty size classification
-- How can 2024 enforcement cases be grouped by penalty size?
-- ============================================================

SELECT
    case_id,
    entity_name_clean,
    amount_numeric,
    CASE
        WHEN amount_numeric IS NULL THEN 'Missing'
        WHEN amount_numeric > 1000000 THEN 'Large'
        ELSE 'Small'
    END AS penalty_band
FROM fca_fines_clean
WHERE year = 2024
ORDER BY amount_numeric DESC;

-- ============================================================
-- Analysis 3: 2024 penalty bands summary
-- How are year 2024 cases and penalty values distributed between
-- large and smaller enforcement penalties?
-- ============================================================

SELECT CASE
          WHEN amount_numeric IS NULL THEN 'Missing'
          WHEN amount_numeric > 1000000 THEN 'Large'
          ELSE 'Small' 
        END AS penalty_band,
        COUNT(case_id) as case_count,
        SUM(amount_numeric) as total_penalties
        
FROM fca_fines_clean
WHERE year = 2024
GROUP BY penalty_band
ORDER BY total_penalties DESC;

-- ============================================================
-- Analysis 4: 2024 misconduct themes with more than 2 cases
-- Which misconduct themes appeared in more than 2 FCA fine
-- cases during 2024?
-- ============================================================

SELECT
    primary_misconduct_theme,
    COUNT(case_id) AS case_count
FROM fca_tableau_cases
WHERE year = 2024
GROUP BY primary_misconduct_theme
HAVING COUNT(case_id) > 2
ORDER BY case_count DESC;

-- ============================================================
-- Analysis 5: Combine case data with misconduct classification
-- Can cleaned case-level enforcement data be successfully
-- joined to the analytical misconduct classification?
-- ============================================================

SELECT
    f.case_id,
    f.entity_name_clean,
    f.year,
    f.amount_numeric,
    c.primary_misconduct_theme
FROM fca_fines_clean AS f
LEFT JOIN fca_case_classification AS c
    ON f.case_id = c.case_id;
-- ============================================================
-- Analysis 6: Total penalties by misconduct theme
-- Which misconduct themes accounted for the highest total
-- penalty values across 2021–2025?
-- ============================================================

SELECT
    c.primary_misconduct_theme,
    COUNT(f.case_id) AS case_count,
    SUM(f.amount_numeric) AS total_penalties
FROM fca_fines_clean AS f
LEFT JOIN fca_case_classification AS c
    ON f.case_id = c.case_id
GROUP BY c.primary_misconduct_theme
ORDER BY total_penalties DESC;

-- ============================================================
-- Analysis 7: Annual penalty comparison, 2021–2025
-- How did the value of FCA penalties in 2021 compare with
-- subsequent years from 2022 to 2025?
-- ============================================================

SELECT
    year,
    COUNT(case_id) AS case_count,
    SUM(amount_numeric) AS total_penalties
FROM fca_fines_clean
GROUP BY year
ORDER BY year;

-- ============================================================
-- Analysis 8: Average vs median penalties by year
-- Were annual penalty values representative of typical cases,
-- or were annual averages influenced by extreme penalties?
-- ============================================================

SELECT
    year,
    ROUND(AVG(amount_numeric), 2) AS avg_penalty,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY amount_numeric)::numeric,
        2
    ) AS median_penalty
FROM fca_fines_clean
GROUP BY year
ORDER BY year;
