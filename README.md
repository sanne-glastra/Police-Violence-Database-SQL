# Incident Reporting Database System (SQL)

![Status](https://img.shields.io/badge/Status-Completed-success)
![Language](https://img.shields.io/badge/Language-SQL-blue)
![Focus](https://img.shields.io/badge/Focus-Data%20Engineering%20%7C%20Database%20Design-blue)

## 📌 Technical Overview
This repository contains the schema design, data modeling, and analytical queries for a relational database built to structure complex incident reporting data.

The project demonstrates **end-to-end data engineering capabilities**, transforming unstructured incident logs from Los Angeles and Orange County into a normalized relational architecture. The system is optimized for multi-dimensional analysis, handling many-to-one relationships between incidents, personnel, and subject demographics.

## 🛠️ Engineering Capabilities
* **Relational Schema Design:** Designed a **normalized Star-like Schema** to reduce data redundancy and ensure referential integrity between Fact tables (Incidents) and Dimension tables (Officers, Victims, Force Types).
* **Advanced SQL Querying:**
    * **Complex Joins:** Implemented multi-table joins to reconstruct event narratives from fragmented dimensional data.
    * **Subqueries & Aggregations:** Utilized nested subqueries to calculate baseline averages (e.g., county-wide incident rates) and compare them against specific subset metrics.
    * **Conditional Logic:** Developed queries with complex `WHERE` and `HAVING` clauses to filter for specific multi-variable edge cases (e.g., specific injury outcomes linked to lack of procedural action).
* **Data Integrity:** Enforced database constraints using Primary Keys and Foreign Keys to prevent orphan records and ensure data quality.

## 📂 Database Architecture
The database models the following entity relationships:

* **`Incidents` (Fact Table):** The central node containing temporal and geospatial data (Date, City, Coordinates).
* **`Victims` (Dimension):** Stores demographic and health outcome data, linked via Foreign Key.
* **`Officers` (Dimension):** Stores personnel metadata and procedural outcomes (Disciplinary Action), allowing for one-to-many analysis (multiple officers per incident).
* **`Force_Types` (Lookup):** A standardized dictionary table to normalize force categorization.

### Schema Diagram
[View Entity Relationship Diagram (EER)](diagrams/entity_relationship_diagram.pdf)

## 💻 Sample Query Logic
The `src/police_violence_schema.sql` script includes queries that demonstrate:

1.  **Demographic Aggregation:** Grouping data by multiple dimensions (Race/Ethnicity + Injury Status) to derive frequency distributions.
2.  **Comparative Analytics:** Comparing the *average* number of incidents across all cohorts vs. the *actual* count for specific high-frequency groups.
3.  **Cross-Table filtering:** Isolating records that meet criteria across joined tables (e.g., Incidents in 'City X' AND Officer Disciplinary Status = 'NULL' AND Victim Status = 'Severe').

## 🚀 Usage
This project uses **PostgreSQL** syntax.
1.  **Schema Build:** Run the `CREATE TABLE` statements in `src/` to initialize the architecture.
2.  **Data Loading:** Use the provided `COPY` commands to seed the `Force_Types` lookup table from CSV.
3.  **Analysis:** Execute the stored queries to generate report metrics.
