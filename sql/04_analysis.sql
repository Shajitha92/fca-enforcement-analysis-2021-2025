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
