-- ============================================================
-- Analysis 1: 2024 penalties above £1 million
-- Question:
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
