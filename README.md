# Incident Reporting Database (SQL)

![Language](https://img.shields.io/badge/Language-SQL-blue)
![Database](https://img.shields.io/badge/Database-PostgreSQL-blue)
![Focus](https://img.shields.io/badge/Focus-Relational%20Design-orange)

## Project Overview
This project establishes a relational database to structure and analyze police violence incidents in **Los Angeles County (LA)** and **Orange County (OC)**.

The goal was to transform unstructured incident logs into a **connected, relational system** capable of supporting rigorous inquiry. By moving away from flat files, this design enables complex analysis of accountability gaps, such as correlating officer disciplinary rates with the severity of injuries sustained by victims.

## Research Aims
The database was engineered to support five critical research aims, requiring a schema that could handle complex demographic and procedural data:
1.  **Force Classification:** Documenting and standardizing the different types of force used (e.g., Taser vs. Firearm).
2.  **Demographic Analysis:** Examining the racial demographics of victims to identify disparities, specifically regarding the disproportionate targeting of Black Americans.
3.  **Accountability:** Tracking disciplinary action rates for officers involved in severe incidents.
4.  **Geospatial Trends:** Comparing incident density in urban settings (LA) versus suburban profiles (OC).
5.  **Correlational Analysis:** Investigating if victim race influences the *type* of force deployed.

## Database Architecture
The schema organizes data into four logical entities connected by strict relationships:
* **`Incidents` (Parent Table):** The central anchor storing unique event data (Date, Location, City).
* **`Officers` (Child Table):** Linked via `incident_id`. Tracks personnel actions and disciplinary outcomes.
* **`Victims` (Child Table):** Linked via `incident_id`. Tracks demographics and injury status.
* **`Force_Types` (Lookup):** A standardized dictionary linked via `force_id` to ensure data consistency.



## Technical Skills Demonstrated

### 1. Database Implementation (DDL)
* **Schema Definition:** Created tables with strict data types, **Primary Keys**, and **Foreign Keys** to enforce referential integrity.
* **Optimization:** Created **Indexes** to speed up queries on frequently searched columns (e.g., City, Date).
* **Automation:** Implemented **Triggers** to automatically update records based on procedural events.
* **Lookup Tables:** Designed a reference table for Force Types to normalize categorical data.

### 2. Advanced SQL Analysis
The project utilizes advanced SQL features to derive insights:

* **Window Functions:** Used `OVER(PARTITION BY)` and `AVG() OVER()` to calculate race-specific incident counts and compare them against the **average across all races** in a single query.
* **Ranking:** Implemented `DENSE_RANK()` to order racial groups by incident frequency while accounting for ties.
* **Views:** Created the `oc_incidents` View to permanently isolate Orange County data for suburban profile analysis.
* **CTEs (Common Table Expressions):** Used `WITH` clauses to simplify complex aggregation logic, such as listing officers alongside their total incident counts.
* **Pivoting Data:** Used `CASE WHEN` logic to pivot the incidents table by year, allowing for side-by-side comparison of 2023 vs. 2024 counts per county.
* **Set Operations:** Used `UNION` to combine distinct lists of Officers and Victims into a single "Person Status" roster.

## Key Analysis Examples

### Investigating Accountability
I used `CASE WHEN` logic inside aggregation functions to "pivot" the data, transforming rows (dates) into columns (years) for side-by-side temporal analysis.
```sql
-- Q4: Pivot incident counts by year to compare 2023 vs 2024 per county
SELECT county, 
    COUNT(CASE WHEN YEAR(date) = 2023 THEN incident_id END) AS incidents_2023,
    COUNT(CASE WHEN YEAR(date) = 2024 THEN incident_id END) AS incidents_2024
FROM incidents
GROUP BY county;
