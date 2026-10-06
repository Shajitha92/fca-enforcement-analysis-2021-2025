-- ============================================================
-- Analysis 1: 2024 cases with penalties above £1 million
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
