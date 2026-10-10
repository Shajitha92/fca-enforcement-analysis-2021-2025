
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

## 6. Total penalties by misconduct theme

**Question:** Which misconduct themes accounted for the highest total penalty values across 2021–2025?

### Findings

| Misconduct theme | Case count | Total penalties |
|---|---:|---:|
| Financial Crime / AML | 22 | £775,331,008.48 |
| Consumer Treatment | 7 | £114,474,600.00 |
| Market Conduct / Market Abuse / Wholesale Conduct | 15 | £86,170,524.00 |
| Disclosure / Listing / Reporting | 9 | £66,488,875.00 |
| Governance / Systems & Controls / Regulatory Compliance | 7 | £47,732,646.00 |
| Integrity / Fitness & Propriety / Cooperation | 16 | £25,980,118.92 |
| Suitability / Advice / Mis-selling | 15 | £11,072,378.00 |
| Conflicts of Interest | 2 | £9,333,560.00 |
| Competition / Antitrust | 3 | £154,300.00 |
| Data Protection / Privacy | 2 | £1,052.00 |

### Interpretation

Financial Crime / AML was both the most frequent primary misconduct theme and the category associated with the highest total penalty value. Its 22 cases accounted for approximately **£775.3 million**, around **68% of all recorded penalties** in the dataset.

However, case frequency does not directly correspond to monetary impact. For example, Integrity / Fitness & Propriety / Cooperation had 16 cases, making it one of the most common categories, but accounted for only about **£26.0 million** in penalties. By contrast, Consumer Treatment had only 7 cases but generated approximately **£114.5 million** in penalties.

This shows why both case counts and penalty values are needed when assessing enforcement patterns. Case counts indicate how frequently a type of misconduct appears, while total penalties provide a different measure of its monetary significance within the dataset.

The results should not be interpreted as measuring the inherent seriousness of each misconduct category. Penalty amounts can be affected by case-specific factors, and the analysis describes the observed enforcement outcomes in this 2021–2025 dataset.

## 7. Annual penalty comparison, 2021–2025

**Question:** How did the value of FCA penalties in 2021 compare with subsequent years from 2022 to 2025?

### Findings

| Year | Case count | Total penalties |
|---|---:|---:|
| 2021 | 10 | £567,765,219.95 |
| 2022 | 26 | £215,351,438.00 |
| 2023 | 12 | £53,354,600.00 |
| 2024 | 27 | £176,045,385.00 |
| 2025 | 23 | £124,222,419.45 |

Across the five-year dataset, recorded penalties totalled approximately **£1.137 billion**.

Despite containing only 10 cases, **2021 accounted for approximately 49.95% of all recorded penalty value**.

The £567.8 million recorded in 2021 was almost equal to the combined **£569.0 million** recorded across 2022–2025.

Compared with 2021, total annual penalties were approximately 62% lower in 2022, 91% lower in 2023, 69% lower in 2024 and 78% lower in 2025.

### Interpretation

2021 stands out as an unusually high-value enforcement year within the dataset, but this was not driven by a high number of cases. Instead, the annual total was strongly influenced by a small number of very large penalties.

This highlights the importance of analysing both enforcement frequency and monetary value. Annual penalty totals can be highly sensitive to individual large cases and should not be interpreted as a direct measure of overall enforcement intensity.

2021 also falls within the period when economic and regulatory activity was emerging from the disruption associated with the COVID-19 pandemic. However, this dataset alone does not establish any causal relationship between the pandemic, the recovery period and FCA penalty levels.

## 8. Average vs median penalties by year

**Question:** Were annual penalty totals representative of typical FCA fine cases, or were they influenced by unusually large penalties?

### Findings

| Year | Average penalty | Median penalty |
|---|---:|---:|
| 2021 | £56,776,522 | £410,200 |
| 2022 | £8,614,058 | £811,900 |
| 2023 | £4,446,217 | £3,073,550 |
| 2024 | £6,520,199 | £1,377,968 |
| 2025 | £5,400,975 | £309,843 |

The difference between average and median penalties varies substantially across the five years.

The largest divergence occurred in **2021**, when the average penalty was approximately **£56.8 million**, compared with a median of only **£410,200**. The average was around **138 times the median**.

Large average-to-median gaps were also present in 2022 and 2025, while 2023 showed the closest relationship between the two measures.

### Interpretation

The large gaps between average and median values show that FCA penalty distributions are strongly right-skewed in several years.

In particular, the very high 2021 average does not describe a typical 2021 case. Instead, a small number of exceptionally large penalties substantially increased both the annual total and the mean.

The median therefore provides an important complementary measure because it is less affected by extreme values.

2023 presents a contrasting pattern: its average and median penalties were comparatively close, suggesting that its annual penalty distribution was less dominated by very large outliers.

For 2022, the average penalty is calculated from 25 available penalty values because one case has no usable penalty amount in the source data.
