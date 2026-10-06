
**SQL:** See `sql/04_analysis.sql`.
## 2024 cases with penalties above £1 million

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
