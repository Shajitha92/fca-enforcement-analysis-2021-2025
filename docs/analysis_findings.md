
**SQL:** See `sql/04_analysis.sql`.
## 1. 2024 cases with penalties above £1 million

**Analysis 1:** 2024 cases with penalties above £1 million

### Findings

15 cases had penalties above £1 million in 2024.

The combined value of these penalties was:

**£173,478,421**

The three largest penalties in this filtered group were:

- Barclays plc — £30,000,000
- Starling Bank Limited — £28,959,426
- Citigroup Global Markets Ltd — £27,766,200

### Interpretation

The 2024 enforcement data contains several high-value penalties, with the largest cases concentrated among a relatively small number of firms.

This suggests that a few large enforcement actions may strongly influence headline annual penalty totals. Further analysis will compare these large penalties with the full annual distribution using total, average and median penalty values.

### Additional finding

Total penalties recorded for 2024 were **£176,045,385**.

The 15 cases with penalties above £1 million contributed approximately **98.54%** of the total 2024 penalty value.

This shows that the 2024 annual penalty total was highly concentrated in a relatively small number of large enforcement actions.

## 2. 2024 penalty size classification

**Analysis 2:** How can 2024 enforcement cases be grouped by penalty size?

### Findings

A `CASE` expression was used to classify cases into:

- **Large** — penalty above £1 million
- **Small** — penalty of £1 million or less
- **Missing** — no usable penalty amount

This demonstrates conditional classification in SQL and creates a simple analytical grouping that can be reused in later aggregation and visualisation.

## 3. 2024 penalty bands

**Question:** How are 2024 enforcement cases distributed by penalty size?

### Findings

Of the 27 FCA fine cases recorded in 2024:

- **15 cases** had penalties above £1 million.
- **12 cases** had penalties of £1 million or less.

The large-penalty group accounted for **£173.48 million** of the **£176.05 million** total penalty value recorded for 2024.

### Interpretation

Although large-penalty cases represented just over half of the 2024 cases, they accounted for approximately **98.54% of the total penalty value**.

This indicates a highly concentrated penalty distribution, where a relatively small number of high-value enforcement actions dominate the annual monetary total.

## 4. 2024 misconduct themes with more than 2 cases

**Question:** Which misconduct themes appeared in more than 2 FCA fine cases during 2024?

### Findings

Five misconduct themes appeared in more than two cases during 2024:

| Misconduct theme | Case count |
|---|---:|
| Integrity / Fitness & Propriety / Cooperation | 10 |
| Consumer Treatment | 4 |
| Disclosure / Listing / Reporting | 4 |
| Market Conduct / Market Abuse / Wholesale Conduct | 3 |
| Suitability / Advice / Mis-selling | 3 |

### Interpretation

**Integrity / Fitness & Propriety / Cooperation** was the most frequently occurring primary misconduct theme among 2024 cases, with 10 cases.

Consumer Treatment and Disclosure / Listing / Reporting were the next most common themes, with four cases each.

The use of `HAVING` allows the analysis to focus only on misconduct categories that occurred repeatedly, rather than displaying every category represented in the year.

## 5. Combining case-level penalties with misconduct classification

**Question:** Can the cleaned FCA fine data be successfully combined with the analytical misconduct classification?

### Findings

The `LEFT JOIN` successfully combined the cleaned case-level dataset with the misconduct classification table using `case_id`.

- All **98 enforcement cases** were retained in the joined result.
- Every case was matched to a `primary_misconduct_theme`.
- The joined dataset contains case identifiers, entity names, year, penalty amount and misconduct classification in a single analytical result.
- One case has no usable penalty amount in the source data, but the case and its misconduct classification are still retained because a `LEFT JOIN` was used.

### Interpretation

The result confirms that the case-level and classification datasets can be integrated without losing records.

Using a `LEFT JOIN` is important because the cleaned enforcement-case dataset remains the base population. If a classification were missing, the enforcement case would still appear in the result, making missing classifications visible rather than silently removing those cases.

The joined dataset provides the foundation for subsequent analysis of penalty values by misconduct category, including case counts, total penalties, average penalties and year-by-year patterns.
