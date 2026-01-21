# Incident Reporting Database (SQL)

![Language](https://img.shields.io/badge/Language-SQL-blue)
![Database](https://img.shields.io/badge/Database-PostgreSQL-blue)
![Focus](https://img.shields.io/badge/Focus-Data%20Modeling-orange)

## Project Overview
This project establishes a relational database to structure and analyze incident reporting data from Los Angeles and Orange County. The goal was to take raw, unstructured incident logs and convert them into a clean, structured format that supports complex querying.

The database organizes data into logical tables (separating "Events" from "People") and enforces strict connections between them to ensure accuracy.

## Skills Demonstrated

### 1. Relational Database Design
* **Structuring Data:** I designed a **Normalized Schema** that separates data into four distinct tables (`Incidents`, `Victims`, `Officers`, `Force_Types`). This reduces redundancy and ensures that updates to one record (like an officer's details) reflect everywhere automatically.
* **Data Integrity:** Implemented **Primary Keys** and **Foreign Keys** to strictly enforce relationships. This prevents "orphan" records (e.g., an incident appearing without a valid location or date).

### 2. Advanced SQL Querying
The `src/police_violence_schema.sql` script demonstrates the ability to solve complex data questions:

* **Complex Joins:** I used multi-table joins to reconnect the four separated tables, reconstructing the full narrative of an event (Who, What, Where) for analysis.
* **Subqueries:** I wrote nested queries to calculate baseline metrics (e.g., the average number of incidents across *all* groups) to compare against specific demographic subsets.
* **Aggregations & Grouping:** Used `GROUP BY` to summarize data by multiple dimensions (e.g., grouping by City AND Injury Status) to find high-density clusters.
* **Conditional Filtering:** Applied `HAVING` clauses to filter these grouped results based on specific thresholds (e.g., only showing cities with >10 severe incidents).

### 3. Data Dictionary


* **`Incidents` (Main Table):** Stores the core event data (Date, Location, City).
* **`Victims` & `Officers`:** Stores demographic and personnel details, linked to the main table via ID numbers.
* **`Force_Types`:** A lookup table that standardizes the categories of force used (e.g., "Taser," "Firearm"), ensuring data consistency across thousands of records.
